# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # DSU - MeasureIonArea - PositiveMode
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
Feature: DSU - QRZ - MeasureIonArea - Positive Mode
	In order to check 'Measure Ion Area' processes for 'positive mode' within a Quartz environment
	I want to check that the 'Measure Ion Area' function as expected and generates the expected outputs when ran in 'positive mode'.


Background:
Given the browser is opened on the Tune page
	And the polarity is Positive
	And reference fluidics are set to
		| Baffle Position | Reservoir | Flow Path | Flow Rate |
		| Reference       | B         | Infusion  | 20.00     |
	And the reference fluidic level is not less than '10.00' minutes
	And the instrument has a beam 
	And you start reference infusing
	And that the Quartz Detector Setup page is open
When Measure Ion Area has been selected
	And detector setup is run for 'Positive' mode

Scenario: DSU - 01 - MeasureIonArea - Positive mode - Positive Mass Results - Range
Then the field value is between Minimum and Maximum
| Field                     | Minimum | Maximum |
| Positive Detector Voltage | 0       | 3950    |
| Positive Ion Area         | 0       | 100     |

Scenario: DSU - 02 - MeasureIonArea - Positive mode - Negative Mass Results - Values
Then the field value should be
| Field                     | FieldValue |
| Negative Detector Voltage | Blank      |
| Negative Ion Area         | Blank      |

Scenario: DSU - 03 - MeasureIonArea - Positive mode - Positive and Negative Mass Results - Status
Then the field value should be
| Field           | Value    |
| Positive Status | Complete |
| Negative Status | Blank    |
	And the Measure Ion Area Setup should complete within 60 seconds

Scenario: DSU - 04 - MeasureIonArea - Positive mode - Positive Mass Results - Values
Then the Measure Ion Area Mass Results values match the Progress Log 

Scenario: DSU - 05 - MeasureIonArea - Positive mode - Progress Log - Messages
Then the message should exist in the Progress Log
| Message              |
| Measured Ion Area    |
| IPP check at voltage |