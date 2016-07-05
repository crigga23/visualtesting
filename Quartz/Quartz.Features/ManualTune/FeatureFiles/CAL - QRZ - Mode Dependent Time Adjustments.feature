
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Time Adjustments (Mode Dependent)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 01-APR-2016
#                          # 20-May-2016 (UPDATED)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # See 'Manual Test Notes' below
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #  
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # AnalyseData tool available:
#                          # Quartz: \Waters Corporation\Typhoon\config\scripts\AnalyseData.bat
#                          # UNIFI:  \Waters\UNIFI\Instruments\Osprey\2.0.0\Typhoon\config\scripts\AnalyseData.bat
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # 20-May-2016 (Chris D Hughes) - clarification of timing information matching across modes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@Ignore
Feature: Time Adjustments (Mode Dependent)
	In order to ensure that acquisition Time Adjustment information is mode specific and different across polarity
	I want to be able to run an acquisition in a specific mode
	So that timing information is made available for that specific mode


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@Updated
Scenario Outline: QRZ-01 - Time Adjustment (Mode Specific)
	When a Tune page acquisition is started for <Polarity> <OpticMode> with Mass Range of '1000'
		And the 'AnalyseData' tool is run
	Then the 'AnalyseData' tool will show the acquisition mode as <Polarity> <OpticMode> 
		And the 'AnalyseData' tool will show the 'Time Adjustments' mode as <Polarity> <OpticMode> 
	 	# Each table will have information in the form...
		#
		#	Table Name:
		#	 mass/time     n.nnn, n.nnn
		#	1:    1.00000, n.nnn, n.nnn
		#	2: Mass Range, n.nnn, n.nnn
		#
		# Where 'Table Name' is the name of the specific Time Adjustment table (Calibration, Alighment, HS lookup)
		# Where n.nnn is a time and
		# Where 'Mass Range' is the current acquisition Mass Range (i.e. 1000)
		
			Examples:
			| Polarity | OpticMode   |
			| Positive | Sensitivity |
			| Positive | Resolution  |
			| Negative | Sensitivity |
			| Negative | Resolution  |

			
# ---------------------------------------------------------------------------------------------------------------------------------------------------	 
@Updated
Scenario: QRZ-02 - Time Adjustment (Changes Across Polarity)
	Given the 'AnalyseData' output has been recorded for each 'Polarity' and 'OpticMode' with Mass Range of '1000'
		| Polarity | OpticMode   |
		| Positive | Sensitivity |
		| Positive | Resolution  |
		| Negative | Sensitivity |
		| Negative | Resolution  |
	Then the 'AnalyseData' output will show 'Matching Time Adjustment' table information for the following 
		| Matching Time Adjustment |
		| Positive Sensitivity     |
		| Negative Sensitivity     |
		And the 'AnalyseData' output will show 'Matching Time Adjustment' table information for the following 
			| Matching Time Adjustment |
			| Positive Resolution      |
			| Negative Resolution      |	
		And the 'AnalyseData' table information between 'Sensitivity' and 'Resolutions' modes will show some differences

			
#------------------------------------------------------------------------------------------------------------------------------------------------------
#END