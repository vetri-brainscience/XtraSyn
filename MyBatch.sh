#!/bin/bash

counter=$1
./x86_64/special -nobanner MyHipp.hoc - << here
  abc($counter, 0.001)
here
  
echo Ok  
echo All done
