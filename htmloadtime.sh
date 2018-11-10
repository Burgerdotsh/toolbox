#!/usr/bin/env bash

HAVE_WGET=$(which wget);
COMPUTE_HOST=$1;

function test {
    res=$( curl -w %{http_code} -s --output /dev/null $1);
	
    if [ "$res" == "000" ]
    then
        echo "Error: could not connect to $1";
    fi
	
    if [ $res -ne 200 ]
    then
        echo "Error: HTTP Status $res on $1";
    fi
} 

if [ -z "$COMPUTE_HOST" ]; then
	echo "Error: enter a host!";
	exit;
else
	echo "Computing load time for $COMPUTE_HOST: ";
fi

test $COMPUTE_HOST;

if [ -z "$HAVE_WGET" ]; then
	echo "Error: Please install wget!";
	exit;
fi

(time wget -p --no-cache --delete-after $COMPUTE_HOST -q ) 2>&1 | awk '/real/ {print $2}'
