# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # ACQ - QRZ - Automatic Detector Optimisation (ADO)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    #          04-AUG-15
#                          # UPDATED: 20-NOV-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # See below for 'Manual Test Notes'
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # SampleList 'A', and 'B' referenced within the Scenarios are detailed at the botton of this feature file
#                          # and when uncommented should replace the contents of 'C:\Waters Corporation\\Typhoon\config\methods\SampleList.xml'.
#                          # 
#                          # Start the SampleList running by executing the following command from 'C:\Waters Corporation\Typhoon\config\methods\'...
#                          # "C:\Waters Corporation\Typhoon\bin\Waters.Test.MethodRunnerClient.exe" -sl SampleList.xml
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Modify the 'ms_ado.xml' and 'ms_ado_adj.xml' methods to change the 'EndMass' to '1000.0' (\Typhoon\config\methods)
#                          # NOTE: This will ensure that the correct LockSpray profile settings are used (LeuEnk 556 / 554)
#                          #
#                          # Engineer Dashboard can be set up to monitor the following if required...
#			               # - 'Detector Voltage' use 'HTPSU3_SUPPLY1_DEMAND_VOLT_SETTING'
#                          # - 'Baffle Position   use 'SPRAYER_POSITION_STATUS'
#                          # - 'Ion Energy'       use 'ION_ENERGY_SETTING'
#                          # - 'Entrance'         use 'ENTRANCE_SETTING'
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # DebugView is running and set to filter for '*ADO*' messages 
#                          # https://technet.microsoft.com/en-us/library/bb896647.aspx
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-158)                 # The system will be able to automatically set up the detector for optimum operation.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-484)                 # An automatic relative gain check and subsequent detector voltage adjustment shall be completed using the signal from 
#                          # the lock mass between individual experiments in a sample list.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-485)                 # The detector voltage is automatically adjusted in order to maintain a constant detector gain. 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-487)                 # It shall be possible to disable Automatic Detector Optimisation.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-488)                 # Failure of Automatic Detector Optimisation shall not cause a sample list to abort; the sample list shall 
#                          # continue with the last valid detector voltage set.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------



#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Ignore
Feature: Automatic Detector Optimisation (ADO)
	 In order to ensure that the Detector Voltage is automatically optimised during a Samplelist run
	 I want to run a Sample list with appropriately modified methods (to enable ADO)
	 So that 'Automatic Detector Optimisation' checking and adusting processes are successfully run


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Background: 
	Given the Typhoon 'data_store' folder has any previous RAW folders removed
		And the following 'XML Files' have been created
			| XML Files      |
			| SampleList 'A' |
			| SampleList 'B' |
		And Typhoon has been stopped and restarted
		# Restarting Typhoon ensures that any previous changes to the configuraton files are applied
		# SampleList 'A' and SampleList 'B' contents are detailed at the bottom of this feature file.
		

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: ACQ-01 - ADO - ADC Setup / Detector Setup 'Not Run'
	Given the Instrument <Polarity> and <Mode> is set
		And the following 'Instrument Setup Processes' have a 'Not Run' status for <Polarity>
			| Instrument Setup Processes |
			| ADC Setup                  |
			| Detector Setup             |
	When SampleList 'A' is run
	Then the following 'ADO Messages' will be reported in sequence
		| ADO Messages                                  |
		| Running Ion Area Check                        |
		| Detector Setup has not been run or run failed |
		| No new voltage avialable                      |
		| Running Ion Area Adjust                       |
		| Detector Setup has not been run or run failed |
		| No new voltage avialable                      |
		# ADO Messages can be monitored from DebugView
		And the following Typhoon 'data_store RAW folders' will be created with a non-zero '_func001.dat' file
			| data_store RAW folders |
			| ADO_Optimize.raw       |
			| ADO_Adjust_001.raw     |
		And when the SampleList acquisition has completed no method will be running
			
			Examples:
			| Polarity | Mode        |
			| Positive | Sensitivity |
			| Negative | Resolution  |
	

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: ACQ-02 - ADO - No Expected Adjustment - Messages Check
	Given the Instrument <Polarity> and <Mode> is set
		And the following 'Instrument Setup Processes' have a 'Success' status for <Polarity>
			| Instrument Setup Processes |
			| ADC Setup                  |
			| Detector Setup             |
		And the initial Detector Voltage is recorded for later comparison
	When SampleList 'A' is run
	Then the following 'ADO Messages' will be reported in sequence
		| ADO Messages                                                             |
		| Running Ion Area Check                                                   |
		| -- Run Noise Check --                                                    |
		| Pass TIC: [a]                                                            |
		| -- Running Detector Conditions Check --                                  |
		| detector check passed, reference noise [b]                               |
		| beam check pass                                                          |
		| Conditions check complete                                                |
		| ref noise: [b], ref voltage: [initial_voltage]                           |
		| No new voltage available                                                 |
		| Running Ion Area Adjust                                                  |
		| -- Running Detector Conditions Check --                                  |
		| beam check pass                                                          |
		| Conditions check complete                                                |
		| ref noise: [b], ref voltage: [initial_voltage]                           |
		| -- Running DetectorAdjust --                                             |
		| Detector Not Degraded: noise [c] in range <[b - (0.2%)b], [b + (0.2%)b]> |
		| Adjust Complete                                                          |
		| No new voltage available                                                 |
		# Where [a], [b], [c], [d] and [e] are various measured values
		# Where [initial_voltage] is the initial Detector Voltage
		And the following Typhoon 'data_store RAW folders' are created with a non-zero '_func001.dat' file
			| data_store RAW folders |
			| ADO_Optimize.raw       |
			| ADO_Adjust_001.raw     |
		And when the SampleList acquisition has completed no method will be running
		And the current Detector Voltage remains unchanged from the initial recorded value	
			
			Examples:
			| Polarity | Mode        |
			| Positive | Sensitivity |
			| Negative | Resolution  |
						

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: ACQ-03 - ADO - No Expected Adjustment - Can be run Successfully again after Typhoon Restart
	Given the ADO process has been successfully run
		And the following 'ADO Messages' were reported in sequence
			| ADO Messages             |
			| Detector Not Degraded... |
			| Adjust Complete          |
			| No new voltage available |
			# Additional related messages may also be reported
	When Typhoon is stopped and restarted
		And SampleList 'A' is run
	Then the following 'ADO Messages' will be reported in sequence
		| ADO Messages             |
		| Detector Not Degraded... |
		| Adjust Complete          |
		| No new voltage available |
		# Additional related messages may also be reported
		

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@RealInstrumentOnly
Scenario Outline: ACQ-04 - ADO - Expected Adjustment - New Voltages Calculated (Multiple Samples)
	Given the \Typhoon\config\DetectorOptimizationConfiguration.xml has the following 'Parameters' and 'Values' set
		| Parameter            | Value |
		| degradationTolerance | 0.2   |
		| runTime              | 60    |
		# Make a note of the initial default values before changing
		And the Typhoon\config\methods\ms.xml has the following 'Parameter' and 'Value' set
			| Parameter | Value |
			| TimeEnd   | 60    |
		And Typhoon is restarted
		And the following 'Instrument Setup Processes' have a 'Success' status for <Polarity>
			| Instrument Setup Processes |
			| ADC Setup                  |
			| Detector Setup             |
		# This should match the [initial_voltage] Debug ADO messages during the Sample list run
		And the Instrument <Polarity> and <Mode> is set
		And the Current Detector Voltage is recorded for <Polarity>
	When SampleList 'B' is run
	
	# Sample 1 (Check)
	Then during 'Sample 1' the 'Detector Voltage' will remain the same
	And the following 'ADO Messages' will be reported in sequence during 'Sample 1'
		| ADO Message                                                    |
		| Running Ion Area Check                                         |
		| ref noise [a], ref voltage [initial_voltage]                   |
		# Additional related messages may also be reported
	
	# Sample 2 (Optimise)
	And during 'Sample 2' the 'Detector Voltage' will be set to a new value
	And the following 'ADO Messages' will be reported in sequence during 'Sample 2'	
		| ADO Message                                                    |
		| Running Ion Area Adjust                                        |
		| ref noise [a], ref voltage [initial_voltage]                   |
		| -- Running Detector Adjust -                                   |
		| Detector Degraded...                                           |
		| setting new voltage to [new_voltage_sample_2]                  |
		| Adjust complete                                                |
		| passing detector voltage to main method [new_voltage_sample_2] |
		# Additional related messages may also be reported
	
	# Sample 3 (No Optimisation)
	And during 'Sample 3' the 'Detector Voltage' will revert to the [initial_voltage]
	# During Sample 3 the previous Detector Voltage determined during Sample 2 will not be used, instead it will revert to the [initial voltage] determined during Sample 1
	And no 'ADO Messages' will be reported for 'Sample 3'		
	
	# Sample 4 (Optimise)
	And during 'Sample 4' the 'Detector Voltage' will be set to another new value
	And the following 'ADO Messages' will be reported in sequence for 'Sample 4'	
		| ADO Message                                                    |
		| Running Ion Area Adjust                                        |
		| ref noise [a], ref voltage [initial_voltage]                   |
		| -- Running Detector Adjust --                                  |
		| Detector Degraded...                                           |
		| setting new voltage to [new_voltage_sample_4]                  |
		| Adjust complete                                                |
		| passing detector voltage to main method [new_voltage_sample_4] |
		# Additional related messages may also be reported
	
	And when the SampleList acquisition has completed no method will be running	
	And the 'Detector Voltage' will return to the initially recorded value
		# Additional related messages may also be reported
		# Where [a] is a measured noise value
		# Where [initial_voltage] is the initial recoreded Detector Voltage
		# Where [new_voltage_sample_2], and [new_voltage_sample_4] are new calculated / optimised Detector Voltage values 
		# 'Sample 3' should use the same optimised voltage as 'Sample 2', as 'Sample 3' is just using the 'ms.xml' method with no additional ADO Check or Adjust lines
		And the following Typhoon 'data_store RAW folders' are created with a non-zero '_func001.dat' file
			| data_store RAW folders |
			| ADO_Optimize.raw       |
			| ADO_Adjust_001.raw     |
			| ADO_NoAdjust_002.raw   |
			| ADO_Adjust_003.raw     |
			# Notice the 'NoAdjust' for sample 002
		
			Examples:
			| Polarity | Mode        |
			| Positive | Sensitivity |
			| Negative | Resolution  |
			# NOTE: Return the DetectorOptimizationConfiguration.xml parameters back to their initial default value
			# To monitor 'Detector Voltage' during the SampleList the 'Engineering Dashboard' tool can be set up to monitor 'HTPSU3_SUPPLY1_DEMAND_VOLT_SETTING'			


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@RealInstrumentOnly
Scenario Outline: ACQ-05 - ADO - No Expected Adjustment - Monitoring Parameter Settings (Detector Voltage, Baffle Position, Ion Energy)
	Given the Instrument <Polarity> and <Mode> is set
		And the following 'Instrument Setup Processes' have a 'Success' status for <Polarity>
			| Instrument Setup Processes |
			| ADC Setup                  |
			| Detector Setup             |
		And the initial 'Detector Voltage' is recorded for later comparison
		And the Fluidics Baffle position is set to 'Sample'
	When SampleList 'B' is run
	Then the 'Detector Voltage' will not change from the previously recorded value during the entire SampleList run
		And the System 1 'Entrance' value will automatically change to '0' (zero) during the ADO 'Noise Check' then revert back to its initial value for the remainder of the SampleList run
		# Monitor with Engineer Dashboard 'ENTRANCE_SETTING' value
		And the 'Baffle Position' will automatically change to REFERENCE (2) and back to SAMPLE (1) during samples 1, 2 and 4
		# Sample 3 is a standard ms acquisition with no ADO or LockSpray settings, so not Reference switching should occur.
		# Monitor with Engineer Dashboard 'SPRAYER_POSITION_STATUS' value
		And the 'Ion Energy' will automatically change to <Temporary Ion Energy Value> and back to the initial value during the first SampleList sample only
		# Monitor with Engineer Dashboard 'ION_ENERGY_SETTING' value
		And two 'Adjust complete' ADO Message will be reported
		# The 'Adjust complete' messages are for Samples 2 and 4
			
			Examples:
			| Polarity | Mode        | Temporary Ion Energy Value |
			| Positive | Sensitivity | -5                         |
			| Negative | Resolution  | +5                         |
			# NOTE: The 'Detector Voltage' is monitored again because in this scenario it is not expected that the value will change during the SampleList run

			
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------		
@RealInstrumentOnly
Scenario Outline: ACQ-06 - ADO - Noise Check Failure
	Given the \Typhoon\config\DetectorOptimizationConfiguration.xml has the following NoiseCheckConfiguration 'Parameter' and 'Value' set
		| Parameter    | Value |
		| ticThreshold | 0     |
		# Make a note of the initial default value before changing
		And Typhoon is restarted
		And the following ADC 'Parameter' for <Polarity> has been modified to increase the current ADC noise level
			| Parameter             |
			| Amplitude Threshold A |
			# Make a note of the initial 'Amplitude Threshold A' value before changing
		And the following 'Instrument Setup Processes' have a 'Success' status for <Polarity>
			| Instrument Setup Processes |
			| ADC Setup                  |
			| Detector Setup             |
		And the initial Detector Voltage is recorded for later comparison
		And the Instrument <Polarity> and <Mode> is set
	When SampleList 'A' is run
	Then the following 'ADO Messages' will be reported in sequence
		| ADO Message                                                                                |
		| Running Ion Area Check                                                                     |
		| - Run Noise Check -                                                                        |
		| Abort TIC: [a]                                                                             |
		| invalid conditions to run, noise check: failed, beam check: n/a, detector noise check: n/a |
		# Additional related messages may also be reported
		# where [a] is a value higher than the 'maximumTIC' value (0) set in DetectorOptimizationConfiguration.xml 
		And no 'Running Detector Adjust' ADO messages will be reported
		And when the SampleList acquisition has completed no method will be running
		And the current Detector Voltage remains unchanged from the initial recorded value
			
			Examples:
			| Polarity | Mode        |
			| Positive | Sensitivity |
			| Negative | Resolution  |
			# NOTE: Return the DetectorOptimizationConfiguration.xml 'beamTolerance' parameter back to its initial noted default value
			# NOTE: Return the ADC 'Amplitude Threshold A' parameter back to its initial noted default value		
			
			
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: ACQ-07 - ADO - Beam Check Failure
	Given the \Typhoon\config\DetectorOptimizationConfiguration.xml has the following 'Parameter' and 'Value' set
			| Parameter     | Value |
			| beamTolerance | 0.05  |
			# Make a note of the initial default value before changing
		And Typhoon is restarted
		And the following 'Instrument Setup Processes' have a 'Success' status for <Polarity>
			| Instrument Setup Processes |
			| ADC Setup                  |
			| Detector Setup             |
		And the initial Detector Voltage is recorded for later comparison
		And the Instrument <Polarity> and <Mode> is set
	When SampleList 'A' is run
	Then the following 'ADO Messages' will be reported in sequence
		| ADO Message                                                                                      |
		| Running Ion Area Check                                                                           |
		| beam check failed...                                                                             |
		| Running Ion Area Adjust                                                                          |
		| invalid conditions to run, noise check: passed, beam check: failed, detector noise check: passed |
		# Additional related messages may also be reported
		But 'Detector Degraded' or 'Detector Not Degradated' ADO messages will not be reported
		And the following Typhoon 'data_store RAW folders' are created with a non-zero '_func001.dat' file
			| data_store RAW folders |
			| ADO_Optimize.raw       |
			| ADO_Adjust_001.raw     |
		And when the SampleList acquisition has completed no method will be running
		And the current Detector Voltage remains unchanged from the initial recorded value
			
			Examples:
			| Polarity | Mode        |
			| Positive | Sensitivity |
			| Negative | Resolution  |
			# NOTE: Return the DetectorOptimizationConfiguration.xml 'beamTolerance' parameter back to its initial default value



#-------------------------- SampleList 'A' - (Sample '1' Optimise, Sample '2' Adjust) -------------------------------------------------------------------------------
# <SampleList>
#	<Repeat count="1">
#		<Sample>
#			<DataFile format="raw">ADO_Optimise.raw</DataFile>
#			<MethodFile>ms_ado.xml</MethodFile>
#		</Sample>
#		<Sample>
#			<DataFile format="raw">ADO_Adjust_001.raw</DataFile>
#			<MethodFile>ms_ado_adj.xml</MethodFile>
#		</Sample>
#	</Repeat>
# </SampleList>
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------


#-------------------------- SampleList 'B' - (Sample '1' Optimise, Sample '2' Adjust, Sample '3' NO Adjustment, Sample '4' Adjust) -----------------------------------
# <SampleList>
#	<Repeat count="1">
#		<Sample>
#			<DataFile format="raw">ADO_Optimise.raw</DataFile>
#			<MethodFile>ms_ado.xml</MethodFile>
#		</Sample>
#		<Sample>
#			<DataFile format="raw">ADO_Adjust_001.raw</DataFile>
#			<MethodFile>ms_ado_adj.xml</MethodFile>
#		</Sample>
#       <Sample>
#			<DataFile format="raw">ADO_NoAdjust_002.raw</DataFile>
#			<MethodFile>ms.xml</MethodFile>
#		</Sample>
#       <Sample>
#			<DataFile format="raw">ADO_Adjust_003.raw</DataFile>
#			<MethodFile>ms_ado_adj.xml</MethodFile>
#		</Sample>
#	</Repeat>
# </SampleList>
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END