#!/bin/bash

# input 
START_TIME=500
START_AIRPORT=HND
TOTAL_MILE=0

## system valiable
CONN_TIME=35 # 乗り継ぎ時間(分)

SEARCH()
{
	START_AIRPORT=$1
	START_TIME=$2

	ls ./timetable/$START_AIRPORT.???.csv > /dev/null ; RET=$?
	if [ $? -ne 0 ] ; then 
		echo "空港ファイル($START_AIRPORT)が無いよ" 
		ECHO_TOTAL_MILE
	fi

	ARRIVE_AIRPORT_LIST=$(ls -1 timetable/$START_AIRPORT.???.csv | awk -F. '{print $2}')

	#echo HOGE : $ARRIVE_AIRPORT_LIST

	for ARRIVE_AIRPORT in $ARRIVE_AIRPORT_LIST ; do 

		# echo 出発空港 : $START_AIRPORT
		# echo 出発設定時間 : $START_TIME
		# echo 到着空港 : $ARRIVE_AIRPORT

		if [ ! -e ./timetable/$START_AIRPORT.$ARRIVE_AIRPORT.csv ] ; then
			# echo $START_AIRPORT - $ARRIVE_AIRPORT の設定がないので処理飛ばし
			continue
		fi

		DATA=$(
		cat ./timetable/$START_AIRPORT.$ARRIVE_AIRPORT.csv |
		awk -F, '$2>'$START_TIME
		)
		
		# echo DATA : $DATA

		if [ -z "$DATA" ] ; then
			#echo $START_TIME に $START_AIRPORT まで辿り着いた
			continue
		fi

		for data in $DATA ; do 
			
			FLIGHT_NUMBER=$( echo $data | awk -F, '{print $1}' )
			START_TIME=$(    echo $data | awk -F, '{print $2}' )
			ARRIVE_TIME=$(   echo $data | awk -F, '{print $3}' )
			MILE=$(cat mile.csv | grep $START_AIRPORT | grep $ARRIVE_AIRPORT | awk -F, '{print $3}' )

			if [ -z "$MILE" ] ; then
				echo "$START_AIRPORTと$ARRIVE_AIRPORT の経路のマイルが未設定。mile.csvを見よ"
				continue
			fi

			TOTAL_MILE=$(( $TOTAL_MILE + $MILE ))
			SAIRPORT=$(awk -F, /$START_AIRPORT/{'print $2'} code.csv)
			AAIRPORT=$(awk -F, /$ARRIVE_AIRPORT/{'print $2'} code.csv)

			echo "$FLIGHT_NUMBER : $SAIRPORT [$START_TIME] => $AAIRPORT [$ARRIVE_TIME]"

			echo $ARRIVE_TIME の $ARRIVE_AIRPORT からの便を検索
			SEARCH $ARRIVE_AIRPORT $(date --date "$ARRIVE_TIME $CONN_TIME minutes" +%H%M)

		done

		echo ==========================================

	done

}

ECHO_TOTAL_MILE()
{
	echo "移動距離: $TOTAL_MILE マイル"
	# exit
}

SEARCH $START_AIRPORT $START_TIME 
