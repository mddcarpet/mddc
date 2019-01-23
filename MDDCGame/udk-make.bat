setlocal
call global.bat
call local.bat
%udkmake% %ini% -REGENERATEINIS %*
endlocal