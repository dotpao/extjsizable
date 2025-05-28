module Extjsizable
  module CoreExt
    module ActiveRecordRelation
      module ExtJs
        def to_extjs(options = {})
          to_a.to_extjs(options) # convert to array and delegate
        end
      end
    end
  end
end
