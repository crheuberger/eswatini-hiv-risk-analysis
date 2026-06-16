# SAS Analysis of HIV Risk Among Adolescent Girls and Young Women in Eswatini

## Overview

This project uses nationally representative Population-Based HIV Impact Assessment (PHIA) data from Eswatini to examine the relationship between educational attainment, early sexual debut, and HIV status among adolescent girls and young women (AGYW) aged 15–24 years.

The analysis compares two survey rounds (2016 and 2021) and applies complex survey methods, including jackknife variance estimation and multivariable logistic regression, to identify factors associated with HIV risk.

## Purpose

The purpose of this project is to demonstrate applied SAS programming, public health data management, survey-weighted analysis, logistic regression, and communication of epidemiologic findings.

## Key Findings

- HIV prevalence among AGYW declined from 21.0% in 2016 to 13.5% in 2021.
- Early sexual debut declined from 13.4% in 2016 to 9.9% in 2021.
- Educational attainment remained strongly protective against both early sexual debut and HIV infection.
- After adjustment for covariates, early sexual debut was not independently associated with HIV status.

## Data

This project used restricted SHIMS/PHIA data. Raw data are not included in this repository.

## Skills Demonstrated

- SAS programming
- Data cleaning and harmonization
- Variable recoding
- Dataset construction
- Complex survey analysis
- Jackknife variance estimation
- Logistic regression
- Public health interpretation
- Communication of technical findings through tables and figures

## Repository Structure

```text
code/
├── 01_data_management_and_harmonization.sas
├── 02_survey_weighted_analysis.sas
└── 03_logistic_regression_models.sas

docs/
└── project_summary.md

outputs/
├── figure1_age_at_sexual_debut_by_education.png
├── table1a_sample_characteristics.png
├── table1b_sample_characteristics.png
├── table3_adjusted_early_sexual_debut_model.png
└── table4_adjusted_hiv_model.png
```

## Additional Documentation

For additional details on the study background, methods, findings, and public health implications, see:

`docs/project_summary.md`
