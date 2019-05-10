
$modelname "cszm/weapons/w_antidote.mdl"

$bodygroup "Body"
{
	studio "w_antidote_ref.smd"
}

$surfaceprop "metal"

$cdmaterials "models/cszm/w_antidote/"

$sequence "idle" {
	"w_antidote_ref.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "w_antidote_phy.smd"
{
	$mass 25
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
}
