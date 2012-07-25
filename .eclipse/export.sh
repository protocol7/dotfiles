#!/bin/sh

sed '1d' $1 | grep -f blacklist.txt -v | sort
