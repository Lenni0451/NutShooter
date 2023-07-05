#!/bin/bash

mkdir build
mkdir build/linux
v . -cc gcc -prod -skip-unused -o build/linux/nutshooter
