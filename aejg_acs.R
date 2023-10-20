################################################################################
# American Equity Justice Group Hackathon (https://www.americanequity.org/)
# Author: Katherine Chang (katherinetchang@gmail.com)
# Date: Fall 2023

# Purpose: The following code generates county-level racial demographic data and 
# education attainment data for Washington State using the U.S. Census Bureau's 
# American Community Survey 5-Year Estimates for 2017-2021

################################################################################

################################################################################
# STEP 1: Load Packages and API Key
################################################################################

rm(list=ls())

library(dplyr)
library(here)
library(readr)
library(tidycensus)

# census_api_key(" #### ", overwrite=TRUE, install=TRUE) 
# !-- Uncomment Line 22 and update #### with unique key
# !-- Get key at: https://api.census.gov/data/key_signup.html

readRenviron("~/.Renviron")
Sys.getenv("CENSUS_API_KEY")

here::i_am("./AEJG/aejg_acs.R")

################################################################################
# STEP 2: Load and Select ACS 2017-2021 ACS Data Variables List 
################################################################################

# https://cran.r-project.org/web/packages/tidycensus/tidycensus.pdf

# Download the Variable dictionary, see documentation for load_variable for available datasets
df_var<- load_variables(year = 2021, 
                        dataset = "acs5", 
                        cache = TRUE) 

# !-- 2020 PL-94171 Redistricting dataset has more accurate population numbers
# if there's interest in using this data instead of the ACS estimates

# df_var_redistricting = load_variables(year = 2020,
#                                       dataset = "pl",
#                                       cache = TRUE)

write_csv(df_var, "./AEJG/outputs/acs_2021_variable_list.csv")

var_selection <- c(
  pop = "B02001_001", # Total Population
  pop_white = "B02001_002", # % White 
  pop_black = "B02001_003", # % Black
  pop_asian = "B02001_005", # % Asian
  pop_latinx = "B03002_012", # % Latinx
  pop_native = "B02001_004", # % Native American
  edu_total = "B15003_001", # EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER
  edu_8th = "B15003_012", # 8th Grade
  edu_9th = "B15003_013", # 9th Grade
  edu_10th = "B15003_014", # 10th Grade
  edu_11th = "B15003_015", # 11th Grade
  edu_12th = "B15003_016", # 12th Grade, no degree
  edu_hs = "B15003_017", # High school diploma
  edu_ged= "B15003_018" # GED or alternative credential
)
  

################################################################################
# STEP 3: Load Variables of Interest
################################################################################

df_education_county <- get_acs(geography = "county",
                               variables = var_selection,
                               year=2021, # 2017-2021 5-year ACS
                               state = "WA", #FIPS code 53
                               moe = 95, #margin of error
                               cache_table = TRUE)

################################################################################
# STEP 4: Data Transformation (Need feedback on new variables, data structure, etc.)
################################################################################

################################################################################
# STEP 5: Write Data File for PowerBI Import
################################################################################

write_csv(df_education_county, "./AEJG/outputs/acs_2021_education_attainment.csv")

