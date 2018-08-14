#!/bin/bash

counter=-1
while [ $counter -le 15 ]
do
echo $counter
param=20
#first parameter is the seed for random num gen.
#second is the lamda in Hz. stim interval is (1/lambda)*1000 ms
((counter++))
./x86_64/special MyHipp.hoc - << here
abc(0, 4+2*$counter)
here
echo This run done!
echo $param

done
echo All done
counter=-1
while [ $counter -le 15 ]
do
echo $counter
param=20
#first parameter is the seed for random num gen.
#second is the lamda in Hz. stim interval is (1/lambda)*1000 ms
((counter++))
./x86_64/special MyHipp.hoc - << here
abc(10, 4+2*$counter)
here
echo This run done!
echo $param

done
echo All done


