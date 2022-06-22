#!/bin/bash -i

shopt -s expand_aliases

full_path=$1
file_parent_dir=${full_path%/*}
filename=${full_path##*/}
module_name=${filename%.*}


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
	echo "parent dir: $file_parent_dir"
	echo "compiling file: $filename"
	echo "simulating module:$module_name"
	
	vlog ../rtl_src/*.sv	
	vlog ../$file_parent_dir/*.sv
	vsim $module_name -quiet -do ../$file_parent_dir/*.do 
fi

exit

