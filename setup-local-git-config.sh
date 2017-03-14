#!/usr/bin/env bash


echo -e "\nglobal config: \n" 
git config --list

git config user.email "rcsuax@gmail.com"
git config user.name "Rcsuax"

echo -e "\nlocal config:"
git config user.email
git config user.name

