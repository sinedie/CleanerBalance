#!/bin/bash

case "$1" in
    "dev") INPUT="env/dev.env" ;;
    "prod") INPUT="env/prod.env";;
    *) echo "Missing arguments [dev|prod]"; exit 1;;
esac

while IFS= read -r line
do
  DART_DEFINES="$DART_DEFINES--dart-define=$line "
done < "$INPUT"
echo "$DART_DEFINES"