#!/bin/sh

noteFilename="$HOME/Dokumente/Personal/Tagebuch/Täglich/thisYear/$(date +%y-%m-%d).md"

nvim -c "norm Go"\
	-c "norm Go## $(date +%H:%M)"\
	-c "norm zz"\
	-c "startinsert" $noteFilename

exit
