
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Instrument Setup - Verify Results
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Original Author:         # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Original Creation Date:  # 14-APR-16
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # 
#                          # Type 1 Corruption: where the KeyValue store does not exist / has been deleted 
#                          # IMPORTANT NOTE: For the time being only use this type of corruption in this feature file 
#                          #
#                          #   1). From the Typoon bin folder open a CMD prompt 
#                          #   2a). Example: Enter the following command to delete the 'Positive Sensitivity 1000 MassCalibration' slot data...
#                          #          KeyValueStoreClient InstrumentSetupResults MassCalibration.Positive.Sensitivity.1000.Result.MassCalibration
#                          #          NOTE: to delete the CCS slot data replace 'MassCalibration' with 'CCSCalibration'
#                          #
#                          #
#                          # 
#                          # NOTE: Some additional testing could be performed with a Type 2 corruption but this will involve the modification of a webserver js file due to a defect that causes a crash... 
#                          # 
#                          # Type 2 Corruption: where the KeyValue store does not contain relavent data / has been corrupted
#                          #   a). First, three lines (21-23) need commenting out in 'enableDisableFilters.js' (\Typhoon\webserver\modules\instrument\tune\client\js\)
#                          # 
#                          #       return function() {
#                          #       // var massCalibration = roomInstrumentSetup.get('MassCalibration.' + currentPolarity.activeValue + '.' + currentOpticMode.activeValue + '.' +
#                          #       //            currentFrequencyMode.activeValue + '.Result.MassCalibration', 'Calibration.Calibration');
#                          #       // if (angular.isDefined(massCalibration) && angular.isDefined(massCalibration.calibrationConditions))
#                          #       return true;  
#                          #
#                          #   b). Restart Typhoon
#                          #   c). Example: Enter the following command to corrupt the 'Positive Sensitivity 1000 MassCalibration' slot data...
#                          #          KeyValueStoreClient InstrumentSetupResults MassCalibration.Positive.Sensitivity.1000.Result.MassCalibration DummyData
#                          #          NOTE: to corrupt the CCS slot data replace 'MassCalibration' with 'CCSCalibration'
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # Vion Sprint 2
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (VION-33)                # Instrument Setup - Verify results for apps
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@Ignore
Feature: Instrument Setup - Verify Results
	In order to ensure that a slot status is automatically reset when a slot result corruption is found 
	I want to purposefully corruption a slot, then restart Typhoon or corrupt a slot during Instrument Setup
	So that the corrupted slot status is changed to 'Not Run' and reported if it was found during Instrument Setup
			

# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario Outline: QRZ-01 - Instrument Setup - Verify Results (Single Slot Curruption Before Typhoon Restart - Vertical Slice)
		
		Given the Instrument Setup <Slot> <Mode> already has a status of 'Success'
			
		When the <Slot> <Mode> is corrupted
		# See 'Manual Test Notes' above
			And Quartz is closed
			And Typhoon is restarted
			And Quartz is opened and logged into
		Then the Instrument Setup <Slot> <Mode> status will have changed to 'Not Run'
			And 'Log Messages' will detail that <Slot <Mode> was reset
		
		When the Instrument <Mode> is set 
			And Tuning is aborted and restarted
			And 'AnalyseData.bat' is run
		Then 'AnalyseData.bat' results will show there is no calibration for <Slot> <Mode>

		When Instrument Setup <Slot> <Mode> is selected
			And Instrument Setup is 'Run' to completion
		Then the <Slot> <Mode> status will have changed back to 'Success' 

		When the Instrument <Mode> is set 
			And Tuning is aborted and restarted
			And 'AnalyseData.bat' is run
		Then 'AnalyseData.bat' results will show there is now a calibration for <Slot> <Mode>
				
		Examples: Single Positive Slot
		| Slot                    | Mode               |
		| Mass Calibration        | POS SENS 1000 only |
		| Mass Calibration        | POS SENS 2000 only |
		| Mass Calibration        | POS SENS 4000 only |
		| CCS Calibration         | POS SENS 1000 only |
		| CCS Calibration         | POS SENS 2000 only |     
		# 'AnalyseData.bat' (located in '\Typhoon\config\scripts\')
		# - 'Not Run' slots - AnlayseData.bat should show as Uncalibrated
		# - 'Success' slots - AnlayseData.bat should show as Calibrated (and calibration information should match the current slot Polarity, Analyser Mode and Mass Range). 
		
			
# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: QRZ-02 - Instrument Setup - Verify Results (Multiple Slots Curruption Before Typhoon Re-start)
		# NOTE: This scenario will have to change when hierarchical (dependancy) resetting is implemented
		Given all the following Instrument Setup slots already have a 'Status' of Success
			| Slots                          |
			| All Mass Calibration 1000      |
			| All Mass Calibration 2000      |
			| Mass Calibration POS SENS 4000 |
			| All CCS Calibration 1000       |
			| All CCS Calibration 2000       |
		When the following 'Slots' are corrupted 
			| Slots                          |
			| Mass Calibration POS SENS 1000 |
			| Mass Calibration POS SENS 2000 |
			| Mass Calibration NEG SENS 2000 |
			| Mass Calibration POS SENS 4000 |
			| CCS Calibration NEG RES 1000   |
			| CCS Calibration POS RES 2000   |
			| CCS Calibration NEG RES 2000   |
			# See 'Manual Test Notes' above

			And Quartz is closed
			And Typhoon is restarted
			And Quartz is opened and logged into
		Then the following Instrument Setup slots will have a status of 'Not Run'
			| Slots                          |
			| Mass Calibration POS SENS 1000 |
			| Mass Calibration POS SENS 2000 |
			| Mass Calibration NEG SENS 2000 |
			| Mass Calibration POS SENS 4000 |
			| CCS Calibration NEG RES 1000   |
			| CCS Calibration POS RES 2000   |
			| CCS Calibration NEG RES 2000   |
			And 'Log Messages' will detail resetting of all corrupted slots regardless of corruption type
			And all other slots will still have a status of 'Success'
			

# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario Outline: QRZ-03 - Instrument Setup - Verify Results (Single Slot Corruption During Run)
		Given any prerequisites slots for <Slots to Run> have a status of 'Success'
		# This will not be applicable for 'ADC Setup' slots
			And the Instrument mode is set to 'Positive Sensitivity' 
			And the Instrument Setup <Slots to Run> are in a 'Not Run' state 
			And the Instrument Setup <Slots to Run> are selected
			And Instrument Setup is started
			And <Corrupted Slot> is currupted after its status changes to 'Success'
		    # See 'Manual Test Notes' above					
		When Instrument Setup completes
		Then the <Corrupted Slot> status will go to a 'Not Run' status
			And 'Log Messages' will detail the <Currupted Slot>
			# This should show a list of all corrupted slots
			
		Examples: Mass Calibration - Standard Mass
		| Slots to Run                                  | Corrupted Slot                                                              |
		| Mass Cal POS SENS 1000, Mass Cal POS RES 1000 | Mass Cal POS SENS 1000                                                      |
		| All Mass Cal 1000                             | Mass Cal POS RES 1000                                                       |
		| All Mass Cal 2000                             | Mass Cal NEG SENS 2000                                                      |
		| All Mass Cal 1000 and 2000                    | Mass Cal NEG RES 1000 and Mass Cal POS SENS 2000                            |
		| All Mass Cal 1000 and 2000                    | Mass Cal POS SENS 1000 and Mass Cal NEG SENS 2000 and Mass Cal POS RES 2000 |
				
		Examples: Mass Calibration - High Mass
		| Slots to Run                                  | Corrupted Slot         |
		| Mass Cal POS SENS 4000                        | Mass Cal POS SENS 4000 |
					
		Examples: CCS Calibration
		| Slots to Run                                  | Corrupted Slot                                 |
		| CCS Cal POS SENS 1000, CCS Cal POS RES 1000   | CCS Cal POS SENS 1000                          |
		| All CCS Cal 1000                              | CCS Cal POS RES 1000                           |
		| All CCS Cal 2000                              | CCS Cal NEG SENS 2000                          |
		| All CCS Cal 1000 and 2000                     | CCS Cal NEG RES 1000 and CCS Cal POS SENS 2000 |

# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END