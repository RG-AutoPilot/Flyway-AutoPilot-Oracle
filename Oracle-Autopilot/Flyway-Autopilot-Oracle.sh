#!/bin/bash

LOGFILE="flyway_oracle_autopilot_run.log"
: > "$LOGFILE"  # Clear log file

# Trap unexpected exits and dump helpful message
trap 'echo -e "\n❌ Script exited early. Please check the log at: $LOGFILE"' ERR EXIT

exec > >(tee -a "$LOGFILE") 2>&1  # Redirect all output to log

echo "🧪 Step 1: Oracle Data Pump Directory Check"
read -p "Have you confirmed an Oracle directory exists for Data Pump? (Y/N): " confirm_dir

if [[ "$confirm_dir" != "Y" && "$confirm_dir" != "y" ]]; then
  echo "❌ Please create or validate your Data Pump directory before continuing."
  echo "Tip: Run this SQL query as a DBA:"
  echo "  SELECT directory_name, directory_path FROM dba_directories;"
  exit 1
fi

read -p "Enter the Oracle DIRECTORY name (e.g., DATA_PUMP_DIR): " ORACLE_DIR
read -p "Enter your Oracle username: " ORACLE_USER
read -s -p "Enter your Oracle password: " ORACLE_PASS
echo
read -p "Enter your Oracle SID or Service name (e.g., orcl or dev1): " ORACLE_SID
read -p "Enter the schema you want to export (e.g., HR): " SOURCE_SCHEMA
read -p "Enter the target schema name for import (e.g., AUTOPILOT_DEV): " TARGET_SCHEMA

DUMP_FILE="${SOURCE_SCHEMA}_export.dmp"
EXPORT_LOG="${SOURCE_SCHEMA}_export.log"
IMPORT_LOG="import_${TARGET_SCHEMA}.log"

echo ""
echo "📦 Exporting schema '$SOURCE_SCHEMA' from $ORACLE_SID..."
expdp "${ORACLE_USER}/${ORACLE_PASS}@${ORACLE_SID}" \
  SCHEMAS=$SOURCE_SCHEMA \
  DIRECTORY=$ORACLE_DIR \
  DUMPFILE=$DUMP_FILE \
  LOGFILE=$EXPORT_LOG \
  CONTENT=METADATA_ONLY

if [ $? -ne 0 ]; then
  echo "❌ Export failed. Check '$EXPORT_LOG' and '$LOGFILE'."
  exit 1
fi

echo ""
echo "🔁 Importing schema into '$TARGET_SCHEMA' (remapped from '$SOURCE_SCHEMA')..."
impdp "${ORACLE_USER}/${ORACLE_PASS}@${ORACLE_SID}" \
  SCHEMAS=$SOURCE_SCHEMA \
  DIRECTORY=$ORACLE_DIR \
  DUMPFILE=$DUMP_FILE \
  LOGFILE=$IMPORT_LOG \
  CONTENT=METADATA_ONLY \
  REMAP_SCHEMA=${SOURCE_SCHEMA}:${TARGET_SCHEMA}

if [ $? -ne 0 ]; then
  echo "❌ Import failed. Check '$IMPORT_LOG' and '$LOGFILE'."
  exit 1
fi

trap - ERR EXIT  # Remove trap on successful finish
echo ""
echo "✅ Success! Schema '$SOURCE_SCHEMA' exported and imported into '$TARGET_SCHEMA'."
echo "📝 See full run log at: $LOGFILE"
