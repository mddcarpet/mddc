rem Local configuration. Should be configured separately for each PC. MDDC-specific.

set gamename=MDDC

rem DEF* inis are redirected so that we can use our own configuration without altering the default UDK files.
rem Non-DEF inis are redirected so that the default non-DEF inis needn't be overwritten. (FB: At least I think so.)
set ini=-DEFENGINEINI=..\..\%gamename%Game\Config\DefaultEngine.ini -ENGINEINI=..\..\%gamename%Game\Config\Engine.ini -DEFGAMEINI=..\..\%gamename%Game\Config\DefaultGame.ini -GAMEINI=..\..\%gamename%Game\Config\Game.ini -DEFINPUTINI=..\..\%gamename%Game\Config\DefaultInput.ini -INPUTINI=..\..\%gamename%Game\Config\Input.ini