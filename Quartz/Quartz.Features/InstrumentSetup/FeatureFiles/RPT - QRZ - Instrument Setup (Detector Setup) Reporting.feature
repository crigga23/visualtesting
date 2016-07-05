
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Instrument Setup (Detector Setup) Reporting
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Mike Hodgkinson
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 10-MAR-15 (updated by Christopher D Hughes on 10-Oct-15)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (10-Oct-15) - Updates to reflect changes in functionality due to FW#7327 and FW#7325
#                          #             - Other updates to correct de-selected slot types
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Quartz EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-165)                 # The software will render a report in a seperate window.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-156)                 # The software will label all reports with user and system information.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-157)                 # All reports will have a report header section for system and user specific information that is separated from the results section.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-158) 				   # The software will label all reports with the following details:
#						   # 1) creation date and time.
#                          # 2) Instrument serial number
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-159) 	               # The software will display the Waters logo on all generated reports.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-160) 	               # All printed reports will have a signature area.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-161) 	               # Reports will be generated as a static serializable file in a format that can be viewed without proprietary software.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-162) 	               # All reports will be rendered using the users current locale.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-163) 	               # All reports will be printed using the users current locale.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-164) 	               # Reports will not be stored in a localized form.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@Ignore
Feature: Instrument Setup (Detector Setup) Process Reporting
	In order to view details of the 'Instrument Setup (Detector Setup)' results
	I want to be able to view the 'Detector Setup' reports for each polarity
	So that determining success criteria and diagnosing setup issues can be achieved


Background:
	Given the tune page is inspected
		And the 'ADC' Average Single Ion Intensity is set to '0' for both polarities
		And the 'ADC' Measured m/z is set to '0.0000' for both polarities
		And the 'ADC' Measured charge is set to '0' for both polarities
		And the 'Instrument' Detector Voltage is set to '2000' for both polarities
		And the Instrument Setup slots have been 'Reset'
	    And the Instrument Setup 'ADC Setup' process has been run successfully for both polarities

# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: RPT-01 - Detector Setup Process Report - Both Polarities
		Given the expected reference solution is present in 'vial B'
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       | X        | X        |
			| Lock CCS Calibration |          |          |
			| Mass Calibration     |          |          |
			| CCS Calibration      |          |          |

			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the Instrument Setup process is 'Run'
		When the 'Instrument Setup Detector Setup' process has successfully completed
			And the 'Display Report' button is selected
		Then the 'Instrument Setup Detector Setup' report will be displayed within a separate window
			And it will contain the following header information
			| Header Information           |
			| Title containing Waters logo |
			| Data and time of creation    |
			And it will contain the following environmental information
			| Environmental Information         |
			| Instrument type and serial number |
			| Instrument driver version number  |
			| Quartz and Typhoon version number |
			| User logged into Quartz           |
			And it will contain the following results summary
			| Results Summary                          |
			| Polarity with individual status          |
			| Mass and charge for each polarity        |
			| Final detector voltage for each polarity |
			| Average Ion Area for each polarity       |

		When the 'Tune Page' is inspected
		Then the following tune page values match the 'Instrument Setup Detector Setup' report for both polarities
			| 'Instrument' Detector Voltage      |
			| 'ADC' Average Single Ion Intensity |
			| 'ADC' Measured m/z                 |
			| 'ADC' Measured charge              |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: RPT-02 - Detector Setup Process Report - Positive Polarity only
		Given the expected reference solution is present in 'vial B'
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       | X        |          |
			| Lock CCS Calibration |          |          |
			| Mass Calibration     |          |          |
			| CCS Calibration      |          |          |
			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the Instrument Setup process is 'Run'
		When the 'Instrument Setup Detector Setup' process has successfully completed
			And the 'Display Report' button is selected
		Then the 'Instrument Setup Detector Setup' report will be displayed within a separate window
			And it will contain the following header information
			| Header Information           |
			| Title containing Waters logo |
			| Data and time of creation    |
			And it will contain the following environmental information
			| Environmental Information         |
			| Instrument type and serial number |
			| Instrument driver version number  |
			| Quartz and Typhoon version number |
			| User logged into Quartz           |
			And it will contain the following results summary
			| Results Summary                              |
			| Polarity with individual status              |
			| Mass and charge for positive polarity        |
			| Final detector voltage for positive polarity |
			| Average Ion Area for positive polarity       |

		When the 'Tune Page' is inspected
		Then the following tune page values match the 'Instrument Setup Detector Setup' report for positive polarity only
			| Positive 'Instrument' Detector Voltage      |
			| Positive 'ADC' Average Single Ion Intensity |
			| Positive 'ADC' Measured m/z                 |
			| Positive 'ADC' Measured charge              |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: RPT-03 - Detector Setup Process Report - Negative Polarity only
		Given the expected reference solution is present in 'vial B'
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       |          | X        |
			| Lock CCS Calibration |          |          |
			| Mass Calibration     |          |          |
			| CCS Calibration      |          |          |
			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the Instrument Setup process is 'Run'
		When the 'Instrument Setup Detector Setup' process has successfully completed
			And the 'Display Report' button is selected
		Then the 'Instrument Setup Detector Setup' report will be displayed within a separate window
			And it will contain the following header information
			| Header Information           |
			| Title containing Waters logo |
			| Data and time of creation    |
			And it will contain the following environmental information
			| Environmental Information         |
			| Instrument type and serial number |
			| Instrument driver version number  |
			| Quartz and Typhoon version number |
			| User logged into Quartz           |
			And it will contain the following results summary
			| Results Summary                              |
			| Polarity with individual status              |
			| Mass and charge for negative polarity        |
			| Final detector voltage for negative polarity |
			| Average Ion Area for negative polarity       |

		When the 'Tune Page' is inspected
		Then the following tune page values match the 'Instrument Setup Detector Setup' report for negative polarity only
			| Negative 'Instrument' Detector Voltage      |
			| Negative 'ADC' Average Single Ion Intensity |
			| Negative 'ADC' Measured m/z                 |
			| Negative 'ADC' Measured charge              |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
    Scenario: RPT-04 - Detector Setup Process Report - Aborted (missing solution)
		Given the expected reference solution is 'NOT' present in 'vial B'
		# Note: For the simulated instrument change the vial to 'C' in the 'InstrumentSetupConfiguration.xml'
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       | X        | X        |
			| Lock CCS Calibration |          |          |
			| Mass Calibration     |          |          |
			| CCS Calibration      |          |          |
			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the Instrument Setup process is 'Run'
		When the 'Instrument Setup Detector Setup' process has aborted for both slots
			And the 'Display Report' button is selected
		Then the 'Instrument Setup Detector Setup' report will be displayed within a separate window
			And it will contain the following header information
			| Header Information           |
			| Title containing Waters logo |
			| Data and time of creation    |
			And it will contain the following environmental information
			| Environmental Information         |
			| Instrument type and serial number |
			| Instrument driver version number  |
			| Quartz and Typhoon version number |
			| User logged into Quartz           |
			And it will contain the following results summary
			| Results Summary                        |
			| Polarity with individual status        |
			| Reason for 'Abort' for both polarities |
			And no other information will be displayed

	
# ---------------------------------------------------------------------------------------------------------------------------------------------------
	@ManualOnly
	Scenario: RPT-05 - Detector Setup Process Report - Printing
		Given the expected reference solution is present in 'vial B'
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       | X        | X        |
			| Lock CCS Calibration |          |          |
			| Mass Calibration     |          |          |
			| CCS Calibration      |          |          |
			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the Instrument Setup process is 'Run'
		When the 'Instrument Setup Detector Setup' process has successfully completed
			And the 'Display Report' button is selected
		Then the 'Instrument Setup Detector Setup' report will be displayed within a separate window
			And the report can be printed using a suitable printer
			And the printed report will have a signature area


# ---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario: RPT-06 - Detector Setup Process Report - Storage
		Given the expected reference solution is present in 'vial B'
		When the Instrument Setup process has the following process 'X' slots set to 'ON'
			| Process              | Positive | Negative |
			| Detector Setup       | X        | X        |
			| Lock CCS Calibration |          |          |
			| Mass Calibration     |          |          |
			| CCS Calibration      |          |          |
			And the Instrument Setup process has all the Mass Calibration slots set to 'OFF'
			And the Instrument Setup process is 'Run'
		When the 'Instrument Setup Detector Setup' process has successfully completed
		Then the 'Instrument Setup Detector Setup' report will stored within 'Typhoon' 
		
		When 'Typhoon' is is restarted and the Quartz application re-opened 
			And the Instrument Setup 'Display Report' button is selected
		Then the current 'Instrument Setup Detector Setup' report will be displayed within a separate window
			And it will contain the following header information
			| Header Information           |
			| Title containing Waters logo |
			| Data and time of creation    |
			And it will contain the following environmental information
			| Environmental Information         |
			| Instrument type and serial number |
			| Quartz and Typhoon version number |
			| User logged into Quartz           |
			And it will contain the following results summary
			| Results Summary                          |
			| Polarity with individual status          |
			| Mass and charge for each polarity        |
			| Final detector voltage for each polarity |
			| Average Ion Area for each polarity       |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
