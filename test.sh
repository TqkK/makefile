#!/bin/bash
echo TEST SCRIPT ON UBUNTU
echo Name?
echo ...
read who
echo Hi, $who! 
echo Age?
echo ...
read age

if [ "$age" -eq 20 ]
then
	echo equal
else
	echo notequal
fi

FILES=/home/tqkk/Desktop/a.cpp
for f in $FILES
do
	echo $f
done

