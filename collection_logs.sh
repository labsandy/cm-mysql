#!/bin/bash

# Database connection details
DB_HOST="cis-ars-db.creditmantri.com"
DB_USER="caadm"
DB_PASS="Cisarsse"
DB_NAME="cisars"
TABLE_NAME="collection_logs"
CHUNK_SIZE=10000000  # Define the chunk size for each export
OUTPUT_FILE="collection_logs.csv"

# Start exporting
echo "Exporting data in chunks..."

# Initialize offset
OFFSET=0

# Get the total row count
TOTAL_ROWS=$(mysql -h $DB_HOST -u $DB_USER -p"$DB_PASS" -N -e "SELECT COUNT(*) FROM $DB_NAME.$TABLE_NAME;")
echo "Total rows to export: $TOTAL_ROWS"

# Loop through and export data in chunks
while [ $OFFSET -lt $TOTAL_ROWS ]; do
    echo "Exporting rows from $OFFSET to $((OFFSET + CHUNK_SIZE - 1))"

    # Export the current chunk
    mysql -h $DB_HOST -u $DB_USER -p"$DB_PASS" -e \
    "SELECT id,created_at,updated_at 
    FROM $DB_NAME.$TABLE_NAME where updated_at >= '2024-11-12 00:00:00' and updated_at <= '2024-11-12 23:59:59' and created_at <= '2024-11-12 00:00:00'
    LIMIT $OFFSET, $CHUNK_SIZE;" | \
    sed 's/\t/","/g;s/^/"/;s/$/"/;s/\n//g' >> "$OUTPUT_FILE"

    # Move to the next chunk
    OFFSET=$((OFFSET + CHUNK_SIZE))
done

echo "Export completed. Data saved to $OUTPUT_FILE."
