@echo off
call "E:\Microsoft Visual Studio 14.0\VC\VCVARSALL.BAT " amd64

cd .
nmake -f vdp.mk  RSIM_SOLVER_SELECTION=2 ISPROTECTINGMODEL=NOTPROTECTING OPTS="-DSLMSG_ALLOW_SYSTEM_ALLOC -DTGTCONN -DON_TARGET_WAIT_FOR_START=0"
@if errorlevel 1 goto error_exit
exit /B 0

:error_exit
echo The make command returned an error of %errorlevel%
An_error_occurred_during_the_call_to_make
