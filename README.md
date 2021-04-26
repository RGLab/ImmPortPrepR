# R to ImmPort (R2i)

<!-- badges: start -->
  [![R-CMD-check](https://github.com/RGLab/R2i/workflows/R-CMD-check/badge.svg)](https://github.com/RGLab/R2i/actions)
[![Codecov test coverage](https://codecov.io/gh/RGLab/R2i/branch/main/graph/badge.svg)](https://codecov.io/gh/RGLab/R2i?branch=main)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
<!-- badges: end -->


Tools for preparing ImmPort Submission


## Package Structure

### data-raw

* csv files holding prototype data and R scripts to convert this data to an rda that can be loaded and used in developing semi-standard datasets as dataframes.

### data

* rda files created by R scripts in /data-raw

### R

* Scripts for the public and helper functions

## Workflow

### 1. Setup of Accounts and Infrastructure

* Create a login for ImmPort.org
https://immport-user-admin.niaid.nih.gov:8443/registrationuser/registration

* Create or get access to appropriate workspace on ImmPort.org
Each study starts as a “workspace” where collaborators have permission to upload documents related 
to the future study.  Workspaces are accessed via the “private” data icon on the immport home page.
To create or get access to the workspace, connect with the ImmPort curation team.

* Create a dataPackageR skeleton to hold your work in an R package.
DataPackageR is a framework developed by Dr. Greg Finak in the Gottardo Lab to manage the input files, output files, and scripts associated with data processing to ensure reproducibility via versioning.  To learn more see: https://github.com/RGLab/DataPackageR

### 2. Install R2i package

```
devtools::install_github("RGlab/R2i")
```

### 3. Load package 

```
library(R2i)
```

### 4. Work on MetaData

For each of the following templates, use the corresponding vignette to see examples of how to build,
write out, and validate the ImmPort-ready tsv files.  These are the required common MetaData
templates. The templates should be created in the order they are listed below so that they can be
correctly cross-referenced.  For example, the "basic_study_design" template needs the protocolID
assigned in the "protocol" template, so it must be created after.

1. protocols
2. basic_study_design
3. subjects


Other MetaData templates that may apply to your study (also in order for cross-referencing):

* reagents
* treatments
* adverseEvents
* interventions
* assessments
* labTestPanels
* labTests
* labTests_Results


### 5. Work on AssayData

For each assay that was performed you will need to first create "Reagents" and "treatment" templates.
Then you will be able to generate an "experimentSamples" template that references User Defined Ids in
your reagent and treatment templates.  For some, you will also need a "results" template.

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

### 6. Upload Files to ImmPort via Aspera

Upload these templates to ImmPort using the `Validate Data` tab within the appropriate ImmPort workspace.
You will need to login and navigate to the Private data section of the website, then look for `Validate Data` in the top right.

* Templates will have the user-defined IDs "digested" and then new unique IDs will be given for things like Subject, Planned Visit, etc. Therefore, it is important to do the meta-data first so you have the ImmPort
digested IDs that should be referenced instead of the User-Defined IDs.

* To see previous validation attempts in validation history you have to press "search" button otherwise the table of results will be blank.

* If your validation fails, then you can see the report by clicking on the Validation Ticket Details in the validation history and looking for the “Download Database Report” link next to “rejected validation” in the status row.

https://immport.niaid.nih.gov/upload/data/uploadDataMain#!/uploadData

