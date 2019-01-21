setlocal
call global.bat
call local.bat
%udk% MainMenu-new?game=MDDCGame.MDDCGame %ini% -LOG -fullscreen -resx=1024 -resy=768 -BENCHMARK -FPS=30 -DUMPMOVIE -MAXQUALITYMODE %*
endlocal