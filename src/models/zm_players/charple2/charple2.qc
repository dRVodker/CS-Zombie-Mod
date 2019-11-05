$modelname "cszm/zombie_charple2.mdl"

$include "bones.qci"
$include "../ruleshierarchy.qci"

$bodygroup "Head"
{
	studio "charple2_head.smd"
	studio "charple2_neck.smd"
	studio "charple2_neck.smd"
	studio "charple2_neck.smd"
}

$model "Hand" "charple2_hand.smd" 

$model "Body" "charple2_body.smd" 

$surfaceprop "flesh"

$ambientboost

$eyeposition 0 0 73

$cdmaterials "models/charple/"
$cdmaterials "models/"

$attachment "eyes" "ValveBiped.Bip01_Head1" 2.86 -3.48 0.11 rotate 0 -80.1 -90
$attachment "mouth" "ValveBiped.Bip01_Head1" 0.8 -5.8 -0.15 rotate 0 -80 -90
$attachment "chest" "ValveBiped.Bip01_Spine2" 5 4 0 rotate 0 90 90
$attachment "forward" "ValveBiped.Bip01_Head1" 0 0 0 rotate 0 0 0
$attachment "anim_attachment_RH" "ValveBiped.Bip01_R_Hand" 0 0 0 rotate -90 -90 0
$attachment "anim_attachment_LH" "ValveBiped.Bip01_L_Hand" 0 0 0 rotate -90 -90 0
$attachment "anim_attachment_head" "ValveBiped.Bip01_Head1" 0 0 0 rotate -90 -90 0

$attachment "headshot1" "ValveBiped.Bip01_Neck1" 1.75 -1.00 0.00 rotate -0 35 0
$attachment "headshot2" "ValveBiped.Bip01_Neck1" 1.75 -1.00 0.00 rotate -0 35 0
$attachment "headshot3" "ValveBiped.Bip01_Neck1" 1.75 -1.00 0.00 rotate -0 35 0

$hboxset "default"
$hbox 1 "ValveBiped.Bip01_Head1"	    -1.50   -6.50   -3.19     8.00    3.50    3.31
$hbox 0 "ValveBiped.Bip01_L_UpperArm"	     0.00   -2.75   -2.75    12.51    1.75    2.25
$hbox 0 "ValveBiped.Bip01_R_UpperArm"	     0.00   -3.00   -2.25    12.39    2.00    2.75
$hbox 0 "ValveBiped.Bip01_R_Forearm"	    -0.50   -2.20   -1.55    12.50    1.80    2.45
$hbox 0 "ValveBiped.Bip01_R_Hand"	     0.06   -2.00   -2.50     4.06    1.00    1.50
$hbox 0 "ValveBiped.Bip01_L_Thigh"	     0.00   -3.75   -3.25    17.85    3.75    3.25
$hbox 0 "ValveBiped.Bip01_L_Calf"	     0.00   -3.51   -3.28    15.64    3.49    2.72
$hbox 0 "ValveBiped.Bip01_L_Foot"	    -1.07   -2.00   -2.84     5.04    5.00    2.16
$hbox 0 "ValveBiped.Bip01_L_Toe0"	    -0.50   -3.00   -2.19     2.50    0.00    2.46
$hbox 0 "ValveBiped.Bip01_R_Thigh"	     0.00   -3.75   -3.25    17.85    3.75    3.25
$hbox 0 "ValveBiped.Bip01_R_Calf"	     0.00   -3.51   -2.82    15.64    3.49    3.18
$hbox 0 "ValveBiped.Bip01_R_Foot"	    -1.06   -2.01   -2.28     5.05    4.99    2.72
$hbox 0 "ValveBiped.Bip01_R_Toe0"	    -0.50   -3.00   -2.60     2.50    0.00    2.10
$hbox 0 "ValveBiped.Bip01_Pelvis"	    -7.50   -5.50   -6.00     7.50    8.50    5.00
$hbox 0 "ValveBiped.Bip01_Spine2"	    -2.50   -2.50   -7.00    13.50    7.50    7.00
$skipboneinbbox

$bbox -16 -16 0 16 16 74

$definebone "ValveBiped.Bip01_Pelvis" "" 0 -0.533598 38.566914 0 0 89.999983 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Thigh" "ValveBiped.Bip01_Pelvis" 3.890447 0 0 2.970156 -89.701128 -89.978727 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Calf" "ValveBiped.Bip01_L_Thigh" 17.848171 0 0 0 1.959516 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Foot" "ValveBiped.Bip01_L_Calf" 16.525248 0 0 -2.355087 -61.399931 -1.37487 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Toe0" "ValveBiped.Bip01_L_Foot" 6.879447 0.000001 0 -0.306705 -33.481246 -0.571755 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Thigh" "ValveBiped.Bip01_Pelvis" -3.890447 0 0 2.970156 -90.299008 -90.012243 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Calf" "ValveBiped.Bip01_R_Thigh" 17.848179 0 0 0 1.959516 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Foot" "ValveBiped.Bip01_R_Calf" 16.525248 0 0 2.347294 -61.400164 2.425903 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Toe0" "ValveBiped.Bip01_R_Foot" 6.879453 0 0 -0.283556 -33.48142 -4.833357 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine" "ValveBiped.Bip01_Pelvis" 0 3.345132 -2.981898 4.766608 89.999983 89.999983 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine1" "ValveBiped.Bip01_Spine" 3.995839 0 0 0 -1.651035 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine2" "ValveBiped.Bip01_Spine1" 3.520299 0 0 0 5.57528 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine4" "ValveBiped.Bip01_Spine2" 8.921476 0 0 0 10.680679 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Neck1" "ValveBiped.Bip01_Spine4" 3.306366 0 0 0 23.268329 179.999911 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Head1" "ValveBiped.Bip01_Neck1" 3.602001 0 0 -0.000057 23.206685 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Clavicle" "ValveBiped.Bip01_Spine4" 2.05953 0.977923 1.937661 -73.71188 169.030982 91.085395 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "ValveBiped.Bip01_L_Clavicle" 6.028142 0.000002 0 2.941851 -33.277966 -82.343662 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "ValveBiped.Bip01_L_UpperArm" 11.692554 0 -0.000008 0.000002 -3.459061 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Clavicle" "ValveBiped.Bip01_Spine4" 2.059541 0.977922 -1.937661 73.711935 169.030914 -95.200946 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "ValveBiped.Bip01_R_Clavicle" 6.028141 0.000001 0 -0.682164 -33.427161 87.135647 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "ValveBiped.Bip01_R_UpperArm" 11.692552 -0.000001 0.000001 -0.000001 -3.459061 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "ValveBiped.Bip01_R_Forearm" 11.481704 -0.000001 0.000005 2.217347 2.063909 -89.381017 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Wrist" "ValveBiped.Bip01_R_Forearm" 11.481704 -0.000001 0.000005 -0.000001 0 0.487587 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Wrist" "ValveBiped.Bip01_L_Forearm" 11.481699 0 -0.000003 0.000002 0 -0.057582 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Ulna" "ValveBiped.Bip01_L_Forearm" 5.74085 0 -0.000001 0.000002 0 -0.031169 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Ulna" "ValveBiped.Bip01_R_Forearm" 5.740856 0 0.000007 -0.000001 0 0.26356 0 0 0 0 0 0

$ikchain "rhand" "ValveBiped.Bip01_R_Hand" knee 0.707 0.707 0
$ikchain "lhand" "ValveBiped.Bip01_L_Hand" knee 0.707 0.707 0
$ikchain "rfoot" "ValveBiped.Bip01_R_Foot" knee 0.707 -0.707 0
$ikchain "lfoot" "ValveBiped.Bip01_L_Foot" knee 0.707 -0.707 0

$sequence "ragdoll" {
	"ragdoll.smd"
	activity "ACT_DIERAGDOLL" 1
	fps 30
	ikrule "rhand" release
	ikrule "lhand" release
	ikrule "rfoot" release
	ikrule "lfoot" release
}

$includemodel "cszm/cszm_anims.mdl"

$collisionjoints "collision.smd"
{
	$mass 175
	$inertia 10
	$damping 0.05
	$rotdamping 5
	$rootbone "valvebiped.bip01_pelvis"

	$jointmassbias "ValveBiped.Bip01_Pelvis" 2.6
	$jointdamping "ValveBiped.Bip01_Pelvis" 1

	$jointmassbias "ValveBiped.Bip01_Spine2" 3.4
	$jointconstrain "ValveBiped.Bip01_Spine2" x limit -15 15 0
	$jointconstrain "ValveBiped.Bip01_Spine2" y limit -12 12 0
	$jointconstrain "ValveBiped.Bip01_Spine2" z limit -20 15 0

	$jointmassbias "ValveBiped.Bip01_R_UpperArm" 0.8
	$jointconstrain "ValveBiped.Bip01_R_UpperArm" x limit -40 40 0
	$jointconstrain "ValveBiped.Bip01_R_UpperArm" y limit -20 91 0
	$jointconstrain "ValveBiped.Bip01_R_UpperArm" z limit -80 24 0

	$jointmassbias "ValveBiped.Bip01_L_UpperArm" 0.8
	$jointconstrain "ValveBiped.Bip01_L_UpperArm" x limit -40 40 0
	$jointconstrain "ValveBiped.Bip01_L_UpperArm" y limit -91 20 0
	$jointconstrain "ValveBiped.Bip01_L_UpperArm" z limit -80 23 0

	$jointmassbias "ValveBiped.Bip01_L_Forearm" 0.6
	$jointconstrain "ValveBiped.Bip01_L_Forearm" x limit 0 0 0
	$jointconstrain "ValveBiped.Bip01_L_Forearm" y limit 0 0 0
	$jointconstrain "ValveBiped.Bip01_L_Forearm" z limit -123 -3 0

	$jointmassbias "ValveBiped.Bip01_R_Forearm" 0.6
	$jointconstrain "ValveBiped.Bip01_R_Forearm" x limit 0 0 0
	$jointconstrain "ValveBiped.Bip01_R_Forearm" y limit 0 0 0
	$jointconstrain "ValveBiped.Bip01_R_Forearm" z limit -120 -3 0

	$jointmassbias "ValveBiped.Bip01_R_Hand" 0.2
	$jointconstrain "ValveBiped.Bip01_R_Hand" x limit -60 60 0
	$jointconstrain "ValveBiped.Bip01_R_Hand" y limit -8 12 0
	$jointconstrain "ValveBiped.Bip01_R_Hand" z limit -52 -1 0

	$jointmassbias "ValveBiped.Bip01_R_Thigh" 1.3
	$jointconstrain "ValveBiped.Bip01_R_Thigh" x limit -12 12 0
	$jointconstrain "ValveBiped.Bip01_R_Thigh" y limit -8 33 0
	$jointconstrain "ValveBiped.Bip01_R_Thigh" z limit -79 24 0

	$jointmassbias "ValveBiped.Bip01_R_Calf" 0.8
	$jointconstrain "ValveBiped.Bip01_R_Calf" x limit 0 0 0
	$jointconstrain "ValveBiped.Bip01_R_Calf" y limit 0 0 0
	$jointconstrain "ValveBiped.Bip01_R_Calf" z limit -6 116 0

	$jointconstrain "ValveBiped.Bip01_Head1" x limit -72 60 0
	$jointconstrain "ValveBiped.Bip01_Head1" y limit -37 33 0
	$jointconstrain "ValveBiped.Bip01_Head1" z limit -19 45 0

	$jointmassbias "ValveBiped.Bip01_L_Thigh" 1.3
	$jointconstrain "ValveBiped.Bip01_L_Thigh" x limit -12 12 0
	$jointconstrain "ValveBiped.Bip01_L_Thigh" y limit -8 33 0
	$jointconstrain "ValveBiped.Bip01_L_Thigh" z limit -79 24 0

	$jointmassbias "ValveBiped.Bip01_L_Calf" 0.8
	$jointconstrain "ValveBiped.Bip01_L_Calf" x limit 0 0 0
	$jointconstrain "ValveBiped.Bip01_L_Calf" y limit 0 0 0
	$jointconstrain "ValveBiped.Bip01_L_Calf" z limit -6 116 0

	$jointmassbias "ValveBiped.Bip01_L_Foot" 0.4
	$jointconstrain "ValveBiped.Bip01_L_Foot" x limit -17 10 0
	$jointconstrain "ValveBiped.Bip01_L_Foot" y limit -25 19 0
	$jointconstrain "ValveBiped.Bip01_L_Foot" z limit -15 35 0

	$jointmassbias "ValveBiped.Bip01_R_Foot" 0.4
	$jointconstrain "ValveBiped.Bip01_R_Foot" x limit -17 10 0
	$jointconstrain "ValveBiped.Bip01_R_Foot" y limit -25 19 0
	$jointconstrain "ValveBiped.Bip01_R_Foot" z limit -15 35 0
}
