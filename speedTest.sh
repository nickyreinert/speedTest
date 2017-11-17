#!/bin/bash
# follow the google date format convetion, otherwise the date will not be recognizied:
# https://developers.google.com/datastudio/connector/semantics
#sourceFiles=("1Mb.db" "10Mb.db" "100Mb.db" "1Gb.db")
sourceFileSizes=(1 10 100 1000)
sourceBaseUrl="http://speedtest.ftp.otenet.gr/files/test"
destinationFolder="/share/Download/Speedtest/"
journalFile="/share/Download/Speedtest/results.csv"
pause=3
loops=3
i=0

for sourceFileSize in "${sourceFileSizes[@]}";
do

	while [ $i -lt $loops ]; do

		startTime=$(($(date +%s%N)))

		if [ "$sourceFileSize" = "1000" ]
		then

			wget --quiet --output-document=$destinationFolder$sourceFileSize"Mb.db.tmp" $sourceBaseUrl"1Gb.db"

		else

			wget --quiet --output-document=$destinationFolder$sourceFileSize"Mb.db.tmp" $sourceBaseUrl$sourceFileSize"Mb.db"

		fi

		endTime=$(($(date +%s%N)))
		delayNsecs=$(($endTime - $startTime))

		delaySecs=$(awk -v delayNsecs="$delayNsecs" 'BEGIN{printf "%.4f\n", ( delayNsecs / 1000000000)}')

		MBitPerSec=$(awk -v sourceFileSize=$sourceFileSize -v delayMSecs=$delaySecs 'BEGIN{printf "%.4f\n", ( sourceFileSize * 8 / delayMSecs)}')

		echo "$(date '+%Y-%m-%d %H:%M:%S'),$delayNsecs,$delaySecs,$MBitPerSec,$sourceFileSize"MByte"" >> $journalFile


		if [ "$sourceFileSize" = "1000" ]
		then
			exit
		fi

		sleep $pause

		((i++))

	done

	((i=0))

done
