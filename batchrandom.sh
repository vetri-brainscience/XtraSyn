#!/bin/bash
NOW=$(date +"%m-%d-%Y")
echo
echo $NOW
echo
echo $SECONDS
 echo $RANDOM
 var1=Vetri
 var2='is an idiot'
 
 for i in {0..10} 
do
  for j in {0..20}
  do
    T=$(bc <<<"$i*$j")
    #echo "$T"
  done
  echo Ok  
done
echo All done
echo var1 and var2 :: $var1 : $var2  
echo second : $SECONDS
echo
echo $NOW
echo