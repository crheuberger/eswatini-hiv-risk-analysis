/**********************************************************************************
 Purpose:
 This program demonstrates survey-weighted logistic regression modeling used in an
 epidemiologic analysis of early sexual debut, educational attainment, and HIV
 status among adolescent girls and young women in Eswatini.

 Notes:
 - Raw SHIMS/PHIA data are restricted and are not included in this repository.
 - This script assumes that `combined_analytic` was created in
   01_data_management_and_harmonization.sas.
 - Models use blood-test weights and jackknife replicate weights to account for
   the complex survey design.
**********************************************************************************/


/*------------------------------------------------------------------------------
 Step 1: Unadjusted association between HIV status and early sexual debut

 Outcome:
 - early_debut = 1 if first sexual intercourse occurred at or before age 15

 Exposure:
 - hivstatusfinal

 This model estimates the crude association between HIV status and early sexual
 debut within each survey round.
------------------------------------------------------------------------------*/

proc sort data=combined_analytic;
    by survey_round;
run;

proc surveylogistic data=combined_analytic;
    by survey_round;

    class hivstatusfinal (ref='1') / param=ref;

    model early_debut(event='1') = hivstatusfinal;

    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;

    title "Unadjusted Association Between HIV Status and Early Sexual Debut by Survey Round";
run;


/*------------------------------------------------------------------------------
 Step 2: Unadjusted association between educational attainment and early sexual debut

 This model estimates the crude association between highest level of education
 attained and early sexual debut.
------------------------------------------------------------------------------*/

proc surveylogistic data=combined_analytic;
    by survey_round;

    class schlhi (ref='2') / param=ref;

    model early_debut(event='1') = schlhi;

    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;

    title "Unadjusted Association Between Educational Attainment and Early Sexual Debut";
run;


/*------------------------------------------------------------------------------
 Step 3: Adjusted model for correlates of early sexual debut

 This multivariable model estimates adjusted odds ratios for early sexual debut,
 controlling for sociodemographic and behavioral covariates.

 Covariates were selected based on prior literature and bivariate screening.
------------------------------------------------------------------------------*/

proc surveylogistic data=combined_analytic(where=(survey_round=1));
    class
        hivstatusfinal (ref='1')
        schlat         (ref='1')
        schlhi         (ref='2')
        wealthquintile (ref='5')
        urban          (ref='1')
        work12mo       (ref='2')
        / param=ref;

    model early_debut(event='1') =
        hivstatusfinal
        schlat
        schlhi
        wealthquintile
        urban
        work12mo;

    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;

    title "Adjusted Odds Ratios for Early Sexual Debut: SHIMS2 2016";
run;


proc surveylogistic data=combined_analytic(where=(survey_round=2));
    class
        hivstatusfinal (ref='1')
        schlat         (ref='1')
        schlhi         (ref='2')
        wealthquintile (ref='5')
        urban          (ref='1')
        work12mo       (ref='2')
        / param=ref;

    model early_debut(event='1') =
        hivstatusfinal
        schlat
        schlhi
        wealthquintile
        urban
        work12mo;

    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;

    title "Adjusted Odds Ratios for Early Sexual Debut: SHIMS3 2021";
run;


/*------------------------------------------------------------------------------
 Step 4: Adjusted association between early sexual debut and HIV status

 Outcome:
 - hivstatusfinal

 Primary exposure:
 - early_debut

 This model evaluates whether early sexual debut is associated with HIV status
 after adjustment for education, employment, and survey round.
------------------------------------------------------------------------------*/

proc surveylogistic data=combined_analytic;
    where hivstatusfinal in (1, 2)
          and early_debut in (0, 1)
          and schlat in (1, 2)
          and work12mo in (1, 2);

    class
        early_debut  (ref='0')
        schlat       (ref='1')
        schlhi       (ref='2')
        work12mo     (ref='2')
        survey_round (ref='1')
        / param=ref;

    model hivstatusfinal(event='1') =
        early_debut
        schlat
        schlhi
        work12mo
        survey_round;

    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;

    title "Adjusted Odds Ratios for HIV Status";
run;


/*------------------------------------------------------------------------------
 Step 5: Interaction model assessing whether associations changed over time

 This model tests whether the association between early sexual debut and HIV
 status differed between the 2016 and 2021 survey rounds.

 The product term early_debut*survey_round evaluates effect modification by
 survey round.
------------------------------------------------------------------------------*/

proc surveylogistic data=combined_analytic;
    where hivstatusfinal in (1, 2)
          and early_debut in (0, 1)
          and schlat in (1, 2)
          and work12mo in (1, 2);

    class
        early_debut  (ref='0')
        schlat       (ref='1')
        schlhi       (ref='2')
        work12mo     (ref='2')
        survey_round (ref='1')
        / param=ref;

    model hivstatusfinal(event='1') =
        early_debut
        schlat
        schlhi
        work12mo
        survey_round
        early_debut*survey_round;

    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;

    title "Interaction Model: Early Sexual Debut, Survey Round, and HIV Status";
run;


/*------------------------------------------------------------------------------
 Step 6: Interaction model for education and survey round

 This model evaluates whether the association between educational attainment and
 HIV status differed between survey rounds.
------------------------------------------------------------------------------*/

proc surveylogistic data=combined_analytic;
    where hivstatusfinal in (1, 2)
          and early_debut in (0, 1)
          and schlat in (1, 2)
          and work12mo in (1, 2);

    class
        early_debut  (ref='0')
        schlat       (ref='1')
        schlhi       (ref='2')
        work12mo     (ref='2')
        survey_round (ref='1')
        / param=ref;

    model hivstatusfinal(event='1') =
        early_debut
        schlat
        schlhi
        work12mo
        survey_round
        schlhi*survey_round;

    weight btwt0;
    repweights pbtwt001-pbtwt141 / jkcoefs=1 df=25;

    title "Interaction Model: Educational Attainment, Survey Round, and HIV Status";
run;
