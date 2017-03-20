#!/usr/bin/env bash

region=$1

name=$(\
    aws --region $region ec2 describe-images --owners 099720109477 \
        --filters Name=root-device-type,Values=ebs \
            Name=architecture,Values=x86_64 \
            Name=name,Values='*hvm-ssd/ubuntu-trusty-14.04*' \
    | awk -F ': ' '/"Name"/ { print $2 | "sort" }' \
    | tr -d '",' | tail -1)

ami_id=$(\
    aws --region $region ec2 describe-images --owners 099720109477 \
        --filters Name=name,Values="$name" \
    | awk -F ': ' '/"ImageId"/ { print $2 }' | tr -d '",')


echo "$region"
echo "$name"
echo "$ami_id"
