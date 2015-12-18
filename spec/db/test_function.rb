Procedural::Function.create :add_account_to_index_queue,
                            language: :plpgsql,
                            returns: :trigger,
                            trigger: Procedural::Trigger.new(:accounts,
                                                             when: :before,
                                                             insert: true,
                                                             update: %i[company_id company_branch_id client_id store_id branch_id agent_id account_holder_id reference number active old_number old_reference case_number],
                                                             delete: nil,
                                                             truncate: nil,
                                                             for_each: :row,
                                                             when: nil,
                                                             arguments: nil
                                                            )
                            sql: <<-SQL
  IF TG_OP = 'INSERT' THEN
    INSERT INTO cascade_jobs (job_class, arguments, priority) VALUES ('Job::Accounts', JSON_BUILD_ARRAY(NEW.id)::jsonb, 0);
    INSERT INTO cascade_jobs (job_class, arguments, priority) VALUES ('Job::Entities', JSON_BUILD_ARRAY(NEW.account_holder_id)::jsonb, 0);
  ELSE
    IF
      OLD.company_id        IS DISTINCT FROM NEW.company_id         OR
      OLD.company_branch_id IS DISTINCT FROM NEW.company_branch_id  OR
      OLD.client_id         IS DISTINCT FROM NEW.client_id          OR
      OLD.store_id          IS DISTINCT FROM NEW.store_id           OR
      OLD.branch_id         IS DISTINCT FROM NEW.branch_id          OR
      OLD.agent_id          IS DISTINCT FROM NEW.agent_id           OR
      OLD.account_holder_id IS DISTINCT FROM NEW.account_holder_id  OR
      OLD.reference         IS DISTINCT FROM NEW.reference          OR
      OLD.number            IS DISTINCT FROM NEW.number             OR
      OLD.active            IS DISTINCT FROM NEW.active             OR
      OLD.old_number        IS DISTINCT FROM NEW.old_number         OR
      OLD.old_reference     IS DISTINCT FROM NEW.old_reference      OR
      OLD.case_number       IS DISTINCT FROM NEW.case_number
    THEN
      INSERT INTO cascade_jobs (job_class, arguments, priority) VALUES ('Job::Accounts', JSON_BUILD_ARRAY(NEW.id)::jsonb, 0);
    END IF;

    IF OLD.account_holder_id IS DISTINCT FROM NEW.account_holder_id OR OLD.active IS DISTINCT FROM NEW.active THEN
      IF OLD.account_holder_id IS NOT NULL THEN
        INSERT INTO cascade_jobs (job_class, arguments, priority) VALUES ('Job::Entities', JSON_BUILD_ARRAY(OLD.account_holder_id)::jsonb, 0);
      END IF;
      INSERT INTO cascade_jobs (job_class, arguments, priority) VALUES ('Job::Entities', JSON_BUILD_ARRAY(NEW.account_holder_id)::jsonb, 0);
    END IF;
  END IF;

  RETURN NEW;
SQL
