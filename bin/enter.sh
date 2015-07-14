#!/bin/bash

if [ -f /usr/bin/rce ]; then
	ENGINE=rce
else
	ENGINE=docker
fi

CONTAINER_PID=$($ENGINE inspect --format '{{if .State.Running}}{{.State.Pid}}{{end}}' $1)
if [ -z $CONTAINER_PID ]; then
	read -p "Application must be running for a terminal to be started."
else
	nsenter --target $CONTAINER_PID --mount --uts --ipc --net --pid -- bash -c 'export $(xargs -n 1 -0 < /proc/1/environ); exec bash'
fi
