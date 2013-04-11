class GeniePlayerController extends PlayerController;

// Note that this PlayerController respects Pawn's desired camera setting returned by Pawn.GetDefaultCameraMode.

var float TurnRateCurrent;
var const float TurnRateDamping;
var const float TurnRateInput;
var const float TargetSpeedCenter;
var const float TargetSpeedRate;
var const float UpRate;
var const float SpeedChangeAlpha;

// http://www.moug-portfolio.info/udk-ai-pawn-movement/
event Possess(Pawn inPawn, bool bVehicleTransition)
{
	//local GeniePawn testPawn;

    super.Possess(inPawn, bVehicleTransition);
	
	// testPawn
    //testPawn = Spawn(class 'GeniePawn',,, vect(500, 500, -500),,,);
	//testPawn.Velocity = vect(100, -100, 100);
	//testPawn.Velocity = testPawn.Velocity - ProjectOnTo(testPawn.Velocity, testPawn.Location);

	// PlayerGenie
	GoToState('PlayerGenie');
}

// Mimics super.PlayerFlying
state PlayerGenie
{
	// Expects Pawn to be a GeniePawn!

	event BeginState(Name PreviousStateName)
	{
		// Set Pawn's physics to Flying.
		Pawn.SetPhysics(PHYS_Flying);
	}

	function UpdateRotation( float DeltaTime )
	{
		// super.UpdateRotation inherits Pawn's Rotation from PlayerController - we want it the other way round.
		if (Pawn!=none)
		{
			// Expects Pawn to be a GeniePawn.
			GeniePawn(Pawn).RecallRotation(DeltaTime); // HACK: Recover Pawn.Rotation after it's been possibly invalidated (probably) by PlayerController.Tick.

			// Inherit Rotation from Pawn.
			SetRotation(Pawn.Rotation);
		}
	}

	// Mimics super.PlayerFlying.PlayerMove
	function PlayerMove(float DeltaTime)
	{
		local Vector X,Y,Z;
		local float DeltaAngle;
		local Quat DeltaQuat;
		local float VerticalLocation;
		local float TargetSpeed;
		local Vector TargetVelocity;

		// Update Velocity
		UpdateRotation(DeltaTime); // Updates Rotation to a proper value (as it may have been invalidated by some other function).
		GetAxes(Rotation, X, Y, Z);
		VerticalLocation = VSize(Pawn.Location); // Distance from center
		TargetSpeed = TargetSpeedCenter + VerticalLocation * TargetSpeedRate;
		TargetVelocity = X * TargetSpeed + Z * PlayerInput.aUp * UpRate / DeltaTime / DeltaTime/12000000;
		
		Pawn.Velocity = VLerp(Pawn.Velocity, TargetVelocity, DeltaTime * SpeedChangeAlpha);
		
		// Turn Pawn.Velocity according to PlayerInput.aTurn.
		TurnRateCurrent *= 1 - DeltaTime * TurnRateDamping;
		TurnRateCurrent += PlayerInput.aTurn * TurnRateInput;
		DeltaAngle = DeltaTime * TurnRateCurrent; // Angle to rotate Velocity.
		DeltaQuat = QuatFromAxisAndAngle(-Pawn.Location, DeltaAngle); // Quaternion that does the rotation.
		Pawn.Velocity = QuatRotateVector(DeltaQuat, Pawn.Velocity); // Engage!

		// Some lines copied from super.PlayerFlying.PlayerMove
		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Pawn.Acceleration, DCLICK_None, rot(0,0,0));
	}
}

//Functions for zooming in and out
exec function NextWeapon() /*The "exec" command tells UDK to ignore what the defined function of NextWeapon is, and use our function declaration here.
We'll go over how to change the function of keys later (if, for instance, you didn't want you use the scroll wheel, but page up and down for zooming instead.)*/
{
if (PlayerCamera.FreeCamDistance < 512) //Checks that the the value FreeCamDistance, which tells the camera how far to offset from the view target, isn't further than we want the camera to go. Change this to your liking.
	{
		//`Log("MouseScrollDown"); //Another log message to tell us what's happening in the code
		PlayerCamera.FreeCamDistance += 64*(PlayerCamera.FreeCamDistance/256); /*This portion increases the camera distance.
By taking a base zoom increment (64) and multiplying it by the current distance (d) over 256, we decrease the zoom increment for when the camera is close,
(d < 256), and increase it for when it's far away (d > 256).
Just a little feature to make the zoom feel better. You can tweak the values or take out the scaling altogether and just use the base zoom increment if you like */
	}
}
exec function PrevWeapon()
{
	if (PlayerCamera.FreeCamDistance > 64) //Checking if the distance is at our minimum distance
	{
		//`Log("MouseScrollUp");
		PlayerCamera.FreeCamDistance -= 64*(PlayerCamera.FreeCamDistance/256); //Once again scaling the zoom for distance
	}
}

defaultproperties
{
	Physics=PHYS_Flying
	
	TickGroup=TG_PostAsyncWork
	// So that native super.Tick doesn't overwrite Pawn.Rotation with invalid value (Roll=0) just before the scene is rendered.
	// The proper Rotation is recovered by calling GeniePawn(Pawn).RecallRotation from UpdateRotation.

	CameraClass=class'MCCamera' //Telling the player controller to use your custom camera script
	//DefaultFOV=90.f //Telling the player controller what the default field of view (FOV) should be
	TurnRateCurrent=0
	TurnRateDamping=5
	TurnRateInput=0.0005
	TargetSpeedCenter=0
	TargetSpeedRate=0.3
	UpRate=6000;
	SpeedChangeAlpha=1
}