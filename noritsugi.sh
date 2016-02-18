#!/bin/bash

# 乗り継ぎ全探索

# とりあえず羽田から到着60分で乗り継げる瓶を探す
NTIME=60
DA=HND

# 乗り継ぎできる便を探す
function noritsugi
{
	local AA=$1
	local FN=$2
	local AT=$3
	local DT=$4
	local DT_NTIME=$( date +%-H%M -d $DT' + '$NTIME' minute')

	# + noritsugi YGJ 1087 1310 1430

	for i in $( ls -1 timetable/${AA}.*.csv ) ; do

		local DA=$AA
		local NA=$( echo $i | awk -F. '{print $2}' ) # next airport

		for j in $(
			cat timetable/${DA}.${NA}.csv | 
			sort -n -t , -k2 |
			awk -F, '{ if ( $2>'$DT_NTIME' ) print }' |
			head -n 1) ; do

			echo $DA" -> "$NA
			echo $j
			FN=$(echo $j | awk -F, '{print $1}') # Flight Number
			AT=$(echo $j | awk -F, '{print $2}') # Arrive Time
			DT=$(echo $j | awk -F, '{print $3}') # Depart Time

			#echo call noritsugi
			noritsugi $NA $FN $AT $DT 

		done
	done

}


# 出発する空港から出発する便を全て出力
function main
{

	for i in $( ls -1 timetable/${DA}.*.csv ) ; do 

		DA=$DA # Depart Airport
		AA=$( echo $i | awk -F. '{print $2}' ) # Arrive Airport

		for j in $(cat timetable/${DA}.${AA}.csv | sort -n -t , -k2 | head -n 1) ; do

			echo ----------------------
			FN=$(echo $j | awk -F, '{print $1}') # Flight Number
			AT=$(echo $j | awk -F, '{print $2}') # Arrive Time
			DT=$(echo $j | awk -F, '{print $3}') # Depart Time

			echo $DA" -> "$AA
			echo $j
			noritsugi $AA $FN $AT $DT
		done

	done
}

# 最終的に配列に格納する
## arr[$FN1]=$FN2 # 乗り継げるFN(FlightNumber)

main
