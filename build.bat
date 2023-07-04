@echo off

mkdir build 2>nul
v . -cc msvc -prod -skip-unused -o build/nutshooter.exe
