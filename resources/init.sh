#!/bin/sh

if [ -d /data/electrs ]; then
  echo 'Found existing directory at /data/electrs.  Skipping initialization.'
  exit 0
fi

mkdir -p /data/electrs
echo "Created /data/electrs directory."

echo 'Finished!'
