# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - ADC2
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    #          05-MAY-15
#                          # UPDATED: 27-JUN-16
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # ADC2 hardware is fitted to a real instrument
#                          #
#                          # Osprey Default Parameters 721006299 is available
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (01-MAR-16) Post review updates
#                          # (27-JUN-16) - Updates after Vion v1.1 testcase execution, mainly due to changes associated with FW#9195
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-276)                 # ADC page will be available with required set of settings both for ADC v1 and ADC v2. 
#                          # Switching ADC configuration should be available via command line bat file or switched automatically by the installer.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-278)                 # Automatic setup routine will be available to sync two ADC2 data channels.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-280)                 # Automatic setup routine will be available to run baseline setup.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@Ignore
Feature: ADC2
	 In order to check that ADC2 Setup and Synchronisation occurs successfully
	 I want to be able to run the Instrument Setup 'ADC Setup' process
	 So that the expected parameters are updated and the two ADC signals are seen to be in sync
	 
	
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@updated
Scenario Outline: TUN-01 - ADC2 GUI Elements
	Given the Instrument <Polarity> is selected
	When the 'ADC2' tab is selected
	Then the following 'Dropdowns' with selectable 'Options' and intial 'Defaults' will be available 
		| Dropdowns               | Options                                       | Defaults |
		| ADC Algorithm           | ADC, Avg, TDC, PkDet TDC                      | ADC      |
		| Input Channel           | A, B, Dual                                    | A        |
		| Signal Source           | Detector, Test Signal                         | Detector |
		| Pulse Shaping           | ON, OFF                                       | ON       |
				
		Examples: 
		| Polarity |
		| Positive |
		| Negative |
					
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------		
@updated
Scenario: TUN-02a - ADC Setup (POSITIVE only) - Successful Parameter Population with Valid Ranges
	Given Instrument Setup has been 'Reset'
		And the 'Positive ADC2 Parameters' have been set to the following initial 'Value'
			| Positive ADC2 Parameters | Value |
			| DC Bias A                | 0.110 |
			| Amplitude Threshold A    | 10    |
			| Baseline Mean A          | 10    |
			| DC Bias B                | 0.110 |
			| Amplitude Threshold B    | 10    |
			| Baseline Mean B          | 10    |
			| Time Delay B             | 110   |
			| Channel B Multiplier     | 1.10  |
		And the 'Negative ADC2 Parameters' have been set to the following initial 'Value'
			| Negative ADC2 Parameters | Value |
			| DC Bias A                | 0.220 |
			| Amplitude Threshold A    | 20    |
			| Baseline Mean A          | 20    |
			| DC Bias B                | 0.220 |
			| Amplitude Threshold B    | 20    |
			| Baseline Mean B          | 20    |
	When the Instrument Setup 'ADC Setup' process is started for 'POSITIVE' only
		And the process completes successfully
	Then the 'Positive ADC2 Parameters' will be determined in the order listed below within a 'Normal Range'
	    # Although it is possible to manually enter values that may be outside the 'Normal Range' specified below, 
		# when the ADC algorithm runs it should normally determine values that are within this 'Normal Range' otherwise it suggests there is potentially something wrong
		# If values are outside the 'Normal Range' after ADC Setup has run successfully, this should be flagged to the Eval / Dev Lead.
		| Positive ADC2 Parameters | Normal Range     |
		| DC Bias A                | -0.400 to -1.000 |
		| Amplitude Threshold A    |      1 to 50     |
		| Baseline Mean A          |      0 to 10     |
		| DC Bias B                | -0.400 to -1.000 |
		| Amplitude Threshold B    |      1 to 50     |
		| Baseline Mean B          |      0 to 10     |
		| Time Delay B             |      0 to 8191   |
		| Channel B Multiplier     |     25 to 35     |
		And the following 'Negative ADC2 Parameters' will remain unchanged at their initial 'Value'
			| Negative ADC2 Parameters | Value |
			| DC Bias A                | 0.220 |
			| Amplitude Threshold A    | 20    |
			| Baseline Mean A          | 20    |
			| DC Bias B                | 0.220 |
			| Amplitude Threshold B    | 20    |
			| Baseline Mean B          | 20    |
		And the following 'ADC2 Parameter' values will be the same in positive and negative modes
			| ADC2 Parameter       |
			| Time Delay B         |
			| Channel B Multiplier |
		And when Typhoon is restarted the same positive and negative 'ADC Parameter' values should be present

@updated		
Scenario: TUN-02b - ADC Setup (NEGATIVE only) - Successful Parameter Population with Valid Ranges
	Given Instrument Setup has been 'Reset'
		And the 'Positive ADC2 Parameters' have been set to the following initial 'Value'
			| Positive ADC2 Parameters | Value |
			| DC Bias A                | 0.110 |
			| Amplitude Threshold A    | 10    |
			| Baseline Mean A          | 10    |
			| DC Bias B                | 0.110 |
			| Amplitude Threshold B    | 10    |
			| Baseline Mean B          | 10    |
			| Time Delay B             | 110   |
			| Channel B Multiplier     | 1.10  |
		And the 'Negative ADC2 Parameters' have been set to the following initial 'Value'
			| Negative ADC2 Parameters | Value |
			| DC Bias A                | 0.220 |
			| Amplitude Threshold A    | 20    |
			| Baseline Mean A          | 20    |
			| DC Bias B                | 0.220 |
			| Amplitude Threshold B    | 20    |
			| Baseline Mean B          | 20    |
	When the Instrument Setup 'ADC Setup' process is started for 'NEGATIVE' only
		And the process completes successfully
	Then the following 'Positive ADC2 Parameters' will remain unchanged at their initial 'Value'
		| Positive ADC2 Parameters | Value |
		| DC Bias A                | 0.110 |
		| Amplitude Threshold A    | 10    |
		| Baseline Mean A          | 10    |
		| DC Bias B                | 0.110 |
		| Amplitude Threshold B    | 10    |
		| Baseline Mean B          | 10    |
		| Time Delay B             | 110   |
		| Channel B Multiplier     | 1.10  |
		And the 'Negative ADC2 Parameters' will be determined in the order listed below within a 'Normal Range'
		# Although it is possible to manually enter values that may be outside the 'Normal Range' specified below, 
		# when the ADC algorithm runs it should normally determine values that are within this 'Normal Range' otherwise it suggests there is potentially something wrong
		# If values are outside the 'Normal Range' after ADC Setup has run successfully, this should be flagged to the Eval / Dev Lead.
			| Negative ADC2 Parameters | Normal Range     |
			| DC Bias A                | -0.400 to -1.000 |
			| Amplitude Threshold A    |      1 to 50     |
			| Baseline Mean A          |      0 to 10     |
			| DC Bias B                | -0.400 to -1.000 |
			| Amplitude Threshold B    |      1 to 50     |
			| Baseline Mean B          |      0 to 10     |
		And the following 'ADC2 Parameter' values will be the same in positive and negative modes
			| ADC2 Parameter       |
			| Time Delay B         |
			| Channel B Multiplier |
		And when Typhoon is restarted the same positive and negative 'ADC Parameter' values should be present

@updated
Scenario: TUN-02c - ADC Setup (POSITIVE and NEGATIVE) - Successful Parameter Population with Valid Ranges
	Given Instrument Setup has been 'Reset'
		And the 'Positive ADC2 Parameters' have been set to the following initial 'Value'
			| Positive ADC2 Parameters | Value |
			| DC Bias A                | 0.110 |
			| Amplitude Threshold A    | 10    |
			| Baseline Mean A          | 10    |
			| DC Bias B                | 0.110 |
			| Amplitude Threshold B    | 10    |
			| Baseline Mean B          | 10    |
			| Time Delay B             | 110   |
			| Channel B Multiplier     | 1.10  |
		And the 'Negative ADC2 Parameters' have been set to the following initial 'Value'
			| Negative ADC2 Parameters | Value |
			| DC Bias A                | 0.220 |
			| Amplitude Threshold A    | 20    |
			| Baseline Mean A          | 20    |
			| DC Bias B                | 0.220 |
			| Amplitude Threshold B    | 20    |
			| Baseline Mean B          | 20    |
	When the Instrument Setup 'ADC Setup' process is started for 'POSITIVE and NEGATIVE' modes together
		And the process completes successfully for both polarities
	Then the 'Positive ADC2 Parameters' will be determined in the order listed below within a 'Normal Range'
		# Although it is possible to manually enter values that may be outside the 'Normal Range' specified below, 
		# when the ADC algorithm runs it should normally determine values that are within this 'Normal Range' otherwise it suggests there is potentially something wrong
		# If values are outside the 'Normal Range' after ADC Setup has run successfully, this should be flagged to the Eval / Dev Lead.
		| Positive ADC2 Parameters | Normal Range     |
		| DC Bias A                | -0.400 to -1.000 |
		| Amplitude Threshold A    |      1 to 50     |
		| Baseline Mean A          |      0 to 10     |
		| DC Bias B                | -0.400 to -1.000 |
		| Amplitude Threshold B    |      1 to 50     |
		| Baseline Mean B          |      0 to 10     |
		| Time Delay B             |      0 to 8191   |
		| Channel B Multiplier     |     25 to 35     |
		And the 'Negative ADC2 Parameters' will be determined in the order listed below within a 'Normal Range'
			| Negative ADC2 Parameters | Normal Range     |
			| DC Bias A                | -0.400 to -1.000 |
			| Amplitude Threshold A    |      1 to 50     |
			| Baseline Mean A          |      0 to 10     |
			| DC Bias B                | -0.400 to -1.000 |
			| Amplitude Threshold B    |      1 to 50     |
			| Baseline Mean B          |      0 to 10     |
		And the following 'ADC2 Parameter' values will be the same in 'Positive' and 'Negative' modes
			| ADC2 Parameter       |
			| Time Delay B         |
			| Channel B Multiplier |
		And when Typhoon is restarted the same positive and negative 'ADC Parameter' values should be present

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------	
@updated
Scenario Outline: TUN-03a - ADC Setup (POSITIVE and NEGATIVE) - Successful Re-run within Tolerance (after Instrument Setup 'Reset')
	Given that the Instrument Setup 'ADC Setup' process has already been run successfully for 'Positive' and 'Negative' modes
		And the 'ADC Parameters' initial values have been recorded separately for each polarity
			| ADC2 Parameters       | 
			| DC Bias A             |
	        | Amplitude Threshold A |
			| Baseline Mean A       |
			| DC Bias B             |
		    | Amplitude Threshold B |
		    | Baseline Mean B       |
		    | Time Delay B          |
		    | Channel B Multiplier  |
	When Instrument Setup is 'Reset'
		And the Instrument Setup 'ADC Setup' process is run again for 'Positive' and 'Negative' polarities together
		And the process completes successfully for both polarities
	Then the final 'ADC2 Parameters' values for 'Positive' and 'Negative' will be within the following 'Tolerance' of their initial recorded value
		| ADC2 Parameters       | Tolerance |
		| DC Bias A             | +/- 0.003 |
		| Amplitude Threshold A | +/- 3     |
		| Baseline Mean A       | +/- 2     |
		| DC Bias B             | +/- 0.003 |
		| Amplitude Threshold B | +/- 3     |
		| Baseline Mean B       | +/- 2     |
		| Time Delay B          | +/- 1     | 
		| Channel B Multiplier  | +/- 0.5   | 
		# The above 'Tolerance' values have been suggested by Witold

@updated				
Scenario Outline: TUN-03b - ADC Setup (POSITIVE and NEGATIVE) - Successful Re-run within Tolerance (after Typhoon Restart and Instrument Setup 'Reset')
	Given that the Instrument Setup 'ADC Setup' process has already been run successfully for 'Positive' and 'Negative' modes
		And the 'ADC Parameters' initial values have been recorded separately for each polarity
			| ADC2 Parameters       | 
			| DC Bias A             |
	        | Amplitude Threshold A |
			| Baseline Mean A       |
			| DC Bias B             |
		    | Amplitude Threshold B |
		    | Baseline Mean B       |
		    | Time Delay B          |
		    | Channel B Multiplier  |
	When Typhoon is Restarted
		And Quartz is Refreshed and successful Logged into again
		And Instrument Setup is Reset
		And the Instrument Setup 'ADC Setup' process is run again for 'Positive' and 'Negative' polarities together
		And the process completes successfully for both polarities
	Then the final 'ADC2 Parameters' values for 'Positive' and 'Negative' will be within the following 'Tolerance' of their initial recorded value
		| ADC2 Parameters       | Tolerance |
		| DC Bias A             | +/- 0.003 |
		| Amplitude Threshold A | +/- 3     |
		| Baseline Mean A       | +/- 2     |
		| DC Bias B             | +/- 0.003 |
		| Amplitude Threshold B | +/- 3     |
		| Baseline Mean B       | +/- 2     |
		| Time Delay B          | +/- 1     | 
		| Channel B Multiplier  | +/- 0.5   | 
		# The above 'Tolerance' values have been suggested by Witold
		

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------	
@updated
@ManualOnly
Scenario Outline: TUN-04 - ADC Setup (POSITIVE and NEGATIVE) - Dual Channel Failure
	Given the following 'Parameter Name' values have been modified within the '\Typhoon\config\InstrumentSetupConfiguration.xml' file
		| Parameter Name         | Modified Value |
		| AmplifierThresholdLow  | 0.1            |
		| AmplifierThresholdHigh | 0.2            |
		# Record the original parameter values before modifying
      	# This was done to get the process to fail as close to the end of the process as possible without physically removing ADC cables, which may not be possible when the instrument panels are fitted
		And Typhoon is restarted
		And the following 'ADC2 Parameters' have been set to <Initial Values> in 'Positive and 'Negative' polarities
			| ADC2 Parameters        |
			| DC Bias A             |
			| Amplitude Threshold A |
			| Baseline Mean A       |
			| DC Bias B             |
			| Amplitude Threshold B |
			| Baseline Mean B       |
			| Time Delay B          |
			| Channel B Multiplier  |
	When the Instrument Setup 'ADC Setup' process is started for 'Positive' and 'Negative' polarities together
		And the process is NOT successful for 'Positive'
		And the process IS successful for 'Negative'
	Then the following 'ADC2 Parameters' will be reset back to their <Initial Values> for 'Positive'
		| ADC2 Parameters       |
		| DC Bias A             |
		| Amplitude Threshold A |
		| Baseline Mean A       |
		| DC Bias B             |
		| Amplitude Threshold B |
		| Baseline Mean B       |
		| Time Delay B          |
		| Channel B Multiplier  |
		And the following 'ADC2 Parameters' will stay at their <Initial Values> for 'Negative'
			| ADC2 Parameters       |
			| DC Bias A             |
			| Amplitude Threshold A |
			| Baseline Mean A       |
			| DC Bias B             |
			| Amplitude Threshold B |
			| Baseline Mean B       |
		
			Examples:
			| Initial Values |
			| Minimum        |
			| Maximum        |
		
			# NOTE: Return the '\Typhoon\config\InstrumentSetupConfiguration.xml' file 'AmplifierThresholdLow' and 'AmplifierThresholdHigh' parameter values to their original value before modification, then Restart Typhoon.
				

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------	
@updated
@ManualOnly
Scenario: TUN-05a - ADC Setup (NOT RUN) - BPI Mass and Intensity Pre / Post run (Internal Test Signal) - Positive Only
	Given the Instrument electronics have just been reset
		And the Instrument Setup 'ADC Setup' process has not been run
		And the Instrument polarity is set to 'Positive'
		And the DC Bias A and B values have been manually set to remove the MZ plot noise
		# This is so the test signal can be seen clearly over the noise.
	When the following 'Signal Source' and 'Input Channel' values are set
		| Signal Source | Input Channel |
	    | Test Signal   | A             |
		And the Test Signal channel 'A' m/z is recorded to 4dp
		# Manually zoom into the MZ plot to determine the Test Signal peak m/z
		And the XIC TIC Intensity is recorded
		# Zoom into the peak on the MZ plot then SHIFT-Right click drag across the whole test signal peak to generate an XIC plot... 
		# ...the TIC Intensity should then be available (top right) within the XIC plot for the selected range
		And the following 'Signal Source' and 'Input Channel' values are set
			| Signal Source | Input Channel |
			| Test Signal   | B             |
		And the Test Signal channel 'B' m/z is recorded to 4dp
		# Manually zoom into the MZ plot to determine the Test Signal peak m/z
		And the XIC TIC Intensity is recorded
		# Zoom into the peak on the MZ plot then SHIFT-Right click drag across the whole test signal peak to generate an XIC plot... 
		# ...the TIC Intensity should then be available (top right) within the XIC plot for the selected range
	Then the recorded Input Channel 'A' and 'B' m/z will not match
		And the recorded 'XIC Intensity Results' for the Input Channel 'A' and 'B' will not match
		

@updated
@ManualOnly
Scenario: TUN-05b - ADC Setup (RUN SUCCESSFULLY) - BPI Mass and Intensity Pre / Post run (Internal Test Signal) - Positive Only
	Given the Instrument Setup 'ADC Setup' process has been run successfully for 'Positive' 
		And the Instrument polarity is set to 'Positive' 
	When the following 'Signal Source' and 'Input Channel' values are set
		| Signal Source | Input Channel |
	    | Test Signal   | A             |
		# IMPORTANT NOTE: When the 'Input Channel' is changed, Tuning must be Aborted and Restarted for the correct channel to take effect.
		And the Test Signal channel 'A' m/z is recorded to 4dp
		# Manually zoom into the MZ plot to determine the Test Signal peak m/z
		And the XIC TIC Intensity is recorded
		# Zoom into the peak on the MZ plot then SHIFT-Right click drag across the whole test signal peak to generate an XIC plot... 
		# ...the TIC Intensity should then be available (top right) within the XIC plot for the selected range
		And the following 'Signal Source' and 'Input Channel' values are set
			| Signal Source | Input Channel |
			| Test Signal   | B             |
			# IMPORTANT NOTE: When the 'Input Channel' is changed, Tuning must be Aborted and Restarted for the correct channel to take effect.
		And the Test Signal channel 'B' m/z is recorded to 4dp
		# Manually zoom into the MZ plot to determine the Test Signal peak m/z
		And the XIC TIC Intensity is recorded
		# Zoom into the peak on the MZ plot then SHIFT-Right click drag across the whole test signal peak to generate an XIC plot... 
		# ...the TIC Intensity should then be available (top right) within the XIC plot for the selected range
	Then the recorded Input Channel 'A' and 'B' m/z values will match to 4dp
		And the recorded 'XIC Intensity' values for Input Channel 'A' and 'B' will match to within 3%


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------	
@ManualOnly
Scenario Outline: TUN-06 -  Automatic ADC2 Setup - BPI Mass and Intensity Post run (Real Detector Signal)
	Given the Instrument Setup 'ADC Setup' process has been run successfully for <Polarity>
		And Instrument Setup 'Detector Setup' process has been run successfully for <Polarity>
		And the Veff has been properly determined for <Polarity> <Mode>
		And the Instrument is set to <Polarity> and <Mode>
		And a good Leucine Enkephalin beam is present
		And a Custom Tune XML file is loaded that contains <Start Mass> and <End Mass> with the following additional parameters
			| Setting   | Value        |
			| TOFMode   | TOF          |
			| Type      | MS           |
			| ScanTime  | 5.0          |
	When the following 'Signal Source' and 'Input Channel' values are set
		| Signal Source | Input Channel |
	    | Detector      | B             |
		# IMPORTANT NOTE: When the 'Input Channel' is changed, Tuning must be Aborted and Restarted for the correct channel to take effect.
		And the detector voltage automatically determined by Detector Setup is manually increased by 100
		# NOTE: This is done to ensure there is a Channel B peak present to record in the next step...
		And the Detector channel 'B' m/z is recorded
		# NOTE: if the channel 'B' m/z peak is not intense enough to measure, then increase the Detector Voltage in increments until it is
		And the BPI Intensity is recorded for the channel 'B' peak
		And the following 'Signal Source' and 'Input Channel' values are set
		| Signal Source | Input Channel |
	    | Detector      | A             |
		# IMPORTANT NOTE: When the 'Input Channel' is changed, Tuning must be Aborted and Restarted for the correct channel to take effect.
		And the Detector channel 'A' m/z is recorded
		And the BPI Intensity is recorded for the channel 'A' peak
	Then the m/z for Input Channel 'A' and 'B' will be within at least 2dp 
		And the BPI Intensity for Input Channel 'A' will be substantially greater than Channel 'B'
		# Tests on a real instrument have indicated that for a Channel 'A' intensity of 3e+05 the Channel 'B' intensity should generally be at least a factor of 50 or more weaker.
		# Manually zoom into the MZ plot to determine the Detector peak m/z
        # BPI Intensity to be determined by selecting the BPI plot and viewing the blue Intensity value displayed (top-right)
		# Return the Detector Voltage to the value initially determined by Detector Setup

		Examples:
		| Polarity | Mode        | Start Mass | End Mass |
		| Positive | Sensitivity | 556        | 557      |
		| Negative | Resolution  | 554        | 555      |

		
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END