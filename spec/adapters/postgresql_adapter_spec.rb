# -*- coding: utf-8 -*-
require 'spec_helper'

module Procedural
  module Adapters
    describe PostgreSQLAdapter do
      configure_database('postgresql')
      recreate_database("procedural_test")
      load_schema

      it_behaves_like "an adapter"

      shared_base = Class.new do
        extend Procedural::Adapters::PostgreSQLAdapter
        def self.quote_table_name(name); name; end
        def self.quote_column_name(name); name; end
        def self.execute(sql); sql; end
      end

      describe "#create_procedure" do
        it "executes the CREATE OR REPLACE FUNCTION command" do
          sql = shared_base.create_procedure(:created_at_trigger, language: 'plpgsql', returns: 'trigger', sql: <<-SQL)
              IF (TG_OP = 'UPDATE') THEN
                NEW."created_at" := OLD."created_at";
              ELSIF (TG_OP = 'INSERT') THEN
                NEW."created_at" := CURRENT_TIMESTAMP;
              END IF;
              RETURN NEW;
          SQL
        end

        it "accepts SQL from a block" do
          sql = shared_base.create_procedure(:created_at_trigger, language: 'plpgsql', returns: 'trigger') do
            <<-SQL
              IF (TG_OP = 'UPDATE') THEN
                NEW."created_at" := OLD."created_at";
              ELSIF (TG_OP = 'INSERT') THEN
                NEW."created_at" := CURRENT_TIMESTAMP;
              END IF;
              RETURN NEW;
            SQL
          end

          expect(sql).to_match(/CREATE OR REPLACE FUNCTION created_at_trigger/);
          expect(sql).to_match(/IF \(TG_OP = 'UPDATE'/);
        end
      end

      describe "#drop_procedure" do
        it "executes the DROP FUNCITON IF EXISTS command" do
          sql = shared_base.drop_procedure(:created_at_trigger)

          expect(sql).to_equal("DROP FUNCTION IF EXISTS created_at_trigger()")
        end
      end

      describe "#create_trigger" do
        it "executes the CREATE TRIGGER command" do
          sql = shared_base.create_trigger(:users, :users_created_at, :created_at_trigger)

          expect(sql).to_equal("CREATE TRIGGER users_created_at BEFORE INSERT OR UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE created_at_trigger()")
        end
      end

      describe "#drop_trigger" do
        it "executes the DROP TRIGGER IF EXISTS command" do
          sql = shared_base.drop_trigger(:users, :users_created_at)

          expect(sql).to_equal("DROP TRIGGER IF EXISTS users_created_at ON users")
        end
      end

    end
  end
end
