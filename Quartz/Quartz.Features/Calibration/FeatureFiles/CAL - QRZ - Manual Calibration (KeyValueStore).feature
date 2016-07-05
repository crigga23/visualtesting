
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # CAL - QRZ - Manual Calibration
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher David Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 10-APR-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-494)                 # It shall be possible to calibrate the time-of-flight mass analyser using the procedure described in: “Osprey Fast Calibration Method “
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-353)                 # It shall be possible to store mass calibrations for each available instrument mode:
#                          #    m/z range 1 m/z range 2 m/z range 3 m/z range 4 m/z range 5
#                          #    Positive Ion Sensitivity & Resolution all ranges
#                          #    Negative Ion Sensitivity & Resolution all ranges
#                          #    [The m/z ranges are as defined in the Default Parameters document]
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-354)                 # It shall be possible to use an appropriate calibration for an analysis method. In the case where an appropriate calibration is not present, 
#                          # the user shall be able to nominate a calibration from another m/z range
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@Ignore
Feature: Manual Calibration - Data Analysis
	 In order to ensure that a slot is calibrated in the correct way
	 I want to be able to apply a Manual Calibration (combined with a pre or post Instrument Setup Mass Calibration) to a specific set of slots / polarity
	 So that Data Analysis reports the expected calibration type against the relevant slots
	 
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given that Detector Setup has been run for both polarities
		And data is recorded and available for Positive Sodium Formate
		And no Instrument Setup Calibration has been run
		And no Manual Calibration has been run
	
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: CAL-01 - Stored Calibration - after Manual Calibration only
		Given an initial Instrument Setup Mass Calibration status of <Initial IS Mass Cal>
			And an initial Manual Calibration status of <Initial Manual Cal>
		When the Calibration page is available
			And the 'Positive Sodium Formate' reference file is selected 
			And the background recorded Positive Sodium Formate data file is selected
			And the calibration is created and <Manual Cal Applied>
			And a Tune page acquisition is started
		Then Data Analysis will report a slot calibration status of <Stored Mass> 
			And Data Analysis will report a slot calibration status of <Stored POS RES> 
			And Data Analysis will report a slot calibration status of <Stored NEG RES> 
			And Data Analysis will report a slot calibration status of <Stored POS SENS> 
			And Data Analysis will report a slot calibration status of <Stored NEG SENS>
		When Typhoon is restarted 
			And a Tune page acquisition is started
		Then Data Analysia will report the same details for <Stored Mass> 
			And Data Analysis will report the same details for <Stored POS RES> 
			And Data Analysis will report the same details for <Stored NEG RES> 
			And Data Analysis will report the same details for <Stored POS SENS> 
			And Data Analysis will report the same details for <Stored NEG SENS>
			Examples:
			| Initial IS Mass Cal | Initial Manual Cal       | Manual Cal Applied | Stored Mass	  | Stored POS RES     | Stored NEG RES     | Stored POS SENS    | Stored NEG SENS  |
			| All slots - Not Run | Uncalibrated			 | Applied            | All           | Manual Calibration | Manual Calibration | Manual Calibration | Manual Calibration |
			| All slots - Success | Uncalibrated			 | Applied            | All           | Manual Calibration | Manual Calibration | Manual Calibration | Manual Calibration |
			| All slots - Success | Uncalibrated			 | Not Applied        | All           | IS Calibration     | IS Calibration     | IS Calibration     | IS Calibration     |
			| All slots - Not Run | Uncalibrated			 | Not Applied        | All           | No Calibration     | No Calibration     | No Calibration     | No Calibration     |
			# IS Calibration - Instrument Setup Calibration applied (i.e. not Manual Calibration)
			# Manual Calibration - Manual Calibration applied (i.e. not Instrument Setup Calibration)
			# Live calibration status can be obtained during acquisition for a specific Mass, Polarity and Optic mode...
			# ...by running 'AnalyseData.bat' located in 'C:\Waters Corporation\Typhoon\config\scripts\'

Scenario: CAL-02 - Stored Calibration - after Manual Calibration and Partial Instrument Setup Calibration		
		Given the initial 'Manual Calibration' status is that both polarities are 'Calibrated'
		When the following Instrument Setup Mass Calibration 'X' slots are successfully	calibrated 	
			| Mass  | POS RES | NEG RES | POS SENS | NEG SENS |
			| 600   | X       | X       | X        |          |
			| 1200  | X       | X       |          | X        |
			| 2000  | X       | X       | X        |          |
			| Other |         |         |          |          |
			And a Tune page acquisition is started
		Then Data Analysis will report the following slot calibration status
			| Stored Mass | Stored POS RES     | Stored NEG RES     | Stored POS SENS    | Stored NEG SENS    |
			| 600         | IS Calibration     | IS Calibration     | IS Calibration     | Manual Calibration |
			| 1200        | IS Calibration     | IS Calibration     | Manual Calibration | IS Calibration     |
			| 2000        | IS Calibration     | IS Calibration     | IS Calibration     | Manual Calibration |
			| Other       | Manual Calibration | Manual Calibration | Manual Calibration | Manual Calibration |
		When Typhoon is restarted 
			And a Tune page acquisition is started
		Then Data Analysis will report the same slot calibration status
			| Stored Mass | Stored POS RES     | Stored NEG RES     | Stored POS SENS    | Stored NEG SENS    |
			| 600         | IS Calibration     | IS Calibration     | IS Calibration     | Manual Calibration |
			| 1200        | IS Calibration     | IS Calibration     | Manual Calibration | IS Calibration     |
			| 2000        | IS Calibration     | IS Calibration     | IS Calibration     | Manual Calibration |
			| Other       | Manual Calibration | Manual Calibration | Manual Calibration | Manual Calibration | 
			# IS Calibration - Instrument Setup Calibration applied (i.e. not Manual Calibration)
			# Manual Calibration - Manual Calibration applied (i.e. not Instrument Setup Calibration)
			# 'Other' represents Masses 5000, 8000, 14000, 32000 and 70000
			# Live calibration status can be obtained during acquisition for a specific Mass, Polarity and Optic mode...
			# ...by running 'AnalyseData.bat' located in 'C:\Waters Corporation\Typhoon\config\scripts\'


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END
