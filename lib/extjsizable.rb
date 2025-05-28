require 'active_record'
require 'active_support/core_ext'
require 'active_support/concern'
require 'extjsizable/active_record/extjs'
require 'extjsizable/core_ext/array/extjs'
require 'extjsizable/core_ext/active_record_relation/extjs'

ActiveRecord::Base.send :include, Extjsizable::ActiveRecord::ExtJs
Array.send              :include, Extjsizable::CoreExt::Array::ExtJs
ActiveRecord::Relation.send :include, Extjsizable::CoreExt::ActiveRecordRelation::ExtJs
