# R to ImmPort (R2i)

[![Travis-CI Build Status](https://travis-ci.org/RGLab/R2i.svg?branch=master)](https://travis-ci.org/RGLab/R2i)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/RGLab/R2i?branch=master&svg=true)](https://ci.appveyor.com/project/RGLab/R2i)
[![Coverage Status](https://img.shields.io/codecov/c/github/RGLab/R2i/master.svg)](https://codecov.io/github/RGLab/R2i?branch=master)


Tools for preparing ImmPort Submission


## Package Structure

### data-raw

* csv files holding prototype data and R scripts to convert this data to an rda that can be loaded and used in developing semi-standard datasets as dataframes.

### data

* rda files created by R scripts in /data-raw

### R

* `transform_<templateName>.R` scripts take in semi-standard dataframes from user and generate tsv files in an output directory
* `validate_<templateName>.R` scripts are used to test tsv files according to ImmPort's online validator tool.
* `write.R` is a script that contains functions used in writing out ImmPort templates
* `utils.R` contains general helper functions used throughout package
* `LookupFns.R` has interactive functions to make it easy to find columns with lookups and allowed values.
* `checkTemplate.R` has the quality control function `checkTemplate()`.
* `getTemplateDF.R` is for the interactive `getTemplateDF()` function for creating a blank template.


## Workflow

### 1. Install package

```
devtools::install_github("RGlab/R2i")
```

### 2. Load package 

```
library(R2i)
```

### 3. Work on MetaData

For each of the following templates, use the corresponding vignette to see examples of how to build,
write out, and validate the ImmPort-ready tsv files.  These are the required common MetaData
templates. The templates should be created in the order they are listed below so that they can be
correctly cross-referenced.  For example, the "basic_study_design" template needs the protocolID
assigned in the "protocol" template, so it must be created after.

1. protocols
2. treatments
3. basic_study_design
4. subjects
5. bioSamples

Other MetaData templates that may apply to your study (also in order for cross-referencing):

* adverseEvents
* interventions
* assessments
* labTestPanels
* labTests
* labTests_Results


### 4. Work on AssayData

For each assay that was performed you will need to first create "Reagents" template and 
then an "experimentSamples" template that references ReagentIDs.  For some, you will also 
need a "results" template.

For example, if you did an ELISA assay, you would use the following templates:

* reagents.elisa
* experimentSamples.elisa
* elisa_results

Assays with result templates:
* ELISA
* ELISPOT
* HAI
* PCR
* Virus Neutralization
* HLA Typing
* KIR Typing
* RNAseq
* MBAA
* Flow Cytometry
* CyTOF

Assays without result templates:
* Genotyping Array
* Mass Spectrometry
* Image Histology

### 5. Create Zip File from Output Directory

to create the zip file needed for the ImmPort Submission website, use:
`zip(zipfile = "my_file_name", files = "output_directory/")`

### 6. Upload the Zip File to ImmPort

https://immport.niaid.nih.gov/upload/data/uploadDataMain#!/uploadData

