CREATE TABLE autopilot_dev.locations (
  location_id NUMBER(4) NOT NULL,
  street_address VARCHAR2(40 BYTE),
  postal_code VARCHAR2(12 BYTE),
  city VARCHAR2(30 BYTE) NOT NULL,
  state_province VARCHAR2(25 BYTE),
  country_id CHAR(2 BYTE),
  territory_id VARCHAR2(20 BYTE),
  location1 VARCHAR2(20 BYTE),
  CONSTRAINT loc_id_pk PRIMARY KEY (location_id) USING INDEX autopilot_dev.loc_id_pkx,
  CONSTRAINT loc_c_id_fk FOREIGN KEY (country_id) REFERENCES autopilot_dev.countries (country_id)
);
COMMENT ON COLUMN autopilot_dev.locations.location_id IS 'Primary key of locations table';
COMMENT ON COLUMN autopilot_dev.locations.street_address IS 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';
COMMENT ON COLUMN autopilot_dev.locations.postal_code IS 'Postal code of the location of an office, warehouse, or production site
of a company. ';
COMMENT ON COLUMN autopilot_dev.locations.city IS 'A not null column that shows city where an office, warehouse, or
production site of a company is located. ';
COMMENT ON COLUMN autopilot_dev.locations.state_province IS 'State or Province where an office, warehouse, or production site of a
company is located.';
COMMENT ON COLUMN autopilot_dev.locations.country_id IS 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';