//=============================================================================
// GeniePawn
// Based on SPG_PlayerPawn
//
// http://labs.vectorform.com/2011/11/creating-a-side-scrolling-game-with-udk/
//=============================================================================

class GeniePawn extends Pawn; // Filip: original Genie
//class GeniePawn extends GamePawn; // Margarita

var bool bFrictionCompensation;
var bool bFrictionCompensationOnlySphere;
var float FrictionCompensation;

var bool bFrictionVerticalExtra;
var float FrictionVerticalExtra;

var bool bAirSpeedControl;
var float AirSpeedCenter;
var float AirSpeedRate;

var Rotator GenieRotation;

var const float MinVerticalLocation;

// http://wiki.beyondunreal.com/Legacy:Quaternions_In_Unreal_Tournament#Vector_expression
// Sets the components of a vector. Vect cannot be used as it will not accept an expression.
static function vector eVect( float x , float y , float z )
{
 // for some reason vect() wont work when setting an array element
 local vector v ;
 v.x = x ;
 v.y = y ;
 v.z = z ;
 return v ;
}

static function string QuatToString(quat Other)
{
	local string result;
	result = "X=" $ Other.X $ ";Y=" $ Other.Y $ ";Z=" $ Other.Z $ ";W=" $ Other.W;
	return result;
}

simulated function Tick(float DeltaTime)
{
	local Vector HorizontalVelocity;
	local float HorizontalVelocitySize;
	local Vector VerticalVelocity;
	local float HorizontalVelocityAngleSpeed;
	local float DeltaAngle;
	local Quat DeltaQuat;
	local Vector RotationAxis;
	local float VerticalLocation;
	local float VelocityDotLocation;

	if (VSize(Velocity) > 0)
	{
		if (bAirSpeedControl)
		{
			// Control AirSpeed dynamically according to distance from center.
			// AirSpeed is the maximal Velocity size.
			// Velocity is pushed to this value in GeniePlayerController.PlayerMove using AccelerationForwardExtra.
			// Set AccelRate to a high value to make Velocity approach AirSpeed at a high rate.
			VerticalLocation = VSize(Location); // Distance from center
			AirSpeed = AirSpeedCenter + VerticalLocation * AirSpeedRate;
		}

		if (bFrictionCompensation)
		{
			// Compensate for air friction imposed by Unreal Engine (probably in native Tick).
			if (bFrictionCompensationOnlySphere)
			{
				// Only compensate in horizontal direction
				VerticalVelocity = ProjectOnTo(Velocity, Location); // The component of Velocity parallel with Location
				HorizontalVelocity = Velocity - VerticalVelocity; // The component of Velocity perpendicular to Location
				HorizontalVelocity = HorizontalVelocity * (1 + (FrictionCompensation * DeltaTime)); // Extend horizontal velocity.
				Velocity = HorizontalVelocity + VerticalVelocity; // Compose velocity from horizontal and vertical components.
			}
			else
			{
				// Compensate in all directions
				Velocity = Velocity * (1 + (FrictionCompensation * DeltaTime)); // Extend Velocity.
			}
		}

		if (bFrictionVerticalExtra)
		{
			// Apply extra friction in vertical direction
			VerticalVelocity = ProjectOnTo(Velocity, Location); // The component of Velocity parallel with Location
			HorizontalVelocity = Velocity - VerticalVelocity;
			VerticalVelocity = VerticalVelocity * (1 - (FrictionVerticalExtra * DeltaTime)); // Shorten vertical velocity.
			Velocity = HorizontalVelocity + VerticalVelocity; // Compose velocity from horizontal and vertical components.
		}

		// Push genie from center when she's too close
		if (VSize(Location) < MinVerticalLocation)
		{
			// Move away from center
			SetLocation(Normal(Location) * MinVerticalLocation);
			VelocityDotLocation = Velocity dot Location;
			if (VelocityDotLocation < 0)
			{
				// Level velocity
				VerticalVelocity = ProjectOnTo(Velocity, Location);
				HorizontalVelocity = Velocity - VerticalVelocity;
				Velocity = HorizontalVelocity;
			}
		}

		// Rotate Velocity around center to simulate excentric gravitation (main function).
		// Center is the point with coordinates (0, 0, 0).
		VerticalVelocity = ProjectOnTo(Velocity, Location); // The component of Velocity parallel with Location
		HorizontalVelocity = Velocity - VerticalVelocity; // The component of Velocity perpendicular to Location
		HorizontalVelocitySize = VSize(HorizontalVelocity); // Horizontal speed
		HorizontalVelocityAngleSpeed = HorizontalVelocitySize / VSize(Location);
		// By travelling for one second at the present horizontal speed along the current orbit, the Velocity direction will turn by HorizontalVelocityAngleSpeed radians.
		DeltaAngle = HorizontalVelocityAngleSpeed * DeltaTime;
		// By travelling for DeltaTime at the present horizontal speed along the current orbit, the Velocity direction will turn by DeltaAngle radians.
		RotationAxis = Location cross Velocity; // Velocity will rotate around axis that is perpendicular to both Location and Velocity.
		DeltaQuat = QuatFromAxisAndAngle(RotationAxis, DeltaAngle); // The quaternion that will do the proper rotation.
		Velocity = QuatRotateVector(DeltaQuat, Velocity); // Engage rotation!
		
		// Update Rotation so that it follows Velocity
		GenieRotation = OrthoRotation(Normal(HorizontalVelocity), Normal(RotationAxis) * -1, Normal(Location) * -1);
		// We use OrthoRotation instead of Rotator(Velocity) to set Roll properly.
		// Set Rotation so that it faces Velocity with center above the head.
	}
	else
	{
		GenieRotation = Rotation;
	}
	
	RecallRotation(DeltaTime);
}

function RecallRotation(float DeltaTime)
{
	FaceRotation(GenieRotation, DeltaTime);
}

//This lets the pawn tell the PlayerController what Camera Style to set the camera in initially.
simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
	return 'ThirdPerson';
}

defaultproperties
{
	TickGroup=TG_PreAsyncWork // Necessary for proper rotation of PlayerController's Pawn
	Physics=PHYS_Flying
	//AccelRate=32768.0
	AccelRate=+1000.0
	
	bFrictionCompensation=true
	bFrictionCompensationOnlySphere=true
	FrictionCompensation=0.3012

	bFrictionVerticalExtra=true
	FrictionVerticalExtra=1.0

	// To be removed - incompatible with new method of controlling speed in GeniePlayerController
	bAirSpeedControl=false
	AirSpeedCenter=0
	AirSpeedRate=0.7 // Should be considered a multiple of 2*PI
	AirSpeed=65536

	MinVerticalLocation=666.f
	
    Components.Remove(Sprite)

	// Setting up the light environment
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        ModShadowFadeoutTime=0.25
        MinTimeBetweenFullUpdates=0.2
        AmbientGlow=(R=.01,G=.01,B=.01,A=1)
        AmbientShadowColor=(R=0.15,G=0.15,B=0.15)
        //LightShadowMode=LightShadow_ModulateBetter
        //ShadowFilterQuality=SFQ_High
		// compiler: unknown properties ^
        bSynthesizeSHLight=TRUE
    End Object
    Components.Add(MyLightEnvironment)
	
	// Dzin
    Begin Object Class=SkeletalMeshComponent Name=InitialSkeletalMesh
        CastShadow=true
        bCastDynamicShadow=true
        bOwnerNoSee=false
        LightEnvironment=MyLightEnvironment;
		BlockRigidBody=true;
		CollideActors=true;
		BlockZeroExtent=true;
		// What to change if you'd like to use your own meshes and animations
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
        //AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_AimOffset'
        //AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		AnimSets(0)=AnimSet'MyPackage.dzin.Bip001_IDLE'
		AnimSets(1)=AnimSet'MyPackage.dzin.Bip001_FRONT'
		AnimSets(2)=AnimSet'MyPackage.dzin.Bip001_BACK'
		AnimSets(3)=AnimSet'MyPackage.dzin.Bip001_LEFT'
		AnimSets(4)=AnimSet'MyPackage.dzin.Bip001_RIGHT'
        //AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		AnimTreeTemplate=AnimTree'MyPackage.dzin.anim_tree_dzin'
        //SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
		SkeletalMesh=SkeletalMesh'MyPackage.dzin.dzin_final'
    End Object
	Mesh=InitialSkeletalMesh;
    Components.Add(InitialSkeletalMesh);

	Begin Object Class=SkeletalMeshComponent Name=Koberec
        CastShadow=true
        bCastDynamicShadow=true
        bOwnerNoSee=false
        LightEnvironment=MyLightEnvironment;
		BlockRigidBody=true;
		CollideActors=true;
		BlockZeroExtent=true;
		// What to change if you'd like to use your own meshes and animations
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
        //AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_AimOffset'
        //AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		AnimSets(0)=AnimSet'MyPackage.koberec.Bone001'
        //AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		AnimTreeTemplate=AnimTree'MyPackage.koberec.animtree_koberec'
        //SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
		SkeletalMesh=SkeletalMesh'MyPackage.koberec.kob'
    End Object
	//Mesh=InitialSkeletalMesh;
    Components.Add(Koberec);

	// collision sphere
	/*begin object class=StaticMeshComponent name=colmesh
		StaticMesh=StaticMesh'MyPackage.koberec.colsphere'
		CollideActors=true
		BlockActors=true
		HiddenGame=true
		//CastShadow=true
        //bCastDynamicShadow=true
	end object
	Components.Add(colmesh)*/
	//CollisionComponent=colmesh
	
	// Setting up a proper collision cylinder
	CollisionType=COLLIDE_BlockAll
	Begin Object Name=CollisionCylinder
		CollisionRadius=+100.0
		CollisionHeight=+100.0
	End Object
	CylinderComponent=CollisionCylinder
}