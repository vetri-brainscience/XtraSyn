#!/bin/bash

for i in {2..32..2} 
do
  for j in {0..10}
  do
    T=$(bc <<<"$i*$j")
#  echo "$T"
./x86_64/special -nobanner MyHipp.hoc - << here
  abc($j, $i)
here
  done
  echo Ok  
done
echo All done

