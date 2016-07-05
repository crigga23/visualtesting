

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Instrument Setup (Calibration) - Fluidics
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 25-FEB-15 (latest update 10-Oct-15)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Calibrant peaks should be available when reservoir 'C' is selected for Sample
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Calibrant peaks should be available when reservoir 'C' is selected for Sample
#                          # NOTE: To avoid contamination, do not select reservoir 'C  for Reference fluidics
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (04-Sep-15) - Removed Scenario CAL-02 based on comments in FW#6132
#                          # (04-Sep-15) - Changed Mass table in CAL-01 to reflect changes in Instrument Setup High Mass values
#                          # (10-Oct-15) - Updates to reflect changes in functionality due to FW#7327 and FW#7325
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-563)                 # The system automatically configures the instrument's fluidics as required for each stage of the instrument setup process. 
#                          # The baffle position, reservoir, flow path, flow rate will be configurable. 
#                          # Optionally a minimum flow time can also be configured and a refill will result if required.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Future Release:          #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-564)                 # After instrument setup completes all applicable stages the fluidics should be returned the baffle position, 
#                          # flow path and flow rate that existed prior to the run.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


Feature: Instrument Setup (Calibration) - Fluidics
	In order to run Mass Calibration within Instrument Setup successfully regardless of initial Tune Page fluidics settings 
	I want to be able to click Instrument Setup 'Run'
	So that the Instrument Setup process completes successfully for Mass Calibration without any fluidics manual intervention


Background:
	Given the instrument Setup slots have been 'Reset'
	And the following Instrument Setup 'Processes' have been successfully run for all available slots 
		| Processes               |
		| ADC Setup               |
		| Detector Setup          |
		| Resolution Optimisation |	


# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: CAL-01 - InstrumentSetupFluidics - Mass Calibration (All Applicable Slots)
		Given the 'InstrumentSetupConfiguration.xml' has <XML Reservoir> <XML FlowRate> <XML FlowPath> and <XML BafflePosition> set for Instrument Setup 'Mass Calibration'
		# See below 'Examples' tables for these XML values
			And the Tune Page <XML BafflePosition> fluidics <Initial Infusion> is set
			And the Tune Page <XML BafflePosition> fluidics <Initial Reservoir> is set
			And the Tune Page <XML BafflePosition> fluidics <Initial Flow Path> is set
			And the Tune Page <XML BafflePosition> fluidics <Initial Flow Rate> is set
			And the Tune Page Fluidics <Initial Baffle> position is set
		When the Instrument Setup process has been configured to run with Mass Calibration with the following 'X' slots set to 'ON'
				| Mass  | POS RES | NEG RES | POS SENS | NEG SENS |
				| 1000  |    X    |    X    |    X     |    X     |
				| 2000  |         |         |          |          |
				| 4000  |         |         |          |          |
			And the Instrument Setup process is 'Run' 
		Then 'Progress Log' messages will indicate that fluidics are being set up
			# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			And before Instrument Setup 'Mass Calibration' starts progressing the Tune Page <XML BafflePosition> fluidics Reservoir will automatically be set to <XML Reservoir>
			And before Instrument Setup 'Mass Calibration' starts progressing the Tune Page <XML BafflePosition> fluidics Infusion Flow Rate will automatically be set to <XML FlowRate>
			And before Instrument Setup 'Mass Calibration' starts progressing the Tune Page <XML BafflePosition> fluidics Flow Path will automatically be set to <XML FlowPath>
			# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			And before Instrument Setup 'Mass Calibration' starts progressing there will be an <XML BafflePosition> fluidics <Refill>
			# Only if no Reservoir change is required and the intial Reservoir level is too low 
			And before Instrument Setup 'Mass Calibration' starts progressing there will be a <Purge Delay>
			# Only if a Reservoir change is required
			# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			And before Instrument Setup 'Mass Calibration' starts progressing the Tune Page 'Baffle' position will automatically be set to <XML Baffle>
			And before Instrument Setup 'Mass Calibration' starts progressing the Tune Page <XML BafflePosition> fluidics Infusion status will automatically change to 'Running'
			# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			And Tune Page fluidics settings other than <XML BafflePosition> fluidics will remain unchanged
			# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			And before Instrument Setup 'Mass Calibration' starts progressing there will be an intensity settling for the <XML BafflePosition> fluidics
			# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			And Instrument Setup will eventually complete with a <Result>
			
			# Future Release - Instrument Settings Returning to their pre-run settings
			# And after Instrument Setup has completed the <XML BafflePosition> fluidics Reservoir will remain at <Initial Reservoir> 
			# And after Instrument Setup has completed the <XML BafflePosition> fluidics Infusion will be set back to <Initial Infusion>
			# And after Instrument Setup has completed the <XML BafflePosition> fluidics Flow Path will be set back to <Initial Flow Path>
			# And after Instrument Setup has completed the <XML BafflePosition> fluidics Flow Rate will be set back to <Initial Flow Rate>
			# And after Instrument Setup has completed the Baffle will be set back to <Initial Baffle> 
			# -----------------------------------------------------------------------------------------------
		
				Examples: XML Baffle Position Sample - Various 'Initial' Settings
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result                      |
				| C             | 10.0         | Infusion     | Sample             | Idle             | Wash              | Waste             | 10.0              | Sample         | Yes         | No     | All enabled slots 'Success' |
				| C             | 10.0         | Infusion     | Sample             | Running          | A                 | Infusion          | 0.9               | Sample         | Yes         | No     | All enabled slots 'Success' |
				| C             | 10.0         | Infusion     | Sample             | Running          | B                 | Combined          | 5.5               | Sample         | Yes         | No     | All enabled slots 'Success' |
				| C             | 10.0         | Infusion     | Sample             | Running          | C                 | LC                | 11.1              | Sample         | No          | No     | All enabled slots 'Success' |

				Examples: Sample Refill Based on Syringe Level
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result                      |
				| C             | 10.0         | Infusion     | Sample             | Idle - Full      | C                 | Infusion          | 10.0              | Sample         | No          | No     | All enabled slots 'Success' |
				| C             | 10.0         | Infusion     | Sample             | Idle - 6 mins    | C                 | Infusion          | 10.0              | Sample         | No          | No     | All enabled slots 'Success' |
				| C             | 10.0         | Infusion     | Sample             | Idle - 4 mins    | C                 | Infusion          | 10.0              | Sample         | No          | Yes    | All enabled slots 'Success' |
				| C             | 10.0         | Infusion     | Sample             | Idle - Empty     | C                 | Infusion          | 10.0              | Sample         | No          | Yes    | All enabled slots 'Success' |
				# It is assumed that for the Refill to occur when expected, that the Detector Setup 'InfusionFlowTime' parameter within 'InstrumentSetupConfiguration.xml' is set to 5 minutes (300 seconds)
				
				Examples: Expected Success with Different 'XML FlowRate' Parameter
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result                      |
				| C             | 22.2         | Infusion     | Sample             | Idle             | C                 | Infusion          | 10.0              | Sample         | No          | No     | All enabled slots 'Success' |

				Examples: Expected Fail due to Wrong 'XML Reservoir' and 'XML BafflePosition' Parameter
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result                      |
				| B             | 10.0         | Infusion     | Reference          | Running          | Wash              | Infusion          | 10.0              | Sample         | No          | No     | All enabled slots 'Failed'  |
				# NOTE: This is the only test that will use anything other than BafflePosition 'Sample' for Mass Calibration but to avoid contamination of the Reference fluidics with calibrant solution, Reservoir 'B' must be used

				Examples: Wrong 'XML FlowPath' Parameter
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result                      |
				| C             | 10.0         | Combined     | Sample             | Running          | C                 | Infusion          | 10.0              | Sample         | No          | No     | All enabled slots 'Success' |
				| C             | 10.0         | LC           | Sample             | Running          | C                 | Infusion          | 10.0              | Sample         | No          | No     | All enabled slots 'Error'   |
				| C             | 10.0         | Waste        | Sample             | Running          | C                 | Infusion          | 10.0              | Sample         | No          | No     | All enabled slots 'Error'   |
				
				Examples: Out of Range Parameters
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result                      |
				| 4             | 10.0         | Infusion     | Sample             | Running          | C                 | Infusion          | 10.0              | Sample         | No          | No     | All enabled slots 'Success' |
				| C             | 10.0         | 4            | Sample             | Running          | C                 | Infusion          | 10.0              | Sample         | No          | No     | All enabled slots 'Success' |
				| C             | 10.0         | Infusion     | 2                  | Running          | C                 | Infusion          | 10.0              | Sample         | No          | No     | All enabled slots 'Success' |
				
				# Where 'Initial Infusion' syringe time or level is not defined above, it is assumed there is sufficient that an automatic refill will not be performed.
				# 'InstrumentSetupConfiguration.xml' is located in 'C:\Waters Corporation\Typhoon\config'
				# It is assumed that all relevant parameters ('Reservoir', 'FlowRate', 'FlowPath', 'BafflePosition' and 'InfusionFlowTime' ) have been specified in the 'InstrumentSetupConfiguration.xml' file
				# 'InstrumentSetupConfiguration.xml' fluidics parameters are stored in numeric format as below:
				# 'InstrumentSetupConfiguration.xml' Reservoir parameters:                     0 = A,        1 = B,        2 = C,  3 = Wash
				# 'InstrumentSetupConfiguration.xml' Baffle parameters:                        0 = Sample,   1 = Reference
				# 'InstrumentSetupConfiguration.xml' Sample (Baffle 0) FlowPath parameters:    0 = Infusion, 1 = Combined, 2 = LC, 3 = Waste
				# 'InstrumentSetupConfiguration.xml' Reference (Baffle 1) FlowPath parameters: 0 = Infusion, 1 = Waste
				# 'InstrumentSetupConfiguration.xml' InfusionFlowTime:                         Specified in seconds
				
				# IMPORTANT: Although details for setting the Baffle to 'Reference' are shown above, 
				#            putting a calibrant through the Reference should be avoided wherever possible on a real instrument
				#            to avoid contamination of the Reference fluidics lines
				

# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
