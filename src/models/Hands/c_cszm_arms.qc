$modelname "cszm/weapons/c_cszm_arms.mdl"

$bodygroup "Arms"
{
	studio "c_cszm_arms.smd"
}

$surfaceprop "default"

$contents "solid"

$illumposition 0.002 -11.44 -13.505

$cdmaterials "models/cszm/hands/"

$cbox 0 0 0 0 0 0

$bbox -1.699 -9.579 -20.921 24.579 9.584 -6.088

$definebone "Spine" "" 0 0.005067 -20.92145 -89.95575 179.999911 0 0 0 0 0 0 0
$definebone "Spine1" "Spine" 6.363436 -0.005067 0 0 -0.045607 -0.000516 0 0 0 0 0 0
$definebone "Neck" "Spine1" 6.36344 -0.002058 0 0 0 0 0 0 0 0 0 0
$definebone "L Clavicle" "Neck" 0.000001 0.002054 1.508082 -89.999983 179.954367 0 0 0 0 0 0 0
$definebone "L UpperArm" "L Clavicle" 5.853648 0 0.000001 28.774566 -89.919708 -88.878363 0 0 0 0 0 0
$definebone "L Forearm" "L UpperArm" 9.221992 -0.000001 0 0 -28.08754 0 0 0 0 0 0 0
$definebone "L Hand" "L Forearm" 8.525427 0 0 1.034934 0.052311 -89.755387 0 0 0 0 0 0
$definebone "L Finger0" "L Hand" 1.316957 0.232856 -0.887512 24.414931 43.987692 112.534184 0 0 0 0 0 0
$definebone "L Finger01" "L Finger0" 1.569123 0.000002 0 0 18.203154 0.000003 0 0 0 0 0 0
$definebone "L Finger02" "L Finger01" 1.263928 0 0.000001 0 3.256976 0.000004 0 0 0 0 0 0
$definebone "L Finger1" "L Hand" 4.30312 -0.549163 -1.396965 2.769449 5.138457 6.925054 0 0 0 0 0 0
$definebone "L Finger11" "L Finger1" 1.775326 0.000001 -0.000001 -0.000001 12.481825 -0.000001 0 0 0 0 0 0
$definebone "L Finger12" "L Finger11" 0.890211 -0.000001 0 0 8.808361 -0.000001 0 0 0 0 0 0
$definebone "L Finger2" "L Hand" 4.29871 -0.99995 -0.33379 -2.927584 19.279801 3.93433 0 0 0 0 0 0
$definebone "L Finger21" "L Finger2" 1.881733 0 0.000001 0.000002 14.390352 -0.000001 0 0 0 0 0 0
$definebone "L Finger22" "L Finger21" 0.998892 0.000002 -0.000001 0.000002 11.402718 -0.000001 0 0 0 0 0 0
$definebone "L Finger3" "L Hand" 3.950136 -0.942987 0.812743 -6.046194 25.034701 -9.261118 0 0 0 0 0 0
$definebone "L Finger31" "L Finger3" 1.876987 0.000002 0.000003 0.000001 17.099756 0.000002 0 0 0 0 0 0
$definebone "L Finger32" "L Finger31" 1.002015 0.000002 -0.000001 0 20.259567 0.000001 0 0 0 0 0 0
$definebone "L Finger4" "L Hand" 3.482876 -0.57292 1.763046 -6.467834 30.075014 -16.97502 0 0 0 0 0 0
$definebone "L Finger41" "L Finger4" 1.367763 0 0 -0.000001 21.90114 0.000003 0 0 0 0 0 0
$definebone "L Finger42" "L Finger41" 0.72598 -0.000004 0 -0.000001 12.741149 0.000002 0 0 0 0 0 0
$definebone "L ForeTwist" "L UpperArm" 9.221992 -0.000001 0 0 -28.08754 0.030596 0 0 0 0 0 0
$definebone "L ForeTwist1" "L ForeTwist" 1.217916 0.000001 0 0 0.000001 0.030596 0 0 0 0 0 0
$definebone "L ForeTwist2" "L ForeTwist1" 1.217916 -0.000001 0 0 0.000001 0.030596 0 0 0 0 0 0
$definebone "L ForeTwist3" "L ForeTwist2" 1.217918 0.000001 0 0 0.000001 0.030596 0 0 0 0 0 0
$definebone "L ForeTwist4" "L ForeTwist3" 1.217918 0 0 0 0.000001 0.030596 0 0 0 0 0 0
$definebone "L ForeTwist5" "L ForeTwist4" 1.217918 0.000001 0 0 0.000001 0.030596 0 0 0 0 0 0
$definebone "L ForeTwist6" "L ForeTwist5" 1.217916 -0.000001 0 0 0.000001 0.030596 0 0 0 0 0 0
$definebone "R Clavicle" "Neck" 0.000002 0.002063 -1.508082 89.999983 179.954367 0 0 0 0 0 0 0
$definebone "R UpperArm" "R Clavicle" 5.853648 0 -0.000001 -28.774566 -89.920739 88.878363 0 0 0 0 0 0
$definebone "R Forearm" "R UpperArm" 9.221992 0 0 0 -28.08754 0 0 0 0 0 0 0
$definebone "R Hand" "R Forearm" 8.525424 0 0 -1.034934 0.05231 89.755387 0 0 0 0 0 0
$definebone "R Finger0" "R Hand" 1.316959 0.232857 0.887511 -24.41493 43.987692 -112.534184 0 0 0 0 0 0
$definebone "R Finger01" "R Finger0" 1.569124 0.000002 -0.000001 -0.000002 18.203151 -0.000006 0 0 0 0 0 0
$definebone "R Finger02" "R Finger01" 1.263927 0 0.000002 0 3.256973 -0.000007 0 0 0 0 0 0
$definebone "R Finger1" "R Hand" 4.303118 -0.549163 1.396964 -2.76945 5.138459 -6.925055 0 0 0 0 0 0
$definebone "R Finger11" "R Finger1" 1.775324 0 0 -0.000001 12.481831 0.000002 0 0 0 0 0 0
$definebone "R Finger12" "R Finger11" 0.890209 -0.000001 -0.000001 -0.000001 8.808371 0.000001 0 0 0 0 0 0
$definebone "R Finger2" "R Hand" 4.298708 -0.99995 0.333789 2.927583 19.279802 -3.934329 0 0 0 0 0 0
$definebone "R Finger21" "R Finger2" 1.881733 0 0 -0.000002 14.390357 0.000001 0 0 0 0 0 0
$definebone "R Finger22" "R Finger21" 0.998892 0 0 -0.000002 11.402724 0 0 0 0 0 0 0
$definebone "R Finger3" "R Hand" 3.95013 -0.942987 -0.812744 6.046193 25.034705 9.261117 0 0 0 0 0 0
$definebone "R Finger31" "R Finger3" 1.876987 0.000002 -0.000004 0 17.099758 -0.000003 0 0 0 0 0 0
$definebone "R Finger32" "R Finger31" 1.002014 -0.000002 -0.000001 0.000002 20.259564 -0.000002 0 0 0 0 0 0
$definebone "R Finger4" "R Hand" 3.482876 -0.57292 -1.763047 6.467832 30.07502 16.975021 0 0 0 0 0 0
$definebone "R Finger41" "R Finger4" 1.367767 0.000002 0 0.000003 21.901143 -0.000005 0 0 0 0 0 0
$definebone "R Finger42" "R Finger41" 0.725977 0 0 0.000003 12.741154 -0.000005 0 0 0 0 0 0
$definebone "R ForeTwist" "R UpperArm" 9.221992 0 0 0 -28.08754 -0.030596 0 0 0 0 0 0
$definebone "R ForeTwist1" "R ForeTwist" 1.217916 0 0 0 0 -0.030596 0 0 0 0 0 0
$definebone "R ForeTwist2" "R ForeTwist1" 1.217916 0 -0.000001 0 0 -0.030596 0 0 0 0 0 0
$definebone "R ForeTwist3" "R ForeTwist2" 1.21792 -0.000001 0 0 0 -0.030596 0 0 0 0 0 0
$definebone "R ForeTwist4" "R ForeTwist3" 1.217917 0 0 0 0 -0.030596 0 0 0 0 0 0
$definebone "R ForeTwist5" "R ForeTwist4" 1.217916 0 0 0 0 -0.030596 0 0 0 0 0 0
$definebone "R ForeTwist6" "R ForeTwist5" 1.217916 -0.000001 -0.000001 0 0 -0.030596 0 0 0 0 0 0

$sequence "reference" {
	"c_cszm_arms.smd"
	fps 5
	loop
}