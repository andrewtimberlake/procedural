# -*- coding: utf-8 -*-
require 'active_record'
require 'procedural/procedure'
require 'procedural/adapters'

ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
  alias_method(:_procedural_original_inherited, :inherited) if method_defined?(:inherited)

  def self.inherited(_klass)
    ::Procedural::load_adapters
    _procedural_orig_inherited if method_defined?(:_procedural_original_inherited)
  end
end

module ActiveRecord
  class Migration
    class CommandRecorder
      def create_procedure(*args, &block)
        record(:create_procedure, args, &block)
      end

      def invert_create_procedure(args)
        [:drop_procedure, args[0]]
      end

      def create_trigger(*args, &block)
        record(:create_trigger, args, &block)
      end

      def invert_create_trigger(args)
        [:drop_trigger, args[0..1]]
      end
    end
  end
end

Procedural.load_adapters
