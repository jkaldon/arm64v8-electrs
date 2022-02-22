#!/bin/sh

helm upgrade electrs -n bitcoin --create-namespace --install ./ -f values.yaml
