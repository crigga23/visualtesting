
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # (Instrument Setup) Detector Setup Improvements
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 01-APR-16
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # See 'Manual Test Notes' below
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #  Osprey Instrument - Resetting the KeyValueStore in DSU-01 scenario: 
#                          #      1). Connect to EPC (using TTERMPRO or Putty)
#                          #      2). Run the following terminal commands
#                		   #	    	| EPC Commands       |
#                 		   #            | StopLegacyService  |
#                		   #            | xdelete "*.kvdb"   |
#               		   #            | StartLegacyService |
#                          #      3). delete the local test PC '\Typhoon\data_store' folder
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # There is a good initial Reference beam (Leucine Enkephalin)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
Feature: (Instrument Setup) Detector Setup Improvements
	In order to check that (Instrument Setup) Detector Setup optimisation is only run if it has never been run before, or if the Ion Area is outside a tolerance
	I want to be able to run the (Instrument Setup) Detector Setup process
	So that new Detector voltage and Ion Area values are calculated if needed, otherwise existing values will be used


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: CAL-01 - (Instrument Setup) Detector Setup Improvements - Never Been Run - Success
	Given that Typhoon has been stopped
		And the instrument EPC KeyValueStore has been deleted
		# See 'Manual Test Notes' comments in header
		And Typhoon has been started
		
		And within Quartz Tune page 'Factory Defaults' have been Reset
		And Instrument Setup 'ADC Setup' is run successfully for <Mode>
	
	When Instrument Setup 'Detector Setup' is run for <Mode>
	Then the following 'Processes' will run with an associated 'Message' logged for each <Mode>
		| Processes                                 | Message                                |
		| Check Process has been run before (FALSE) | N/A                                    |
		| Basic Fluidics Check (PASS)               | Basic Fludics Check                    |
		| Detector Voltage Optimisation             | New optimised 'Detector Voltage' value |
		| Ion Area Measure                          | New measured 'Ion Area' value          |
		| Values written to Tune page for <Mode>    | N/A                                    |
		# The Messages above are not explicit but just give an ide of the information sent to the Message Log 
		And the slot status is 'Success' for <Mode>
			
			Examples: Mandatory
			| Mode                  |
			| Positive and Negative |
						
			Examples: Optional
			| Mode                  |
			| Positive Only         |
			| Negative Only         |
					

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: CAL-02 - (Instrument Setup) Detector Setup Improvements - Has Been Run (Ion Area Within Tolerance) - Success
	Given Instrument Setup 'Detector Setup' has already run for <Mode>
		And the following 'Original Parameter' values are already stored from this previous run	
			| Original Parameter |
			| Detector Voltage   |
			| Average Ion Area   |
		
		And Quartz Tune page 'Factory Defaults' have been Reset
		And Instrument Setup is 'Reset'
		And Instrument Setup 'ADC Setup' is run successfully for <Mode>
	
	When Instrument Setup 'Detector Setup' is run in <Mode>
	Then the following 'Processes' will run with an associated 'Message' logged for each <Mode>
		| Process                                                            | Message                                                                         |
		| Check Process has been run before (TRUE)                           | N/A                                                                             |
		| Full Fluidics Beam and Stability Check (PASS)                      | Fluidics and Stability Check                                                    |
		| Ion Area Measure                                                   | Current measured 'Ion Area' value                                               |
		| Check if current 'Ion Area' is within tolerance of original (TRUE) | Current 'Ion Area' is within Tolerance (current value and expected range shown) |
		| N/A                                                                | Original 'Detector Voltage and 'Ion Area' will be used (both values reiterated) |
		| Values written to Tune page for <Mode>                             | N/A                                                                             |
		And the slot status is 'Success' for <Mode>
			
			Examples: Mandatory
			| Mode                  |
			| Positive and Negative |
						
			Examples: Optional
			| Mode                  |
			| Positive Only         |
			| Negative Only         |


#------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: CAL-03 - (Instrument Setup) Detector Setup Improvements - Has Been Run (Ion Area Outside Tolerance) - Success
	Given Instrument Setup 'Detector Setup' has already run for <Mode>
		And the following 'Original Parameter' values are already stored from this previous run	
			| Original Parameter |
			| Detector Voltage   |
			| Average Ion Area   |

		And Typhoon has been stopped
		And the 'Typhoon\DetectorSetupConfiguration.xml' file has been modified to force the Ion Area tolerance to fail
		# Suggest setting 'checkTolerance' to "0.1"
		And Typhoon has been started
		
		And Quartz Tune page 'Factory Defaults' have been Reset
		And Instrument Setup is 'Reset'
		And Instrument Setup 'ADC Setup' is run successfully for <Mode>
	
	When Instrument Setup 'Detector Setup' is run in <Mode>
	Then the following 'Processes' will run with an associated 'Message' logged for each <Mode>
		| Process                                                                     | Message                                                                          |
		| Check Process has been run before (TRUE)                                    | N/A                                                                              |
		| Full Fluidics Beam and Stability Check (PASS)                               | Fluidics and Stability Check                                                     |
		| Ion Area Measure                                                            | Current measured 'Average Ion Area' value                                        |
		| Check if current 'Ion Area' is within tolerance of original (FALSE)         | Current 'Ion Area' is outside Tolerance (current value and expected range shown) |
		| Detector Voltage Optimisation                                               | New optimised 'Detector Voltage' value                                           |
		| Ion Area Measure                                                            | New measured 'Average Ion Area' value                                            |
		| N/A                                                                         | New 'Detector Voltage and 'Ion Area' will be used (both values reiterated)       |
		| New 'Detector Voltage and 'Ion Area' values written to Tune page for <Mode> | N/A                                                                              |
		And the slot status is 'Success' for <Mode>
		
			Examples: Mandatory
			| Mode                  |
			| Positive and Negative |
						
			Examples: Optional
			| Mode                  |
			| Positive Only         |
			| Negative Only         |


#------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: CAL-04 - (Instrument Setup) Detector Setup Improvements - Has Been Run (Fluidics Failure) - Error
	Given Instrument Setup 'Detector Setup' has already run for <Mode>
		
		And Quartz Tune page 'Factory Defaults' have been Reset
		And Instrument Setup is 'Reset'
		And Instrument Setup 'ADC Setup' is run successfully for <Mode>
	
		And the Tune page System 1 'Entrance' value is set to zero
		# This will simulate a Reference beam failure
	
	When Instrument Setup 'Detector Setup' is run in <Mode>
	Then the following 'Processes' will run with an associated 'Message' logged for each <Mode>
		| Process                                       | Message                              |
		| Check Process has been run before (TRUE)      | N/A                                  |
		| Full Fluidics Beam and Stability Check (FAIL) | Fluidics and Stability Check Failure |
		And the slot status is 'Error' for <Mode>
		
			Examples: Mandatory
			| Mode                  |
			| Positive and Negative |
						
			Examples: Optional
			| Mode                  |
			| Positive Only         |
			| Negative Only         |


#------------------------------------------------------------------------------------------------------------------------------------------------------
# Although the When and Then lines in this Scenario Outline are run from Instrument Setup... 
# ...it assumes a prerequisite that Detector Setup has already been run from the Quartz 'Detector Setup' page
Scenario Outline: CAL-05 - (Instrument Setup) Detector Setup Improvements - Has Been Run - Success
	Given that Typhoon has been stopped
		And the instrument EPC KeyValueStore has been deleted
		# See 'Manual Test Notes' comments in header
		And Typhoon has been started
		
		And within Quartz Tune page 'Factory Defaults' have been Reset
		And that Instrument Setup 'ADC Setup' is run successfully for <Mode>
		And Detector Setup is run to Success from the 'Detector Setup' page for <Mode>
		# Run from 'Detector Setup' page not Instrument Setup

		And Instrument Setup is 'Reset'
		And Instrument Setup 'ADC Setup' is run successfully for <Mode>
			
	When Instrument Setup 'Detector Setup' is run for <Mode>
	# This time run from Instrument Setup
	
	Then the following 'Processes' will run with an associated 'Message' logged for each <Mode>
		| Process                                                            | Message                                                                         |
		| Check Process has been run before (TRUE)                           | N/A                                                                             |
		| Full Fluidics Beam and Stability Check (PASS)                      | Fluidics and Stability Check                                                    |
		| Ion Area Measure                                                   | Current measured 'Ion Area' value                                               |
		| Check if current 'Ion Area' is within tolerance of original (TRUE) | Current 'Ion Area' is within Tolerance (current value and expected range shown) |
		| N/A                                                                | Original 'Detector Voltage and 'Ion Area' will be used (both values reiterated) |
		| Values written to Tune page for <Mode>                             | N/A                                                                             |
		# The Messages above are not explicit but just give an ide of the information sent to the Message Log 
		And the slot status is 'Success' for <Mode>
			
			Examples: Mandatory
			| Mode                  |
			| Positive and Negative |
						
			Examples: Optional
			| Mode                  |
			| Positive Only         |
			| Negative Only         |


#------------------------------------------------------------------------------------------------------------------------------------------------------
#END

































#END