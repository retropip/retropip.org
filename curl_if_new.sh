#!/bin/bash


bat simple.html | htmlq --attribute href a | ./simple2jsonurl.awk | parallel -j 20 --colsep '\t' curl --etag-compare "json/{2}.etag" --etag-save "json/{2}.etag" -o "json/{2}.json" {1}
