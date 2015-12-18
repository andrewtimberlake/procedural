# -*- coding: utf-8 -*-
module Procedural
  SUPPORTED_ADAPTERS = %w[PostgreSQL]

  def self.load_adapters
    SUPPORTED_ADAPTERS.each do |adapter|
      adapter_class = "#{adapter}Adapter"

      if ActiveRecord::ConnectionAdapters.const_defined?(adapter_class)
        require "procedural/adapters/#{adapter.downcase}_adapter"

        adapter = ActiveRecord::ConnectionAdapters.const_get(adapter_class)
        extension = Procedural::Adapters.const_get(adapter_class)

        adapter.send :prepend, extension
      end
    end
  end
end
