CREATE OR REPLACE PROCEDURE autopilot_dev.GET_CONTACTS( p_rc OUT SYS_REFCURSOR )
AS
BEGIN
  OPEN p_rc FOR
  SELECT * FROM CONTACTS;
  -- SELECT FIRST_NAME, LAST_NAME, EMAIL FROM CONTACTS;
END;
/