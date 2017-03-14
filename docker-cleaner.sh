#!/usr/bin/env bash

CON=$(docker ps -a -q)
IMG=$(docker images -q)

if [ "$CON" != "" ]; then
	echo "deleting containers: $CON"
	docker rm $CON
fi

# [ -n STRING ] or [ STRING ] returns true if the length of the string is non-zero
if [ -n "$IMG " ]; then
	echo "deleting images: $IMG"
	docker rmi $IMG
fi

