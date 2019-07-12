SETLOCAL EnableDelayedExpansion
IF "%1" == "start" (
	SET file_Path="%~2"
	GOTO:Routines
)

SET file_Path=%2
GOTO:Routines

:Routines
CALL :Replace file_Path
GOTO:Execute

:Replace
FOR %%i IN ("{A=Ä" "{B=ä" "{C=Å" "{D=å" "{E=É" "{F=é" "{G=Ñ" "{H=ñ" "{I=Ö" "{J=ö" "{K=Ø" "{L=ø" "{M=ẞ" "{N=ß" "{O=Ü" "{P=ü") DO CALL SET "%1=%%%1:%%~i%%"
GOTO:EOF

:Execute
IF "%1" == "no" (
	notepad.exe %file_Path%
)
IF "%1" == "no2" (
	notepads %file_Path%
)
IF "%1" == "exe" (
	%file_Path%
	GOTO:EOF
)
IF "%1" == "start" (
	%file_Path%
)
IF "%1" == "cmd" (
	cmd.exe /c "%file_Path%"
)

GOTO:EOF

