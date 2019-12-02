#!/bin/bash
set -x #echo on

git filter-branch --tree-filter 'rm -f my_file' HEAD
