$modelname "cszm/weapons/c_css_zombie_arms.mdl"

$bodygroup "arms"
{
	studio "css_zombie_arms.smd"
}

$cdmaterials "models/cszm/hands"

$surfaceprop "default"

$contents "solid"

$sequence "idle" "idle.smd" {
	fps 15
	loop
}

// Used to check if the arm is properly skinned!
$sequence "arm_test" "test.smd" {
	fps 30
	loop
}