
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # CAL - QRZ - Instrument Setup (Calibration) - Slot GUI and Calibration
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes / Mike Hodgkinson
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 09-FEB-15 (updated by Christopher D Hughes 22-JUN-16)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Sample vial set to 'C' (MajorMix) and Baffle set to Sample position
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Calibration solution be available for Sample fluidics and Baffle set to Sample position
#                          # There should be a good Sample beam available with peaks consistent with the expected Calibration solution (MajorMix)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (10-OCT-15) - Christopher D Hughes - Updates to reflect changes in functionality due to FW#7327 and FW#7325
#                          # (22-JUN-16) - Christopher D Hughes - Updates after Vion v1.1
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-132)                 #	The user will be able to automatically calibrate and setup the MS in all the supported modes of the instrument over different mass ranges using the Dev Console.  
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
# (SS-473)                 #	The software will allow the user to select what polarity is enable or disable prior to running the setup process
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-475)                 #	The software will allow the user to activate or deactivate the polarity for the entire column via the top toggle button control
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-536)                 #	The software will display an appropriate warning for any failure of setup items.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
Feature: Instrument Setup (Calibration)
	In order to successfully run Instrument Setup (Calibration)
	I want to be able to run Instrument Setup with various instrument settings and Instrument Setup GUI Settings
	So that I can automatically apply a calibration to all selected / expected slots.
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the instrument Setup slots have been 'Reset'
		And the following Instrument Setup 'Processes' have been successfully run for all available slots 
			| Processes               |
			| ADC Setup               |
			| Detector Setup          |
			| Resolution Optimisation |	
		And the 'Instrument Setup' page has been accessed	

	
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario Outline: CAL-01a - InstrumentSetupGUIandCalibration - Basic State Transitions - Slot and Calibration Status
		Given the instrument is set to <Instrument Mode>
			And instrument <Tune Settings> are applied
			And the <Initial Slot State> is present
			And the <Instrument Mode> slot is enabled
			And all other Mass Calibration slots are 'Not Run' and not enabled
		When Instrument Setup Calibration is started and a 'Running' status is shown for the <Instrument Mode> slot
			And an <Action> is performed
		Then the slot status will finally go to the <Final Slot State> for the <Instrument Mode> slot
		
		When Tuning is aborted and restarted in <Instrument Mode>
			And 'AnalyseData.bat' is run
		Then 'AnalyseData.bat' results will show the slot as <Instrument Mode> 
			And 'AnalyseData.bat' results will show the Calibration used as <Current Mass Calibration> 
		
			Examples: Slots Transitions and Calibration Status
			| Instrument Mode | Tune Settings | Initial Slot State | Action                                   | Final Slot State | Current Mass Calibration  |
			# ------------------------------------------------------------------------------------------------------------------------------
			| POS SENS 1000   | Default       | 'Not Run'          | N/A                                      | 'Success'        | POS SENS 1000             |
			# ------------------------------------------------------------------------------------------------------------------------------
			| POS RES 2000    | Default       | 'Not Run'          | Abort Slot                               | 'Aborted'        | N/A (No Mass Calibration) |
			| POS RES 2000    | Default       | 'Aborted'          | Abort Slot                               | 'Aborted'        | N/A (No Mass Calibration) |
			| POS RES 2000    | Default       | 'Aborted'          | Set Det Voltage 0 after Fluidics success | 'Failed'         | N/A (No Mass Calibration) |
			| POS RES 2000    | Default       | 'Failed'           | Abort Slot                               | 'Aborted'        | N/A (No Mass Calibration) |
			| POS RES 2000    | Det Voltage 0 | 'Aborted'          | N/A                                      | 'Error'          | N/A (No Mass Calibration) |
			| POS RES 2000    | Default       | 'Error'            | N/A                                      | 'Success'        | POS RES 2000              |
			# ------------------------------------------------------------------------------------------------------------------------------
			| NEG SENS 1000   | Det Voltage 0 | 'Not Run'          | N/A                                      | 'Error'          | N/A (No Mass Calibration) |
			| NEG SENS 1000   | Default       | 'Error'            | Set Det Voltage 0 after Fluidics success | 'Failed'         | N/A (No Mass Calibration) |
			| NEG SENS 1000   | Default       | 'Failed'           | Set Det Voltage 0 after Fluidics success | 'Failed'         | N/A (No Mass Calibration) |
			| NEG SENS 1000   | Default       | 'Failed'           | N/A                                      | 'Success'        | NEG SENS 1000             |
			# ------------------------------------------------------------------------------------------------------------------------------
			| NEG RES 2000    | Default       | 'Not Run'          | Set Det Voltage 0 after Fluidics success | 'Failed'         | N/A (No Mass Calibration) |
			| NEG RES 2000    | Det Voltage 0 | 'Failed'           | N/A                                      | 'Error'          | N/A (No Mass Calibration) |
			| NEG RES 2000    | Det Voltage 0 | 'Error'            | N/A                                      | 'Error'          | N/A (No Mass Calibration) |
			| NEG RES 2000    | Default       | 'Error'            | Abort Slot                               | 'Aborted'        | N/A (No Mass Calibration) |
			| NEG RES 2000    | Default       | 'Aborted'          | N/A                                      | 'Success'        | NEG RES 2000              |
			# -----------------------------------------------------------------------------------------------------------------------------------------------------
			# Default 'Settings' assumes that Detector Voltage is sufficient to give a good beam.
			# When requested to set the detector voltage to zero, this can be done in the Tune page.
			
			# 'AnalyseData.bat' (located in 'C:\Waters Corporation\Typhoon\config\scripts\')
			# - 'Not Run' slots - AnlayseData.bat should show as Uncalibrated
			# - 'Success' slots - AnlayseData.bat should show as Calibrated (and calibration information should match the current slot Polarity, Analyser Mode and Mass Range).
			
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario Outline: CAL-01b - InstrumentSetupGUIandCalibration - State Transition - Already Success
		Given 'Default' instrument settings are applied
			And the initial slot state is already 'Success'
			And the slot is enabled
		When an attempt is made to start Instrument Setup Calibration 
		Then the process will NOT run
			And the slot status remains at 'Success'
			And the following 'Log Message' is shown
				| Log Message                                                                                        |
				| Nothing to run. Instrument Setup has detected that it does not need to run any tasks at this time. |
				# Default 'Settings' assumes that Detector Voltage is sufficient to give a good beam
				# This can be run on any calibration slot
				

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario Outline: CAL-02a - InstrumentSetupGUIandCalibration - All Slots 'Not Run' - Uncalibrated
		Given the Mass Calibration status is 'Not Run' for all slots
		When the Instrument <Instrument Mode> is set 
			And Tuning is aborted and restarted
			And 'AnalyseData.bat' is run
		Then 'AnalyseData.bat' results will show the Current Tuning mode as <Instrument Mode> 
			And 'AnalyseData.bat' results will show the Current Mass Calibration as having 'No Mass Calibration'
			
			Examples: 
			| Instrument Mode |
			| POS SENS 1000   |
			| POS SENS 2000   |
			| NEG SENS 1000   |
			| NEG SENS 2000   |
			| POS RES  1000   |
			| POS RES  2000   |
			| NEG RES  1000   |
			| NEG RES  2000   |
			| POS SENS 4000   |
			| POS SENS 8000   |
			# 'AnalyseData.bat' is located in 'C:\Waters Corporation\Typhoon\config\scripts\'	
 

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario Outline: CAL-02b - InstrumentSetupGUIandCalibration - Calibration Status (All Default Slots Success)
		Given the Mass Calibration status is Success for the following 'Slots'
			| Slots         |
			| POS SENS 1000 |
			| POS SENS 2000 |
			| NEG SENS 1000 |
			| NEG SENS 2000 |
			| POS RES  1000 |
			| POS RES  2000 |
			| NEG RES  1000 |
			| NEG RES  2000 |
			And the Mass Calibration slot Status is 'Not Run' for all other slots
		When the Instrument <Instrument Mode> is set 
			And Tuning is aborted and restarted
			And 'AnalyseData.bat' is run
		Then 'AnalyseData.bat' results will show the 'Current Tuning mode' as <Instrument Mode>
			And 'AnalyseData.bat' results will show the 'Current Mass Calibration used' as <Instrument Mode>
			
			Examples: 
			| Instrument Mode |
			| POS SENS 1000   |
			| POS SENS 2000   |
			| NEG SENS 1000   |
			| NEG SENS 2000   |
			| POS RES  1000   |
			| POS RES  2000   |
			| NEG RES  1000   |
			| NEG RES  2000   |
			# 'AnalyseData.bat' is located in 'C:\Waters Corporation\Typhoon\config\scripts\'	
 
 
 Scenario Outline: CAL-02c - InstrumentSetupGUIandCalibration - Calibration Status (High Mass Mode Slots Success)
		Given the Mass Calibration status is Success for the following 'Slots'
			| Slots         |
			| POS SENS 4000 |
			| POS SENS 8000 |
			And the Mass Calibration slot Status is 'Not Run' for all other slots
		When the Instrument <Instrument Mode> is set 
			And Tuning is aborted and restarted
			And 'AnalyseData.bat' is run
		Then 'AnalyseData.bat' results will show the 'Current Tuning mode' as <Instrument Mode>
			And 'AnalyseData.bat' results will show the 'Current Mass Calibration used' as <Instrument Mode>
			
			Examples: 
			| Instrument Mode |
			| POS SENS 4000   |
			| POS SENS 8000   |
			# 'AnalyseData.bat' is located in 'C:\Waters Corporation\Typhoon\config\scripts\'	


 #----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario Outline: CAL-02d - InstrumentSetupGUIandCalibration - Calibration Status (Some 'Success', Some 'Not Run')
		Given the Mass Calibration status is Success for the following 'Slots'
			| Slots         |
			| POS SENS 1000 |
			| NEG SENS 2000 |
			| POS RES 1000  |
			| NEG RES 2000  |
			| POS SENS 4000 |
			And the Mass Calibration slot Status is 'Not Run' for all other slots
		When the <Instrument Mode> is set 
			And Tuning is aborted and restarted
			And 'AnalyseData.bat' is run
		Then 'AnalyseData.bat' results will show the Current Tuning Mode as <Instrument Mode> 
			And 'AnalyseData.bat' results will show the the Current Mass Calibration used as <Current Mass Calibration>
					
			Examples: 
			| Instrument Mode | Current Mass Calibration  |
			| POS SENS 1000   | POS SENS 1000             |
			| POS SENS 2000   | N/A (No Mass Calibration) |
			| NEG SENS 1000   | N/A (No Mass Calibration) |
			| NEG SENS 2000   | NEG SENS 2000             |
			| POS RES  1000   | POS RES  1000             |
			| POS RES  2000   | N/A (No Mass Calibration) |
			| NEG RES  1000   | N/A (No Mass Calibration) |
			| NEG RES  2000   | NEG RES  2000             |
			| POS SENS 4000   | POS SENS 4000             | 
			| POS SENS 8000   | N/A (No Mass Calibration) | 			                   
			# 'AnalyseData.bat' is located in 'C:\Waters Corporation\Typhoon\config\scripts\'	

		
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END