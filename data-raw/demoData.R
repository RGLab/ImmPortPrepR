demoData <- list(
  study = list(
    "User Defined ID" = "example human study",
    "Brief Title" = "example human study title",
    "Official Title" = "example human study official",
    "Type" = "Interventional",
    "Brief Description" = "example human study",
    "Description" = "this is a detailed description.",
    "Hypothesis" = "example human study hypothesis",
    "Objectives" = "example human study objectives",
    "Endpoints" = "example human study endpoints",
    "Sponsoring Organization" = "university",
    "Target Enrollment" = 2,
    "Condition Studied" = "example human study test load",
    "Minimum Age" = 0,
    "Maximum Age" = 100,
    "Age Unit" = "Years",
    "Actual Start Date" = "06-Feb-2005",
    "Intervention Agent" = "example human study"
  ),
  study_categorization = list(
    "Research Focus" = "Immune Response"
  ),
  arm_or_cohort = data.frame(
    "User Defined ID" = c(
      "example arm vaccine 1",
      "example arm vaccine 2"
    ),
    "Name" = c(
      "example human study vaccine 1",
      "example human study vaccine 2"
    ),
    "Description" = c(
      "vaccine type 001",
      "vaccine type 002"
    ),
    "Type" = c(
      "Intervention",
      "Intervention"
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  ),
  study_personnel = data.frame(
    "User Defined ID" = c(
      "example human study 1"
    ),
    "Honorific" = c(
      "Dr."
    ),
    "Last Name" = c(
      "last"
    ),
    "First Name" = c(
      "first"
    ),
    "Suffixes" = c(
      "jr"
    ),
    "Organization" = c(
      "college"
    ),
    "Email" = c(
      "first.name@address.org"
    ),
    "Title In Study" = c(
      "Principal Investigator"
    ),
    "Role In Study" = c(
      "Principal Investigator"
    ),
    "Site Name" = c(
      "college"
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  ),
  planned_visit = data.frame(
    "User Defined ID" = c(
      "example human study v1",
      "example human study v2"
    ),
    "Name" = c(
      "example human study v1",
      "example human study v2"
    ),
    "Order Number" = c(
      1,
      2
    ),
    "Min Start Day" = c(
      1,
      10
    ),
    "Max Start Day" = c(
      NA,
      NA
    ),
    "Start Rule" = c(
      NA,
      NA
    ),
    "End Rule" = c(
      NA,
      NA
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  ),
  inclusion_exclusion = data.frame(
    "User Defined ID" = c(
      "example human study.Question 1",
      "example human study.Question 2"
    ),
    "Criterion" = c(
      "Question asked",
      "Question asked"
    ),
    "Criterion Category" = c(
      "Inclusion",
      "Exclusion"
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  ),
  study_2_protocol = list(
    "Protocol ID" = "example human study protocol"
  ),
  study_file = c(
    "File Name",
    "Description",
    "Study File Type"
  ),
  study_link = c(
    "Name",
    "Value"
  ),
  study_pubmed = c(
    "Pubmed ID",
    "DOI",
    "Title",
    "Journal",
    "Year",
    "Month",
    "Issue",
    "Pages",
    "Authors"
  )
)

save(demoData, file = "data/demoData.rda")
