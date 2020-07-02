@echo off
set mypath=%cd%
powershell -noprofile -command "&{ start-process powershell -ArgumentList '-ExecutionPolicy Bypass -noprofile -file %mypath%\inventory.ps1' -verb RunAs}"