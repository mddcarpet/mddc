setlocal

set gamename=MDDC
set configpath=..\..\%gamename%Game\Config

rem DEF* inis are redirected so that we can use our own configuration without altering the default UDK files.
rem Non-DEF inis are redirected so that the default non-DEF inis needn't be overwritten. (FB: At least I think so.)
rem https://api.unrealengine.com/udk/Three/CommandLineArguments.html#INI/Config%20Files
set ini=^
-EDITORINI=%configpath%\MDDCEditor.ini ^
-EDITORUSERSETTINGSINI=%configpath%\MDDCEditorUserSettings.ini ^
-LIGHTMASSINI=%configpath%\MDDCLightmass.ini ^
-ENGINEINI=%configpath%\MDDCEngine.ini ^
-GAMEINI=%configpath%\MDDCGame.ini ^
-INPUTINI=%configpath%\MDDCInput.ini ^
-UIINI=%configpath%\MDDCUI.ini ^
-DEFENGINEINI=%configpath%\DefaultEngine.ini ^
-DEFGAMEINI=%configpath%\DefaultGame.ini ^
-DEFINPUTINI=%configpath%\DefaultInput.ini

..\Binaries\Win32\UDK.exe %* %ini%

endlocal