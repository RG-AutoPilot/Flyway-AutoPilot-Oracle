CREATE TABLE autopilot_dev.task (
  task_id NUMBER,
  task_name VARCHAR2(100 BYTE),
  project_id NUMBER,
  assigned_date DATE,
  favorite_task VARCHAR2(20 BYTE)
)
ENABLE ROW MOVEMENT;