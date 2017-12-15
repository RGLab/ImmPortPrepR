# Import2ImmPort
Tools for preparing ImmPort Submission

# Package Structure
- Import2ImmPort
--- data-raw
        * csv files holding prototype data and R scripts to convert this data to
        an rda that can be loaded and used in developing semi-standard datasets
        as dataframes.
--- data
        * rda files created by R scripts in /data-raw
--- R
        * transform_<templateName>.R scripts take in semi-standard dataframes 
        from user and generate tsv files in an output directory
        * validate_<templateName>.R scripts are used to test tsv files according to
        ImmPort's online validator tool.
        * write.R is a script that contains functions used in writing out ImmPort templates
        * utils.R contains general helper functions used throughout package

# Workflow
1. Install package with `devtools::install_github("RGlab/Import2ImmPort")`
2. Load package with `library(Import2ImmPort)`
3. Work on MetaData
    * for each of the following templates, follow the corresponding vignette to 
    see examples of how to build, write out, and validate the ImmPort-ready tsv files.
    a. BasicStudyDesign
    b. Protocol
    c. Treatments
    d. bioSamples
    e. Subjects
4. Work on AssayData (repeat for each assay)
    * After identifying necessary templates with the help of an ImmPort colleague, use
    an example vignette as a guide for creating an assay tsv file.
    a. experimentSamples
    b. Results
    c. Reagents
    
