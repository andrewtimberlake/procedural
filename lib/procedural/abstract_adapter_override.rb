# -*- coding: utf-8 -*-
ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
  class << self
    alias_method(:_procedural_orig_inherited, :inherited) if method_defined?(:inherited)

    def inherited(_subclass)
      ::Procedural::load_adapters
      _procedural_orig_inherited(_subclass) if methods.include?(:_procedural_orig_inherited)
    end
  end
end
