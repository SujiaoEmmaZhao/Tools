program define get_div1

syntax varlist, [file(string) levels(string) fr cfl en] namevar(string) 

cap drop rev1_*

preserve
	qui use "`file'", clear
	if "`en'" == "en" {
		qui keep _cae_num `namevar' _des_en 
		qui gen divlabel = `namevar' + " - " + _des_en
		keep _cae_num divlabel
	}
	else {
		qui keep _cae_num `namevar' _des_pt 
		qui gen divlabel = `namevar' + " - " + _des_pt
		keep _cae_num divlabel
	}
	quietly count 
	local total = r(N)
	label define divlabel1 -99 "Unsuccessful conversion", add modify 
	forvalues i = 1/`total' {
		local value = _cae_num[`i']
		local label = divlabel[`i']     
		label define divlabel1 `value' `"`label'"', add modify    
	}
	qui label save divlabel1 using lixo, replace
restore

qui do lixo.do
rm lixo.do

local var "`varlist'"
tempvar vardiv

local vartype: type `var'
local vallabel: value label `var'

// decode variable if specified by the user
if "`cfl'" == "cfl" {
	qui decode `var', gen(`vardiv')
	qui replace `vardiv' = word(`vardiv',1)
}
else {
	if substr("`vartype'",1,3) == "str" {
		qui clonevar `vardiv' = `var'
	}
	else {
		qui gen `vardiv' = string(`var')
	}
}

tempvar len
qui gen `len' = length(`vardiv')

if "`fr'" == "fr" {
	cap assert !(substr(`vardiv',`len',1) == "0") // while any observation has a zero in the last char
	while _rc {
		qui replace `vardiv' = substr(`vardiv',1,`len'-1) if substr(`vardiv',`len',1) == "0"
		qui replace `len' = length(`vardiv')
		cap assert !(substr(`vardiv',`len',1) == "0")
	}
	qui replace `vardiv' = "0" if missing(`vardiv') 
	qui replace `len' = length(`vardiv')
}

foreach item in `levels' {
		
	if "`item'" == "1" {
		qui gen str1 `namevar' = substr(`vardiv',1,1) 
		qui merge m:1 `namevar' using "`file'"
		qui drop if _m == 2
		qui drop _m
		qui drop _des_pt
		qui drop _des_en
		qui drop `namevar'
		qui rename _cae_num rev1_division
		//qui rename _des rev1_division_des
		//qui gen rev1_division_conv = (_valid_cae_1 != 0 & _valid_cae_1 != 99 & `len' >= 1)
		qui replace rev1_division = -99 if _valid_cae_1 == 0
		qui replace rev1_division = -99 if _valid_cae_1 == 99
		qui replace rev1_division = -99 if `len' < 1 /*
		qui replace rev1_division_des = "" if _valid_cae_1 == 0
		qui replace rev1_division_des = "" if _valid_cae_1 == 99
		qui replace rev1_division_des = "" if `len' < 1
		label define l1division 0 "Unsuccessful conversion" 1 "Successful conversion"
		label values rev1_division_conv l1division*/
		label var rev1_division "CAE Rev. 1 Division (Level 1)"
		//label rev1_division_des "CAE Rev. 1 Division Designation"
		//label rev1_division_des "Conversion to CAE Rev. 1 Division"
		label values rev1_division divlabel1
	}	
	if "`item'" == "2" {
		qui gen str2 `namevar' = substr(`vardiv',1,2)
		qui merge m:1 `namevar' using "`file'"
		qui drop if _m == 2
		qui drop _m
		qui drop _des_pt
		qui drop _des_en
		qui drop `namevar'
		qui rename _cae_num rev1_subdivision
		//qui rename _des rev1_subdivision_des
		//qui gen rev1_subdivision_conv = (_valid_cae_1 != 0 & _valid_cae_1 != 99 & `len' >= 2)
		qui replace rev1_subdivision = -99 if _valid_cae_1 == 0
		qui replace rev1_subdivision = -99 if _valid_cae_1 == 99
		qui replace rev1_subdivision = -99 if `len' < 2 /*
		qui replace rev1_subdivision_des = "" if _valid_cae_1 == 0
		qui replace rev1_subdivision_des = "" if _valid_cae_1 == 99
		qui replace rev1_subdivision_des = "" if `len' < 2
		label define l1subdivision 0 "Unsuccessful conversion" 1 "Successful conversion"
		label values rev1_subdivision_conv l1subdivision*/	
		label var rev1_subdivision "CAE Rev. 1 Subdivision (Level 2)"
		//label rev1_subdivision_des "CAE Rev. 1 Division Designation"
		//label rev1_subdivision_des "Conversion to CAE Rev. 1 Division"
		label values rev1_subdivision divlabel1
	}
	if "`item'" == "3" {
		qui gen str3 `namevar' = substr(`vardiv',1,3) 
		qui merge m:1 `namevar' using "`file'"
		qui drop if _m == 2
		qui drop _m
		qui drop _des_pt
		qui drop _des_en
		qui drop `namevar'
		qui rename _cae_num rev1_class
		//qui rename _des rev1_class_des
		//qui gen rev1_class_conv = (_valid_cae_1 != 0 & _valid_cae_1 != 99 & `len' >= 3)
		qui replace rev1_class = -99 if _valid_cae_1 == 0
		qui replace rev1_class = -99 if _valid_cae_1 == 99
		qui replace rev1_class = -99 if `len' < 3 /*
		qui replace rev1_class_des = "" if _valid_cae_1 == 0
		qui replace rev1_class_des = "" if _valid_cae_1 == 99
		qui replace rev1_class_des = "" if `len' < 3
		label define l1class 0 "Unsuccessful conversion" 1 "Successful conversion"
		label values rev1_class_conv l1class*/
		label var rev1_class "CAE Rev. 1 Class (Level 3)"
		label values rev1_class divlabel1
	}
	if "`item'" == "4" {
		qui gen str4 `namevar' = substr(`vardiv',1,4) 
		qui merge m:1 `namevar' using "`file'"
		qui drop if _m == 2
		qui drop _m
		qui drop _des_pt
		qui drop _des_en
		qui drop `namevar'
		qui rename _cae_num rev1_group
		//qui rename _des rev1_group_des
		//qui gen rev1_group_conv = (_valid_cae_1 != 0 & _valid_cae_1 != 99 & `len' >= 4)
		qui replace rev1_group = -99 if _valid_cae_1 == 0
		qui replace rev1_group = -99 if _valid_cae_1 == 99
		qui replace rev1_group = -99 if `len' < 4 /*
		qui replace rev1_group_des = "" if _valid_cae_1 == 0
		qui replace rev1_group_des = "" if _valid_cae_1 == 99
		qui replace rev1_group_des = "" if `len' < 4
		label define l1group 0 "Unsuccessful conversion" 1 "Successful conversion"
		label values rev1_group_conv l1group*/
		label values rev1_group divlabel1
		label var rev1_group "CAE Rev. 1 Group (Level 4)"
	}
	if "`item'" == "5" {
		qui gen str5 `namevar' = substr(`vardiv',1,5) 
		qui merge m:1 `namevar' using "`file'"
		qui drop if _m == 2
		qui drop _m
		qui drop _des_pt
		qui drop _des_en
		qui drop `namevar'
		qui rename _cae_num rev1_subgroup
		//qui rename _des rev1_subgroup_des
		//qui gen rev1_subgroup_conv = (_valid_cae_1 != 0 & _valid_cae_1 != 99 & `len' >= 5)
		qui replace rev1_subgroup = -99 if _valid_cae_1 == 0
		qui replace rev1_subgroup = -99 if _valid_cae_1 == 99
		qui replace rev1_subgroup = -99 if `len' < 5 /*
		qui replace rev1_subgroup_des = "" if _valid_cae_1 == 0
		qui replace rev1_subgroup_des = "" if _valid_cae_1 == 99
		qui replace rev1_subgroup_des = "" if `len' < 5
		label define l1subgroup 0 "Unsuccessful conversion" 1 "Successful conversion"
		label values rev1_subgroup_conv l1subgroup*/
		label var rev1_subgroup "CAE Rev. 1 Subgroup (Level 5)"
		label values rev1_subgroup divlabel1
	}
	if "`item'" == "6" {
		qui clonevar `namevar' = `vardiv'
		qui merge m:1 `namevar' using "`file'"
		qui drop if _m == 2
		qui drop _m
		qui drop _des_pt
		qui drop _des_en
		qui drop `namevar'
		qui rename _cae_num rev1_split
		//qui rename _des rev1_split_des
		//qui gen rev1_split_conv = (_valid_cae_1 != 0 & _valid_cae_1 != 99 & `len' == 6)
		qui replace rev1_split = -99 if _valid_cae_1 == 0
		qui replace rev1_split = -99 if _valid_cae_1 == 99
		qui replace rev1_split = -99 if `len' < 6 /*
		qui replace rev1_split_des = "" if _valid_cae_1 == 0
		qui replace rev1_split_des = "" if _valid_cae_1 == 99
		qui replace rev1_split_des = "" if `len' < 6
		label define l1split 0 "Unsuccessful conversion" 1 "Successful conversion"
		label values rev1_split_conv l1split*/
		label values rev1_split divlabel1
		label var rev1_split "CAE Rev. 1 Split (Level 6)"
	}	


}

qui compress rev1_*

end
