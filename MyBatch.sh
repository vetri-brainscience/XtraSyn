#!/bin/bash

counter=$1
./x86_64/special -nobanner MyHipp.hoc - << here
  abc($counter, 10)
here
  
echo Ok  
echo All done
