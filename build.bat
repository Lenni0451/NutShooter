@echo off

mkdir build
mkdir build\windows
v . -cc msvc -prod -skip-unused -o build/windows/nutshooter.exe
