#!/bin/awk -f

{
  clean = gsub(/\/simple\//, "", $1);
  clean = gsub(/\//, "", $clean);
  print "https://pypi.org/pypi/" $clean "/json \t" $clean;
}
