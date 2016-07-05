# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # DSU - MeasureIonArea - NegativeMode
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

@DetectorSetup
@MeasureIonArea
Feature: DSU - QRZ - MeasureIonArea - Negative Mode
	In order to check 'Measure Ion Area' processes for 'negative mode' within a Quartz environment
	I want to check that the 'Measure Ion Area' function as expected and generates the expected outputs when ran in 'negative mode'.


Background:
Given the browser is opened on the Tune page
	And the polarity is Negative
	And reference fluidics are set to
		| Baffle Position | Reservoir | Flow Path | Flow Rate |
		| Reference       | B         | Infusion  | 20.00     | 
	And the reference fluidic level is not less than '10.00' minutes
	And the instrument has a beam
	And you start reference infusing
	And that the Quartz Detector Setup page is open
When Measure Ion Area has been selected
	And detector setup is run for 'Negative' mode

Scenario: DSU - 01 - MeasureIonArea - Negative mode - Negative Mass Results - Range  
Then the field value is between Minimum and Maximum
| Field                     | Minimum | Maximum |
| Negative Detector Voltage | 0       | 3950    |
| Negative Ion Area         | 0       | 100     |

Scenario: DSU - 02 - MeasureIonArea - Negative mode - Negative Mass Results - Values
Then the field value should be
| Field                     | FieldValue |
| Positive Detector Voltage | Blank      |
| Positive Ion Area         | Blank      |


Scenario: DSU - 03 - MeasureIonArea - Negative mode - Negative and Negative Mass Results - Status
Then the field value should be
| Field           | Value    |
| Positive Status | Blank    |
| Negative Status | Complete |
	And the Measure Ion Area Setup should complete within 60 seconds


Scenario: DSU - 04 - MeasureIonArea - Negative mode - Negative Mass Results - Values
Then the Measure Ion Area Mass Results values match the Progress Log 
	
Scenario: DSU - 05 - MeasureIonArea - Negative mode - Progress Log - Messages
Then the message should exist in the Progress Log
| Message                 |
| Measured Ion Area       |
| IPP check at voltage    |