#!/bin/sh

if [ -d /data/electrs ]; then
  echo 'Found existing directory at /data/electrs.  Skipping initialization.'
  exit 0
fi

mkdir -p /data/electrs
echo "Created /data/electrs directory."

sed -E "s/^auth\s*=.*$/auth = \"${RPC_USERNAME}:${RPC_PASSWORD}\"/" /home/electrs/electrs.conf.template > /data/electrs/electrs.conf
echo "Updated /data/electrs/electrs.conf with credentials for '${RPC_USERNAME}'."

echo 'Finished!'
