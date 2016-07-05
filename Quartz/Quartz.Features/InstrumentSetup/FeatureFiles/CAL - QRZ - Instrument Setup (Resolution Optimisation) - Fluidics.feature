
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Instrument Setup (Resolution Optimisation) - Fluidics 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 30-MAR-15 (updated 01-OCT-15)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (01-OCT-15) Updates to reflect changes in functionality due to FW#7327 and FW#7325 
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


Feature: Instrument Setup (Resolution Optimisation) - Fluidics
	In order to run Resolution Optimisation within Instrument Setup successfully regardless of initial Tune Page fluidics settings 
	I want to be able to click Instrument Setup 'Run'
	So that the Instrument Setup process completes successfully for Resolution Optimisation without any fluidics manual intervention

# ---------------------------------------------------------------------------------------------------------------------------------------------------
	@Ignore
	@updated
	Scenario: DSU-01 - InstrumentSetupFluidics - Resolution Optimisation (Both Polarities) - General Fluidics Control
		Given the 'InstrumentSetupConfiguration.xml' has <XML Reservoir> <XML FlowRate> <XML FlowPath> and <XML BafflePosition> set for Instrument Setup 'Resolution Optimisation'
		# See below 'Examples' tables for these XML values
			And the Tune Page <XML BafflePosition> fluidics <Initial Infusion> is set
			And the Tune Page <XML BafflePosition> fluidics <Initial Reservoir> is set
			And the Tune Page <XML BafflePosition> fluidics <Initial Flow Path> is set
			And the Tune Page <XML BafflePosition> fluidics <Initial Flow Rate> is set
			And the Tune Page fluidics <Initial Baffle> position is set
		When the Instrument Setup slot statuses have been 'Reset' 
			And Instrument Setup has the following processes set
				| Process                 | Positive   | Negative   |
				| ADC Setup               | ON         | ON         |
				| Detector Setup          | ON         | ON         |
				| Lock CCS Calibration    | OFF        | OFF        |
				| Resolution Optimisation | ON  - Both | ON  - Both |
				| Mass Calibration        | OFF - All  | OFF - All  |
				| CCS Calibration         | OFF        | OFF        |
			And the Instrument Setup process is 'Run' 
		Then 'Progress Log' messages will indicate that fluidics are being set up
			And before Instrument Setup 'Resolution Optimisation' starts progressing the Tune Page <XML BafflePosition> fluidics Reservoir will automatically be set to <XML Reservoir>
			And before Instrument Setup 'Resolution Optimisation' starts progressing the Tune Page <XML BafflePosition> fluidics Infusion Flow Rate will automatically be set to <XML FlowRate>
			And before Instrument Setup 'Resolution Optimisation' starts progressing the Tune Page <XML BafflePosition> fluidics Flow Path will automatically be set to <XML FlowPath>
			# ---------------------------------------------------------------------------------------------------------------------------------------------------------
			And before Instrument Setup 'Resolution Optimisation' starts progressing there will be an <XML BafflePosition> fluidics <Refill>
			# Only if no Reservoir change is required and the intial Reservoir level is too low 
			And before Instrument Setup 'Resolution Optimisation' starts progressing there will be a <Purge Delay>
			# Only if a Reservoir change is required
			# ---------------------------------------------------------------------------------------------------------------------------------------------------------
			And before Instrument Setup 'Resolution Optimisation' starts progressing the Tune Page baffle position will automatically be set to <XML BafflePosition>
			And before Instrument Setup 'Resolution Optimisation' starts progressing the Tune Page <XML BafflePosition> fluidics Infusion status will automatically change to 'Running'
			# ---------------------------------------------------------------------------------------------------------------------------------------------------------
			And Tune Page fluidics settings other than <XML BafflePosition> fluidics will remain unchanged
			# ---------------------------------------------------------------------------------------------------------------------------------------------------------
			And before Instrument Setup 'Resolution Optimisation' starts progressing there will be an intensity settling for <XML BafflePosition> fluidics
			# ---------------------------------------------------------------------------------------------------------------------------------------------------------
			And Instrument Setup will eventually complete with a <Result>
			
			# Future Release - Instrument Settings Returning to their pre-run settings
			# And after Instrument Setup has completed the <XML BafflePosition> fluidics Reservoir will remain at <Initial Reservoir> 
			# And after Instrument Setup has completed the <XML BafflePosition> fluidics Infusion will be set back to <Initial Infusion>
			# And after Instrument Setup has completed the <XML BafflePosition> fluidics Flow Path will be set back to <Initial Flow Path>
			# And after Instrument Setup has completed the <XML BafflePosition> fluidics Flow Rate will be set back to <Initial Flow Rate>
			# And after Instrument Setup has completed the Baffle will be set back to <Initial Baffle> 
		
				Examples: XML Baffle Position Reference - Various Initial Settings
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result              |
				| B             | 10.0         | Infusion     | Reference          | Idle             | Wash              | Waste             | 5.0               | Sample         | Yes         | No     | All slots 'Success' |
				| B             | 10.0         | Infusion     | Reference          | Running          | A                 | Infusion          | 0.9               | Reference      | Yes         | No     | All slots 'Success' |
				| B             | 10.0         | Infusion     | Reference          | Running          | B                 | Infusion          | 0.9               | Reference      | No          | No     | All slots 'Success' |
				| B             | 10.0         | Infusion     | Reference          | Running          | C                 | Infusion          | 0.9               | Reference      | Yes         | No     | All slots 'Success' |
				
				Examples: XML Baffle Position Sample - Various Initial Settings
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result              |
				| B             | 10.0         | Infusion     | Sample             | Idle             | Wash              | Waste             | 10.0              | Sample         | Yes         | No     | All slots 'Success' |
				| B             | 10.0         | Infusion     | Sample             | Running          | A                 | Infusion          | 0.9               | Sample         | Yes         | No     | All slots 'Success' |
				| B             | 10.0         | Infusion     | Sample             | Running          | B                 | Combined          | 5.5               | Sample         | No          | No     | All slots 'Success' |
				| B             | 10.0         | Infusion     | Sample             | Running          | C                 | LC                | 11.1              | Sample         | Yes         | No     | All slots 'Success' |
								
				Examples: Refill Based on Syringe Level - Sample
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result              |
				| B             | 10.0         | Infusion     | Sample             | Idle - Full      | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Success' |
				| B             | 10.0         | Infusion     | Sample             | Idle - 6 mins    | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Success' |
				| B             | 10.0         | Infusion     | Sample             | Idle - 4 mins    | B                 | Infusion          | 10.0              | Sample         | No          | Yes    | All slots 'Success' |
				| B             | 10.0         | Infusion     | Sample             | Idle - Empty     | B                 | Infusion          | 10.0              | Sample         | No          | Yes    | All slots 'Success' |
				# It is assumed that for the Refill to occur when expected, that the Resolution Optimisation 'InfusionFlowTime' parameter within 'InstrumentSetupConfiguration.xml' is set to 5 minutes (300 seconds)

				Examples: Refill Based on Syringe Level - Reference
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result              |
				| B             | 10.0         | Infusion     | Reference          | Running - 9 mins | B                 | Infusion          | 10.0              | Reference      | No          | No     | All slots 'Success' |
				| B             | 10.0         | Infusion     | Reference          | Running - 6 mins | B                 | Infusion          | 10.0              | Reference      | No          | No     | All slots 'Success' |
				| B             | 10.0         | Infusion     | Reference          | Running - 4 mins | B                 | Infusion          | 10.0              | Reference      | No          | Yes    | All slots 'Success' |
				| B             | 10.0         | Infusion     | Reference          | Running - Empty  | B                 | Infusion          | 10.0              | Reference      | No          | Yes    | All slots 'Success' |
				# It is assumed that for the Refill to occur when expected, that the Resolution Optimisation 'InfusionFlowTime' parameter within 'InstrumentSetupConfiguration.xml' is set to 5 minutes (300 seconds)

				Examples: Expected Success with Different 'XML FlowRate' Parameter
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result              |
				| B             | 20.0         | Infusion     | Reference          | Idle             | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Success' |
				| B             | 22.2         | Infusion     | Sample             | Idle             | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Success' |
							
				Examples: Expected Fail due to Wrong 'XML Reservoir' Parameter
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result              |
				| A             | 10.0         | Infusion     | Reference          | Running          | B                 | Infusion          | 10.0              | Sample         | Yes         | No     | All slots 'Failed'  |
				| C             | 10.0         | Infusion     | Sample             | Running          | B                 | Infusion          | 10.0              | Sample         | Yes         | No     | All slots 'Failed'  |
								
				Examples: Expected Fail due to Wrong 'XML FlowPath' Parameter
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result              |
				| B             | 10.0         | Combined     | Reference          | Running          | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Success' |
				| B             | 10.0         | LC           | Reference          | Running          | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Failed'  |
				| B             | 10.0         | Waste        | Reference          | Running          | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Failed'  |
				| B             | 10.0         | Waste        | Sample             | Running          | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Failed'  |
				
				Examples: Out of Range Parameters
				| XML Reservoir | XML FlowRate | XML FlowPath | XML BafflePosition | Initial Infusion | Initial Reservoir | Initial Flow Path | Initial Flow Rate | Initial Baffle | Purge Delay | Refill | Result              |
				| 4             | 10.0         | Infusion     | Sample             | Running          | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Success' |
				| B             | 10.0         | 4            | Sample             | Running          | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Success' |
				| B             | 10.0         | 2            | Reference          | Running          | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Success' |
				| B             | 10.0         | Infusion     | 2                  | Running          | B                 | Infusion          | 10.0              | Sample         | No          | No     | All slots 'Success' |
				# Where 'Initial Infusion' syringe time or level is not defined above, it is assumed there is sufficient that an automatic refill will not be performed.
				# 'InstrumentSetupConfiguration.xml' is located in 'C:\Waters Corporation\Typhoon\config'
				# It is assumed that all relevant parameters ('Reservoir', 'FlowRate', 'FlowPath', 'BafflePosition' and 'InfusionFlowTime' ) have been specified in the 'InstrumentSetupConfiguration.xml' file
				# 'InstrumentSetupConfiguration.xml' fluidics parameters are stored in numeric format as below:
				# 'InstrumentSetupConfiguration.xml' Reservoir parameters:                     0 = A,        1 = B,        2 = C,  3 = Wash
				# 'InstrumentSetupConfiguration.xml' Baffle parameters:                        0 = Sample,   1 = Reference
				# 'InstrumentSetupConfiguration.xml' Sample (Baffle 0) FlowPath parameters:    0 = Infusion, 1 = Combined, 2 = LC, 3 = Waste
				# 'InstrumentSetupConfiguration.xml' Reference (Baffle 1) FlowPath parameters: 0 = Infusion, 1 = Waste
				# 'InstrumentSetupConfiguration.xml' InfusionFlowTime:                         Specified in seconds


# ---------------------------------------------------------------------------------------------------------------------------------------------------
	@Ignore
	@updated
	Scenario Outline: DSU-02 - InstrumentSetupFluidics - Resolution Optimisation (Both Polarities) - Missing XML Configuration Fluidics Parameters
		Given the 'InstrumentSetupConfiguration.xml' has <Missing XML Parameter> line for Instrument Setup 'Resolution Optimisation'
		When the Instrument Setup slot statuses have been 'Reset' 
			And Instrument Setup has the following processes set
				| Process                 | Positive   | Negative   |
				| ADC Setup               | ON         | ON         |
				| Detector Setup          | ON         | ON         |
				| Lock CCS Calibration    | OFF        | OFF        |
				| Resolution Optimisation | ON  - Both | ON  - Both |
				| Mass Calibration        | OFF - All  | OFF - All  |
				| CCS Calibration         | OFF        | OFF        |
			And the Instrument Setup process is 'Run' 
		Then there will be an <Instrument Setup Effect>
			
			Examples: 
			| Missing XML Parameter | Instrument Setup Effect                                        |
			| 'Reservoir'           | Success - Run with default Reservoir setting (B)               |
			| 'FlowRate'            | Success - Run with default FlowRate setting (10.0)             |
			| 'FlowPath'            | Success - Run with default FlowPath setting (Infusion)         |
			| 'BafflePosition'      | Success - Run with default Baffle Position setting (Reference) |
			| All the above         | Success - Run with above default settings                      |
			| 'InfusionFlowTime'    | Success - No 'Refill' is performed                             |
			# An example of a missing 'Reservoir' line would be where the following complete line would be missing from the <Parameters> section: 
			# <Parameter Name="Reservoir" Value="1.0" />

			# NOTE: Default settings are currenlty incorrect (see FW#4596)
			
				
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
