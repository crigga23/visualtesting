
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Instrument Setup - (Detector Setup)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Mike Hodgkinson 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 27-JUN-16
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (06-OCT-15) - Christopher D Hughes - Updates to Background to reflect changes in functionality due to FW#7327 and FW#7325
#                          #                                    - Other updates to correct de-selected slot types
#                          # (26-NOV-15) - Mike Hodgkinson      - Minor updates
#                          # (27-JUN-16) - Christopher D Hughes - Updates after Vion v1.1 testcase execution including changes for CR ID: FW#9154
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-156)                 # The system will automatically manage running all required instrument setup operations in order to get the system ready for all required types of acquisition (all required mass ranges,  polarities, resolution modes etc.).
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-482)                 # It shall be possible to determine the optimum detector voltage
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-477)                 # It shall be possible to determine the average ion area.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # IBM Rational Change (see below)...
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# CR ID: FW#9154           # Detector Setup can fail Ion Area Measure if nominal mass not set
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@Ignore
Feature: Instrument Setup - (Detector Setup)
	In order to run Detector Setup within Instrument Setup successfully
	I want to be able to click Instrument Setup 'Run'
	So that the Instrument Setup process completes successfully for Detector Setup

Background:
	Given the tune page is inspected
		And the 'ADC' Average Single Ion Intensity is set to '1.0' for both polarities
		And the 'ADC' Measured m/z is set to '0.0000' for both polarities
		And the 'ADC' Measured charge is set to '0' for both polarities
		And the 'Instrument' Detector Voltage is set to '2000' for both polarities
		And the Instrument Setup slots have been 'Reset'
		And the Instrument Setup 'ADC Setup' process has been run successfully for both polarities

# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: DSU-01 - Detector Setup - Both Polarities
		Given the expected reference solution is present in 'vial B'
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       | X        | X        |
			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the 'Follow Tail' Progress Log option has been 'enabled'
		    And the Instrument Setup process is 'Run'
		# Progress Log - Positive
		Then it can be determined from the Instrument Setup 'Detector Setup Positive Results' that the status is 'Running'
			And the Process Log shows the following
				| Setting up fluidics                     |
				| IPP check beam too weak                 |
				| Detector level beam too weak            |
				| Detector Level Ramping up to            |
				| IPP check at voltage                    |
				| Detector Level Ramping voltage down to  |
				| Detector Level Complete: Final voltage: |
				| Measured Ion Area:                      |
			And then it can be determined from the Instrument Setup 'Detector Setup Positive Results' that the Status is 'Success'
			And the 'Progress Log' contains the final 'Detector Voltage' for positive polarity
			And the 'Progress Log' contains the 'Average Ion Area' for positive polarity
		# Progress Log - Negative
		Then it can be determined from the 'Detector Setup Negative Results' that the status is 'Running'
			And the Progress Log shows the following
				| Setting up fluidics                     |
				| IPP check beam too weak                 |
				| Detector level beam too weak            |
				| Detector Level Ramping up to            |
				| IPP check at voltage                    |
				| Detector Level Ramping voltage down to  |
				| Detector Level Complete: Final voltage: |
				| Measured Ion Area:                      |
				| Time taken:                             |
			And then it can be determined from the Instrument Setup 'Detector Setup Negative Results' that the Status is 'Success'
			And the 'Progress Log' contains the final 'Detector Voltage' for negative polarity
			And the 'Progress Log' contains the 'Average Ion Area' for negative polarity
		When the 'Tune Page' is inspected
		    # Positive
		Then the positive 'Instrument' Detector Voltage value matches the 'Progress Log' for positive polarity
			And the positive 'ADC' Average Single Ion Intensity value matches the 'Progress Log' for positive polarity
			And the positive 'ADC' Measured m/z is 556.2700
			And the positive 'ADC' Measured charge value is 1
			# Negative
			And the negative 'Instrument' Detector Voltage value matches the 'Progress Log' for negative polarity
			And the negative 'ADC' Average Single Ion Intensity value matches the 'Progress Log' for negative polarity
			And the negative 'ADC' Measured m/z is 554.2600
			And the negative 'ADC' Measured charge value is -1

				
# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: DSU-02 - Detector Setup - Positive Polarity only
		Given the expected reference solution is present in 'vial B'
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       | X        |          |
			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the 'Follow Tail' Progress Log option has been 'enabled'
			And the Instrument Setup process is 'Run'
		# Progress Log - Positive
		Then it can be determined from the 'Detector Setup Positive Results' that the status is 'Running'
			And the Process Log shows the following
				| Setting up fluidics                     |
				| IPP check beam too weak                 |
				| Detector level beam too weak            |
				| Detector Level Ramping up to            |
				| IPP check at voltage                    |
				| Detector Level Ramping voltage down to  |
				| Detector Level Complete: Final voltage: |
				| Measured Ion Area:                      |
				| Time Taken                              |
			And then it can be determined from the Instrument Setup 'Detector Setup Positive Results' that the Status is 'Success'
			And the 'Progress Log' contains the final 'Detector Voltage' for positive polarity
			And the 'Progress Log' contains the 'Average Ion Area' for positive polarity
		When the 'Tune Page' is inspected
		    # Positive
		Then the positive 'Instrument' Detector Voltage value matches the 'Progress Log' for positive polarity
			And the positive 'ADC' Average Single Ion Intensity value matches the 'Progress Log' for positive polarity
			And the positive 'ADC' Measured m/z is 556.2700
			And the positive 'ADC' Measured charge value is 1
			# Negative
			And the negative 'Instrument' Detector Voltage value will be 2000 for negative polarity
			And the negative 'ADC' Average Single Ion Intensity value will be 0 for negative polarity
			And the negative 'ADC' Measured m/z is 0.0000
			And the negative 'ADC' Measured charge value is 0


# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: DSU-03 - Detector Setup - Negative Polarity only
		Given the expected reference solution is present in 'vial B'
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       |          | X        |
			And the Instrument Setup progress has all the Mass Calibration slots set to 'OFF'
			And the 'Follow Tail' Process Log option has been 'enabled'
			And the Instrument Setup process is 'Run'
		# Progress Log - Negative
		Then it can be determined from the 'Detector Setup Negative Results' that the status is 'Running'
			And the Process Log shows the following
				| Setting up fluidics                     |
				| IPP check beam too weak                 |
				| Detector level beam too weak            |
				| Detector Level Ramping up to            |
				| IPP check at voltage                    |
				| Detector Level Ramping voltage down to  |
				| Detector Level Complete: Final voltage: |
				| Measured Ion Area:                      |
				| Time taken:                             |
			And then it can be determined from the Instrument Setup 'Detector Setup Negative Results' that the Status is 'Success'
			And the 'Progress Log' contains the final 'Detector Voltage' for negative polarity
			And the 'Progress Log' contains the 'Average Ion Area' for negative polarity
		When the 'Tune Page' is inspected
		    # Positive
		Then the positive 'Instrument' Detector Voltage value will be 2000 for positive polarity
			And the positive 'ADC' Average Single Ion Intensity value will be 0 for positive polarity
			And the positive 'ADC' Measured m/z is 0.0000
			And the positive 'ADC' Measured charge value is 0
			# Negative
			And the negative 'Instrument' Detector Voltage value matches the 'Progress Log' for negative polarity
			And the negative 'ADC' Average Single Ion Intensity value matches the 'Progress Log' for negative polarity
			And the negative 'ADC' Measured m/z is 554.2600
			And the negative 'ADC' Measured charge value is -1
				

# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: DSU-04 - Detector Setup - Both Polarities - Aborted (missing solution)
		Given the expected reference solution is 'NOT' present in 'vial B'
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       | X        | X        |
			And the Instrument Setup progress has all the Mass Calibration slots set to 'OFF'
			And the 'Follow Tail' Process Log option has been 'enabled'
			And the Instrument Setup process is 'Run'
		# Progress Log - Positive
		Then it can be determined from the 'Positive Results' that the status is 'Running'
			And then during the 'positive' polarity process, it can be determined from the 'Process Log' that the 'Detector Level' ramped up too far 
			And then it can be determined from the Instrument Setup 'Detector Setup Positive Results' that the Status is 'Error'
			# Progress Log - Negative
			And then it can be determined from the 'Negative Results' that the status is 'Running'
			And then during the 'negative' polarity process, it can be determined from the 'Process Log' that the 'Detector Level' ramped up too far 
			And then it can be determined from the Instrument Setup 'Detector Setup Negative Results' that the Status is 'Error'
		When the 'Tune Page' is inspected
		    # Positive
		Then the positive 'Instrument' Detector Voltage value will be 2000 for positive polarity
			And the positive 'ADC' Average Single Ion Intensity value will be 0 for positive polarity
			And the positive 'ADC' Measured m/z is 0.0000
			And the positive 'ADC' Measured charge value is 0
			# Negative
			And the negative 'Instrument' Detector Voltage value will be 2000 for negative polarity
			And the negative 'ADC' Average Single Ion Intensity value will be 0 for negative polarity
			And the negative 'ADC' Measured m/z is 0.0000
			And the negative 'ADC' Measured charge value is 0


# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario Outline: DSU-05 - Detector Setup - Manually Abort
		Given the expected reference solution is present in 'vial B'
			And the <Initial Mode> is set on the tune page
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       | X        | X        |
			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the 'Follow Tail' Progress Log option has been 'enabled'
			And the Instrument Setup process is 'Run'
			But the Instrument Setup Detector Setup process is manually cancelled during <Slot> and <Progress Log>
		Then there will be a <Slot Result> and <Tune Page Status>
			
			Examples:
			# Aborted during Detector Level Ramping up to
			| Initial Mode | Slot            | Progress Log                            | Slot Result                                           | Tune Page Status          |
			| Positive     | Both polarities | Detector Level Ramping up to            | Positive 'Aborted' - Negative previous state retained | Both polarities unchanged |
			| Positive     | Both polarities | Detector Level Ramping up to            | Positive 'Success' - Negative 'Aborted'               | Positive only changed     |
			| Negative     | Both polarities | Detector Level Ramping up to            | Positive 'Aborted' - Negative 'Success'               | Negative only changed     |
			| Negative     | Both polarities | Detector Level Ramping up to            | Positive previous state retained - Negative 'Aborted' | Both polarities unchanged |
			# Aborted during Detector Level Complete: Final voltage:
			| Positive     | Both polarities | Detector Level Complete: Final voltage: | Positive 'Aborted' - Negative previous state retained | Both polarities unchanged |
			| Positive     | Both polarities | Detector Level Complete: Final voltage: | Positive 'Success' - Negative 'Aborted'               | Positive only changed     |
			| Negative     | Both polarities | Detector Level Complete: Final voltage: | Positive 'Aborted' - Negative 'Success'               | Negative only changed     |
			| Negative     | Both polarities | Detector Level Complete: Final voltage: | Positive previous state retained - Negative 'Aborted' | Both polarities unchanged |
			# Aborted during Setting up fluidics
			| Positive     | Both polarities | Setting up fluidics                     | Positive 'Aborted' - Negative previous state retained | Both polarities unchanged |
			| Positive     | Both polarities | Setting up fluidics                     | Positive 'Success' - Negative 'Aborted'               | Positive only changed     |
			| Negative     | Both polarities | Setting up fluidics                     | Positive 'Aborted' - Negative 'Success'               | Negative only changed     |
			| Negative     | Both polarities | Setting up fluidics                     | Positive previous state retained - Negative 'Aborted' | Both polarities unchanged |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: DSU-06 - Detector Setup - Both Polarities - Aborted Re-run
		Given the detector setup status for both polarities is 'Aborted'
			And the expected reference solution is present in 'vial B'
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       | X        | X        |
			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the 'Follow Tail' Progress Log option has been 'enabled'
			And the Instrument Setup process is 'Run'
			And the process completes succesfully for both polarities
		When the 'Tune Page' is inspected
		    # Positive
		Then the positive 'Instrument' Detector Voltage value matches the 'Process Log' for positive polarity
			And the positive 'ADC' Average Single Ion Intensity value matches the 'Process Log' for positive polarity
			And the positive 'ADC' Measured m/z is 556.2700
			And the positive 'ADC' Measured charge value is 1
			# Negative
			And the negative 'Instrument' Detector Voltage value matches the 'Process Log' for negative polarity
			And the negative 'ADC' Average Single Ion Intensity value matches the 'Process Log' for negative polarity
			And the negative 'ADC' Measured m/z is 554.2600
			And the negative 'ADC' Measured charge value is -1


# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario Outline: DSU-07 - Detector Setup - Both Polarities - Modified Mass Parameters
		Given the 'InstrumentSetupConfiguration.xml' has Instrument Setup 'Detector Setup' <Positive Mass> and <Negative Mass> parameter values set
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process               | Positive | Negative |
			| Detector Setup        | X        | X        |
			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the Instrument Setup process is 'Run' 
		Then the <Positive Results> and <Negative Results> for 'Detector Setup' will be shown
			
			Examples:
			| Positive Mass | Negative Mass | Positive Results | Negative Results |
			| 400.00        | 554.26        | 'Error'          | 'Success'        |
			| 556.27        | 600.00        | 'Success'        | 'Error'          |
			
			
# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: DSU-08 - Detector Setup - Factory Defaults Saved after Successful Run
		Given the 'Tune Page' is inspected
			And the 'Instrument' Detector Voltage is manually set to 2345 for both polarities
			And the 'ADC' Average Single Ion Intensity value is set to 34 for both polarities
			And the 'ADC' Measured m/z is set to 789.1234 for both polarities
			And the 'ADC' Measured charge value is set to 2 for both polarities
			And the Tune Page 'Parameter' settings are then saved as 'Factory Defaults'
		When the expected reference solution is present in 'vial B'
			And the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       | X        | X        |
			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the Instrument Setup process is 'Run'
			And it can be determined from the Instrument Setup 'Detector Setup Positive Results' that the Status is 'Success'
			And it can be determined from the Instrument Setup 'Detector Setup Negative Results' that the Status is 'Success'
		When the 'Instrument' Detector Voltage is manually set to 2000 for both polarities
			And the positive 'ADC' Average Single Ion Intensity value is set to 0 for both polarities
			And the positive 'ADC' Measured m/z is set to 0.0000 for both polarities
			And the positive 'ADC' Measured charge is set to 0 for both polarities
			And the 'Factory Defaults' are Loaded
		Then the zero value 'Parameters' are overwritten with the automatically saved 'Factory Defaults' values from the successful 'Detector Setup' that was previously run.
		# Rather than the initial 'Factory Defaults' settings that were Saved before the process was run



# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# CR ID: FW#9154           # Detector Setup can fail Ion Area Measure if nominal mass not set
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
	Scenario Outline: DSU-09 - Detector Setup - Veff Settings Tolerance
		Given Leucine Enkephalin is present in 'vial B'
			And the Instrument <Polarity> has been set
			And the Detector Voltage has been manually set to '2500' so Leucine Enkephalin peaks are present
			# if 2500 is not enough then increase the Detector voltage until a good beam is present
			And the Veff Value has been set so that the main Leucine Enkephalin peak is at <m/z Position>
		When the Instrument Setup Detector Setup is selected and run to completion for <Polarity> only
		Then the Instrument Setup Detector Setup <Polarity> slot will show the <Expected Result>

			Examples: Positive
			| Polarity | m/z Position | Expected Result | Comment                         |
			| Positive | 558.27       | Success         | 2 Da from expected m/z (556.27) |
			| Positive | 559.27       | Error           | 3 Da from expected m/z (556.27) |

			Examples: Negative
			| Polarity | m/z Position | Expected Result | Comment                         |
			| Negative | 556.26       | Success         | 2 Da from expected m/z (554.26) |
			| Negative | 557.26       | Error           | 3 Da from expected m/z (554.26) |

		
#END