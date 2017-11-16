#!/bin/bash
# follow the google date format convetion, otherwise the date will not be recognizied:
# https://developers.google.com/datastudio/connector/semantics
#sourceFiles=("1Mb.db" "10Mb.db" "100Mb.db" "1Gb.db")
sourceFiles=("1Mb.db" "10Mb.db" "100Mb.db" "1Gb.db")
sourceBaseUrl="http://speedtest.ftp.otenet.gr/files/test"
destinationFolder="/share/Download/Speedtest/"
journalFile="/share/Download/Speedtest/results.csv"
pause=3
loops=3
i=0

for sourceFile in "${sourceFiles[@]}";
do

	while [ $i -lt $loops ]; do

		startTime=$(($(date +%s%N)))
		wget --quiet --output-document=$destinationFolder$sourceFile.tmp $sourceBaseUrl$sourceFile
		endTime=$(($(date +%s%N)))
		delay=$(($endTime - $startTime))
 		echo "$(date '+%Y-%m-%d %H:%M:%S'),$delay,$sourceFile" >> $journalFile

		if [ "$sourceFile" = "1Gb.db" ]
		then
			exit
		fi

		sleep $pause

		((i++))

	done

	((i=0))

done
