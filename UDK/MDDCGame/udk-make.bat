setlocal
call global.bat
call local.bat
%udkmake% -DEFENGINEINI=..\..\%gamename%Game\Config\DefaultEngine.ini -ENGINEINI=..\..\%gamename%Game\Config\Engine.ini %*
endlocal