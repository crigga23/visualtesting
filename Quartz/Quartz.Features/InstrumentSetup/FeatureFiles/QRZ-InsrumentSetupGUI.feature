# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # ISP - QRZ - Instrument Setup
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # NK
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Quartz Development Console environment is available and Typhoon is running
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # MH - 14-Sep-2015
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-469)                 # The user will access the Instrument setup page from the Instrument tab in the Dev Console.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-562)                 # The user will be able to automatically calibrate and setup the MS in all the supported modes of the instrument over different mass ranges using the Dev Console.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-472)                 # When the Run button is pressed the instrument setup process will start. The Run button will be disabled and the Cancel button will be enabled.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-535)                 # When the Cancel button is pressed the instrument setup process will aborted. The Run button will be enable again and the Cancel button will be disabled.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-474)                 # The software will provide the overall progress with a progress bar
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-476)                 # The software will be report the progress of the individual setup item.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-473)                 # The software will allow the user to select what polarity is enable or disable prior to running the setup
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-536)                 # The software will display an appropriate warning for any failure of setup items.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@Ignore
Feature: Instrument Setup GUI
	In order to setup the instrument ready for use
	I want to be able to calibrate the instrument based on set of values for polarity and optical mode
	And setting such as Detector setup, Resolution Optimisation and  CCS calibration


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the Instrument setup page is accessed


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: ISP-01 - Instrument Setup - Instrument Setup page GUI
	When the Instrument setup page is viewed
	Then the following panels are available
			| Panels                                                        |
			| Detector Setup                                                |
			| Resolution Optimisation, Mass Calibration and CCS Calibration |
		And following controls are available
			| Controls              |
			| Progress Status       |
			| Progress Bar          |
			| Run Button            |
			| Cancel Button         |
			| Summary Report Button |
			| Select None Button    |


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: ISP-02 - Instrument Setup options - Default settings
	When the Instrument setup page is viewed
	Then the Instrument Setup has the following available options
		And the Instrument Setup process has the following Setup 'X' slots enabled
			| Process        | Positive | Negative |
			| Detector Setup | X        | X        |
		And the Instrument Setup process has the following Resolution Optimisation 'X' slots enabled
			| Process        | POS RES | NEG RES | POS SENS | NEG SENS |
			| Resolution Opt | X       | X       | X        | X        |
		And the Instrument Setup process has the following Mass Calibration 'X' slots enabled
			| Mass Calibration | POS RES | NEG RES | POS SENS | NEG SENS |
			| 1000             | X       | X       | X        | X        |
			| 2000             | X       | X       | X        | X        |
			| 4000             |         |         |          |          |
		And the Instrument Setup process has the following CCS Calibration 'X' slots enabled
			| CCS Calibration | POS RES | NEG RES | POS SENS | NEG SENS |
			| 1000            | X       | X       | X        | X        |
			| 2000            | X       | X       | X        | X        |
			

Scenario: ISP-03 - Instrument Setup options - All settings
	When the Instrument setup page is viewed
	Then the Instrument Setup has the following available options
		And the Instrument Setup process will allow the following Setup 'X' slots to be selected
			| Process        | Positive | Negative |
			| Detector Setup | X        | X        |
		And the Instrument Setup process will allow the following Resolution Optimisation 'X' slots enabled
			| Process        | POS RES | NEG RES | POS SENS | NEG SENS |
			| Resolution Opt | X       | X       | X        | X        |
		And the Instrument Setup process will allow the following Mass Calibration 'X' slots to be selected
			| Mass Calibration | POS RES | NEG RES | POS SENS | NEG SENS |
			| 1000             | X       | X       | X        | X        |
			| 2000             | X       | X       | X        | X        |
			| 4000             | X       | X       | X        | X        |
		And the Instrument Setup process will allow the following CCS Calibration 'X' slots to be selected
			| CCS Calibration | POS RES | NEG RES | POS SENS | NEG SENS |
			| 1000            | X       | X       | X        | X        |
			| 2000            | X       | X       | X        | X        |
			


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: ISP-04 - Instrument Setup options - Next Available Slot Status When Current Slot is Success
		When the Instrument setup page is viewed
			And the <Current Slot> status is 'Success' for all slots
		Then the <Next Slots Available> status will always be 'Yes' for all <Next Slots Available> slots regardless of <Current Slot> 'enabled' or 'disabled' status
			Examples:
				| Current Slot            | Next Slots Available    |
				| Detector Setup          | Resolution Optimisation |
				| Resolution Optimisation | Mass Calibration        |
				| Mass Calibration        | CCS Calibration         |


Scenario Outline: ISP-05 - Instrument Setup options - Restriction of slots for Resolution Optimisation - Detector Setup Not run, Aborted and Failed
		When the Instrument setup page is viewed
			And the Detector Setup slot status <Detector Setup Slot Status> is set for Positive and Negative
		Then setting the 'Detector Setup Check Box' will generate a corresponding 'Resolution Optimisation available' status
			| Detector Setup Check Box | Resolution Optimisation available |
			| Both enabled             | Yes - All slots                  |
			| POS only enabled         | Yes - Positive RES and SENS only |
			| NEG only enabled         | Yes - Negative RES and SENS only |
			| None enabled             | None                             |
			# Note: RES and SENS are an abbreviation of Resolution and Sensitivity modes

			Examples:
			| Detector Setup Slot Status |
			| Not Run                    |
			| Aborted                    |
			| Failed                     |
			
		
Scenario Outline: ISP-06 - Instrument Setup options - Restriction of slots for Mass Calibration - Resolution Optimisation Not run, Aborted and Failed
		When the Instrument setup page is viewed
			And the the Detector Setup slot status is 'Success' for Positive and Negative
			And the Resolution Optimisation slot status <Resolution Optimisation Slot Status> is set for All modes
		Then setting the 'Resolution Optimisation Check Box' will generate a corresponding 'Mass Calibration Slots available' status
			| Resolution Optimisation Check Box   | Mass Calibration Slots available                      |
			| All slots enabled                   | Yes - All mass slots                                 |
			| Positive RES and SENS enabled only  | Yes - Positive RES and SENS mass slots only          |
			| Negative RES and SENS enabled only  | Yes - Negative RES and SENS mass slots only          |
			| Positive RES and Negative SENS only | Yes - Positive RES and Negative SENS mass slots only |
			| None enabled                        | None                                                 |
			# Note: RES and SENS are an abbreviation of Resolution and Sensitivity modes

			Examples:
			| Detector Setup Slot Status |
			| Not Run                    |
			| Aborted                    |
			| Failed                     |


Scenario Outline: ISP-07 - Instrument Setup options - Restriction of slots for CCS Calibration - Mass Calibration Not run, Aborted and Failed
		When the Instrument setup page is viewed
			And the the Detector Setup slot status is 'Success' for Positive and Negative
			And the Resolution Optimisation slot status is 'Success' for All modes
			And the Mass Calibration slot status <Mass Calibration Slot Status> is set for All modes
		Then setting the 'Mass Calibration Check Box' will generate a corresponding 'CCS Calibration Slots available' status
			| Mass Calibration Check Box        | CCS Calibration Slots available         |
			| All mass slots enabled            | Yes - All CCS slots                    |
			| All Positive RES mass slots only  | Yes - All Positive RES CCS slots only  |
			| All Negative SENS mass slots only | Yes - All Negative SENS CCS slots only |
			| Positive RES 1000 amass slot only | Yes - Positive RES 1000 CCS slot only  |
			| Negative SENS 1000 mass slot only | Yes - Negative SENS 1000 slot only     |
			| None enabled                      | None                                   |
			# Note: RES and SENS are an abbreviation of Resolution and Sensitivity modes

			Examples:
			| Detector Setup Slot Status |
			| Not Run                    |
			| Aborted                    |
			| Failed                     |
			

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: ISP-08 - Instrument Setup - Run and Cancel button states
		When the Instrument setup page is viewed
			And the Instrument Setup process is in <Set-up state>
		Then the Run button state <Run Button State> is observed
			And the Cancel button state <Cancel Button State> is observed
			Examples:
			| Set-up State | Run Button State | Cancel button state |
			| Not running  | Enabled          | Disabled            |
			| Running      | Disabled         | Enabled             |


Scenario Outline: ISP-09 - Instrument Setup - Summary Report button states
		Given the instrument setup process has never been run
		When the Instrument setup page is viewed
			And the Instrument Setup process is in <Set-up state>
		Then the Summary Report button state <Button State> is observed
			Examples:
			| Set-up State | Button State |
			| Not running  | Disabled     |
			| Running      | Disabled     |
			| Complete     | Enabled      |


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Obsolete
Scenario Outline: ISP-10 -  Instrument Setup - Select All - Resolution Optimisation, Mass Calibration and CCS Calibration
		Given the Instrument setup page is viewed
			And the Instrument Setup process for Resolution Optimisation, Mass Calibration and CCS Calibration has initial slots <Initial Slots> enabled
		When the 'Select All' button is pressed
		Then the Resolution Optimisation, Mass Calibration and CCS Calibration has a final slots <Final Slots> enabled
			Examples:
			| Initial Slots                | Final Slots |
			| Default                      | All         |
			| All                          | All         |
			| None                         | All         |
			| Resolution Optimisation only | All         |
			| Mass Calibration only        | All         |
			| CCS Calibration only         | All         |

Scenario Outline: ISP-11 -  Instrument Setup - Select None - Resolution Optimisation, Mass Calibration and CCS Calibration
		Given the Instrument setup page is viewed
			And the Instrument Setup process for Resolution Optimisation, Mass Calibration and CCS Calibration has initial slots <Initial Slots> enabled
		When the 'Select None' button is pressed
		Then the Resolution Optimisation, Mass Calibration and CCS Calibration has a final slots <Final Slots> enabled
			Examples:
			| Initial Slots                | Final Slots |
			| Default                      | None        |
			| All                          | None        |
			| None                         | None        |
			| Resolution Optimisation only | None        |
			| Mass Calibration only        | None        |
			| CCS Calibration only         | None        |


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: ISP-12 - Instrument Setup - Progress Bar and Status - Complete
		Given the Instrument setup page is viewed
			And the default Instrument Setup slots are enabled
		When the Instrument setup process is started
		Then the progress bar will fill from left to right in stages until the prosess has complete
			And the progress status will show the % remaining until 100% complete
			And the progress the of each individual slot will be displayed during the run until completion
			And upon completion the date of the last Setup Run will be displayed


Scenario: ISP-13 - Instrument Setup - Progress Bar and Status - Aborted
		Given the Instrument setup page is viewed
			And the default Instrument Setup slots are enabled
		When the Instrument setup process is started
			And the Instrument Setup process is cancelled before completion
		Then the progress bar will fill from left to right
			And the status the of the individual slot which was cancelled will state Aborted
			And the date of the last Setup Run will be displayed


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END
