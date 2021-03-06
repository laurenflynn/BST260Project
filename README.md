# BST260Project
This repository contains files for the BST 260 final project by Lauren Flynn, Anna Lai, Kehuan Lin, and Carolin Schulte, completed in Fall 2021.

### Main files
All main analyses are included in BST260_final. The supplementary information in the different appendices is referenced as appropriate.
- **BST260_final.Rmd**: R Markdown file containing an overview of project background and motivation, all main analyses (code and figures) and a discussion of our findings.
- **BST260_final.html**: BST260_final.Rmd knitted to html

- **AppendixA.Rmd**: Code for merging NHANES data for 2007 - 2018 and re-coding variables of interest; all .XPT files were obtained from the [CDC website for NHANES](https://www.cdc.gov/nchs/nhanes/about_nhanes.htm) and are not included as part of this repository (file will not knit without those data). The output is 'masterDF.Rda', which is included in the **Data** folder.
- **AppendixA.html**: AppendixA.Rmd knitted to html

- **AppendixB.Rmd**: Code for creating graphs of NHANES data for exploratory data analysis (in addition to analyses performed in BST260_final) and assessing missingness for covariates of interest
- **AppendixB.html**: AppendixB.Rmd knitted to html

- **AppendixC.Rmd**: Code for fitting all machine learning models described in this study
- **AppendixC.html**: AppendixC.Rmd knitted to html

- **AppendixD.Rmd**: Code for running sensitivity analyses for the inclusion of survey weights in the logistic regression models
- **AppendixD.html**: AppendixD.Rmd knitted to html

### Data
- **GlobalMortalityData2014.csv**: Data on global country-specific mortality due to eating disorders in 2014; based on [data published by the WHO](https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fwww.who.int%2Fhealthinfo%2Fglobal_burden_disease%2FGHE_Deaths_2012_country.xls%3Fua%3D1&wdOrigin=BROWSELINK) 

- **masterDF.Rda**: R data object containing combined NHANES data for 2007 - 2018; required for all data analyses using NHANES data. The data was originally accessed through the [CDC website for NHANES](https://www.cdc.gov/nchs/nhanes/about_nhanes.htm). 

### ShinyApp
- **app.R**: Code for the Shiny app; in order to download this app, please download the data file filtered_for_shiny.Rda. The app is also available online at https://laurenflynn.shinyapps.io/project/

- **filtered_for_shiny.Rda**: NHANES data which has been filtered to include the variables necessary for the Shiny app (app.R). 

- **filtering_for_shiny.Rmd**: Selects variables of interest and filters out missing values in order to create filtered_for_shiny.Rda


### Video
Our video is available at https://youtu.be/TFpKMJgDkFU


### Website
Our website is available at https://sites.google.com/view/bst260-nhanes
