#!/bin/bash
# CACHEFILE is the place where the script keeps old readings. It is used as a logfile, too.
# you can move CACHEFILE to /tmp if you don't want to keep a log of your battery
CACHEFILE=~/battery_voltage.log
# CACHEAGE is the maximum age a battery reading can have, before it is updated.
CACHEAGE=60

# if the age of the cache + the allowed age is still greater than now, the cache is still valid
if [ $(( $( stat --format=%Y $CACHEFILE ) + $CACHEAGE )) -gt $( date +%s ) ] ;
then
    tail -1 $CACHEFILE
    exit 0
fi
# If the script is still running, the cache must have been invalid
# so append a new line with current data to the cache
(
	export PERCENT=$(sudo cat /sys/firmware/beepberry/battery_percent )
	export VOLTAGE=$(sudo cat /sys/firmware/beepberry/battery_volts )
	export RAW=$(sudo cat /sys/firmware/beepberry/battery_raw )
        export TIME=$(date +'%H:%M %d.%m')
	echo $PERCENT'% '$VOLTAGE'v '$RAW' '$TIME' '
) >> $CACHEFILE

tail -1 $CACHEFILE
