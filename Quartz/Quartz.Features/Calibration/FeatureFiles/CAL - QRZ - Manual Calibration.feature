# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # CAL - QRZ - Manual Calibration
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Michael Hodgkinson /Mark Brown
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 30-Jul-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:	   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Typoon and Quartz installed for Osprey instrument
#                          # Detector Setup must be succesully run for both polarities
#                          # Data is recorded for Positive Sodium Formate
#                          # CCS Data is recorded for Positive Major Mix
#                          # No Instrument Setup Calibration has been run
#                		   # No Manual Calibration has been run
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis                    # Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-248)                 # The user will be able to manually calibrate the MS in all the supported modes of the instrument over different mass ranges using the Dev Console.  More detail will be provided post DM
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-598)                 # The user will be able to manuall un-calibrate any supported mode and mass range.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-255)                 # The software will show sample data, reference data and the current calibration curve.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-256)                 # The software will allow the user to match peaks between sample data and reference data.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-257)                 # The software will allow the user to un-match peaks between sample data and reference data.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-258)                 # The software will display an initial set of automatically matched peaks.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-259)                 # The software will have the ability to return to the initial set of automatically patched peaks.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-260)                 # The software will show calibrated residuals.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-261)                 # The software will show linear residuals.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-262)                 # The software will have the ability to display a calibration report.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-263)                 # The software will indicate matched peaks to the user.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-264)                 # The software will have the ability to accept a calibration.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-265)                 # The software will have the ability to reject a calibration.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-266)                 # The software will allow the user to change automatic peak matching parameters.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-267)                 # The software will automatically update the summary information when changes occur
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-269)                 # The software will show summary information for the peak matching process.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-271)                 # The software will allow the user to display a calibration report.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-272)                 # The software will allow the user to print the calibration report.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------



@ignore
Feature: Quartz - Manual Calibration
	In order to manually calibrate the instrument
	I want to be able to use previously acquired data for calibration of all instrument modes


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given that the Manual Calibration application is open
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: CAL-01 - Manual Calibration - GUI Slot Selection
	When the manual calibration application page is inspected
	Then a single 'Mass Calibration' slot can be selected for each 'X' slot
			| Mass Cal | POS RES | NEG RES | POS SENS | NEG SENS |
			| 1000     | X       | X       | X        | X        |
			| 2000     | X       | X       | X        | X        |
			| 4000     | X       | X       | X        | X        |
			| 8000     | X       | X       | X        | X        |
			| 16000    | X       | X       | X        | X        |
			| 32000    | X       | X       | X        | X        |
			| 64000    | X       | X       | X        | X        |
		And a single 'CCS Calibration' slot can be selected for each 'X' slot
			| CCS Cal | POS RES | NEG RES | POS SENS | NEG SENS |
			| 1000    | X       | X       | X        | X        |
			| 2000    | X       | X       | X        | X        |
			And only a single slot can be selected at any one time


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: CAL-02 - Manual Calibration - GUI Button Status - Uncalibrated Slot
	When the manual calibration application page is viewed
		And an 'uncalibrated' slot is selected for calibration
	Then the 'Create' button is enabled
		And the 'Uncalibrate' button is disabled

Scenario: CAL-03 - Manual Calibration - GUI Button Status - Calibrated Slot
	When the manual calibration application page is viewed
		And a 'calibrated' slot is selected for calibration
	Then the 'Create' button is enabled
		And the 'Uncalibrate' button is enabled


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: CAL-04 - Manual Calibration - Slot Selection - Create Button
	When the manual calibration application page is viewed
		And single slot is selected for calibration
		And the 'Create' button is pressed
	Then the 'Create' dialog is displayed
		And the following elements are available
			| Reference compound dropdown |
			| Raw data file dropdown      |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: CAL-05 - Manual Calibration - Reference Compound Selection
	Given a single slot is selected for calibration
		And the 'Create' button is pressed
	When the 'Create' dialog is displayed
	Then the following reference compounds are available for selection
			| Sodium Iodide  |
			| Sodium Formate |
			| Major Mix      |
			| PolyAlanline   |

Scenario: CAL-06 - Manual Calibration - Data File Selection
	Given data files are present in the data store
		And a single slot is selected for calibration
		And the 'Create' button is pressed
	When the 'Create' dialog is displayed
	Then a list of data files is displayed

Scenario: CAL-07 - Manual Calibration - Data File Selection Updated
	Given data files are present in the data store
		And that new data has been saved during the current typhoon session
	When the 'Create' dialog is displayed
	Then a list of data files is displayed
		And the data files created during the current session are present in the data file list
		# Note: This list is dynamically updated when data is acquired

Scenario: CAL-08 - Manual Calibration - Data File Selection Updated - After Typhoon restart
	Given that data has been initially saved
		And typhoon is restarted
		And new data has been saved
	When the 'Create' dialog is displayed
		And the initial and new data files are present in the data store
	Then a list of initial and new data files are displayed in the data file list
	# Note: This list is dynamically updated when data is acquired and the list is maintained after a typhoon restart

Scenario: CAL-09 - Manual Calibration - Selection Retention
    Given the 'Create' dialog has previously been displayed
    And a non default data file has been selected
    And a non default reference name has been selected
	When the 'Create' dialog is displayed
	Then the previously selected data file name is selected
		And the previously selected reference name is selected


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: CAL-10 - Manual Calibration (Mass only) - Create Calibration - Successful
	Given the 'Create' dialog is displayed
		And the reference file 'Sodium Formate' is selected
		And the data file 'Positive Sodium Formate' is selected
		When the 'Create' button is pressed
	Then the Calibration status is 'Calibration Successful'
	# Note: status is presented on peak picker window

Scenario: CAL-11 - Manual Calibration (Mass only) - Create Calibration - Failed
	Given the 'Create' dialog is displayed
		And the reference file 'sodium Iodide' is selected
		And the data file 'Positive Sodium Formate' is selected
		When the 'Create' button is pressed
	Then the Calibration status is 'Calibration Failed'
	# Note: status is presented on peak picker window

Scenario: CAL-12 - Manual Calibration (Mass only) - Create Calibration - Failed (no ADC Parameters)
	Given that raw data has been acquired with the following ADC Tune page parameters set to zero
		| ADC Parameters               |
		| Average Single Ion Intensity |
		| Measured m/z                 |
		| Measured charge              |
		And the 'Create' dialog is displayed
		And the reference file 'sodium Iodide' is selected
		And the above data file 'Positive Sodium Formate' is selected
		When the 'Create' button is pressed
			And the Calibration status is 'Calibration Failed'
		Then the 'Accept' button should be disabled
		# Note: status is presented on peak picker window


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: CAL-13 - Manual Calibration (Mass only) - Peak Picker - Reject
	Given the selected slot is in a 'Not Run' state
		And the 'Peak Picker Window' is displayed with a successful calibration
	When the 'Reject' button is pressed
	Then the slot remains in a 'Not Run' state
		And the Log window states "data rejected"

Scenario: CAL-14 - Manual Calibration (Mass only) - Peak Picker - Reject on close
	Given the selected slot is in a 'Not Run' state
		And the 'Peak Picker Window' is displayed with a successful calibration
	When the 'Peak Picker Window' is closed
	Then the slot remains in a 'Not Run' state
		And the Log window states "data rejected"

Scenario: CAL-15 - Manual Calibration (Mass only) - Peak Picker - Accept
	Given the selected slot is in a 'Not Run' state
		And the 'Peak Picker Window' is displayed with a successful calibration
	When the 'Accept' button is pressed
	Then the slot status is updated to a 'Success' state
		And the slot report is available
		And the Log window states "data applied"

Scenario: CAL-16 - Manual Calibration (Mass only) - Peak Picker - Reject With Previous Cal
	Given the selected slot is in a 'Success' state
		And the 'Peak Picker Window' is displayed with a successful calibration
	When the 'Reject' button is pressed
	Then the slot status remains in a 'Success' state
		And the slot report is available for the original calibration
		And the Log window states "data rejected"
		
Scenario: CAL-17 - Manual Calibration (Mass only) - Peak Picker - Accept With Previous Cal
	Given the selected slot is in a 'Success' state
		And the 'Peak Picker Window' is displayed with a successful calibration
	When the 'Accept' button is pressed
	Then the slot status remains in a 'Success' state
		And the new calibration is applied to the slot
		And the slot report is available for the new calibration
		And the Log window states "data applied"
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: CAL-18 - Manual Calibration (Mass only) - Peak Picker - Slot Report Confirmation
	Given the 'Peak Picker Window' is displayed with a successful calibration
		And a capture of the 'Peak Picker Window' information is retained
	When the 'Accept' button is pressed
		And the slot status is in a 'Success' state
	Then the slot report can be accessed
		And the slot report information will match the retained 'Peak Picker Window' information

Scenario: CAL-19 - Manual Calibration (Mass only) - Instrument Setup - Slot Report Confirmation
	Given the selected slot is in a 'Success' state
		And the slot report information is retained
	When the 'Instrument Setup' application is accessed
		And the same slot report is accessed
	Then the 'Instrument Setup' slot report will match the retained 'Manual Calibration' report

Scenario: CAL-20 - Manual Calibration (CCS only) - Instrument Setup - Slot Report Confirmation
	Given the selected slot is in a 'Success' or 'Failed' state
		And the 'Manual Calibration' CCS slot report information is viewed
	When the 'Instrument Setup' application is accessed
		And the same CCS slot report is accessed
	Then the 'Instrument Setup' CCS slot report will match the 'Manual Calibration' CCS report


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: CAL-21 - Manual Calibration (Mass only) - Accept Attempt with Given Number of Matched Peaks
	Given the calibration 'Peak Picker Window' is displayed
	When a <Number> of reference peaks are matched
	Then the new calibration will be <Status>
		And the <Accept Button> status will be set
		Examples:
		| Number | Status     | Accept Button |
		| 0      | Failed     | Disabled      |
		| 2      | Failed     | Disabled      |
		| >= 3   | Successful | Enabled       |
		| All    | Successful | Enabled       |

Scenario: CAL-22 - Manual Calibration (Mass only) - Peak Picker Zoom In and Out
	Given the calibration 'Peak Picker Window' is displayed
	When I zoom in and out of the peak picker multiple times
	Then the peak picker is updated correctly
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: CAL-23 - Manual Calibration (Mass only) - Peak Picker Summary Details
	Given the calibration 'Peak Picker Window' is displayed
	When the calibration status is 'Successful'
	Then the <Summary Pane Details> are populated with appropriate <Details>
		Examples:
		| Summary Pane Details     | Details                        |
		| Matched                  | [v] of [w]                     |
		# [v] = the total number of reference peaks
		# [w] = the number of matched data peaks
		| Reference Data           | Name                           |
		# This name should match the reference file selected prior to generating the Calibration
		| Sample Data              | Name                           |
		## This name should match the raw data selected prior to generating the Calibration
		| Mode                     | [Polarity] and [Analyser Mode] |
		# Polarity = "Positive" or "Negative", Analyser Mode = "Sensitivity" or "Resolution"
		| Mean Prediction error    | [x] ppm                        |
		# [x] = Calculated Value
		| Maximum Prediction error | [y] ppm                        |
		# [y] = Calculated Value
		| Flexibility              | [z]                            |
		# [z] = Calculated Value

Scenario Outline: CAL-24 - Manual Calibration (Mass only) - Peak Picker Changing Summary Details
	Given the calibration 'Peak Picker Window' is displayed
		And the calibration status is 'Successful'
	When I change the number of selected peaks
	Then the <Summary Pane Details> will be <Changed>
		Examples:
		| Summary Pane Details | Changed |
		| Matched              | Yes     |
		| Reference data       | No      |
		| Sample data          | No      |
		| Mode                 | No      |
		| Residual 1           | Yes     |
		| Residual 2           | Yes     |
		| Residual 3           | Yes     |

Scenario Outline: CAL-25 - Manual Calibration (Mass only) - Peak Colouring (Matched and Unmatched)
	Given the calibration 'Peak Picker Window' is displayed
		And only some of the peaks are matched
	When a single peak pair is zoomed into (- one reference peak, one data peak)
		And an <Action> is performed
	Then there will be a <Reference Peak Colouring> result
		And there will be <Data Peak Colouring> result
			Examples: Matched
			| Action                             | Reference Peak Colouring  | Data Peak Colouring       |
			| Unmatch a matched peak             | Final Colour = Blue       | Final Colour = Blue       |
			| Deselect a matched peak            | Final Colour = Red        | Final Colour = Red        |
			| Highlight a matched reference peak | Final Colour = Red (Bold) | Final Colour = Red (Bold) |
			
			Examples: Unmatched
			| Action                                | Reference Peak Colouring  | Data Peak Colouring       |
			| Select / Deselect an unmatched peak   | Final Colour = Blue       | Final Colour = Blue       |
			| Highlight an unmatched reference peak | Final Colour = Red (Bold) | Final Colour = Blue       |
			| Match an unmatched peak               | Final Colour = Red (Bold) | Final Colour = Red (Bold) |
			# A Calibration display with only some of the peaks matched can be generated by selecting an incorrect Reference compound
			

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: CAL-26 - Manual Calibration (Mass only) - Peak Picker Changing Calibration Parameters
	Given the calibration 'Peak Picker Window' is displayed
		And the calibration status is 'Successful' with partially matched peaks
		And the 'Calibration Parameters' window is displayed using the 'Tools' button
	When I change the parameter <Parameter> to a setting <Setting>
		And I press OK to accept the change
	Then the number of matched peaks will <Change> accordingly
		Examples: Reduced
		| Parameter           | Setting | Change                            |
		| Peak Window +/-     | 0.001   | Reduced peak matches              |
		| Initial Error       | 0.1     | Reduced peak matches              |
		| Intensity Threshold | 20      | Reduced peak matches              |

		Examples: Increased
		| Parameter           | Setting | Change                            |
		| Peak Window +/-     | 5.000   | Increased or reduced peak matches |
		| Initial Error       | 10.00   | Increased or reduced peak matches |
		| Intensity Threshold | 1       | Increased or reduced peak matches |
		# This can be acheived by using the Positive Sodium Formate data and the MajorMix reference file

Scenario: CAL-27 - Manual Calibration (Mass only) - Peak Picker Restoring Calibration Parameters
	Given the calibration 'Peak Picker Window' is displayed
		And the calibration status is 'Successful' with all matched peaks
	When some peaks have been manually deselected
		And the 'F5' key is pressed
	Then the default peak matches are restored


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: CAL-28 - Manual Calibration - Uncalibrate 'No'
	Given the selected slot is in a 'Success' state
	When the 'Uncalibrate' button is pressed
		And the 'No' option is selected
	Then the current slot remains in a 'Success' state
		And the current slot remains calibrated

Scenario: CAL-29 - Manual Calibration - Uncalibrate 'Yes'
	Given the selected slot is in a 'Success' state
	When the 'Uncalibrate' button is pressed
		And the 'Yes' option is selected
	Then the current slot changes to a 'Not Run' state
		And the same 'Instrument Setup' slot changes to a 'Not Run' state
		And the same slot calibration is removed
		And the same slot report is removed
		And the 'Uncalibrate' button is disabled
		And the Log window states "data removed"
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: CAL-30 - Manual Calibration - Applied Calibration
	Given the selected slot is in a 'Success' state
	When new data is recorded with an end mass equal to the selected slot mass
		And the 'AnalyseData' tool is run during the acquisition
	Then the data output will show the current calibration information
		And the current calibration information will match the selected slot information
		And other remaining slots will remain uncalibrated
		# Only a selection of uncalibrated slots need to be tested

Scenario: CAL-31 - Manual Calibration - Uncalibrated
	Given the following 'Slots' are in a 'Success' state
		| Slot                      |
		| Positive Sensitivity 1000 |
		| Negative Resolution  2000 |
		And the 'Positive Sensitivity 1000' slot is selected
		And the 'Uncalibrate' button is pressed
		And the 'Yes' option is selected
		And the 'Positive Sensitivity 1000' changes to a 'Not Run' state
	# Calibration removed
	When new data is recorded with for 'Positive Sensitivity 1000'
		And the 'AnalyseData' tool is run during the acquisition
	Then the data output will show no calibration information
	# Calibration remains
	When new data is recorded with for 'Negative Resolution 2000'
		And the 'AnalyseData' tool is run during the acquisition
	Then the data output will show a calibration is applied
	
	
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: CAL-32 - Manual Calibration - CCS - Fail (No Mass Cal)
	Given the selected CCS slot is in a 'Not Run' state
	When the 'Create' button is pressed
		And the reference file 'Major Mix' is selected
		And the data file 'Positive Major Mix' is selected which was acquired without a Mass Calibration
		And the 'Create' button is pressed
	Then the slot changes to a 'Failed' state
		And the Log window states "no mass calibration"

Scenario: CAL-33 - Manual Calibration - CCS - Fail (insufficient data)
	Given the selected CCS slot is in a 'Not Run' state
	When the 'Create' button is pressed
		And the reference file 'Polyalanine' is selected
		And the data file 'Positive Major Mix' is selected which was acquired with a Mass Calibration
		And the 'Create' button is pressed
	Then the log window will show progress before showing 'Failed' state
		And the CCS slot status is updated to a 'Failed' state
		And the CCS slot report is available and contains sufficient failure information
		
Scenario: CAL-34 - Manual Calibration - CCS - Success
	Given the selected CCS slot is in a 'Not Run' state
	When the 'Create' button is pressed
		And the reference file 'Major Mix' is selected
		And the data file 'Positive Major Mix' is selected which was acquired with a Mass Calibration
		And the 'Create' button is pressed
	Then the log window will show progress before showing "CCS calibration successful"
		And the CCS slot status is updated to a 'Success' state
		And the CCS slot report is available
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
