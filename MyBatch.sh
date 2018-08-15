#!/bin/bash

counter=$1
param=$2
jobid=$3
./x86_64/special -nobanner MyHipp.hoc - << here
  abc($counter, $param, $jobid)
here
  
echo Ok  
echo All done
