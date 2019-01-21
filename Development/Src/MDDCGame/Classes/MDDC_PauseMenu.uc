class MDDC_PauseMenu extends GFxUI_PauseMenu;
function OnPressExitButton(GFxClikWidget.EventData ev)
{
	ConsoleCommand("exit");
}
defaultproperties
{
        bEnableGammaCorrection=FALSE
        bPauseGameWhileActive=TRUE
        bCaptureInput=true
}
///**
// *      DG_PauseMenu
// *
// *      Creation date: 03/07/2011 20:10
// *      Copyright 2011, Jimmy
// */ 
//var GFxObject RootMC, PauseMC, Btn_Resume_Wrapper, Btn_Exit_Wrapper;
//var GFxClikWidget Btn_ResumeMC, Btn_ExitMC;
 
////GFx framework always runs this function first
//function bool Start(optional bool StartPaused = false)
//{
//        super.Start();
//        Advance(0);
       
//        RootMC = GetVariableObject("_root");
//		PauseMC = RootMC.GetObject("pausemenu");    

//		Btn_Resume_Wrapper = PauseMC.GetObject("resume");
//		Btn_Exit_Wrapper = PauseMC.GetObject("exit");

//		Btn_ResumeMC = GFxClikWidget(Btn_Resume_Wrapper.GetObject("btn", class'GFxClikWidget'));
//		Btn_ExitMC = GFxClikWidget(Btn_Exit_Wrapper.GetObject("btn", class'GFxClikWidget'));
//		Btn_ExitMC.AddEventListener('CLIK_press', OnPressExitButton);
//		Btn_ResumeMC.AddEventListener('CLIK_press', OnPressResumeButton);
//        //`log("RootMC = "$RootMC);
       
//        //AddCaptureKey('XboxTypeS_A');
//        //AddCaptureKey('XboxTypeS_Start');
//        AddCaptureKey('Enter');
       
//        return true;
//}
 

//function OnPressResumeButton(GFxClikWidget.EventData ev)
//{
//    PlayCloseAnimation();
//}
 
 
////function RestartLevel(GFxClikWidget.EventData ev)
////{
////        local string currentMapName;
////        local WorldInfo WI;
       
////        WI = class'WorldInfo'.static.GetWorldInfo();
       
////        currentMapName = WI.Title;
////        //`log("WorldInfo.Title = "$currentMapName);
////        //switch(currentMapName)
////        //{
////        //        case ("Down Town"):
////        //                ConsoleCommand("open DG-DownTownCity");
////        //                break;
////        //        case ("Farm"):
////        //                ConsoleCommand("open DG-Farm");
////        //                break;
////        //        default:
////        //                ConsoleCommand("open MainMenu");
////        //}
////}
 
//function OnPressExitButton(GFxClikWidget.EventData ev)
//{
//	ConsoleCommand("exit");
//}

//function PlayOpenAnimation()
//{
//    PauseMC.GotoAndPlay("open");
//}

//function PlayCloseAnimation()
//{
//    PauseMC.GotoAndPlay("close");
//}

//function OnPlayAnimationComplete()
//{
//    //
//}
//function OnCloseAnimationComplete()
//{
//    MDDCHUD(GetPC().MyHUD).CompletePauseMenuClose();
//}

 
//defaultproperties
//{
//        bEnableGammaCorrection=FALSE
//        bPauseGameWhileActive=TRUE
//        bCaptureInput=true
//}