# Project Summary

## Background

Eswatini has the highest adult HIV prevalence in the world, with approximately one in four adults living with HIV. Although substantial progress has been made in reducing HIV incidence through expanded prevention, testing, and treatment programs, adolescent girls and young women (AGYW) continue to experience a disproportionate burden of HIV infection. Understanding the structural and behavioral factors associated with HIV risk among AGYW remains critical for informing prevention strategies and resource allocation.

## Research Objective

The objective of this analysis was to evaluate the relationship between educational attainment, early sexual debut, and HIV status among AGYW aged 15–24 years in Eswatini. Specifically, the study examined whether patterns of age at sexual debut and associated HIV risk factors changed between 2016 and 2021, a period characterized by substantial expansion of HIV prevention programming.

## Data Source

Data were obtained from the Swaziland HIV Incidence Measurement Survey (SHIMS) Round 2 (2016) and Round 3 (2021), nationally representative Population-Based HIV Impact Assessment (PHIA) surveys conducted in Eswatini. SHIMS employs a two-stage cluster sampling design and includes both interview data and biological HIV testing data.

> **Note:** Due to data use restrictions, the original datasets are not included in this repository.

## Study Population

The analytic sample included adolescent girls and young women aged 15–24 years who:

- Completed both the household interview and HIV testing components of the survey
- Had a confirmed HIV test result
- Reported age at first sexual intercourse

The final combined analytic dataset included **2,185 participants** across both survey rounds.

## Statistical Methods

Data management and statistical analyses were conducted in **SAS**.

Key analytic steps included:

- Restricting and harmonizing study populations across survey rounds
- Merging interview and biological testing datasets
- Recoding and harmonizing variables across survey years
- Constructing derived variables, including early sexual debut (defined as first sexual intercourse at or before age 15)
- Applying survey weights and jackknife replicate weights to account for the complex survey design
- Estimating weighted prevalence and descriptive statistics
- Conducting survey-weighted logistic regression analyses to identify factors associated with early sexual debut and HIV status
- Evaluating interaction effects to assess whether associations differed between survey rounds

## Key Findings

Several important findings emerged from the analysis:

- HIV prevalence among AGYW declined from **21.0% in 2016** to **13.5% in 2021**.
- The prevalence of early sexual debut declined from **13.4% in 2016** to **9.9% in 2021**.
- Secondary and tertiary educational attainment were associated with significantly lower odds of early sexual debut.
- Tertiary educational attainment was associated with significantly lower odds of HIV infection.
- After adjustment for demographic and socioeconomic factors, early sexual debut was not independently associated with HIV status.
- The relationships between educational attainment, early sexual debut, and HIV status remained stable between survey rounds despite substantial HIV prevention efforts.

## Public Health Implications

The findings suggest that educational attainment remains an important structural factor associated with HIV vulnerability among adolescent girls and young women. While biomedical HIV interventions have contributed to reductions in HIV burden, continued investment in strategies that support educational attainment and school retention may provide additional benefits for HIV prevention.

These results also highlight the importance of evaluating structural determinants of health alongside traditional behavioral risk factors when designing HIV prevention programs.

## Skills Demonstrated

### SAS Programming

- Data management and cleaning
- Dataset merging and harmonization
- Variable recoding and derivation
- Macro programming
- Survey analysis procedures

### Epidemiologic Methods

- Cross-sectional study design
- Complex survey analysis
- Survey weighting and jackknife variance estimation
- Logistic regression modeling
- Interaction assessment and effect modification

### Public Health Analytics

- HIV surveillance data analysis
- Interpretation of epidemiologic findings
- Translation of statistical results into public health recommendations
- Communication of technical findings to diverse audiences
