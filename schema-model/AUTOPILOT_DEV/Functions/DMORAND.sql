CREATE OR REPLACE FUNCTION autopilot_dev.DMORAND(seedVal IN  VARCHAR2) RETURN NUMBER IS BEGIN dbms_random.seed(seedVal); RETURN dbms_random.VALUE(); END;
/