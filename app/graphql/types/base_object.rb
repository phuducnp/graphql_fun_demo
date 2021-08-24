module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    def batch_load_one(foreign_id, key)
      return nil if foreign_id.nil? || key.nil?

      BatchLoader::GraphQL.for(foreign_id).batch(key: key) do |ids, loader, args|
        model = args[:key].constantize
        # model = model.kept if model.ancestors.include? Discard::Model
        model.where(id: ids).each { |record| loader.call(record.id, record) }
      end
    end

    def batch_load_many(foreign_id, foreign_id_name, key, conditions = {}, order = {})
      batch_key = "#{key}#{conditions.hash}#{order.hash}"
      simple, raw = preprocess_conditions(conditions)
      BatchLoader::GraphQL.for(foreign_id).batch(default_value: [], key: batch_key) do |ids, loader, _args|
        model = key.constantize
        # model = model.kept if model.ancestors.include? Discard::Model
        model
          .where({ foreign_id_name => ids }.merge(simple))
          .where(raw)
          .order(order)
          .each do |child|
            loader.call(child.send(foreign_id_name)) { |memo| memo << child }
          end
      end
    end
  end
end
