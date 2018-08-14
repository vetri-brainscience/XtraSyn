#!/bin/bash

counter=-1
while [ $counter -le -1 ]
do
echo $counter
param=20
#first parameter is the seed for random num gen.
#second is the lamda in Hz. stim interval is (1/lambda)*1000 ms
((counter++))
./x86_64/special MyHipp.hoc - << here
abc($counter, 10)
here
echo This run done!
done
echo All done


