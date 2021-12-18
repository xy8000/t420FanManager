#!/bin/bash
# Information:
#	Params:
# 		$1 = Manual high temp
# 		$2 = Seconds between updates
#	Needs root
#   Only for Lenovo-PCs
#	Following programms should be available:
#		sensors

# Variables
timeout=$2
if [[ -z $timeout ]]
then
	timeout=3
fi
disengaged=0
man_high_temp=$1

# Funcitons
check_last_rc () {
	rc=$?
	if [ $rc -ne 0 ]
	then
		echo "Could not execute programm. Do you granted root permissions? Aborting!"
		exit 1   
	fi
}
get_current_temp () {
	echo $( sensors | grep 'Core 0' | awk '{print $3}' | sed 's/[^0-9.]*//g' )
}
get_high_temp () {
	if [[ -z $man_high_temp ]]
	then
		echo $( sensors | grep 'Core 0' | awk '{print $6}' | sed 's/[^0-9.]*//g' )
	else
		echo $man_high_temp
	fi
}
disengage_fan () {
	echo "Fan-Status: disengaged"
	sudo bash -c "echo level disengaged > /proc/acpi/ibm/fan"
	disengaged=1
	check_last_rc
}
reset_fan () {
	echo "Fan-Status: auto"
	sudo bash -c "echo level auto > /proc/acpi/ibm/fan"
	disengaged=0
	check_last_rc
}
print_cpu_temp () {
	echo "Current temp: " $( get_current_temp )
}

# Code
echo "CPU-Infos:"
echo "Current temp: " $( get_current_temp )
echo "High temp: " $( get_high_temp )
echo "Seconds between updates: " $timeout
reset_fan
while [ 1 ]
do
	print_cpu_temp
	if [[ "$( get_current_temp )" > "$( get_high_temp )" ]]
	then
		if [ $disengaged -eq 0 ]
		then
			disengage_fan
		fi
	else
		if [ $disengaged -eq 1 ]
		then
			reset_fan
		fi
	fi
	sleep $timeout
done
