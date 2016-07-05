# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # CAL - QRZ - Instrument Setup (Resolution Optimisation)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher David Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    #          27-MAR-15
#                          # UPDATED: 18-MAY-16 (http://devtools/jira/browse/VION-254)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # a). Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference
#                          #
#                          # b). 'minResolution', 'sensitivityModeResolution' and 'resolutionModeResolution' values used throughout this feature file
#                          #     need to be substituted for the current values found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # a). Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference
#                          # 
#                          # b). 'minResolution', 'sensitivityModeResolution' and 'resolutionModeResolution' values used throughout the feature file
#                          #     need to be substituted for the current values found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
#                          #
#                          # c). Manually Setting Resolution:
#                          #     When manually determining a peak's resolution, the tune page 'Ions Per Push' should be approximately '2.0'
#                          #     otherwise an inaccurate value may be set. This can be done by changing the 'System 2' tab 'pDRE Attenuate' percentage
#                          #     value until the desired 'Ions Per Push' is observed (MZ Plot Data: top left blue value).
#                          #     Once the 'Ions Per Push' value is set to approximately 2.0 the peak's resolution can be changed by adjusting the 
#                          #     'Pusher Offset' or 'Reflectron Grid' value for that mode.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (30-NOV-15) Major updates to most scenarios to reflect the correct functionality post release
#                          # (18-MAY-16) Updated to include initial Resolution Check
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-159                  # The system will be able to automatically optimise conditions for a given resolution
#                          # using parameters and algorithm defined in doc 721005052
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-492                  # A service user shall be able to change adjustment ranges and step sizes.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@Ignore
Feature: Instrument Setup - (Resolution Optimisation)
	In order to automaticall​y optimise the instrument resolution
	I want to be able to click Instrument Setup 'Run'
	So that the Instrument Setup 'Resolution Optimisation' process completes as expected for all selected modes


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Updated
Scenario Outline: RES-01 - Basic Progress Log Elements - Pre-check Outside Range - Optimisation Expected
	Given the Instrument Setup slots are 'Reset'
		And the following Instrument Setup 'Processes' are run successfully for <Polarity>
			| Processes      |
			| ADC Setup      |
			| Detector Setup |
		And the instrument is de-tuned for <Polarity> <Mode> so the <Initial Resolution> value is set
	# This will ensure that the optimisation process actually starts, rather than stopping because the resolution is already good enough
		And the following 'Initial System 1 Tune page Values' are recorded for all modes
			| Initial System 1 Tune page Values |
			| Tube                              |
			| Reflectron Grid                   |
			| Pusher Offset                     |
	When the Instrument Setup 'Resolution Optimisation' <Polarity> <Mode> slot is enabled
		And the Instrument Setup process is 'Run'
	Then the following will be presented within the 'Progress Log' for <Polarity> <Mode>
		| Process Elements                                                                         |
		| Setting up fluidics                                                                      |
		| DRE set to [a], ions per push = [b]                                                      |
		| Resolution = [c]                                                                         |
		| The resolution is below [d]. The resolution will now be optimised                        |
		| Tube = [e], Reflectron Grid = [f], Resolution = [g] (x 40)                               |
		| Optimum Tube = [h], Optimum Reflectron Grid = [i], Resolution = [j]                      |
		| Pusher offset = [k], Resolution = [l]  (x 21)                                            |
		| Optimum Pusher offset = [m], Resolution = [n]                                            |
		| Resolution = [o]                                                                         |
		| Resolution Optimisation parameters updated.                                              |
		| Initial resolution = [c], Optimised resolution = [o], standard deviation tolerance = [p] |
		# where [a] = DRE value from 99.80 to 5.00
		# where [b] = measured 'ions per push' NOTE: the final 'ions per push' value should be less than or equal to 2.0
		# where [c] = Initial Resolution (measured) - should be between 'minResolution' and 'maxResolution' (\Typhoon\config\TofResolutionOptimisationConfiguration.xml)
		# where [d] = Resolution PreCheck Value (see the 'sensitivityModeResolution' and 'resolutionModeResolution' values in \Typhoon\config\TofResolutionOptimisationConfiguration.xml)
		# where [e] = Stepped value from (Initial 'Tube Lens' value - 'tubeLowRange') to (Initial 'Tube Lens' value + 'tubeHighRange') in steps of 'tubeStep'
		# where [f] = Repeated stepped value from (Initial 'Reflectron Grid' value - 'reflectronGridLowRange') to (Initial 'Reflectron Grid' value + 'reflectronGridHighRange') in steps of 'reflectronGridStep'
		# where [g] = In-process Resolution measurement
		# where [h] = Optimum Tube value (where In-process Resolution measurement [f] was the greatest)
		# where [i] = Optimum Reflectron Grid value (where In-process Resolution measurement [f] was the greatest)
		# where [j] = Resolution measured for Optimum Tube [g] and Reflectron Grid [h] values
		# where [k] = Stepped value from (Initial 'Pusher Offset' value - 'pusherOffsetLowRange') to (Initial 'Pusher Offset' value + 'pusherOffsetHighRange') in steps of 'pusherOffsetStep'
		# where [l] = In-process Resolution measurement
		# where [m] = Optimum Pusher Offset value (where In-process Resolution measurement [k] was the greatest) 
		# where [n] = Resolution measured for Optimum Pusher Offset [l]
		# where [o] = Optimised Resolution (measured with Optimum Tube [g], Optimum Reflectron Grid [h] and Optimum Pusher Offset [l] values) - should be between 'minResolution' and 'maxResolution' (\Typhoon\config\TofResolutionOptimisationConfiguration.xml)
		# where [p] = Calculated standard error (found during Optimised Resolution measurement) - should be less than maxRSD (10)
		And the Instrument Setup 'Resolution Optimisation' <Polarity> <Mode> slot will show a status of 'Passed'
		And the 'Log Messages' Summary details will reflect the <Polarity> <Mode> slot status
		And the final 'System 1 Tune page Values' have been 'Updated' from their original values for <Polarity> <Mode> 
			| Updated               |
			| Tube = [h]            |
			| Reflectron Grid = [i] |
			| Pusher Offset = [m]   |
		And the Tune Page 'Parameters' for any modes not run remain unchanged	
			
			Examples:
			| Polarity | Mode        | Initial Resolution                                      |
			| Positive | Sensitivity | between 'minResolution' and 'sensitivityModeResolution' |
			| Positive | Resolution  | between 'minResolution' and 'resolutionModeResolution'  |
			| Negative | Sensitivity | between 'minResolution' and 'sensitivityModeResolution' |
			| Negative | Resolution  | between 'minResolution' and 'resolutionModeResolution'  |
			# 'minResolution', 'sensitivityModeResolution' and 'resolutionModeResolution' values can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Updated
Scenario Outline: RES-02 - Basic Progress Log Elements - Pre-check within Range - No Optimisation Expected
	Given the Instrument Setup slots are 'Reset'
		And the following Instrument Setup 'Processes' are run successfully for <Polarity>
			| Processes      |
			| ADC Setup      |
			| Detector Setup |
		And the instrument is tuned for <Polarity> <Mode> so the <Initial Resolution> value is set
	# This will ensure that the optimisation process will not run, because the resolution is already good enough
		And the following 'Initial System 1 Tune page Values' are recorded for all modes
			| Initial System 1 Tune page Values |
			| Tube                              |
			| Reflectron Grid                   |
			| Pusher Offset                     |
	When the Instrument Setup 'Resolution Optimisation' <Polarity> <Mode> are enabled
		And the Instrument Setup process is 'Run'
		And the Instrument Setup 'Resolution Optimisation' process runs successfully for <Polarity> <Mode>
	Then the following will be presented within the 'Progress Log' for <Polarity> <Mode>
		| Process Elements                                                                           |
		| Setting up fluidics                                                                        |
		| DRE set to [a], ions per push = [b]                                                        |
		| Resolution = [c]                                                                           |
		| The resolution is already equal to or greater than [d]. No need to optimize the resolution |
		# where [a] = DRE value from 99.80 to 5.00
		# where [b] = measured 'ions per push' NOTE: the final 'ions per push' value should be less than or equal to 2.0
		# where [c] = Initial Resolution (measured) - should be between 'minResolution' and 'maxResolution' (\Typhoon\config\TofResolutionOptimisationConfiguration.xml)
		# where [d] = Resolution PreCheck Value (see the 'sensitivityModeResolution' and 'resolutionModeResolution' values in \Typhoon\config\TofResolutionOptimisationConfiguration.xml)
		And the Instrument Setup 'Resolution Optimisation' <Polarity> <Mode> slot will show a status of 'Passed'
		And the 'Log Messages' Summary details will reflect the <Polarity> <Mode> slot status
		And the 'System 1 Tune page Values' for all modes remain unchanged			
			| System 1 Tune page Values |
			| Tube                      |
			| Reflectron Grid           |
			| Pusher Offset             |	
			
			Examples:
			| Polarity | Mode        | Initial Resolution                     |
			| Positive | Sensitivity | 'sensitivityModeResolution' or greater |
			| Positive | Resolution  | 'resolutionModeResolution' or greater  |
			| Negative | Sensitivity | 'sensitivityModeResolution' or greater |
			| Negative | Resolution  | 'resolutionModeResolution' or greater  |
			# 'sensitivityModeResolution' and 'resolutionModeResolution' values can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: RES-03 - Basic Progress Log Elements - Pre-check Outside Modified Range - Optimisation NOT Possible
	Given the Instrument Setup 'Resolution Optimisation' process has been run successfully for <Polarity> <Mode>
		And the Resolution attained during that process has been recorded 
		# This can be found from the Report
		And the 'Precheck Parameter' for <Mode> is modified to a value 10000 higher than the value attained during the run
			| Mode        | PreCheck Parameter        |
			| Sensitivity | sensitivityModeResolution |
			| Resolution  | resolutionModeResolution  |
			# PreCheck parameters can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
			# e.g. if the Report suggests a resolution of 55000 was attained in Sensitivity mode, then modify and save the 'sensitivityModeResolution' value to 65000. 
			# Not what the original 'sensitivityModeResolution' and 'resolutionModeResolution' values are set to.
		And Typhoon is restarted
	When the Instrument Setup slots are 'Reset'
		And the following Instrument Setup 'Processes' are run successfully for <Polarity>
			| Processes      |
			| ADC Setup      |
			| Detector Setup |
		And the following 'Initial System 1 Tune page Values' are recorded for all modes
			| Initial System 1 Tune page Values |
			| Tube                              |
			| Reflectron Grid                   |
			| Pusher Offset                     |
		And the Instrument Setup 'Resolution Optimisation' <Polarity> <Mode> slot is enabled
		And the Instrument Setup process is 'Run'
		And the Instrument Setup 'Resolution Optimisation' process runs successfully for <Polarity> <Mode>
	Then the following will be presented within the 'Progress Log' for <Polarity> <Mode>
		| Process Elements                                                                       |
		| Setting up fluidics                                                                    |
		| DRE set to [a], ions per push = [b]                                                    |
		| Resolution = [c]                                                                       |
		| The resolution is below [d]. The resolution will now be optimised                      |
		| Tube = [e], Reflectron Grid = [f], Resolution = [g] (x 40)                             |
		| Optimum Tube = [h], Optimum Reflectron Grid = [i], Resolution = [j]                    |
		| Pusher offset = [k], Resolution = [l]  (x 21)                                          |
		| Optimum Pusher offset = [m], Resolution = [n]                                          |
		| Resolution = [o]                                                                       |
		| Resolution Optimisation parameters unchanged.                                          |
		| Initial resolution = [c], Optimised resolution = [o]                                   |
		| Optimised resolution needed to be greater than initial resolution + standard error [p] |
		# where [a] = DRE value from 99.80 to 5.00
		# where [b] = measured 'ions per push' NOTE: the final 'ions per push' value should be less than or equal to 2.0
		# where [c] = Initial Resolution (measured) - should be between 'minResolution' and 'maxResolution' (\Typhoon\config\TofResolutionOptimisationConfiguration.xml)
		# where [d] = Resolution PreCheck Value (see the 'sensitivityModeResolution' and 'resolutionModeResolution' values in \Typhoon\config\TofResolutionOptimisationConfiguration.xml)
		# where [e] = Stepped value from (Initial 'Tube Lens' value - 'tubeLowRange') to (Initial 'Tube Lens' value + 'tubeHighRange') in steps of 'tubeStep'
		# where [f] = Repeated stepped value from (Initial 'Reflectron Grid' value - 'reflectronGridLowRange') to (Initial 'Reflectron Grid' value + 'reflectronGridHighRange') in steps of 'reflectronGridStep'
		# where [g] = In-process Resolution measurement
		# where [h] = Optimum Tube value (where In-process Resolution measurement [f] was the greatest)
		# where [i] = Optimum Reflectron Grid value (where In-process Resolution measurement [f] was the greatest)
		# where [j] = Resolution measured for Optimum Tube [g] and Reflectron Grid [h] values
		# where [k] = Stepped value from (Initial 'Pusher Offset' value - 'pusherOffsetLowRange') to (Initial 'Pusher Offset' value + 'pusherOffsetHighRange') in steps of 'pusherOffsetStep'
		# where [l] = In-process Resolution measurement
		# where [m] = Optimum Pusher Offset value (where In-process Resolution measurement [k] was the greatest) 
		# where [n] = Resolution measured for Optimum Pusher Offset [l]
		# where [o] = Optimised Resolution (measured with Optimum Tube [g], Optimum Reflectron Grid [h] and Optimum Pusher Offset [l] values) - should be between 'minResolution' and 'maxResolution' (\Typhoon\config\TofResolutionOptimisationConfiguration.xml)
		# where [p] = Calculated standard error (found during Optimised Resolution measurement) - should be less than maxRSD (10)
		And the Instrument Setup 'Resolution Optimisation' <Polarity> <Mode> slot will show a status of 'Passed'
		And the 'Log Messages' Summary details will reflect the <Polarity> <Mode> slot status
		And the 'System 1 Tune page Values' for all modes remain unchanged			
			| System 1 Tune page Values |
			| Tube                      |
			| Reflectron Grid           |
			| Pusher Offset             |
			
			Examples:
			| Polarity | Mode        | Initial Resolution                                      |
			| Positive | Sensitivity | between 'minResolution' and 'sensitivityModeResolution' |
			| Positive | Resolution  | between 'minResolution' and 'resolutionModeResolution'  |
			| Negative | Sensitivity | between 'minResolution' and 'sensitivityModeResolution' |
			| Negative | Resolution  | between 'minResolution' and 'resolutionModeResolution'  |
			# 'minResolution', 'sensitivityModeResolution' and 'resolutionModeResolution' values can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
			

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Updated
Scenario Outline: RES-04 - DRE and 'Ions Per Push' (Positive Sensitivity)
	Given the Instrument Setup slots are 'Reset'
		And the following Instrument Setup 'Processes' are run successfully for Positive
			| Processes      |
			| ADC Setup      |
			| Detector Setup |
		And the following Tune page 'System 2' tab parameter and value is set 
			| Parameter             | Value |
			| pDRE Attenuate        | Off   |
		And the Detector Voltage is changed such that the MZ plot IPP is set to an <Initial IPP Value> when the following Custom method is run
			| Setting   | Value |
			| StartMass | 555.0 |
			| EndMass   | 557.0 |
			| ScanTime  | 0.5   |
		And the Custom method is 'Aborted'
		And the following Tune page 'System 2' tab parameters and values are set 
			| Parameter             | Value |
			| pDRE Attenuate        | On    |
			| pDRE Transmission (%) | 55.5  |
	When the Instrument Setup 'Resolution Optimisation' is enabled for Positive Sensitivity only
		And the Instrument Setup process is 'Run'
		And the Instrument Setup 'Resolution Optimisation' process runs successfully
	Then the following <Number of Lines> will be presented within the 'Progress Log' similar to the following
		| Progress Log                        |
		| DRE set to [a], ions per push = [b] |
	    # Where [a] is a DRE setting and [b] is an 'Ions Per Push' measurement
		And the initial DRE value [a] will be 99.90
		# The value of 55.5 set manually above should never be used as the initial DRE value
		And <Subsequent Lines DRE Values> have parameters set
		And the initial 'ions per push' value [b] will the same as the <Initial IPP Value>
		And the <Final DRE> value [a] will be set
		And the <Final 'Ions Per Push> value [b] will be set
					
			Examples: 
			| Initial IPP Value | Number of Lines | Subsequent Lines DRE Values | Final DRE       | Final Ions Per Push | Error                                             |
			| Less than 2.0     | Single          | N/A                         | 99.8            | Less than 2.0       | N/A                                               |
			| Greater than 2.0  | Multiple        | Each line steps down by 5.0 | <99.8 and >=5.0 | <=2.0               | N/A                                               |
			| Very large        | Multiple        | Each line steps down by 5.0 | <5.0            | Greater than 2.0    | Resolution Optimisation in error. Beam too Strong |


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@ManualOnly, @Updated
Scenario: RES-05 - Engineering Dashboard Parameter Changes - All Modes
	Given the Instrument Setup slots are 'Reset'
		And the following Instrument Setup 'Processes' are run successfully for Positive and Negative
			| Processes      |
			| ADC Setup      |
			| Detector Setup |
		And the instrument is de-tuned for 'Polarity' and 'Mode' so the 'Initial Resolution' is within range
			| Polarity | Mode        | Initial Resolution                                      |
			| Positive | Sensitivity | between 'minResolution' and 'sensitivityModeResolution' |
			| Positive | Resolution  | between 'minResolution' and 'resolutionModeResolution'  |
			| Negative | Sensitivity | between 'minResolution' and 'sensitivityModeResolution' |
			| Negative | Resolution  | between 'minResolution' and 'resolutionModeResolution'  |
			# 'minResolution', 'sensitivityModeResolution' and 'resolutionModeResolution' values can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
			# This will ensure that the optimisation process actually starts, rather than stopping because the resolution is already good enough
		And the following current Tune Page parameter values have been recorded for all modes
			| Parameters      |
			| Pusher Offset   |
			| Reflectron Grid |
			| Tube Lens       |
	When all the Instrument Setup 'Resolution Optimisation' modes are enabled
		And the Instrument Setup process is 'Run'
	Then during the process the following monitored mode 'Parameters' should move from their initial recorded value by 'Lower Offset' to 'Upper Offset' in incremental 'Steps', for each mode
		| Parameter Name       | Engineering Dashboard Parameter | Lower Offset | Upper Offset | Steps  |
		| Pusher Offset        | PUSHER_OFFSET_SETTING           | -0.1         | +0.1         | +0.01  |
		| Reflectron Grid (kV) | REFLECTRON_GRID_SETTING         | -0.002       | +0.002       | +0.001 |
		| Tube Lens            | TUBE_LENS_SETTING               | -5.0         | +2.0         | +1.0   |
		# These are assumed to be default configuration parameters
		# The 'Parameters' will be monitored using an appropriate tool (e.g. Engineering Dashboard)
		

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Updated
Scenario Outline: RES-06 - Running Again Immediately After Successful Run - No Tune Page Updates 
	Given the Instrument Setup 'Resolution Optimisation' process has been run successfully for <Polarity> <Mode>
		And the current Tune Page 'Parameter' settings have been recorded for <Polarity> <Mode>
			| Parameters      |
			| Pusher Offset   |
			| Reflectron Grid |
			| Tube Lens       |
		And all the Instrument Setup slots are then 'Reset'
		And the following 'Processes' are run successfully for <Polarity>
			| Processes      |
			| ADC Setup      |
			| Detector Setup |
	When the Instrument Setup 'Resolution Optimisation' <Polarity> <Mode> slot is enabled
		And the Instrument Setup process is 'Run'
	Then finally the Instrument Setup 'Resolution Optimisation' <Polarity> <Mode> slot will show a status of 'Passed'
		And the 'Progress Log' details will reflect the <Polarity> <Mode> status
		# i.e. Updated / not updated parameters. Not Aborted or Error.
		And the final Tune Page 'Parameter' values have not changed from their original values
			
			Examples:
			| Polarity | Mode             |
			| Positive | Resolution only  |
			| Negative | Sensitivity only |


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Updated
Scenario Outline: RES-07 - Major De-tuning - Error expected - No Tune Page Updates 
	Given the Instrument Setup slots are 'Reset'
		And the following Instrument Setup 'Processes' are run successfully for Positive and Negative
			| Processes      |
			| ADC Setup      |
			| Detector Setup |
		And the instrument is de-tuned for <Polarity> and <Mode> so the initial resolution is less than 'minResolution'
		# 'minResolution' value can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
		# This will ensure that the optimisation process will not run and will go to an 'Error' state.
		And the following 'Parameter' values applied for <Polarity> <Mode> have their values recorded
			| Parameter       |
			| Pusher Offset   |
			| Reflectron Grid |
			| Tube Lens       |
	When the Instrument Setup 'Resolution Optimisation' <Polarity> <Mode> slot is enabled
		And the Instrument Setup process is 'Run'
	Then finally the Instrument Setup 'Resolution Optimisation' <Polarity> <Mode> slot will show a status of 'Error'
		And the 'Progress Log' details will show a 'Resolution Optimisation in error' message for <Polarity> <Mode>
		# The status should not show that parameters have been Updated, or that the process has Aborted.
		And the final Tune Page 'Parameter' values have not changed from their manually applied original values
			
			Examples:
			| Polarity | Mode             |
			| Positive | Resolution only  |
			| Negative | Sensitivity only |
						

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Updated
Scenario Outline: RES-08 - Manually Abort Selected Slots
	Given the Instrument Setup slots are 'Reset'
        And the following 'Processes' are run successfully for both Polarities
			| Processes      |
			| ADC Setup      |
			| Detector Setup |
		And the Instrument Setup 'Resolution Optimisation' process has been run successfully for all modes
		And the previously optimised Tune Page 'Parameter' values have the following 'Manual Offsets' applied for all modes
			| Parameter       | Manual Offsets |
			| Pusher Offset   | -0.05          |
			| Reflectron Grid | +0.005         |
			| Tube Lens       | -3.0           |
		# The parameters above need the 'Manual Offsets' adding to their current values (rather than explicitely setting to these values)
		And for each 'Polarity'and 'Mode' the 'Initial Resolution' is within range
			| Polarity | Mode        | Initial Resolution                                      |
			| Positive | Sensitivity | between 'minResolution' and 'sensitivityModeResolution' |
			| Positive | Resolution  | between 'minResolution' and 'resolutionModeResolution'  |
			| Negative | Sensitivity | between 'minResolution' and 'sensitivityModeResolution' |
			| Negative | Resolution  | between 'minResolution' and 'resolutionModeResolution'  |
			# If needed, change the Parameter Manual Offsets again to achieve this
			# This will ensure that the optimisation process actually starts, for modes that are run to success
		And the following 'Parameters' have their initial values recorded for all modes
			| Parameters      |
			| Pusher Offset   |
			| Reflectron Grid |
			| Tube Lens       |
		And the <Initial Instrument Mode> is set
	When the Instrument Setup 'Resolution Optimisation' modes are all enabled
		And the Instrument Setup process is 'Run'
		But the Instrument Setup process is manually <Cancelled During Slot> optimisation
	Then there will be a <Slot Results> and a <Tune Page Status>
		
		Examples:
		| Initial Instrument Mode | Cancelled During Slot | Slot Results                     | Tune Page Status                                        |
		| Positive Resolution     | Positive Resolution   | Positive Sensitivity - 'Success' | Positive Sensitivity parameters updated                 |
		|                         |                       | Negative Sensitivity - 'Not Run' | Negative Sensitivity parameters maintain initial values |
		|                         |                       | Positive Resolution  - 'Aborted' | Positive Resolution parameters maintain initial values  |
		|                         |                       | Negative Resolution  - 'Not Run' | Negative Resolution parameters maintain initial values  |
		# Currently the Sensitivity slot will always run first, if selected
				
		Examples:
		| Initial Instrument Mode | Cancelled During Slot | Slot Results                     | Tune Page Status                                        |
		| Negative Sensitivity    | Negative Sensitivity  | Positive Sensitivity - 'Not Run' | Positive Sensitivity parameters maintain initial values |
		|                         |                       | Negative Sensitivity - 'Aborted' | Negative Sensitivity parameters maintain initial values |
		|                         |                       | Positive Resolution  - 'Not Run' | Positive Resolution parameters maintain initial values  |
		|                         |                       | Negative Resolution  - 'Not Run' | Negative Resolution parameters maintain initial values  |
		

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Updated
Scenario: RES-09 - No Reference Beam (All Slots Error) - No Tune Page Updates 
	Given there is no Leucine Enkephalin beam available within the Tune Page plot for any mode
		And the following 'Parameter' values have their initial values recorded for all modes
			| Parameter       |
			| Pusher Offset   |
			| Reflectron Grid |
			| Tube Lens       |
	When the Instrument Setup 'Resolution Optimisation' modes are all enabled
		And the Instrument Setup process is 'Run'
	Then finally Instrument Setup 'Resolution Optimisation' will show a status of 'Error' for each mode
		And the 'Progress Log' details will show a 'Resolution Optimisation in error' message for each mode
		# The status should not show that parameters have been Updated, or that the process has Aborted.
		And the final Tune Page 'Parameter' values have not changed from the initial values for any mode
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
@Updated
Scenario Outline: RES-10 - Standard Deviation Error - Final Status (Error) - No Tune Page Updates 
	Given 
	the instrument is slightly de-tuned for Positive Resolution mode so the Resolution is within 'minResolution' and 'resolutionModeResolution'
		# 'minResolution' and 'resolutionModeResolution' values can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
		# This will ensure that when the slot process starts, it will start optimising
		And the current Tune Page 'Parameter' settings have been recorded for Positive Resolution mode
			| Parameters      |
			| Pusher Offset   |
			| Reflectron Grid |
			| Tube Lens       |
	When the Instrument Setup 'Resolution Optimisation' Positive Resolution mode only is enabled
		And the Instrument Setup process is 'Run'
		And during the Instrument Setup run <Stage> the Reference fluidics line is physically removed
		# This should adversely affect the Resolution Optimisation Standard Deviation check
		# NOTE: If this is not possible, changing the 'Tune' page 'System 1' tab 'Entrance' value to zero (Positive Resolution mode) should have the same effect
	Then finally the Instrument Setup 'Resolution Optimisation' Positive Resolution mode will show a <Final Status>
		And the 'Progress Log' details will reflect the Positive Resolution mode status
		# The status should not show that parameters have been Updated, or that the process has Aborted.
		And the final Tune Page 'Parameter' values have not changed from their original values for any mode
			
			Examples:
			| Stage                                              | Final Status |
			| Resolution 1 - Current Resolution Check            | Error        |
			| Resolution 2 - New Resolution Optimisation process | Error        |
			

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Updated
Scenario Outline: RES-11 - Successful Run After Previous Abort / Error (Positive Resolution mode only) - 
	Given the Instrument Setup 'Resolution Optimisation' process has already been run in Positive Resolution mode with a <Previous Result>
		And the instrument is slightly de-tuned for Positive Resolution mode so the initial resolution is between 'minResolution' and 'resolutionModeResolution'
		# 'minResolution' and 'resolutionModeResolution' values can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
		# This will ensure that when the slot process starts, it will start optimising
		And the current Tune Page 'Parameter' settings have been recorded for Positive Resolution mode
			| Parameters      |
			| Pusher Offset   |
			| Reflectron Grid |
			| Tube Lens       |
	When the Instrument Setup 'Resolution Optimisation' Positive Resolution mode is enabled
		And the Instrument Setup process is 'Run'
	Then finally Instrument Setup 'Resolution Optimisation' will show a status of 'Passed' for Positive Resolution mode
		And the 'Progress Log' details will reflect the Positive Resolution mode status
	    # i.e. Updated Parameters. Not Aborted or Error.
		And the final Tune Page 'Parameter' values for Positive Resolution mode have changed from their manually applied original values
		But the 'Parameters' for any modes not run will remain unchanged
			
			Examples:
			| Previous Result |
			| Abort           |
			| Error           |


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Updated
Scenario: RES-12 - Factory Defaults Saved after Successful Run
	Given the Instrument Setup 'Resolution Optimisation' process has been run successfully for all modes
		And the instrument is de-tuned for all modes so the 'Initial Resolution' is within range
			| Polarity | Mode        | Initial Resolution                                      |
			| Positive | Sensitivity | between 'minResolution' and 'sensitivityModeResolution' |
			| Positive | Resolution  | between 'minResolution' and 'resolutionModeResolution'  |
			| Negative | Sensitivity | between 'minResolution' and 'sensitivityModeResolution' |
			| Negative | Resolution  | between 'minResolution' and 'resolutionModeResolution'  |
			# 'minResolution', 'sensitivityModeResolution' and 'resolutionModeResolution' values can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
		And the current Tune Page 'Parameter' settings have been recorded for all modes
			| Parameters      |
			| Pusher Offset   |
			| Reflectron Grid |
			| Tube Lens       |
		# Initial Factory Defaults manual Save
		And the Tune Page 'Parameter' settings are then Saved as 'Factory Defaults'
		And all the Instrument Setup 'Resolution Optimisation' modes are enabled
		And the Instrument Setup process is 'Run'
		And finally all Instrument Setup 'Resolution Optimisation' modes will show a status of 'Passed'
		# Automatic Factory Defaults saved with specific Resolution Optimisation parameters
		And the final Tune Page 'Parameters' for all modes have changed from their 'Manual Offset'
	When the following 'Parameter' settings are then manually changed to 'Value' for all modes
		| Parameter       | Value |
		| Pusher Offset   | 0     |
		| Reflectron Grid | 0     |
		| Tube Lens       | 0     |
		And the 'Factory Defaults' are Loaded
	Then the zero value 'Parameters' are overwritten with the automatically saved optimised values for all modes
	# Rather than the initial 'Manual Offset' values that were Saved before the process was run
		| Parameters      |
		| Pusher Offset   |
		| Reflectron Grid |
		| Tube Lens       |
	

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END