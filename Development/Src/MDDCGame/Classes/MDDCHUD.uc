class MDDCHUD extends UTHUDBase;


exec function ShowMenu()
{
        // if using GFx HUD, use GFx pause menu
        TogglePauseMenu();
}
 
/*
 * Toggle the Pause Menu on or off.
 *
 */
function TogglePauseMenu()
{
    if ( PauseMenuMovie != none && PauseMenuMovie.bMovieIsOpen )
        {
			CompletePauseMenuClose();
        }
        else
    {
        PlayerOwner.SetPause(True);
 
        if (PauseMenuMovie == None)
        {
            PauseMenuMovie = new class 'MDDC_PauseMenu';
            PauseMenuMovie.MovieInfo = SwfMovie'MDDCFlashMenu.menu.pause_menu';
			//PauseMenuMovie = new class'GFxUI_PauseMenu';
            //PauseMenuMovie.MovieInfo = SwfMovie'UDKHud.udk_pausemenu';
            PauseMenuMovie.bEnableGammaCorrection = FALSE;
            PauseMenuMovie.LocalPlayerOwnerIndex = class'Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));
            PauseMenuMovie.SetTimingMode(TM_Real);
        }
 
        SetVisible(false);
        PauseMenuMovie.Start();
        PauseMenuMovie.PlayOpenAnimation();
        PauseMenuMovie.AddFocusIgnoreKey('Escape');
    }
}
 
//UnPause and close Pause HUD SWF
function CompletePauseMenuClose()
{
    PlayerOwner.SetPause(False);
    PauseMenuMovie.Close(false);
}
 