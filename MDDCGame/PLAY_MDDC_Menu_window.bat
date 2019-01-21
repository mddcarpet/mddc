setlocal
call global.bat
call local.bat
%udk% MainMenu-new?game=MDDCGame.MDDCGame %ini% -LOG %*
endlocal