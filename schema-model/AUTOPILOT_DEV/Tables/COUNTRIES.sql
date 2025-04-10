CREATE TABLE autopilot_dev.countries (
  country_id CHAR(2 BYTE) NOT NULL,
  country_name VARCHAR2(40 BYTE),
  region_id NUMBER,
  country_language VARCHAR2(20 BYTE),
  CONSTRAINT country_c_id_pk PRIMARY KEY (country_id) USING INDEX autopilot_dev.country_c_id_pkx,
  CONSTRAINT countr_reg_fk FOREIGN KEY (region_id) REFERENCES autopilot_dev.regions (region_id)
);
COMMENT ON COLUMN autopilot_dev.countries.country_id IS 'Primary key of countries table.';
COMMENT ON COLUMN autopilot_dev.countries.country_name IS 'Country name';
COMMENT ON COLUMN autopilot_dev.countries.region_id IS 'Region ID for the country. Foreign key to region_id column in the departments table.';