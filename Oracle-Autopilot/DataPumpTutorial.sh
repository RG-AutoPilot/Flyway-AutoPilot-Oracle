#!/bin/bash

LOGFILE="flyway_oracle_autopilot_run.log"
: > "$LOGFILE"

# Redirect stdout and stderr to log file, but keep output in terminal too
exec 3>&1 4>&2
exec > >(tee -a "$LOGFILE") 2> >(tee -a "$LOGFILE" >&2)

echo "Step 1: Oracle Data Pump Directory Check"
read -p "Have you confirmed an Oracle directory exists for Data Pump? (Y/N): " confirm_dir
[[ "$confirm_dir" =~ ^[Yy]$ ]] || {
  echo "Please confirm your Data Pump directory exists before proceeding."
  echo "Run this SQL to check: SELECT directory_name, directory_path FROM dba_directories;"
  read -p "Press Enter to exit..."
  exit 1
}

read -p "Enter the Oracle DIRECTORY name (e.g., DATA_PUMP_DIR): " ORACLE_DIR
read -p "Enter Oracle username: " ORACLE_USER
read -s -p "Enter Oracle password: " ORACLE_PASS
echo
read -p "Enter Oracle SID or Service Name (e.g., orcl or dev1): " ORACLE_SID
read -p "Enter the schema you want to export/import (e.g., HR): " SOURCE_SCHEMA

DUMP_FILE="${SOURCE_SCHEMA}_export.dmp"
EXPORT_LOG="${SOURCE_SCHEMA}_export.log"

echo ""
read -p "Would you like to run a new export for schema '$SOURCE_SCHEMA'? (Y/N): " do_export
if [[ "$do_export" =~ ^[Yy]$ ]]; then
  echo ""
  echo "Exporting schema '${SOURCE_SCHEMA}' from ${ORACLE_SID}..."
  expdp "${ORACLE_USER}/${ORACLE_PASS}@${ORACLE_SID}" \
    SCHEMAS=$SOURCE_SCHEMA \
    DIRECTORY=$ORACLE_DIR \
    DUMPFILE=$DUMP_FILE \
    LOGFILE=$EXPORT_LOG \
    CONTENT=METADATA_ONLY \
    REUSE_DUMPFILES=Y

  if [ $? -ne 0 ]; then
    echo ""
    echo "Export failed. Check '$EXPORT_LOG' and '$LOGFILE'."
    read -p "Press Enter to continue or Ctrl+C to quit..."
  else
    echo "Export successful."
  fi
else
  echo "Skipping export. Make sure '$DUMP_FILE' already exists in '$ORACLE_DIR'."
fi

echo ""
echo "You can now import into Flyway environments."

ENVIRONMENTS=("AUTOPILOTDEV" "AUTOPILOTTEST" "AUTOPILOTPROD" "AUTOPILOTSHADOW" "AUTOPILOTCHECK" "AUTOPILOTBUILD")

for TARGET_SCHEMA in "${ENVIRONMENTS[@]}"; do
  read -p "Would you like to import into environment '$TARGET_SCHEMA'? (Y/N): " do_import
  if [[ "$do_import" =~ ^[Yy]$ ]]; then
    IMPORT_LOG="import_${TARGET_SCHEMA}.log"
    echo ""
    echo "Importing into '$TARGET_SCHEMA'..."
    impdp "${ORACLE_USER}/${ORACLE_PASS}@${ORACLE_SID}" \
      SCHEMAS=$SOURCE_SCHEMA \
      DIRECTORY=$ORACLE_DIR \
      DUMPFILE=$DUMP_FILE \
      LOGFILE=$IMPORT_LOG \
      CONTENT=METADATA_ONLY \
      REMAP_SCHEMA=${SOURCE_SCHEMA}:${TARGET_SCHEMA} \
      TRANSFORM=OID:N

    if [ $? -ne 0 ]; then
      echo "Import into '$TARGET_SCHEMA' failed. Check '$IMPORT_LOG'."
    else
      echo "Import into '$TARGET_SCHEMA' succeeded."
    fi
  else
    echo "Skipping '$TARGET_SCHEMA'."
  fi
done

echo ""
echo "All requested actions complete."
echo "Log written to: $LOGFILE"
read -p "Press Enter to close..."
