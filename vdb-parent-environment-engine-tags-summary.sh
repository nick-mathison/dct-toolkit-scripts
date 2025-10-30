# List all VDBs alongside their parent's name, environment, engine, and tags

#!/bin/bash
echo "VDB ID, VDB Name, Parent ID, Parent Name, Environment Name, Engine Name, Tags"

# Iterate through the VDB inventory report with parent info
dct-toolkit search_vdb_inventory_report --json | jq -c '.items[]' | while read -r vdb; do
  # echo $vdb
  vdb_id=$(echo "$vdb" | jq -r '.vdb_id')
  vdb_name=$(echo "$vdb" | jq -r '.name')
  parent_id=$(echo "$vdb" | jq -r '.parent_id')
  parent_name=$(echo "$vdb" | jq -r '.parent_name')
  engine_name=$(echo "$vdb" | jq -r '.engine_name')
  env_id=""
  env_name=""
  tags=""

  # Get environment id
  env_id=$(dct-toolkit get_vdb_by_id vdb_id=$vdb_id -js --jsonpath='environment_id')

  # Get environment name
  env_name=$(dct-toolkit get_environment_by_id environment_id=$env_id -js --jsonpath='name')

  # Get tags
  tags=$(dct-toolkit get_tags_vdb vdb_id=$vdb_id --json --jsonpath='tags' | jq -r '[.[] | "\(.key)=\(.value)"] | join(",")')
  
  echo "$vdb_id, $vdb_name, $parent_id, $parent_name, $env_name, $engine_name, $tags"

done
``
