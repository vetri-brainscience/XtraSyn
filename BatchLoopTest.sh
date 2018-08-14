#!/bin/bash
# Basic while loop
counter=1
N=10
while [ $counter -le 10 ]
do
  echo $counter
  ((counter++))
done
echo All done