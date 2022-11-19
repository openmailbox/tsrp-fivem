#!/bin/bash

for i in $(find src -maxdepth 3 -type f -name "package.json" | xargs realpath)
do
    cd $(dirname $i) && npm install && npm run build
done
