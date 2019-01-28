$modelname "cszm/cszm_anims.mdl"
$include "bones.qci"
$include "ruleshierarchy.qci"

$hboxset "zp_hboxes"

$hbox 1 "ValveBiped.Bip01_Head1"	   -1.50   -6.50   -3.19     8.00    3.50    3.31
$hbox 4 "ValveBiped.Bip01_L_UpperArm"	    0.00   -2.75   -2.75    12.51    1.75    2.25
$hbox 4 "ValveBiped.Bip01_L_Forearm"	    0.00   -2.19   -2.38    13.00    1.81    1.62
$hbox 4 "ValveBiped.Bip01_L_Hand"	    0.06   -2.00   -1.50     4.06    1.00    2.50
$hbox 5 "ValveBiped.Bip01_R_UpperArm"	    0.00   -3.00   -2.25    12.39    2.00    2.75
$hbox 5 "ValveBiped.Bip01_R_Forearm"	   -0.50   -2.20   -1.55    12.50    1.80    2.45
$hbox 5 "ValveBiped.Bip01_R_Hand"	    0.06   -2.00   -2.50     4.06    1.00    1.50
$hbox 6 "ValveBiped.Bip01_L_Thigh"	    0.00   -3.75   -3.25    17.85    3.75    3.25
$hbox 6 "ValveBiped.Bip01_L_Calf"	    0.00   -3.51   -3.28    15.64    3.49    2.72
$hbox 6 "ValveBiped.Bip01_L_Foot"	   -1.07   -2.00   -2.84     5.04    5.00    2.16
$hbox 6 "ValveBiped.Bip01_L_Toe0"	   -0.50   -3.00   -2.19     2.50    0.00    2.46
$hbox 7 "ValveBiped.Bip01_R_Thigh"	    0.00   -3.75   -3.25    17.85    3.75    3.25
$hbox 7 "ValveBiped.Bip01_R_Calf"	    0.00   -3.51   -2.82    15.64    3.49    3.18
$hbox 7 "ValveBiped.Bip01_R_Foot"	   -1.06   -2.01   -2.28     5.05    4.99    2.72
$hbox 7 "ValveBiped.Bip01_R_Toe0"	   -0.50   -3.00   -2.60     2.50    0.00    2.10
$hbox 3 "ValveBiped.Bip01_Pelvis"	   -7.50   -5.50   -6.00     7.50    8.50    5.00
$hbox 2 "ValveBiped.Bip01_Spine2"	   -2.50   -2.50   -7.00    12.50    7.50    7.00

$bbox -16 -16 0 16 16 74

$eyeposition 0 0 70

$weightlist "UpperBody" {
	"ValveBiped.Bip01_Pelvis" 0
	"ValveBiped.Bip01_L_Thigh" 0
	"ValveBiped.Bip01_L_Calf" 0
	"ValveBiped.Bip01_L_Foot" 0
	"ValveBiped.Bip01_L_Toe0" 0
	"ValveBiped.Bip01_R_Thigh" 0
	"ValveBiped.Bip01_R_Calf" 0
	"ValveBiped.Bip01_R_Foot" 0
	"ValveBiped.Bip01_R_Toe0" 0
	"ValveBiped.Bip01_Spine" 0.95
	"ValveBiped.Bip01_Spine1" 0.95
	"ValveBiped.Bip01_Spine2" 0.95
	"ValveBiped.Bip01_Spine4" 1
	"ValveBiped.Bip01_R_Clavicle" 1
	"ValveBiped.Bip01_L_Clavicle" 1
	"ValveBiped.Bip01_Neck1" 0.45
	"ValveBiped.Bip01_Head1" 0.65
}

$weightlist "UpperBodyAttack" {
	"ValveBiped.Bip01_Pelvis" 0
	"ValveBiped.Bip01_L_Thigh" 0
	"ValveBiped.Bip01_L_Calf" 0
	"ValveBiped.Bip01_L_Foot" 0
	"ValveBiped.Bip01_L_Toe0" 0
	"ValveBiped.Bip01_R_Thigh" 0
	"ValveBiped.Bip01_R_Calf" 0
	"ValveBiped.Bip01_R_Foot" 0
	"ValveBiped.Bip01_R_Toe0" 0
	"ValveBiped.Bip01_Spine" 0
	"ValveBiped.Bip01_Spine1" 0.10
	"ValveBiped.Bip01_Spine2" 0.15
	"ValveBiped.Bip01_Spine4" 0.25
	"ValveBiped.Bip01_R_Clavicle" 1
	"ValveBiped.Bip01_L_Clavicle" 1
	"ValveBiped.Bip01_Neck1" 0.45
	"ValveBiped.Bip01_Head1" 0.65
}

$weightlist OnlyArms {
	"ValveBiped.Bip01_Pelvis" 0
	"ValveBiped.Bip01_Neck1" 0.15
	"ValveBiped.Bip01_Head1" 0.25
	"ValveBiped.Bip01_R_Toe0" 0
	"ValveBiped.Bip01_L_Toe0" 0
	"ValveBiped.Bip01_R_Foot" 0
	"ValveBiped.Bip01_L_Foot" 0
	"ValveBiped.Bip01_R_Calf" 0
	"ValveBiped.Bip01_L_Calf" 0
	"ValveBiped.Bip01_R_Thigh" 0
	"ValveBiped.Bip01_L_Thigh" 0
	"ValveBiped.Bip01_L_Thigh" 0
	"ValveBiped.Bip01_Spine" 0.15
	"ValveBiped.Bip01_R_Clavicle" 0.25
	"ValveBiped.Bip01_L_Clavicle" 0.25
	"ValveBiped.Bip01_R_UpperArm" 0.75
	"ValveBiped.Bip01_L_UpperArm" 0.75
}

$weightlist AttackBones {
	"ValveBiped.Bip01_Pelvis" 0.50
	"ValveBiped.Bip01_Neck1" 1
	"ValveBiped.Bip01_Head1" 0
	"ValveBiped.Bip01_R_Toe0" 1
	"ValveBiped.Bip01_L_Toe0" 1
	"ValveBiped.Bip01_R_Foot" 1
	"ValveBiped.Bip01_L_Foot" 1
	"ValveBiped.Bip01_R_Calf" 1
	"ValveBiped.Bip01_L_Calf" 1
	"ValveBiped.Bip01_R_Thigh" 0.75
	"ValveBiped.Bip01_L_Thigh" 0.75
	"ValveBiped.Bip01_Spine" 1
	"ValveBiped.Bip01_Spine1" 1
	"ValveBiped.Bip01_Spine2" 1
	"ValveBiped.Bip01_Spine4" 1
	"ValveBiped.Bip01_L_Clavicle" 0.75
	"ValveBiped.Bip01_R_Clavicle" 1
	"ValveBiped.Bip01_R_UpperArm" 1
	"ValveBiped.Bip01_L_UpperArm" 0.75
}

$weightlist LessLHand {
	"ValveBiped.Bip01_Pelvis" 1
	"ValveBiped.Bip01_L_Clavicle" 1
	"ValveBiped.Bip01_L_UpperArm" 1
}

$weightlist BreathesBones {
	"ValveBiped.Bip01_Pelvis" 0
	"ValveBiped.Bip01_L_Thigh" 0
	"ValveBiped.Bip01_R_Thigh" 0
	"ValveBiped.Bip01_Spine" 0.95
	"ValveBiped.Bip01_Spine1" 0.95
	"ValveBiped.Bip01_Spine2" 0.85
}

$animation "a_breathes"	"anims/Idle_lower.smd" subtract a_breathes 0 weightlist "BreathesBones"

$sequence Breathes {
	"a_breathes"
	fps 25
	delta
	autoplay
	hidden
	weightlist "BreathesBones"
}

$animation "a_knife_stand_new"			"anims/idle_poses_standing.smd" frame 11 11 weightlist "OnlyArms"
$animation "a_knife_crouch_new"			"anims/idle_poses_crouching.smd" frame 11 11 weightlist "OnlyArms"
$animation "a_knife_neutral"			"anims/aim_matrix_knife_test" frame 4 4 weightlist "UpperBody"

$animation a_knife_aim_down_left		"anims/aim_matrix_knife_test" frame 0 0 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_down_center		"anims/aim_matrix_knife_test" frame 1 1 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_down_right		"anims/aim_matrix_knife_test" frame 2 2 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_mid_left			"anims/aim_matrix_knife_test" frame 3 3 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_mid_center		"anims/aim_matrix_knife_test" frame 4 4 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_mid_right		"anims/aim_matrix_knife_test" frame 5 5 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_up_left			"anims/aim_matrix_knife_test" frame 6 6 subtract "a_knife_neutral" 0 weightlist "UpperBody" 
$animation a_knife_aim_up_center		"anims/aim_matrix_knife_test" frame 7 7 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_up_right			"anims/aim_matrix_knife_test" frame 8 8 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_straight_up		"anims/aim_matrix_knife_test" frame 9 9 subtract "a_knife_neutral" 0 weightlist "UpperBody"

$animation a_knife_aim_crouch_down_left		"anims/aim_matrix_knife_crouch" frame 0 0 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_crouch_down_center		"anims/aim_matrix_knife_crouch" frame 1 1 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_crouch_down_right		"anims/aim_matrix_knife_crouch" frame 2 2 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_crouch_mid_left			"anims/aim_matrix_knife_crouch" frame 3 3 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_crouch_mid_center		"anims/aim_matrix_knife_crouch" frame 4 4 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_crouch_mid_right		"anims/aim_matrix_knife_crouch" frame 5 5 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_crouch_up_left			"anims/aim_matrix_knife_crouch" frame 6 6 subtract "a_knife_neutral" 0 weightlist "UpperBody" 
$animation a_knife_aim_crouch_up_center		"anims/aim_matrix_knife_crouch" frame 7 7 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_crouch_up_right			"anims/aim_matrix_knife_crouch" frame 8 8 subtract "a_knife_neutral" 0 weightlist "UpperBody"
$animation a_knife_aim_crouch_straight_up		"anims/aim_matrix_knife_crouch" frame 9 9 subtract "a_knife_neutral" 0 weightlist "UpperBody"

$animation a_knife_aim_attack_down_left		"anims/aim_matrix_knife_test" frame 0 0 subtract "a_knife_neutral" 0 weightlist "UpperBodyAttack"
$animation a_knife_aim_attack_down_center		"anims/aim_matrix_knife_test" frame 1 1 subtract "a_knife_neutral" 0 weightlist "UpperBodyAttack"
$animation a_knife_aim_attack_down_right		"anims/aim_matrix_knife_test" frame 2 2 subtract "a_knife_neutral" 0 weightlist "UpperBodyAttack"
$animation a_knife_aim_attack_mid_left			"anims/aim_matrix_knife_test" frame 3 3 subtract "a_knife_neutral" 0 weightlist "UpperBodyAttack"
$animation a_knife_aim_attack_mid_center		"anims/aim_matrix_knife_test" frame 4 4 subtract "a_knife_neutral" 0 weightlist "UpperBodyAttack"
$animation a_knife_aim_attack_mid_right		"anims/aim_matrix_knife_test" frame 5 5 subtract "a_knife_neutral" 0 weightlist "UpperBodyAttack"
$animation a_knife_aim_attack_up_left			"anims/aim_matrix_knife_test" frame 6 6 subtract "a_knife_neutral" 0 weightlist "UpperBodyAttack" 
$animation a_knife_aim_attack_up_center		"anims/aim_matrix_knife_test" frame 7 7 subtract "a_knife_neutral" 0 weightlist "UpperBodyAttack"
$animation a_knife_aim_attack_up_right			"anims/aim_matrix_knife_test" frame 8 8 subtract "a_knife_neutral" 0 weightlist "UpperBodyAttack"
$animation a_knife_aim_attack_straight_up		"anims/aim_matrix_knife_test" frame 9 9 subtract "a_knife_neutral" 0 weightlist "UpperBodyAttack"

$animation a_RunS "anims/RunS" loop LX LY startloop 0 rotateto -180 fps 25
$animation a_RunSE "anims/RunSE" loop LX LY startloop 0 rotateto -135 fps 25
$animation a_RunE "anims/RunE" loop LX LY startloop 0 rotateto -90 fps 25
$animation a_RunNE "anims/RunNE" loop LX LY startloop 0 rotateto -45 fps 25
$animation a_RunN "anims/RunN" loop LX LY startloop 0 rotateto 0 fps 25
$animation a_RunNW "anims/RunNW" loop LX LY startloop 0 rotateto 45 fps 25
$animation a_RunW "anims/RunW" loop LX LY startloop 0 rotateto 90 fps 25
$animation a_RunSW "anims/RunSW" loop LX LY startloop 0 rotateto 135 fps 25

$animation a_CwalkS "anims/Crouch_walkS" loop LX LY startloop 0 rotateto -180
$animation a_CWalkSE "anims/Crouch_walkSE" loop LX LY startloop 0 rotateto -135
$animation a_CWalkE "anims/Crouch_walkE" loop LX LY startloop 0 rotateto -90
$animation a_CWalkNE "anims/Crouch_walkNE" loop LX LY startloop 0 rotateto -45
$animation a_CWalkN "anims/Crouch_walkN" loop LX LY startloop 0 rotateto 0
$animation a_CWalkNW "anims/Crouch_walkNW" loop LX LY startloop 0 rotateto 45
$animation a_CWalkW "anims/Crouch_walkW" loop LX LY startloop 0 rotateto 90
$animation a_CWalkSW "anims/Crouch_walkSW" loop LX LY startloop 0 rotateto 135

$sequence "aim_knife"  {
	a_knife_aim_straight_up	a_knife_aim_straight_up	a_knife_aim_straight_up
	a_knife_aim_up_right 	a_knife_aim_up_center	a_knife_aim_up_left 
	a_knife_aim_mid_right 	a_knife_aim_mid_center	a_knife_aim_mid_left 
	a_knife_aim_down_right	a_knife_aim_down_center	a_knife_aim_down_left 
	blendwidth 3
	blend "aim_yaw" -45 45
	blend "aim_pitch" -90 45
	delta
	hidden
	iklock "rfoot" 1 0
	iklock "lfoot" 1 0
}

$sequence "aim_crouch_knife"  {
	a_knife_aim_crouch_straight_up	a_knife_aim_crouch_straight_up	a_knife_aim_crouch_straight_up
	a_knife_aim_crouch_up_right 	a_knife_aim_crouch_up_center	a_knife_aim_crouch_up_left 
	a_knife_aim_crouch_mid_right 	a_knife_aim_crouch_mid_center	a_knife_aim_crouch_mid_left 
	a_knife_aim_crouch_down_right	a_knife_aim_crouch_down_center	a_knife_aim_crouch_down_left 
	blendwidth 3
	blend "aim_yaw" -45 45
	blend "aim_pitch" -90 45
	delta
	hidden
	iklock "rfoot" 1 0
	iklock "lfoot" 1 0
}

$sequence "attack_aim_knife"  {
	a_knife_aim_attack_straight_up	a_knife_aim_attack_straight_up	a_knife_aim_attack_straight_up
	a_knife_aim_attack_up_right 	a_knife_aim_attack_up_center	a_knife_aim_attack_up_left 
	a_knife_aim_attack_mid_right 	a_knife_aim_attack_mid_center	a_knife_aim_attack_mid_left 
	a_knife_aim_attack_down_right	a_knife_aim_attack_down_center	a_knife_aim_attack_down_left 
	blendwidth 3
	blend "aim_yaw" -45 45
	blend "aim_pitch" -90 45
	delta
	hidden
	iklock "rfoot" 1 0
	iklock "lfoot" 1 0
}

$sequence "stand_knife" "a_knife_stand_new" weightlist "OnlyArms" hidden

$sequence "crouch_knife" "a_knife_crouch_new" weightlist "OnlyArms" hidden

$sequence "Idle" "anims/Idle_lower.smd"{
	loop
	fps 30
	addlayer stand_knife
	addlayer aim_knife
	activity "ACT_ZP_IDLE_MELEE" 1
}

$sequence "CrouchIdle" "anims/Crouch_Idle_Lower.smd"{
	loop
	fps 30
	addlayer crouch_knife
	addlayer aim_crouch_knife
	activity "ACT_ZP_IDLE_CROUCH_MELEE" 1
}

$sequence "Run" {
	a_runS a_runSE a_runE
	a_runNE a_runN a_runNW
	a_runW a_runSW a_runS
	blendwidth 9
	blend "move_yaw" -180 180
	"ACT_ZP_RUN_MELEE" 1
	addlayer stand_knife
	addlayer aim_knife
}

$sequence "CrouchWalk" {
	a_CwalkS a_CwalkSE a_CwalkE
	a_CwalkNE a_CwalkN a_CwalkNW
	a_CwalkW a_CwalkSW a_CwalkS
	blendwidth 9
	blend "move_yaw" -180 180
	"ACT_ZP_WALK_CROUCH_MELEE" 1
	addlayer crouch_knife
	addlayer aim_crouch_knife
}

$sequence "Jump" {
	"anims/jump.smd"
	"ACT_ZP_JUMP_MELEE" 1
	addlayer stand_knife
	addlayer aim_knife
}

$animation a_attack "anims/shoot_knife" subtract a_attack 0 weightlist "AttackBones"
$sequence Attack a_attack activity ACT_ZP_GESTURE_RANGE_ATTACK_MELEE 1 looping fps 45 {
  iklock lfoot 1 0 iklock rfoot 1 0
  delta
  addlayer attack_aim_knife
}

$sequence Push a_attack activity ACT_ZP_PUSHPROP 1 looping fps 45 {
  iklock lfoot 1 0 iklock rfoot 1 0
  delta
  addlayer attack_aim_knife
}

$sequence "Idle_Lobby" "anims/Idle_lower.smd"{
	loop
	fps 30
	addlayer stand_knife
	addlayer aim_knife
	activity "ACT_ZP_IDLE" 1
	hidden
}

$sequence "CrouchIdle_Lobby" "anims/Crouch_Idle_Lower.smd"{
	loop
	fps 30
	addlayer crouch_knife
	addlayer aim_knife
	activity "ACT_ZP_IDLE_CROUCH" 1
	hidden
}

$sequence "Run_Lobby" {
	a_runS a_runSE a_runE
	a_runNE a_runN a_runNW
	a_runW a_runSW a_runS
	blendwidth 9
	blend "move_yaw" -180 180
	"ACT_ZP_RUN" 1
	addlayer stand_knife
	addlayer aim_knife
	hidden
}

$sequence "CrouchWalk_Lobby" {
	a_CwalkS a_CwalkSE a_CwalkE
	a_CwalkNE a_CwalkN a_CwalkNW
	a_CwalkW a_CwalkSW a_CwalkS
	blendwidth 9
	blend "move_yaw" -180 180
	"ACT_ZP_WALK_CROUCH" 1
	addlayer crouch_knife
	addlayer aim_knife
	hidden
}

$sequence "Jump_Lobby" {
	"anims/jump.smd"
	"ACT_ZP_JUMP" 1
	addlayer stand_knife
	addlayer aim_knife
	hidden
}

$sequence "deathpose_front" {
	"css_anims/deathpose_front.smd"
	activity "ACT_DIE_FRONTSIDE" -1
	fps 1
	ikrule "rhand" release
	ikrule "lhand" release
	ikrule "rfoot" release
	ikrule "lfoot" release
	hidden
}

$sequence "deathpose_back" {
	"css_anims/deathpose_back.smd"
	activity "ACT_DIE_BACKSIDE" -1
	fps 1
	ikrule "rhand" release
	ikrule "lhand" release
	ikrule "rfoot" release
	ikrule "lfoot" release
	hidden
}

$sequence "deathpose_right" {
	"css_anims/deathpose_right.smd"
	activity "ACT_DIE_RIGHTSIDE" -1
	fps 1
	ikrule "rhand" release
	ikrule "lhand" release
	ikrule "rfoot" release
	ikrule "lfoot" release
	hidden
}

$sequence "deathpose_left" {
	"css_anims/deathpose_left.smd"
	activity "ACT_DIE_LEFTSIDE" -1
	fadein 0.2
	fadeout 0.2
	fps 1
	ikrule "rhand" release
	ikrule "lhand" release
	ikrule "rfoot" release
	ikrule "lfoot" release
	hidden
}

$sequence "deathpose_crouch_front" {
	"css_anims/deathpose_crouch_front.smd"
	activity "ACT_DIE_CROUCH_FRONTSIDE" -1
	fps 1
	ikrule "rhand" release
	ikrule "lhand" release
	ikrule "rfoot" release
	ikrule "lfoot" release
	hidden
}

$sequence "deathpose_crouch_back" {
	"css_anims/deathpose_crouch_back.smd"
	activity "ACT_DIE_CROUCH_BACKSIDE" -1
	fps 1
	ikrule "rhand" release
	ikrule "lhand" release
	ikrule "rfoot" release
	ikrule "lfoot" release
	hidden
}

$sequence "deathpose_crouch_right" {
	"css_anims/deathpose_crouch_right.smd"
	activity "ACT_DIE_CROUCH_RIGHTSIDE" -1
	fps 1
	ikrule "rhand" release
	ikrule "lhand" release
	ikrule "rfoot" release
	ikrule "lfoot" release
	hidden
}

$sequence "deathpose_crouch_left" {
	"css_anims/deathpose_crouch_left.smd"
	activity "ACT_DIE_CROUCH_LEFTSIDE" -1
	fps 1
	ikrule "rhand" release
	ikrule "lhand" release
	ikrule "rfoot" release
	ikrule "lfoot" release
	hidden
}

$ikchain "rhand" "ValveBiped.Bip01_R_Hand" knee 0.707 0.707 0
$ikchain "lhand" "ValveBiped.Bip01_L_Hand" knee 0.707 0.707 0
$ikchain "rfoot" "ValveBiped.Bip01_R_Foot" knee 0.707 -0.707 0
$ikchain "lfoot" "ValveBiped.Bip01_L_Foot" knee 0.707 -0.707 0

$ikautoplaylock "rfoot" 1 0.1
$ikautoplaylock "lfoot" 1 0.1

$bonemerge "ValveBiped.Bip01_Pelvis"
$bonemerge "ValveBiped.Bip01_Spine"
$bonemerge "ValveBiped.Bip01_Spine1"
$bonemerge "ValveBiped.Bip01_Spine2"
$bonemerge "ValveBiped.Bip01_Spine4"
$bonemerge "ValveBiped.Bip01_R_Clavicle"
$bonemerge "ValveBiped.Bip01_R_UpperArm"
$bonemerge "ValveBiped.Bip01_R_Forearm"
$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "ValveBiped.Anim_Attachment_RH"

