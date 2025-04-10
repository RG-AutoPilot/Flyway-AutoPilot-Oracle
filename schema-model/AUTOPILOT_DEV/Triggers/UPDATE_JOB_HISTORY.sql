CREATE OR REPLACE TRIGGER autopilot_dev."UPDATE_JOB_HISTORY" 
    AFTER UPDATE OF JOB_ID, DEPARTMENT_ID ON autopilot_dev.EMPLOYEES 
    FOR EACH ROW 
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END; 

/