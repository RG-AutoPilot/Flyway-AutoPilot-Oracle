CREATE TABLE ap_dev.task (
  task_id NUMBER,
  task_name VARCHAR2(100 BYTE),
  project_id NUMBER,
  assigned_date DATE
)
ENABLE ROW MOVEMENT;