
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # DSU - DetectorSetup - BothModes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CWS
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 27-JUN-14
#                          # (Updated 27-JUN-16)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # Revision: 02 (Automation Rewrite)
#                          # 27-JUN-16 - Christopher D Hughes - Updates to add DSU-5 to cover Vion v1.1 CR FW#9038  
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # How to Implement Detector setup for Quartz.doc
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-289)                 # The Detector Setup procedure will perform a procedure whereby the software will determine the optimum detector voltage and ion area for a specified polarity.  This procedure will perform an acquisition in order to achieve this.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-294)                 # The user will be able to specify which polarities the procedure will be run in.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-298)                 # The user will be able to specify to run a Detector setup or a Measure Ion Area
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-299)                 # The user will be able to start the detector setup operation from this screen. 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-301)                 # The operation will run in a single polarity at a time.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-303)                 # When the process completes, the software will display the calculated detector voltage for each polarity where applicable. 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-304)                 # When the process completes, the software will display the calculated Ion area for each polarity where applicable.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-305)                 # While the process is running the software will log diagnostics messages to a progress log.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # IBM Rational Change (see below)...
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# CR ID: FW#9038           # Quartz - Detector Setup page - First Run - negative values not written to tune page
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@DetectorSetup
Feature: DSU - QRZ - DetectorSetup - Both Modes
	In order to check 'Detector Setup' processes with both the modes within a Quartz environment
	I want to check that the function as expected and generates the expected outputs.


# -----------------------------------------------------------------------------------------------------------------
@Ignore
@Updated
Background:
Given the browser is opened on the Tune page
	And the polarity is Positive
	And reference fluidics are set to
	| Baffle Position | Reservoir | Flow Path | Flow Rate |
	| Reference       | B         | Infusion  | 20.00     | 
	And the reference fluidic level is not less than '10.00' minutes
	And the instrument has a beam
	And you start reference infusing


# -----------------------------------------------------------------------------------------------------------------------------------------
@SmokeTest
@Ignore
@Updated
Scenario: DSU - 01 - DetectorSetup - Both Modes - Positive Mass Results - Range
	Given the Quartz Detector Setup page is open
	When detector setup is run for 'Both' modes
	Then the field value is between Minimum and Maximum
		| Field                     | Minimum | Maximum |
		| Positive Detector Voltage | 0       | 3950    |
		| Positive Ion Area         | 0       | 100     |
		| Negative Detector Voltage | 0       | 3950    |
		| Negative Ion Area         | 0       | 100     |
	
@SmokeTest
@Ignore
@Updated
Scenario: DSU - 02 - DetectorSetup - Both Modes - Negative Mass Results - Status
	Given the Quartz Detector Setup page is open
	When detector setup is run for 'Both' modes
	Then the field value should be
		| Field           | Value    |
		| Positive Status | Complete |
		| Negative Status | Complete |
		And the Detector Setup should complete within 10 minutes

@SmokeTest	
@Ignore
@Updated
Scenario: DSU - 03 - DetectorSetup - Both Modes - Progress Log - Messages
	Given the Quartz Detector Setup page is open	
	When detector setup is run for 'Both' modes
	Then the message should exist in the Progress Log for each mode
		| Message                                 |
		| Setting up fluidics                     |
		| IPP check beam too weak                 |
		| Detector level beam too weak            |
		| Detector Level Ramping up to            |
		| IPP check at voltage                    |
		| Detector Level Ramping voltage down to  |
		| Detector Level Complete: Final voltage: |
		| Measured Ion Area:                      |


@Ignore
@Updated
Scenario: DSU - 04 - DetectorSetup - Both Modes - Positive and Negative Mass Results - Values
	Given the Quartz Detector Setup page is open
	Then the Mass Results values match the Progress Log



# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# CR ID: FW#9038           # Quartz - Detector Setup page - First Run - negative values not written to tune page
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
@ManualOnly
@Ignore
Scenario: DSU-05 - Detector Setup - Both Modes - Values Written to Tune Page after First Run
	Given that Typhoon has been stopped
		And the instrument EPC KeyValueStore has been deleted by connecting to the EPC and running the following commands
			| EPC Commands       |
			| StopLegacyService  |
			| xdelete "*.kvdb"   |
			| StartLegacyService |
			# Via TTERMPRO or Putty
		And the local test PC '\Typhoon\data_store' folder has been removed
		And Typhoon has been started
		And within Quartz Tune page 'Factory Defaults' have been Reset
		
		# Manual Setup
		And the ADC is manually set up in Positive and Negative modes
		And the Detector Voltage has been manually set to '2500' so Leucine Enkephalin peaks are present
		# if 2500 is not enough then increase the Detector voltage until a good beam is present
		And the Veff Value has been set so that the main Reference peaks are at the correct position
		# For Leucine Enkephalin, Positive m/z = 556.27, Negative m/z = 554.26
		
		# Detector Setup run
		And the Quartz Detector Setup page is opened
		# Not the Instrument Setup page
	When the Detector Setup process has the following selected
		| Positive Mass | Negative Mass |
		| 556.2         | 554.2         |
		And the Detector Setup process is run to 'Success' for both polarities
	
	# Positive Tune page values
	Then the positive Detector Setup 'Detector Voltage' value matches the positive Tune Page Instrument 'Detector Voltage' value
		And the positive Detector Setup 'Ion Area' value matches the positive Tune Page ADC2 'Average Single Ion Intensity' value
		And the positive Tune Page ADC2 'Measured m/z' is 556.2700
		And the positive Tune Page ADC2 'Measured charge' value is 1
	
	# Negative Tune page values
	Then the negative Detector Setup 'Detector Voltage' value matches the negative Tune Page Instrument 'Detector Voltage' value
		And the negative Detector Setup 'Ion Area' value matches the negative Tune Page ADC2 'Average Single Ion Intensity' value
		And the negative Tune Page ADC2 'Measured m/z' is 554.2600
		And the negative Tune Page ADC2 'Measured charge' value is -1


# ---------------------------------------------------------------------------------------------------------------------------------------------------		
# END