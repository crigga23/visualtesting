
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Detector Setup Improvements
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
Feature: Detector Setup Improvements
	In order to check that Detector Setup optimisation and Ion Area measure is run every time, even if it has been run before
	I want to be able to run the Detector Setup process
	So that new Detector voltage and Ion Area values are calculated

		
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: DSU-01 - (Detector Setup page) Detector Setup Improvements - Never Been Run - Success
	Given that Typhoon has been stopped
		And the instrument EPC KeyValueStore has been deleted
		# See 'Manual Test Notes' comments in header
		And Typhoon has been started
		And within Quartz Tune page 'Factory Defaults' have been Reset
		And ADC Setup has been run successfully for <Mode>

	When Detector Setup is run for <Mode>
	# From the Detector Setup' page
	Then the following 'Processes' will run with an associated 'Message' logged for each <Mode>
		| Processes                                 | Message                                |
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
Scenario Outline: DSU-02 - (Detector Setup page) Detector Setup Improvements - Has Been Run - Success
	Given Detector Setup has already been run to Success for <Mode>
	# From the Detector Setup' page
	When Detector Setup is run again for <Mode>
	# From the Detector Setup' page
	Then the following 'Processes' will run with an associated 'Message' logged for each <Mode>
		| Processes                                 | Message                                |
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


#------------------------------------------------------------------------------------------------------------------------------------------------------
#END

































#END