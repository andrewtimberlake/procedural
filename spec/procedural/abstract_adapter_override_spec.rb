require 'spec_helper'

describe "loading an adapter" do
  it "calls the original AR::CA::AbstractAdapter.inherited method" do
    ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
      def self.inherited(subclass)
        @_procedural_inherited_called = true
      end
    end
    load File.join(__dir__, '../../lib/procedural/abstract_adapter_override.rb')
    Class.new(ActiveRecord::ConnectionAdapters::AbstractAdapter)
    ActiveRecord::ConnectionAdapters::AbstractAdapter.instance_variable_get("@_procedural_inherited_called").must_equal true
  end
end
