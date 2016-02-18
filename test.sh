#!/bin/sh

for i in `seq 1 10` ; do 
	echo B $i
	grep -q ERROR /tmp/1000 && continue
	echo A $i
done
