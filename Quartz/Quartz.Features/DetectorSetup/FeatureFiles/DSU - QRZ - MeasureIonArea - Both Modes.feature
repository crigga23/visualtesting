# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # DSU - MeasureIonArea - BothModes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CM
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 22-DEC-14
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # \\tu-server-sw\tu-server1\docs\Quartz\Quartz Smoke Test.xlsx
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-298)                 # The user will be able to specify to run a Detector setup or a Measure Ion Area
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@DetectorSetup
@MeasureIonArea
Feature: DSU - QRZ - MeasureIonArea - Both Modes
	In order to check 'Measure Ion Area' processes with both the modes within a Quartz environment
	I want to check that 'Measure Ion Area' functions as expected and generates the expected outputs when ran in 'Both Modes'.
	
# --------------------------------------------------------------------------------------------------------------------------------------------------
Background:
Given the browser is opened on the Tune page
	And reference fluidics are set to
	| Baffle Position | Reservoir | Flow Path | Flow Rate |
	| Reference       | B         | Infusion  | 20.00     | 
	And the reference fluidic level is not less than '10.00' minutes
	And the instrument has a beam
	And you start reference infusing
	And that the Quartz Detector Setup page is open
When Measure Ion Area has been selected
	And detector setup is run for 'Both' mode

Scenario: DSU - 01 - MeasureIonArea - Both mode - Negative Mass Results - Status
Then the field value should be
| Field           | Value    |
| Positive Status | Complete |
| Negative Status | Complete |


Scenario: DSU - 02 - MeasureIonArea - Both mode - Positive and Negative Mass Results - Values
Then the Measure Ion Area Mass Results values match the Progress Log 

Scenario: DSU - 03 - MeasureIonArea - Both mode - Positive and Negative Mass Results - Setup Completion Time
Then the Measure Ion Area Setup should complete within 120 seconds

Scenario: DSU - 04 - MeasureIonArea - Both mode - Progress Log - Messages
Then the message should exist in the Progress Log
| Message              |
| Measured Ion Area    |
| IPP check at voltage |