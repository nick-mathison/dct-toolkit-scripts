#!/bin/bash
# Script to find and shut down (or stop) all Running, Oracle VDBs using DCT Toolkit

# Shut down each VDB
dct-toolkit search_vdbs database_type=Oracle status=RUNNING -js | jq -r '.items[].id' | while read -r VDB; do
  VDB=$(echo "$VDB" | sed 's/[ \t]*$//')
  
  echo "Shutting down VDB: $VDB"
  
  dct-toolkit stop_vdb vdb_id=$VDB --json
  #echo "dct-toolkit stop_vdb vdb_id=$VDB --json"
  # The --no-wait flag will run the command async without waiting for completion
  
  if [ $? -ne 0 ]; then
    echo "Failed to stop VDB: $VDB"
  else
    echo "Successfully stop VDB: $VDB"
  fi
done
