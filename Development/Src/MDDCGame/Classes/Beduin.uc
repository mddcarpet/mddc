class Beduin extends Pawn;

defaultproperties
{
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
		AnimSets(0)=AnimSet'MyPackage.Beduin.Bip_BEDUIN'
        //AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		AnimTreeTemplate=AnimTree'MyPackage.Beduin.anim_tree_beduim'
        //SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
		SkeletalMesh=SkeletalMesh'MyPackage.Beduin.BEDUIN_ANIMACE_LEZICI'
    End Object
	Mesh=InitialSkeletalMesh;
    Components.Add(InitialSkeletalMesh);

	// Setting up a proper collision cylinder
	/*CollisionType=COLLIDE_BlockAll
	Begin Object Name=CollisionCylinder
		CollisionRadius=+100.0
		CollisionHeight=+100.0
	End Object
	CylinderComponent=CollisionCylinder*/
}