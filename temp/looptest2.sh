#!/bin/bash
for i in {0..2} 
do
  for j in {0..20..10}
  do
    T=$(bc <<<"$i*$j")
    echo "$T"
    ./x86_64/special MyHipp.hoc - << here
    abc($i, $j)
    here
  done
  echo Ok  
done
echo All done

