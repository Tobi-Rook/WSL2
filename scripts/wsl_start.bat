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
FOR %%i IN ("{00=Ä" "{01=Á" "{02=À" "{03=Å" "{04=ä" "{05=á" "{06=à" "{07=å" "{08=Æ" "{09=æ" "{10=Ç" "{11=ç" "{12=Ë" "{13=É" "{14=È" "{15=ë" "{16=é" "{17=è" "{18=Ğ" "{19=ğ" "{20=Ï" "{21=Î" "{22=ï" "{23=î" "{24=Ñ" "{25=ñ" "{26=Ö" "{27=Ó" "{28=Ò" "{29=Ø" "{30=ö" "{31=ó" "{32=ò" "{33=ø" "{34=ẞ" "{35=Ş" "{36=ß" "{37=ş" "{38=Ü" "{39=Ú" "{40=Ù" "{41=ü" "{42=ú" "{43=ù" "{44=Ÿ" "{45=ÿ" "{46=©" "{47=℗" "{48=®" "{49=™") DO CALL SET "%1=%%%1:%%~i%%"
GOTO:EOF

:Execute
IF "%1" == "code" (
  code %file_Path%
  GOTO:EOF
)
IF "%1" == "exe" (
  %file_Path%
  GOTO:EOF
)
IF "%1" == "dir" (
  explorer %file_Path%
  GOTO:EOF
)
IF "%1" == "start" (
  %file_Path%
  GOTO:EOF
)
IF "%1" == "cmd" (
  cmd /c "%file_Path%"
  GOTO:EOF
)

GOTO:EOF
