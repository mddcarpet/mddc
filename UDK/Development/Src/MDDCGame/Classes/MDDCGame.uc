// Magic Dance Dance Carpet
// mddcarpet@googlegroups.com

// Jakub Janovsky
// Filip Bartek
// Margarita Vishnyakova
// Jiri Nezapomenout
// Jan Drska

class MDDCGame extends GameInfo;

defaultproperties
{
	bDelayedStart=false
	PlayerControllerClass=Class'MDDCGame.GeniePlayerController'
	DefaultPawnClass=Class'MDDCGame.GeniePawn'
	HUDType = Class'MDDCGame.MDDCHUD'
}