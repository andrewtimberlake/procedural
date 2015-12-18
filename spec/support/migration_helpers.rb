# -*- coding: utf-8 -*-
require 'spec_helper'

shared_examples_for "an adapter" do
  describe "create procedure migration" do
    create_procedure_migration = Class.new(ActiveRecord::Migration) do
      def change
        create_procedure :test_procedure, language: 'plpgsql', returns: 'text', sql: <<-SQL.strip_heredoc
        RETURN "Hello World";
      SQL
      end
    end

    it "migrates up" do
      create_procedure_migration.new.exec_migration(ActiveRecord::Base.connection, :up)
      expect(true).to_equal(true)
    end

    it "migrates down" do
      create_procedure_migration.new.exec_migration(ActiveRecord::Base.connection, :down)
      expect(true).to_equal(true) #
    end
  end

  describe "create trigger migration" do
    create_procedure_migration = Class.new(ActiveRecord::Migration) do
      def change
        create_procedure :test_procedure, language: 'plpgsql', returns: 'trigger', sql: "RETURN NEW;"
        create_trigger :users, :users_trigger, :test_procedure
      end
    end

    it "migrates up" do
      create_procedure_migration.new.exec_migration(ActiveRecord::Base.connection, :up)
      expect(true).to_equal(true)
    end

    it "migrates down" do
      create_procedure_migration.new.exec_migration(ActiveRecord::Base.connection, :down)
      expect(true).to_equal(true) #
    end
  end
end
