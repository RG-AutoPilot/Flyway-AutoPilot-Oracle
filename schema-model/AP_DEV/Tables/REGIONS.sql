CREATE TABLE ap_dev.regions (
  region_id NUMBER NOT NULL,
  region_name VARCHAR2(25 BYTE),
  region_territory VARCHAR2(20 BYTE),
  CONSTRAINT reg_id_pk PRIMARY KEY (region_id) USING INDEX ap_dev.reg_id_pkx
);