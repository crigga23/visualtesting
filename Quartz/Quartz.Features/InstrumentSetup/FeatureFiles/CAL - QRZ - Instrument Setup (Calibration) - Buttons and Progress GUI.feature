
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 09-FEB-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Sample vial set to 'A' (Sodium Formate) and Baffle set to Sample position
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Calibration solution be available for Sample fluidics and Baffle set to Sample position
#                          # There should be a good Sample beam available with peaks consistent with the expected Calibration solution
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-469)                 #	The user will access the Instrument setup page from the Instrument tab in the Dev Console.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-470)                 #	The Instrument Setup page will be present for all authenticated users
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-472)                 #	When the Run button is pressed the instrument setup process will start. The Run button will be disabled and the Cancel button will be enabled.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-535)                 #	When the Cancel button is pressed the instrument setup process will aborted. The Run button will be enable again and the Cancel button will be disabled.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-474)                 #	The software will provide the overall progress with a progress bar once the instrument setup process has started
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-476)                 #	The software will be report the progress of the individual setup item.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-475)                 #	The software will allow the user to activate or deactivate the polarity for the entire column via the top toggle button control
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-536)                 #	The software will display an appropriate warning for any failure of setup items.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@InstrumentSetup
Feature: CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI
	In order to change initial Instrument Setup settings, control and monitor overall progress
	I want to be able to toggle slot buttons, click Start / Cancel and view progress via a bar / messages
	So that I can control the overall slots calibrated and interview if progress is not successful
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	### TODO - Needed for an instrument  - steps cannot be verified due to instrument access ###
	#Given the browser is opened on the Tune page
	#And reference fluidics are set to 
	#	| Baffle Position | Reservoir | Flow Path | Flow Rate |
	#	| Reference       | B         | Infusion  | 40.00     |
	#And the reference fluidic level is not less than '25.00' minutes
	#And the instrument has a beam
	
Given the Instrument Setup page is accessed	
	And the Instrument Setup process is not running

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario: CAL-01 - InstrumentSetupGUIandCalibration - Basic GUI Elements and States
	Given that the Instrument Setup process has not been run
	Then the following Instrument Setup buttons are in the expected state
		| Button      | Expected State |
		| Run         | Enabled        |
		| Cancel      | Disabled       |
		| Select None | Enabled        |
		And all slots are in the correct selected state	
		And the progress message should be 'Last update performed : Never been run!'


Scenario Outline: CAL-02 - InstrumentSetupGUIandCalibration - Buttons Status 
	Given all slots are in a 'Not Run' status
		And '<Slots>' ADC setup slots are selected and run
		And an instrument state of <Instrument Setup State>
	Then the Instrument Setup 'Run' button should be '<Run Button State>'
		And the Instrument Setup 'Cancel' button should be '<Cancel Button State>'
		Examples: States
		| Instrument Setup State | Slots |Run Button State | Cancel Button State |
		| Running                | 1     |Disabled         | Enabled             |
		| Aborted                | 1     |Enabled          | Disabled            |
		| Completed              | 1     |Enabled          | Disabled            |


Scenario Outline: CAL-03 - InstrumentSetupGUIandCalibration - Progress Bar and Messages
	Given all slots are in a 'Not Run' status
		And '<Slots>' ADC setup slots are selected and run
		And an instrument state of <Instrument Setup State>
	Then the progress bar should be <Progress Bar>
		And the progress message will be <Progress Message>
		And the issue message will be <Issue Message>
		Examples:
		| Instrument Setup State | Slots | Progress Bar                     | Progress Message                       | Issue Message                                                       |
		| Running                | 2     | Progressing left to right        | Running selected tests, x% complete    | na                                                                  |
		| Aborted                | 1     | Progress frozen at Aborted state | Running selected tests,  100% complete | Last update performed : ddd-MMM-dd-yyyy - ADC Setup aborted         |
		| Completed              | 1     | Full                             | Running selected tests,  100% complete | Last update performed : ddd-MMM-dd-yyyy - Instrument Setup Complete |
	

@cleanup-xml
Scenario Outline: CAL-04 - InstrumentSetupGUIandCalibration - Progress Bar and Mass Calibration Failure Messages
	Given ADC Setup, Instrument Setup Detector Setup and Resolution Optimisation has been run for all modes
		And calibration acceptance criteria has been modified to simulate a failure
		And '<Slots>' mass calibration slots are selected and run
		Then the activated mass calibration slots have a run state of 'Failed'
	Then the progress bar should be <Progress Bar>
		And the progress message will be <Progress Message>
		And the issue message will be <Issue Message>
		Examples:
		| Slots | Progress Bar                     | Progress Message                       | Issue Message                                                                                         |
		| 1     | Full                             | Running selected tests,  100% complete | Last update performed : ddd-MMM-dd-yyyy - Instrument Setup Failed - see log messages view for details |
		| 2     | Full                             | Running selected tests,  100% complete | Last update performed : ddd-MMM-dd-yyyy - Instrument Setup Failed - see log messages view for details |


Scenario Outline: CAL-05 - InstrumentSetupGUIandCalibration - Progress Bar and Mass Calibration Abort Message
	Given ADC Setup, Instrument Setup Detector Setup and Resolution Optimisation has been run for all modes
		And '<Slots>' mass calibration slots are selected
	When instrument setup process is 'started'
	And instrument setup process is 'stopped'
		Then the activated mass calibration slots have a run state of 'Aborted'
	Then the progress bar should be <Progress Bar>
		And the progress message will be <Progress Message>
		And the issue message will be <Issue Message>
		Examples:
		| Slots | Progress Bar                     | Progress Message                       | Issue Message                                                                                         |
		| 1     | Progress frozen at Aborted state | Running selected tests,  100% complete | Last update performed : ddd-MMM-dd-yyyy - Mass Calibration aborted                                    |		


Scenario: CAL-06 - InstrumentSetupGUIandCalibration - Reset Message
	When the instrument setup 'Reset' button is clicked
	Then the progress message should be 'Last update performed : Instrument Setup data reset by command'


Scenario: CAL-07 - InstrumentSetupGUIandCalibration - Select None	
	Given all slots are selected 
	When the instrument setup 'Select None' button is clicked
	Then all Resolution Optimisation and Calibration slots are not selected

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END
