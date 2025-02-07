CREATE TABLE ap_dev."PROJECT" (
  project_id NUMBER,
  project_name VARCHAR2(100 BYTE),
  start_date DATE,
  department_id NUMBER,
  project_type VARCHAR2(20 BYTE)
)
ENABLE ROW MOVEMENT;