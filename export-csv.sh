#!/bin/bash

# Database connection details
DB_HOST="cmoldbw.creditmantri.com"
DB_USER="rdscmoldb"
DB_PASS="passwd"
DB_NAME="cmolbeta"
TABLE_NAME="lender_user_answers"
CHUNK_SIZE=1000000  # Define the chunk size for each export
OUTPUT_FILE="lender_user_answers.csv"

# Start exporting
echo "Exporting data in chunks..."

# Initialize offset
OFFSET=0

# Get the total row count
TOTAL_ROWS=$(mysql -h $DB_HOST -u $DB_USER -p"$DB_PASS" -N -e "SELECT COUNT(*) FROM $DB_NAME.$TABLE_NAME;")
if [ $? -ne 0 ]; then
    echo "Error: Unable to connect to the database or fetch row count."
    exit 1
fi
echo "Total rows to export: $TOTAL_ROWS"

# Add headers to the output file
mysql -h $DB_HOST -u $DB_USER -p"$DB_PASS" -N -e "SHOW COLUMNS FROM $DB_NAME.$TABLE_NAME;" | awk '{print $1}' | paste -sd, - > "$OUTPUT_FILE"

# Loop through and export data in chunks
while [ $OFFSET -lt $TOTAL_ROWS ]; do
    echo "Exporting rows from OFFSET $OFFSET with CHUNK_SIZE $CHUNK_SIZE"

    # Export the current chunk with all columns
    mysql -h $DB_HOST -u $DB_USER -p"$DB_PASS" -N -e \
    "SELECT * FROM $DB_NAME.$TABLE_NAME LIMIT $OFFSET, $CHUNK_SIZE;" | \
    sed 's/\t/,/g' >> "$OUTPUT_FILE"

    if [ $? -ne 0 ]; then
        echo "Error: Failed to export data at OFFSET $OFFSET"
        exit 1
    fi

    # Move to the next chunk
    OFFSET=$((OFFSET + CHUNK_SIZE))
done

echo "Export completed. Data saved to $OUTPUT_FILE."
