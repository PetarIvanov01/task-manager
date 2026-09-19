@echo off

if not exist build mkdir build

xcopy /D /Y vendor\raylib.dll build\

odin build . ^
  -out:build\task-manager.exe ^
  -define:RAYLIB_SHARED=true
