# -----------------------------------------------------------------------------------------------------------------
# Revision:		01
# Author:     	NK, Date: 02-Apr-14
# Revised by: 	TBD, date revised TBD
# Basis:      	How to Implement Detector setup for Quartz.doc
# -----------------------------------------------------------------------------------------------------------------
# Feature: DESCRIPTION
#
# Prerequisites:
# Given = PREREQUISITE
#   And = PREREQUISITE
#
# Scenario : Name
# Given = STEP
# 	And = STEP
# 	And = STEP
# When  = STEP
# 	And = STEP
# 	And = STEP
# Then  = ACCEPTANCE CRITERIA
# 	And = ACCEPTANCE CRITERIA
# 	And = ACCEPTANCE CRITERIA
#   And = ACCEPTANCE CRITERIA	
# -----------------------------------------------------------------------------------------------------------------------------------------
#Prerequisites:
	#Given a 'Quartz environment' is available
	#And a 'valid username and password' is available for successful login to the Quartz Environment
	#And the Quartz enviroment is connected to a 'simulated Osprey instrument'
# -----------------------------------------------------------------------------------------------------------------------------------------

@DetectorSetup
Feature: DSU - QRZ - DetectorSetup - Negative Mode
	In order to check 'Detector Setup' processes for negative mode within a Quartz environment
	I want to check that the function as expected and generates the expected outputs.

	
Background:
Given the browser is opened on the Tune page
	And the polarity is Negative
	And reference fluidics are set to
	| Baffle Position | Reservoir | Flow Path | Flow Rate |
	| Reference       | B         | Infusion  | 20.00     | 
	And the reference fluidic level is not less than '10.00' minutes
	And the instrument has a beam
	And you start reference infusing
	#And pDRE Attenuate is ON
	And that the Quartz Detector Setup page is open
When detector setup is run for 'Negative' mode

Scenario: DSU - 01 - DetectorSetup - Negative mode - Negative Mass Results - Range  
Then the field value is between Minimum and Maximum
| Field                     | Minimum | Maximum |
| Negative Detector Voltage | 0       | 3950    |
| Negative Ion Area         | 0       | 100     |

Scenario: DSU - 02 - DetectorSetup - Negative mode - Positive Mass Results - Values
Then the field value should be
| Field                     | FieldValue |
| Positive Detector Voltage | Blank      |
| Positive Ion Area         | Blank      |


Scenario: DSU - 03 - DetectorSetup - Negative mode - Positive and Negative Mass Results - Status
Then the field value should be
| Field           | Value    |
| Positive Status | Blank    |
| Negative Status | Complete |
	And the Detector Setup should complete within 5 minutes


Scenario: DSU - 04 - DetectorSetup - Negative mode - Negative Mass Results - Values
Then the Mass Results values match the Progress Log
	
Scenario: DSU - 05 - DetectorSetup - Negative mode - Progress Log - Messages
Then the message should exist in the Progress Log
| Message                      |
| IPP check beam too weak      |
| Detector Level Ramping up to |
| IPP check at voltage         |