@echo off

if not exist build mkdir build

xcopy /D /Y vendor\raylib.dll build\

odin run . ^
  -out:build\task-manager.exe ^
  -define:RAYLIB_SHARED=true
