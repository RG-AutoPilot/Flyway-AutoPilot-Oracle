CREATE TABLE autopilot_dev.employee_work_logs (
  log_id NUMBER NOT NULL,
  employee_id NUMBER NOT NULL,
  activity_type VARCHAR2(20 BYTE) NOT NULL,
  activity_date DATE NOT NULL,
  hours_worked NUMBER,
  PRIMARY KEY (log_id)
);