
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Instrument Setup - CCS Calibration
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    #          09-JUL-15
#                          # UPDATED: 27-JUN-16
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # As below for 'Manual Test Notes' 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # The instrument has been set up so that...
#                          # - Vial 'B' contains Leucine Enkephalin
#                          # - Vial 'C' contains MajorMix
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Access to 'C:\Waters Corporation\Typhoon\config\scripts\AnalyseData.bat'
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (30-NOV-15) - Christopher D Hughes - Most scenarios re-written to reflect current functionality
#                          # (27-JUN-16) - Christopher D Hughes - Updates after v1.1
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-160)                 # It will be possible to carry out automatic calibration of the drift cell for accurate collisional cross section
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# CR ID: FW#9177           # CCS Calibration multiple slots - Hang if incorrect ref compound in vial (Scenario QRZ-07)
#--------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
Feature: Instrument Setup (CCS Calibration)
	In order to check that the CCS Calibration process works as expected
	I want to be able to run 'Instrument Setup' CCS Calibration with various conditions
	So that the process completes with the expected slot and Calibration status


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-01 - InstrumentSetup - CCS Calibration - Successful Run Messages, Status and Fluidics
	Given the 'Tune page' Fluidics are set as follows
		| Fluidics  | Reservoir | Flow Path | Infusion Flow Rate | Infusion Status |
		| Sample    | Wash      | Waste     | 1.0                | Idle (empty)    |
		| Reference | Wash      | Waste     | 1.00               | Idle (empty)    |
		And the following 'Instrument Setup' process slots are already of status 'Success' for <Polarity> 
			| Process                 |
			| ADC Setup               |
			| Detector Setup          |
		And the following 'Instrument Setup' process slots are already of status 'Success' for <Polarity> <Mode> 
			| Process                 |
			| Resolution Optimisation |
			| Mass Calibration        |		
	When the 'Instrument Setup' CCS Calibration slot is 'Not Run' and is selected for <Polarity> <Mode> 
		And the 'Instrument Setup' process is started
	Then during the process the 'Tune page' Fluidics are automatically set as follows
		| Fluidics  | Reservoir | Flow Path | Infusion Flow Rate | Infusion Status |
		| Sample    | C         | Infusion  | 10.0               | Infusing        |
		| Reference | B         | Infusion  | 10.00              | Infusing        |
		And the following will be presented within the Log Messages window during the CCS Calibration process
			| Message No. | Messages                                                       |
			| 1           | Starting CCS Calibration for <Polarity> <Mode>                 |
			| 2           | Reference Fluidics Setup started                               |
			| 3           | Fluidics setup completed                                       |
			| 4           | Sample Fluidics Setup started                                  |
			| 5           | Fluidics setup completed                                       |
			| 6           | Lock Mass Correction Started                                   |
			| 7-11        | Lock Mass Correction detected masses : <LockMass>, <LockMass>. |
			| 12          | Lock Mass Correction complete.                                 |
			| 13-36       | CCS Calibration - Acquiring data [X]% complete                 |
			| 37          | CCS Calibration successful.                                    |
			# Where [X] increases in steps of 4 or 5 towards 100
			# Where [Y] increases in steps of 16 or 17 towards 100
		And the 'Instrument Setup' CCS Calibration <Polarity> <Mode> slot completes with a status 'Success'
		And when the process has completed the 'Sample' and 'Reference' Tune page Fluidics are automatically set to 'Idle'

			Examples: Required
			| Polarity | Mode             | LockMass |
			| Positive | Sensitivity 1000 | 556.27   |
			| Negative | Resolution  1000 | 554.26   |
			
			Examples: Optional
			| Polarity | Mode             | LockMass |
			| Positive | Resolution  1000 | 556.27   |
			| Negative | Sensitivity 1000 | 554.26   |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-02 - InstrumentSetup - CCS Calibration - AnalyseData.bat Calibration Status
	Given the following 'Instrument Setup' process slots are already of status 'Success' for <Polarity> 
		| Process                 |
		| ADC Setup               |
		| Detector Setup          |
		And the following 'Instrument Setup' process slots are already of status 'Success' for <Polarity> <Mode> 
			| Process                 |
			| Resolution Optimisation |
			| Mass Calibration        |		
		And the 'Instrument Setup' CCS Calibration slot is selected for <Polarity> <Mode> 
	When the 'Instrument Setup' process is run to completion
	Then the <Polarity> <Mode> slot will show a status of 'Success'
		And when Data is acquiring for <Polarity> <Mode> the 'AnalyseData' tool will show that a CCS Calibration is present for this same slot
	
			Examples: 
			| Polarity | Mode             |
			| Positive | Sensitivity 1000 |
			| Positive | Resolution  1000 |
			| Negative | Sensitivity 1000 |
			| Negative | Resolution  1000 | 

			Examples: 
			| Polarity | Mode             |
			| Positive | Sensitivity 2000 |
			| Positive | Resolution  2000 |
			| Negative | Sensitivity 2000 |
			| Negative | Resolution  2000 | 
						
			# Example 'AnalyseData.bat' output for a Calibrated CCS slot (Negative Sensitivity 1000)
			# --------------------------------------------------------------------------------------
			# CCS Calibration Mode :
			# Polarity - Negative
			# OpticMode - Sensitivity
			# FrequencyMode - 1000
			# Start Mz -50
			# End Mz -1000
			# Mz  179.057, 585.300, 656.337, 727.374, 798.411, 869.448, 940.485
			# Reduced CCS 651.639, 1177.318, 1254.879, 1329.068, 1396.815, 1459.704, 1536.533
			# Error bars 0.0172038, 0.0103115, 0.0150909, 0.0138598, 0.0123145, 0.0087324, 0.0083275
			# Creation Type : AUTOMATIC

			# Example 'AnalyseDatabat' output for an Uncalibrated CCS slot
			# ------------------------------------------------------------
			# CCS Calibration Mode :
			# No CCS Calibration
	
				
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-03 - InstrumentSetup - CCS Calibration - AnalyseData Calibration Status - Re-running from 'Failed', 'Aborted', or 'Error'
 	Given the following 'Instrument Setup' process slots are already of status 'Success' for <Polarity> 
		| Process                 |
		| ADC Setup               |
		| Detector Setup          |
		And the following 'Instrument Setup' process slots are already of status 'Success' for <Polarity> <Mode> 
			| Process                 |
			| Resolution Optimisation |
			| Mass Calibration        |	
		And the <Polarity> <Mode> 'Instrument Setup' CCS Calibration slot is already of <Initial Status>
		And when the Tune Page is tuning in <Polarity> <Mode> the 'AnalyseData.bat' tool shows that a CCS Calibration is NOT present for this same slot
		And the 'Instrument Setup' CCS Calibration <Polarity> <Mode> slot is selected
	When the 'Instrument Setup' process is run
    Then the 'Instrument Setup' CCS Calibration <Polarity> <Mode> slot completes with a status 'Success'
		And when the Tune Page is tuning in <Polarity> <Mode> the 'AnalyseData.bat' tool shows that a CCS Calibration is present for this same slot
			
			Examples:  
			| Initial Status | Polarity | Mode        |
			| Failed         | Positive | Sensitivity |
			| Aborted        | Negative | Resolution  |
			| Error          | Negative | Sensitivity |

						
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-04 - InstrumentSetup - CCS Calibration - Calibration Persistence
	Given 'Instrument Setup' CCS Calibration shows the following 'Slots' with 'Status'
		| Slots                     | Status  |
		| Positive Sensitivity 1000 | Success |
		| Positive Resolution  2000 | Failed  |
		| Negative Sensitivity 1000 | Aborted |
		| Negative Resolution  2000 | Error   |
		| Positive Sensitivity 2000 | Not Run |
		And 'AnalyseData' tool shows the following CCS Calibrations are present
			| Slots                     | CCS Calibration |
			| Positive Sensitivity 1000 | Present         |
			| Positive Resolution  2000 | None            |
			| Negative Sensitivity 1000 | None            |
			| Negative Resolution  2000 | None            |
			| Positive Sensitivity 2000 | None            |
	When a <Persistance Test> is performed
	Then 'Instrument Setup' CCS Calibration still shows the following 'Slots' with 'Status'
		| Slots                     | Status  |
		| Positive Sensitivity 1000 | Success |
		| Positive Resolution  2000 | Failed  |
		| Negative Sensitivity 1000 | Aborted |
		| Negative Resolution  2000 | Error   |
		| Positive Sensitivity 2000 | Not Run |
		And 'AnalyseData' tool still shows the following CCS Calibrations are present
			| Slots                     | CCS Calibration |
			| Positive Sensitivity 1000 | Present         |
			| Positive Resolution  2000 | None            |
			| Negative Sensitivity 1000 | None            |
			| Negative Resolution  2000 | None            |
			| Positive Sensitivity 2000 | None            |
	
			Examples:
			| Persistance Test                                       |
			| Browser closed,    Browser Reopened                    |
			| Browser closed,    Typhoon Restarted, Browser Reopened |
			| Typhoon Restarted, Browser Refreshed                   |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-05 - InstrumentSetup - CCS Calibration - Reset
	Given the following 'Instrument Setup' process slots are already of status 'Success' for <Polarity> 
		| Process                 |
		| ADC Setup               |
		| Detector Setup          |
		And the following 'Instrument Setup' process slots are already of status 'Success' for <Polarity> <Mode> 
			| Process                 |
			| Resolution Optimisation |
			| Mass Calibration        |
			| CCS Calibration         |
		And when the Tune Page is tuning in <Polarity> <Mode> the 'AnalyseData.bat' tool shows that a CCS Calibration is present for this same slot
	When the 'Instrument Setup' process is 'Reset'
	Then when the Tune Page is tuning in <Polarity> <Mode> the 'AnalyseData.bat' tool shows that a CCS Calibration is NOT present for this same slot

		Examples:
		| Polarity | Mode             |
		| Positive | Sensitivity 1000 |
		| Positive | Resolution  2000 |
		| Negative | Resolution  2000 |
		| Negative | Sensitivity 1000 |

		
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-06 - InstrumentSetup - CCS Calibration - Failure Conditions (Fluidics and Parameter Related)
	Given there is a <Current Failure Condition> set
		And Typhoon has been restarted
		And the following <Polarity> 'Instrument Setup' slots are already of status 'Success' but are not selected
			| Process                 |
			| ADC Setup               |
			| Detector Setup          |
			| Resolution Optimisation |
		And the 'Instrument Setup' Mass Calibration <Polarity> 'Sensitivity 1000' slot is already of status 'Success'
		And the 'Instrument Setup' CCS Calibration <Polarity> 'Sensitivity 1000' slot is selected
	When the 'Instrument Setup' process is run to completion
	Then the <Polarity> 'Sensitivity 1000' slot will show a <Final Slot Status>
		And appropriate <Current Failure Condition> details will be displayed within the Log Message window
			
			Examples:
			| Polarity | Current Failure Condition                                           | Final Slot Status |
			| Positive | No Sample beam                                                      | Error             |
			| Negative | No Reference beam                                                   | Error             |
			| Positive | Wrong CCS Calibration 'LockMass-Positive' parameter value specified | Error             |
			| Negative | Wrong CCS Calibration 'LockMass-Negative' parameter value specified | Error             |
			| Positive | Wrong Solution (missed peaks)                                       | Failed            |
			# CCS LockMass parameter values are specified in the 'InstrumentSetupConfiguration.xml' file
			# Wrong Solution can be set by specifying an incorrect 'SampleFluidics-Reservoir' value in 'InstrumentSetupConfiguration.xml'
	

# ---------------------------------------------------------------------------------------------------------------------------------------------------
@ignore
@Updated
Scenario: QRZ-07 - InstrumentSetup - CCS Calibration - Failure Conditions (Lock mass setup unsuccessful)
	Given the Instrument Setup Configuration file is modified for 'Parameter Name' with a non-default 'Value' 
		| Parameter Name    | Value  |
		| LockMass-Positive | 400.27 |
		| LockMass-Negative | 400.25 |
		# this simulates the incorrect solution in the Reference vial
		# CCS LockMass parameter values are specified and can be modified in the 'InstrumentSetupConfiguration.xml' file
		And Typhoon has been restarted
		And Instrument Setup page has been accessed
		And the Instrument Setup for the following 'Processes' has been caried out for all polarities and modes having a 'Success' status
		| Processes              |
		| ADC Setup              |
		| Detector Setup         |
		| Resolution Optmisation |
		| Mass Calibration 1000  |
	When the Instrument is set to 'Positive' mode
		And the CCS Calibration 1000 frequency mode slots are enabled
		And the Instrument Setup is run
	Then all 'CCS Calibration 1000 slots' fail in a specific 'Failure Order' having the following 'Status'
		| Failure Order | CCS Calibration 1000 slots | Status |
		| 1             | Positive Sensitivity       | Error  |
		| 2             | Positive Resolution        | Error  |
		| 3             | Negative Sensitivity       | Error  |
		| 4             | Negative Resolution        | Error  |
		And for each slot, the 'Log Messages' section displays the following 'Tasks' being performed
		| Tasks                                                                    |
		| Starting CCS Calibration                                                 |
		| Reference Fluidics Setup started                                         |
		| Fluidics setup completed                                                 |
		| Lock Mass Correction started                                             |
		| Lock mass setup unsuccessful                                             |
		| Error Occurred in CCS Calibration acquisition. Possibly a fluidics error |


#-------------------------------------------------------------------------------------------------------------------------------------------------------
#END