#!/bin/bash -i

shopt -s expand_aliases

if [ ! -d 'modelsim_simulation' ] ; then 
	echo "no modelsim_simulation directory found"
	echo $'creating modelsim_simulation directory\n'
	mkdir modelsim_simulation
fi

cd modelsim_simulation


if [ ! -d 'work' ] ; then 
	echo "no work directory found"
	echo $'creating work directory\n'
	vlib work
fi

if [ -z $1 ]; then 
	echo 'no file specified'
	echo $'enter file\n'
else
	vlog ../$1
fi

exit

