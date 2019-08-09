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
FOR %%i IN ("{0=Ä" "{1=ä" "{2=Á" "{3=á" "{4=À" "{5=à" "{6=Å" "{7=å" "{8=Ë" "{9=ë" "{A=É" "{B=é" "{C=È" "{D=è" "{E=Ñ" "{F=ñ" "{G=Ö" "{H=ö" "{I=Ó" "{J=ó" "{K=Ò" "{L=ò" "{M=Ø" "{N=ø" "{O=ẞ" "{P=ß" "{Q=Ü" "{R=ü" "{S=Ú" "{T=ú" "{U=Ù" "{V=ù") DO CALL SET "%1=%%%1:%%~i%%"
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

