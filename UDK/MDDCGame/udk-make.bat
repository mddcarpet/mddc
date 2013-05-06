setlocal
call global.bat
call local.bat
%udkmake% %ini% %*
endlocal