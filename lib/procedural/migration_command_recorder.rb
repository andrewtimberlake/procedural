# -*- coding: utf-8 -*-
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
