
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # CAL - QRZ - Instrument Setup (Combined Processes) - Fluidics
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 25-FEB-15 (updated 10-Oct-15), Minor update 26-Nov-2015 (MH)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference
#                          # Calibrant peaks should be available when reservoir 'C' is selected for Sample
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference
#                          # Calibrant peaks should be available when reservoir 'C' is selected for Sample
#                          # NOTE: To avoid contamination, do not select reservoir 'C  for Reference fluidics
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (10-Oct-15) - Updates to reflect changes in functionality due to FW#7327 and FW#7325
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


@Ignore
Feature: Instrument Setup (Combined Processes) - Fluidics
	In order to run Combined Processes within Instrument Setup successfully regardless of initial Tune Page fluidics settings
	I want to be able to click Instrument Setup 'Run'
	So that the Instrument Setup process completes successfully for all the Combined Processes without any fluidics manual intervention

Background:
	Given the instrument Setup slots have been 'Reset'
		And the 'ADC Setup' process have been successfully run for both Pos and Neg modes
			
		
# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: CAL-01 - InstrumentSetupFluidics - Combine Processes (Detector Setup and Mass Calibration)
		Given the 'InstrumentSetupConfiguration.xml' has default parameters set for Instrument Setup 'Detector Setup' and Instrument Setup 'Mass Calibration'
			And the initial Tune Page fluidics <Sample Infusion> is set
			And the initial Tune Page fluidics <Sample Reservoir> is set
			And the initial Tune Page fluidics <Sample Flow Path> is set
			And the initial Tune Page fluidics <Sample Flow Rate> is set
			#--------------------------------------------------------------------
			And the initial Tune Page fluidics <Reference Infusion> is set
			And the initial Tune Page fluidics <Reference Reservoir> is set
			And the initial Tune Page fluidics <Reference Flow Path> is set
			And the initial Tune Page fluidics <Reference Flow Rate> is set
			#--------------------------------------------------------------------
			And the initial Tune Page fluidics <Baffle> position is set
			#--------------------------------------------------------------------
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process        | Positive | Negative |
			| Detector Setup | X        | X        |
			And the Instrument Setup process has the following Resolution Optimisation, Mass and CCS Calibration 'X' slots set to 'ON'
			| Process         | POS RES | NEG RES | POS SENS | NEG SENS |
			| Res Opt         | X       | X       | X        | X        |
			| Mass Cal (1000) | X       | X       | X        | X        |
			| CCS Cal  (1000) | X       | X       | X        | X        |
			
			And the Instrument Setup process is 'Run'
		Then 'Progress Log' messages will indicate that fluidics are being set up
			And before Instrument Setup 'Detector Setup' starts progressing there will be a <Reference Refill>
			And before Instrument Setup 'Mass Calibration' starts progressing there will be a <Sample Refill>
			# Only if no Reservoir change is required and the intial Reservoir level is too low
			# -------------------------------------------------------------------------------------------------
			And Instrument Setup will eventually complete with a <Result>
			
			# Future Release - Instrument Settings Returning to their pre-run settings
			# -------------------------------------------------------------------------------------------------------------------------
			# And after Instrument Setup has completed the initial <Sample Infusion> will be automatically set
			# And after Instrument Setup has completed the initial <Sample Reservoir> will remain set
			# And after Instrument Setup has completed the initial <Sample Flow Path> will be automatically set
			# And after Instrument Setup has completed the initial <Sample Flow Rate> will be automatically set
			# -------------------------------------------------------------------------------------------------------------------------
			# And after Instrument Setup has completed the initial <Reference Infusion> will be automatically set
			# And after Instrument Setup has completed the initial <Reference Reservoir> will remain set
			# And after Instrument Setup has completed the initial <Reference Flow Path> will be automatically set
			# And after Instrument Setup has completed the initial <Reference Flow Rate> will be automatically set
			# -------------------------------------------------------------------------------------------------------------------------
			# And after Instrument Setup has completed the initial <Baffle> position will be automatically set

			Examples: Sample Fluidics Settings - Default Tune Page Fluidics
			| Sample Infusion | Sample Reservoir | Sample Flow Path | Sample Flow Rate | Sample Refill | Reference Infusion | Reference Reservoir | Reference Flow Path | Reference Flow Rate | Reference Refill | Baffle | Result                      |
			| Idle            | Wash             | Waste            | 5.0              | No            | Idle               | Wash                | Waste               | 10.0                | No               | Sample | All enabled slots 'Success' |

			Examples: Sample Fluidics Settings - Non-Default Tune Page Fluidics
			| Sample Infusion | Sample Reservoir | Sample Flow Path | Sample Flow Rate | Sample Refill | Reference Infusion | Reference Reservoir | Reference Flow Path | Reference Flow Rate | Reference Refill | Baffle    | Result                      |
			| Running         | A                | Infusion         | 0.9              | No            | Running            | B                   | Infusion            | 0.8                 | No               | Reference | All enabled slots 'Success' |
			| Running         | B                | Combined         | 5.5              | No            | Running            | B                   | Infusion            | 5.4                 | No               | Reference | All enabled slots 'Success' |
			| Running         | C                | LC               | 11.1             | No            | Running            | B                   | Infusion            | 11.0                | No               | Reference | All enabled slots 'Success' |

			Examples: Refill Based on Syringe Levels - Sample and Reference
			| Sample Infusion | Sample Reservoir | Sample Flow Path | Sample Flow Rate | Sample Refill | Reference Infusion | Reference Reservoir | Reference Flow Path | Reference Flow Rate | Reference Refill | Baffle | Result                      |
			| Idle - Full     | C                | Infusion         | 10.0             | No            | Running - 4 mins   | B                   | Infusion            | 10.0                | Yes              | Sample | All enabled slots 'Success' |
			| Idle - 50%      | C                | Infusion         | 10.0             | No            | Running - 6 mins   | B                   | Infusion            | 10.0                | No               | Sample | All enabled slots 'Success' |
			| Idle - 25%      | C                | Infusion         | 10.0             | Yes           | Running - 9 mins   | B                   | Infusion            | 10.0                | No               | Sample | All enabled slots 'Success' |
			| Idle - Empty    | C                | Infusion         | 10.0             | Yes           | Running - Empty    | B                   | Infusion            | 10.0                | Yes              | Sample | All enabled slots 'Success' |
			# Where 'Initial Infusion' syringe time or level is not defined above, it is assumed there is sufficient that an automatic refill will not be performed.
			# It is assumed that for the Refill to occur when expected, that the Detector Setup 'InfusionFlowTime' parameter within 'InstrumentSetupConfiguration.xml' is set to 5 minutes (300 seconds)

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END
