# Grabs all PostgreSQL (aka postgres-vsdk) database types and triggers a refresh if they haven't been refreshed since the given date.
#!/bin/bash

# Get the current date and the date of the last Friday
current_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)
last_friday=$(date -u -d 'last Friday' +%Y-%m-%dT%H:%M:%SZ)
echo "Last Friday: $last_friday"

# Get all Postgres VDBs - Removes all white space so you can iterate over the list.
postgres_vdbs=$(dct-toolkit search_vdbs database_type=postgres-vsdk -js | jq -c '.items[].id' | sed 's/[[:space:]]//g')

echo $postgres_vdbs

# Loop through each Postgres VDB and check the last refresh date
for vdb_id in ${postgres_vdbs[@]}; do
	echo "Checking... $vdb_id"
  last_refresh_date=$(dct-toolkit get_vdb_by_id vdb_id="$vdb_id" -js | jq -r '.last_refreshed_date')
  if [[ "$last_refresh_date" < "$last_friday" ]]; then
    # Refresh the VDB if it hasn't been refreshed since last Friday
	echo "Refreshing VDB: $vdb_id"
    dct-toolkit refresh_vdb_by_snapshot vdb_id="$vdb_id" --no-wait
  else 
	echo "Skipping... $vdb_id"
  fi
done