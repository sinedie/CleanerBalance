#!/bin/bash

DART_DEFINES=$(scripts/generate_dart_defines.sh dev)

if [ $? -ne 0 ]; then
  echo -e "Failed to generate dart defines"
  exit 1
fi

eval "flutter run $DART_DEFINES"