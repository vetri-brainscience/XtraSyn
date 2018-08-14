#!/bin/bash
echo "-----------------"

# If you need a random int within a certain range, use the 'modulo' operator.
# This returns the remainder of a division operation.

RANGE=10
for i in {0..10} 
do
  number=$RANDOM
  let "number %= $RANGE"
  #           ^^
  echo "Random number less than $RANGE  ---  $number"
done
echo
