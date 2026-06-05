/**********************************************************************************
 Purpose:
 This program demonstrates SAS-based data management steps used to construct an
 analytic dataset for an epidemiologic analysis of HIV risk among adolescent girls
 and young women (AGYW) in Eswatini.

 Notes:
 - Raw SHIMS/PHIA data are restricted and are not included in this repository.
 - Dataset names and file paths have been generalized for public portfolio use.
 - This script is intended to demonstrate workflow, logic, and SAS programming skills.
**********************************************************************************/

/*------------------------------------------------------------------------------
 Step 1: Define libraries

 Replace the file paths below with local paths if running this program.
------------------------------------------------------------------------------*/

/*
libname raw  "path/to/restricted/raw/data";
libname out  "path/to/output/folder";
*/


/*------------------------------------------------------------------------------
 Step 2: Restrict SHIMS2 2016 datasets to analytic population

 Inclusion criteria:
 - Female participants
 - Aged 15–24 years
 - Completed blood test
 - Completed individual interview
 - Non-missing age at first sex
------------------------------------------------------------------------------*/

data shims2_adult_bio;
    set raw.shims2_adult_bio;
    if gender = 2 and bt_status = 1 and 15 <= age <= 24;
run;

data shims2_adult_ind;
    set raw.shims2_adult_ind;
    if gender = 2
       and indstatus = 1
       and bt_status = 1
       and 15 <= age <= 24
       and firstsxage >= 0;
run;


/*------------------------------------------------------------------------------
 Step 3: Merge SHIMS2 biological and interview datasets

 The IN= indicators ensure that only participants present in both datasets are
 retained in the analytic file.
------------------------------------------------------------------------------*/

proc sort data=shims2_adult_bio;
    by personid;
run;

proc sort data=shims2_adult_ind;
    by personid;
run;

data shims2_analytic;
    merge shims2_adult_bio (in=in_bio)
          shims2_adult_ind (in=in_ind);
    by personid;

    if in_bio and in_ind;

    survey_year = 2016;
    survey_round = 1;
run;


/*------------------------------------------------------------------------------
 Step 4: Restrict SHIMS3 2021 datasets to analytic population

 Inclusion criteria are aligned with SHIMS2 to support cross-survey comparison.
------------------------------------------------------------------------------*/

data shims3_adult_bio;
    set raw.shims3_adult_bio;
    if gender = 2
       and bt_status = 1
       and 15 <= age <= 24
       and hivstatusfinal ne 99;
run;

data shims3_adult_ind;
    set raw.shims3_adult_ind;
    if gender = 2
       and indstatus = 1
       and bt_status = 1
       and 15 <= age <= 24
       and firstsxage >= 0
       and hivstatusfinal ne 99;
run;


/*------------------------------------------------------------------------------
 Step 5: Merge SHIMS3 biological and interview datasets
------------------------------------------------------------------------------*/

proc sort data=shims3_adult_bio;
    by personid;
run;

proc sort data=shims3_adult_ind;
    by personid;
run;

data shims3_analytic;
    merge shims3_adult_bio (in=in_bio)
          shims3_adult_ind (in=in_ind);
    by personid;

    if in_bio and in_ind;

    survey_year = 2021;
    survey_round = 2;
run;


/*------------------------------------------------------------------------------
 Step 6: Harmonize variable formats across survey rounds

 Example: selected contraceptive method variables were stored as numeric in one
 survey round and character in another. This step converts numeric variables to
 character format so that datasets can be appended consistently.
------------------------------------------------------------------------------*/

data shims3_analytic_harmonized;
    set shims3_analytic;

    array cmethod_num {*} 
        cmethod_a cmethod_c cmethod_d cmethod_e cmethod_f
        cmethod_g cmethod_j cmethod_k cmethod_x;

    array cmethod_char {*} $ 
        cmethod_a_char cmethod_c_char cmethod_d_char cmethod_e_char
        cmethod_f_char cmethod_g_char cmethod_j_char cmethod_k_char
        cmethod_x_char;

    do i = 1 to dim(cmethod_num);
        cmethod_char[i] = put(cmethod_num[i], 8.);
    end;

    drop cmethod_: i;

    rename 
        cmethod_a_char = cmethod_a
        cmethod_c_char = cmethod_c
        cmethod_d_char = cmethod_d
        cmethod_e_char = cmethod_e
        cmethod_f_char = cmethod_f
        cmethod_g_char = cmethod_g
        cmethod_j_char = cmethod_j
        cmethod_k_char = cmethod_k
        cmethod_x_char = cmethod_x;
run;


/*------------------------------------------------------------------------------
 Step 7: Combine survey rounds

 The combined dataset supports analyses comparing 2016 and 2021.
------------------------------------------------------------------------------*/

proc format;
    value roundf
        1 = "SHIMS2: 2016"
        2 = "SHIMS3: 2021";
run;

data combined_analytic;
    set shims2_analytic
        shims3_analytic_harmonized;

    format survey_round roundf.;
run;


/*------------------------------------------------------------------------------
 Step 8: Create derived analytic variables and recode missing values

 Early sexual debut is defined as first sexual intercourse at or before age 15.
 Negative values such as -8 and -9 indicate non-substantive responses and are
 recoded to SAS missing values.
------------------------------------------------------------------------------*/

data combined_analytic;
    set combined_analytic;

    if firstsxage ne . then early_debut = (firstsxage <= 15);

    if schlat in (-8, -9) then schlat = .;
    if wealthquintile in (99, -99) then wealthquintile = .;
    if work12mo in (-8, -9) then work12mo = .;
    if evermar in (-8, -9) then evermar = .;
    if curmar in (-8, -9) then curmar = .;
run;


/*------------------------------------------------------------------------------
 Step 9: Validate analytic dataset construction
------------------------------------------------------------------------------*/

proc freq data=combined_analytic;
    tables survey_round early_debut hivstatusfinal / missing;
    title "Validation Check: Survey Round, Early Sexual Debut, and HIV Status";
run;

proc means data=combined_analytic n mean std min max nmiss;
    var age firstsxage;
    class survey_round;
    title "Validation Check: Age and Age at Sexual Debut by Survey Round";
run;

proc contents data=combined_analytic varnum;
    title "Validation Check: Combined Analytic Dataset Structure";
run;
