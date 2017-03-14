#!/usr/bin/env bash

CON= $(docker ps -a -q)
IMG= $(docker images -q)

if [ "$CON" != "" ]; then
	echo "deleting containers: $CON"
	docker rm "$CON"
fi

#[ -z STRING ]	True if the length of "STRING" is zero.
if [ -z "$IMG " ]; then
	echo "deleting images: $IMG"
	docker rmi "$IMG"
fi

