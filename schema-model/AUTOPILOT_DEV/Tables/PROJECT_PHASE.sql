CREATE TABLE autopilot_dev.project_phase (
  phase_id NUMBER,
  phase_name VARCHAR2(100 BYTE),
  phase_start_date DATE,
  project_id NUMBER,
  department_id NUMBER
)
ENABLE ROW MOVEMENT;