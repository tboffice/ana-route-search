#!/bin/bash

# ���Ѥ���õ��

# �Ȥꤢ�������Ĥ�������60ʬ�Ǿ��Ѥ����Ӥ�õ��
NTIME=60
DA=HND

# ���Ѥ��Ǥ����ؤ�õ��
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


# ��ȯ������������ȯ�����ؤ����ƽ���
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

# �ǽ�Ū������˳�Ǽ����
## arr[$FN1]=$FN2 # ���Ѥ���FN(FlightNumber)

main
