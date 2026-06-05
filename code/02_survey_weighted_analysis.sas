/**********************************************************************************
Purpose:
 This program demonstrates survey-weighted descriptive analysis using SAS.
 The analytic workflow estimates weighted frequencies, weighted means, confidence
 intervals, and survey-weighted comparisons across SHIMS survey rounds.

 Notes:
 - Raw SHIMS/PHIA data are restricted and are not included in this repository.
 - This script assumes that `combined_analytic` was created in
   01_data_management_and_harmonization.sas.
 - The code uses blood-test weights and jackknife replicate weights to account
   for the complex survey design.
**********************************************************************************/


/*------------------------------------------------------------------------------
 Step 1: Review survey round distribution

 This basic frequency check confirms that both survey rounds are represented in
 the analytic dataset prior to weighted analysis.
------------------------------------------------------------------------------*/

proc freq data=combined_analytic;
    tables survey_round / missing;
    title "Unweighted Validation Check: Survey Round Distribution";
run;


/*------------------------------------------------------------------------------
 Step 2: Estimate weighted HIV prevalence by survey round

 PROC SURVEYFREQ accounts for the complex survey design using the main survey
 weight and jackknife replicate weights.
------------------------------------------------------------------------------*/

proc sort data=combined_analytic;
    by survey_round;
run;

proc surveyfreq data=combined_analytic varmethod=jackknife;
    by survey_round;
    tables hivstatusfinal / cl;
    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;
    title "Weighted HIV Status Distribution by Survey Round";
run;


/*------------------------------------------------------------------------------
 Step 3: Estimate weighted distribution of educational attainment

 This example summarizes highest level of education attained among AGYW in each
 survey round.
------------------------------------------------------------------------------*/

proc surveyfreq data=combined_analytic varmethod=jackknife;
    by survey_round;
    tables schlhi / cl;
    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;
    title "Weighted Highest Educational Attainment by Survey Round";
run;


/*------------------------------------------------------------------------------
 Step 4: Estimate weighted urban/rural distribution

 This example demonstrates weighted estimation for a demographic covariate.
------------------------------------------------------------------------------*/

proc surveyfreq data=combined_analytic varmethod=jackknife;
    by survey_round;
    tables urban / cl;
    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;
    title "Weighted Urban/Rural Residence by Survey Round";
run;


/*------------------------------------------------------------------------------
 Step 5: Estimate weighted wealth quintile distribution

 Missing or non-substantive values should be recoded before this step in the
 data management script.
------------------------------------------------------------------------------*/

proc surveyfreq data=combined_analytic(where=(wealthquintile ne .)) varmethod=jackknife;
    by survey_round;
    tables wealthquintile / cl;
    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;
    title "Weighted Wealth Quintile Distribution by Survey Round";
run;


/*------------------------------------------------------------------------------
 Step 6: Estimate weighted mean age and age at sexual debut by survey round

 PROC SURVEYMEANS is used for continuous variables while applying survey weights
 and jackknife replicate weights.
------------------------------------------------------------------------------*/

proc surveymeans data=combined_analytic mean std stderr clm varmethod=jackknife;
    by survey_round;
    var age firstsxage;
    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;
    title "Weighted Mean Age and Age at Sexual Debut by Survey Round";
run;


/*------------------------------------------------------------------------------
 Step 7: Estimate overall weighted mean age at sexual debut

 This estimate pools both survey rounds and provides an overall weighted mean.
------------------------------------------------------------------------------*/

proc surveymeans data=combined_analytic mean std stderr clm varmethod=jackknife;
    var firstsxage;
    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;
    title "Overall Weighted Mean Age at Sexual Debut";
run;


/*------------------------------------------------------------------------------
 Step 8: Compare mean age at sexual debut by survey round

 PROC SURVEYREG provides a survey-weighted test of whether mean age at sexual
 debut differed between 2016 and 2021.
------------------------------------------------------------------------------*/

proc surveyreg data=combined_analytic varmethod=jackknife;
    class survey_round;
    model firstsxage = survey_round;
    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;
    title "Survey-Weighted Comparison of Mean Age at Sexual Debut by Survey Round";
run;


/*------------------------------------------------------------------------------
 Step 9: Compare mean age at sexual debut by educational attainment

 This model evaluates whether age at sexual debut differs by highest level of
 education attained.
------------------------------------------------------------------------------*/

proc surveyreg data=combined_analytic(where=(schlhi ne .)) varmethod=jackknife;
    class schlhi;
    model firstsxage = schlhi;
    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;
    title "Survey-Weighted Comparison of Mean Age at Sexual Debut by Educational Attainment";
run;
