#!/usr/bin/env bash
ps aux | grep org.apache.catalina.startup.Bootstrap | grep -v grep | awk '{ print $2 }'
