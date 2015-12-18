# -*- coding: utf-8 -*-
module Procedural
  module Adapters
    module PostgreSQLAdapter
      def create_procedure(*args)
        options = args.extract_options!

        procedure_name = args.shift
        language = options.fetch(:language)
        returns = options.fetch(:returns)
        sql = options.fetch(:sql)

        execute(<<-SQL)
CREATE OR REPLACE FUNCTION #{quote_column_name(procedure_name)}()
  RETURNS #{returns}
  LANGUAGE #{language}
AS $$
  BEGIN
    #{sql}
  END
$$
SQL
      end

      def drop_procedure(*args)
        procedure_name = args.shift

        execute("DROP FUNCTION IF EXISTS #{quote_column_name(procedure_name)}()")
      end

      def create_trigger(*args)
        options = args.extract_options!

        table_name = args.shift
        trigger_name = args.shift
        procedure_name = args.shift

        execute("CREATE TRIGGER #{quote_column_name(trigger_name)} BEFORE INSERT OR UPDATE ON #{quote_table_name(table_name)} FOR EACH ROW EXECUTE PROCEDURE #{quote_column_name(procedure_name)}()")
      end

      def drop_trigger(*args)
        table_name = args.shift
        trigger_name = args.shift

        execute("DROP TRIGGER IF EXISTS #{quote_column_name(trigger_name)} ON #{quote_table_name(table_name)}")
      end
    end
  end
end
