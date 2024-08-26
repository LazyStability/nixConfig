#!/bin/sh

noteFilename="$HOME/notes/dailies/$(date +%>-%m-%d).md"

nvim -c "norm Go"\
	-c "norm Go## $(date +%H:%M)"\
	-c "norm zz"\
	-c "startinsert" $noteFilename
