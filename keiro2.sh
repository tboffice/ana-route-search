#!/bin/sh

# ·ÐÏ©Ãµº÷

START_AIRPORT=HND
DEP_START_TIME=600
CONN_TIME=30

# INPUT
## START_AIRPORT, time
# OUTPUT
## ARRIVE_AIRPORT, time

main()
{
	START_AIRPORT=$1
	DEP_START_TIME=$2

	for SA in `ls -1 ./timetable/$START_AIRPORT.???.csv | head -n 1` ; do 

		ARRIVE_AIRPORT=`echo $SA | awk -F. '{print $3}'`

		for F in $(cat $SA | awk -F, '$2>'$DEP_START_TIME) ; do 

			FN=`echo $F | awk -F, '{print $1}'`
			START_TIME=`echo $F | awk -F, '{print $2}'`
			ARRIVE_TIME=`echo $F | awk -F, '{print $3}'`

			# echo DEP_START_TIME : $DEP_START_TIME

			echo "$FN,$START_AIRPORT,$START_TIME,$ARRIVE_AIRPORT,$ARRIVE_TIME"

			# echo START_AIRPORT : $START_AIRPORT
			# echo START_TIME : $START_TIME
			# echo ARRIVE_AIRPORT :  $ARRIVE_AIRPORT
			# echo ARRIVE_TIME : $ARRIVE_TIME

		done

	done

}

main $START_AIRPORT $DEP_START_TIME
