#!/bin/bash
#param is array task id
seed=$1
param=$2
jobid=$3
./x86_64/special -nobanner MyHipp.hoc - << here
  abc($seed, $param, $jobid)
here
  
echo Ok  
echo All done
