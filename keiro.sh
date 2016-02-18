#!/bin/sh

# 経路探索

START_AIRPORT=HND
DEP_START_TIME=700 # time
CONN_TIME=30
DEP_START_TIME_RANGE=60 # min
DEP_START_TIMEUP=$(date +%-H%M -d '700 + '$DEP_START_TIME_RANGE' minute')

# INPUT
## START_AIRPORT, time
# OUTPUT
## ARRIVE_AIRPORT, time

init()
{
	START_AIRPORT=$1
	DEP_START_TIME=$2

	for SA in `ls ./timetable/$START_AIRPORT.???.csv` ; do 

		ARRIVE_AIRPORT=`echo $SA | awk -F. '{print $3}'`

		for F in $(cat $SA | awk -F, '{ if ( $2>'$DEP_START_TIME' && $2<'$DEP_START_TIMEUP' ) print }' ) ; do 

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

next()
{
	START_AIRPORT=$1
	DEP_START_TIME=$(date +%-H%M -d $2' + '$CONN_TIME' minute') # 到着時刻から出発まで30分を足す
	DEP_START_TIMEUP=$(date +%-H%M -d $DEP_START_TIME' + '$DEP_START_TIME_RANGE' minute')

	for SA in `ls -1 ./timetable/$START_AIRPORT.???.csv` ; do 

		ARRIVE_AIRPORT=`echo $SA | awk -F. '{print $3}'`

		for F in $(cat $SA | awk -F, '{ if ( $2>'$DEP_START_TIME' && $2<'$DEP_START_TIMEUP' ) print }') ; do 

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

# main $START_AIRPORT $DEP_START_TIME

echo $START_AIRPORT $DEP_START_TIME

for i in $(init $START_AIRPORT $DEP_START_TIME) ; do

	FN=$(echo $i | awk -F, '{print $1}')
	ARRIVE_AIRPORT=$(echo $i | awk -F, '{print $4}')
	ARRIVE_TIME=$(echo $i | awk -F, '{print $5}')

	echo $i
	next $ARRIVE_AIRPORT $ARRIVE_TIME
	echo ---------------------------------------------

done


