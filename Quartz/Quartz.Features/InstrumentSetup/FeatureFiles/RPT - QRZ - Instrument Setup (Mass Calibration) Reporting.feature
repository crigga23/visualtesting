
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Instrument Setup (Mass Calibration) Reporting
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Original Author:         # Mike Hodgkinson
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Original Creation Date:  # 27-JUN-16
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (06-OCT-15) - Christopher D Hughes - Updates to Background to reflect changes in functionality due to FW#7327 and FW#7325
#                          #                                    - Other updates to correct de-selected slot types
#                          # (10-OCT-15) - Christopher D Hughes - Minor updates
#                          # (27-JUN-16) - Christopher D Hughes - Major Updates after Vion v1.1 testcase execution
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
Feature: Instrument Setup (Mass Calibration) Process Reporting
	In order to view details of the 'Instrument Setup (Mass Calibration)' results
	I want to be able to view the 'Mass Calibration' reports for each slot
	So that determining success criteria and diagnosing issues can be achieved



Background:
	Given the Instrument Setup slots have been 'Reset'
	And the following Instrument Setup 'Processes' have been run successfully for all available slots
		| Processes               |
		| ADC Setup               |
		| Detector Setup          |
		| Resolution Optimisation |
	

# ---------------------------------------------------------------------------------------------------------------------------------------------------
	@Updated
	Scenario: RPT-01 - Mass Calibration Process Report - Standard Masses
		Given the 'MajorMix' solution is present in 'Vial C'
			# If the solution has recently been changed, then purge the Sample Fluidics
			And the Instrument Setup process has the following Mass Calibration 'X' slots selected
				| Mass  | POS SENS | NEG SENS | POS RES | NEG RES |
				| 1000  |    X     |    X     |    X    |    X    |
				| 2000  |    X     |    X     |    X    |    X    |
				| 4000  |          |          |         |         |
			And the Instrument Setup process is 'Run'
			And the 'Instrument Setup Mass Calibration' process completes successfully for each selected slot
		
		# Quick check of multiple reports	
		When the 'Success' link is opened for each slot
		Then an 'Instrument Setup Mass Calibration' report is available in a seperate window for each selected slot
			And the correct slot name should be present in each report above the Summary table
			And the correct 'Status' should be present in each report within the Summary table
		
		# Detailed check of a single report			
		When the contents of the 'POS SENS 1000' report is inspected	
		
		# Header Logo
		Then it will contain a Waters logo in the header 
			# Slot Title
			And it will contain a slot Title
			# i.e. 'Mass Calibration Positive Sensitivity 1000' |
			
			# 'Summary' pane (Table)
			And it will contain 'Summary' pane information
				| Summary Pane                 | Comment                                      |
				| Last Update Performed on     | Text / Numbers (Day, Date, Time, GMT offset) |
				| Status                       | Text ('Succes' / 'Failed')                   |
				| Creation                     | Text ('Automatic')                           |
				| Calibration Status           | Text ('Success' / Failure reason)            |
				| Number of Matched Peaks      | Integer                                      |
				| Number of Reference Peaks    | Integer                                      |
				| Missing Peaks                | Integer (possibly blank)                     |
				| Flexibility                  | Exponent (1.23e-4)                           |
				| Mean Prediction Error        | Number                                       |
				| Maximum Prediction Error     | Number                                       |
				| Start m/z                    | Number ('50.0')                              |
				| End m/z                      | Number ('1000', or '2000', or '4000')        |
			
			# 'Acceptance Criteria' pane (Table)
			And it will contain 'Acceptance Criteria' pane information
				| Acceptance Criteria Pane     | Comment                                      |
				| Matched Peaks Threshold      | Number, Number, Text ('Pass' / 'Failed')     |
				| RMS Residual Limit           | Number, Number, Text ('Pass' / 'Failed')     |
				| Mean Prediction Error Limit  | Number, Number, Text ('Pass' / 'Failed')     |
			
			# 'Reference Peaks' pane (Table)
			And it will contain 'Reference Peaks' pane information
				| Reference Peaks Pane Columns | Comment                                      |
				| Reference Peaks (mz)         | Number                                       |
				| Matched Peak (mz)            | Number                                       |
				| Difference (mDa)             | Number                                       |
				| Difference (ppm)             | Number                                       |
				| Intensity                    | Exponent (1.23e-4)                           |
				| State                        | Text ('Matched' / 'Unmatched')               |
            
			# Number of 'Reference Peaks' data rows
			And the number of data rows in the 'Reference Peaks' pane matches the 'Number of Reference Peaks' in the Summary pane
			
			# 'Reference Peaks' pane (Graphical)
			And the 'Reference Peaks' pane will contain a graph 
			And the 'Reference Peaks' graph will have an x-axis scale of 'm/z' across the expected mass range 
			And the 'Reference Peaks' graph will have a y-axis scale of '%' (0-100) 
		    And the 'Reference Peaks' graph will show the reference peaks as blue 
			And the 'Reference Peaks' graph will show the reference peaks with an intensity of 100%
			
			# 'Matched Peaks' pane (Graphical)
			And the 'Matched Peaks' pane will contain a graph 
			And the 'Matched Peaks' graph will have an x-axis scale of 'm/z' across the expected mass range 
			And the 'Matched Peaks' graph will have a y-axis scale of '%' (0-100) 
		    And the 'Matched Peaks' graph will show the matched data peaks as red 
			And the 'Matched Peaks' graph will show the unmatched data peaks as blue 
			And the 'Matched Peaks' graph will show the peak intensities normalised to the most intense peak 
			
			# 'Residuals' pane (Graphical)
			And the 'Residuals' pane will contain a graph 
			And the 'Residuals' graph will have an x-axis scale of 'm/z' across the expected mass range 
			And the 'Residuals' graph will have a y-axis scale of 'ppm' 
			And the 'Residuals' graph will show matched peaks as a small blue circle with an error bar above and below it
			And the 'Residuals' graph will show a top and bottom best fit curve in grey
			
			# 'Linear Residuals' (Graphical)
			And the 'Linear Residuals' pane will contain a graph 
			And the 'Linear Residuals' graph will be similar in content to the Residuals' graph except the matched peak circle positions and best fit curve will be different
			
			# 'Environmental Information' pane (Table)
			And it will contain 'Environmental Information' pane details
				| Environmental Information         |
				| Instrument type and serial number |
				| Instrument driver version number  |
				| Quartz and Typhoon version number |
				| User logged into Quartz           |
			
			# Footer information
			And it will contain footer information
				| Footer Information | Comments                                                           |
				| Date               | with room to the right to insert the date on the printed report    |
				| Signature          | with room to the right to insert a signature on the printed report |
				

# ---------------------------------------------------------------------------------------------------------------------------------------------------
	@Updated
	Scenario: RPT-02 - Mass Calibration Process Report - High Mass Slot
		Given the 'Sodium Iodide' solution is present in 'Vial C'
			# If the solution has recently been changed, then purge the Sample Fluidics
			And the Instrument Setup process has the following Mass Calibration 'X' slot selected
				| Mass  | POS SENS | NEG SENS | POS RES | NEG RES |
				| 1000  |          |          |         |         |
				| 2000  |          |          |         |         |
				| 4000  |    X     |          |         |         |
			And the Instrument Setup process is 'Run'
			And the 'Instrument Setup Mass Calibration' process completes successfully for the 'POS SENS 4000' slot
		
		# Quick check of multiple reports	
		When the 'Success' link is opened for the 'POS SENS 4000' slot
		Then an 'Instrument Setup Mass Calibration' report is available in a seperate window
			And the correct slot name should be present in each report above the Summary table
			And the correct 'Status' should be present in each report within the Summary table
		
		# Detailed check of a single report				
		When the contents of the 'POS SENS 4000' slot report is inspected	
		Then it will contain the expected information for the following panes / sections
			| Pane / Section            | Type                   |
			| Header (Logo)             | Graphical              |
			| Title                     | Text                   |
			| Summary                   | Table (Text / Numeric) |
			| Acceptance Criteria       | Table (Text / Numeric) |
			| Reference Peaks           | Table (Text / Numeric) |
			| Reference Peaks           | Graphical              |
			| Matched Peaks             | Graphical              |
			| Residuals                 | Graphical              |
			| Linear Residuals          | Graphical              |
			| Environmental Information | Table (Text)           |
			| Footer                    | Text                   |
			# See RPT-01 for detailed report content information

# ---------------------------------------------------------------------------------------------------------------------------------------------------
	@Updated
	Scenario: RPT-03 - Mass Calibration Process Report - Selected Slots
		Given the 'MajorMix' solution is present in 'Vial C'
		# If the solution has recently been changed, then purge the Sample Fluidics
			And  the Instrument Setup process has the following Mass Calibration 'X' slots selected
				| Mass  | POS SENS | NEG SENS | POS RES | NEG RES |
				| 1000  |    X     |          |         | X       |
				| 2000  |          |    X     |         |         |
				| 4000  |          |          |         |         |
			And the Instrument Setup process is 'Run'
			And the 'Instrument Setup Mass Calibration' process completes successfully for each selected slot
		
		# Quick check of multiple reports	
		When each Mass Calibration 'Success' link is opened in turn
		Then an 'Instrument Setup Mass Calibration' report is available in a seperate window for each selected slot
			And the correct slot name should be present in each report above the Summary table
			And the correct 'Status' should be present in each report within the Summary table
		
		# Detailed check of a single report				
		When the contents of the 'POS SENS 1000' report is inspected	
		Then it will contain the expected information for the following panes / sections
			| Pane / Section            | Type                   |
			| Header (Logo)             | Graphical              |
			| Title                     | Text                   |
			| Summary                   | Table (Text / Numeric) |
			| Acceptance Criteria       | Table (Text / Numeric) |
			| Reference Peaks           | Table (Text / Numeric) |
			| Reference Peaks           | Graphical              |
			| Matched Peaks             | Graphical              |
			| Residuals                 | Graphical              |
			| Linear Residuals          | Graphical              |
			| Environmental Information | Table (Text)           |
			| Footer                    | Text                   |
			# See RPT-01 for detailed report content information

# ---------------------------------------------------------------------------------------------------------------------------------------------------
    @Updated
	Scenario: RPT-04 - Mass Calibration Process Report - Default Slots Error (Missing Solution)
		Given the expected reference solution is 'NOT' present in 'vial C'
		# This could also be aceived by setting the Detector Voltage to zero for each polarity 
			And the Instrument Setup process has the following Mass Calibration 'X' slots selected
				| Mass  | POS SENS | NEG SENS | POS RES | NEG RES |
				| 1000  |    X     |    X     |    X    |    X    |
				| 2000  |    X     |    X     |    X    |    X    |
				| 4000  |          |          |         |         |
			And the Instrument Setup process is 'Run'
		When the 'Instrument Setup Mass Calibration' process has gone to 'Error' for all selected slots
		Then the 'Error' slots do NOT link to a report
		# Set the Detector Voltage back to the initial value for Positive and Negative, if there were changed
	
			
# ---------------------------------------------------------------------------------------------------------------------------------------------------
    @Updated
	Scenario: RPT-05 - Mass Calibration Process Report - Specific Slot Aborted
		Given the Instrument Setup process has the following Mass Calibration 'X' slot selected
			| Mass  | POS SENS | NEG SENS | POS RES | NEG RES |
			| 1000  |          |          |         |         |
			| 2000  |          |    X     |         |         |
			| 4000  |          |          |         |         |
			And the Instrument Setup process is 'Run'
		When the 'Instrument Setup Mass Calibration' process is immediately cancelled
		Then the slot goes to 'Aborted'
			And the 'Aborted' slot does NOT link to a report			
	

# ---------------------------------------------------------------------------------------------------------------------------------------------------
	@Updated
	Scenario: RPT-06 - Mass Calibration Process Report - Default Slots Fail (Outside ppm Tolerance)
		Given the 'MajorMix' solution is present in 'Vial C'
			And the following '\Typhoon\config\CalibrationProcessingCriteria.xml' details are changed
			| Parameter        | max Value |
			| RMSResidualLimit | 0.0       |
			# Make a note of the initial RMSResidualLimit 'max' value
			And Typhoon is restarted 
			And the Instrument Setup process has the following Mass Calibration 'X' slots selected
			| Mass  | POS SENS | NEG SENS | POS RES | NEG RES |
			| 1000  |    X     |    X     |    X    |    X    |
			| 2000  |    X     |    X     |    X    |    X    |
			| 4000  |          |          |         |         |
			And the Instrument Setup process is 'Run'
		
		# Quick check of multiple reports	
		When each Mass Calibration 'Success' link is opened in turn
		Then an 'Instrument Setup Mass Calibration' report is available in a seperate window for each selected slot
			And the correct slot name should be present in each report above the Summary table
			And the correct 'Status' should be present in each report within the Summary table

		# Detailed check of a single report				
		When the contents of the 'POS SENS 1000' report is inspected	
		Then it will contain the expected information for the following panes / sections
			| Pane / Section            | Type                   |
			| Header (Logo)             | Graphical              |
			| Title                     | Text                   |
			| Summary                   | Table (Text / Numeric) |
			| Acceptance Criteria       | Table (Text / Numeric) |
			| Reference Peaks           | Table (Text / Numeric) |
			| Reference Peaks           | Graphical              |
			| Matched Peaks             | Graphical              |
			| Residuals                 | Graphical              |
			| Linear Residuals          | Graphical              |
			| Environmental Information | Table (Text)           |
			| Footer                    | Text                   |
			# See RPT-01 for detailed report content information
			And the Summary pane will show an overal Status of 'Failed' with a Calibration Status of 'Failed acceptance criteria'
			# Return the \Typhoon\config\CalibrationProcessingCriteria.xml RMSResidualLimit 'max' value to its initial value, then restart Typhoon
			

# ---------------------------------------------------------------------------------------------------------------------------------------------------
	@Updated
	@ManualOnly
	Scenario: RPT-07 - Mass Calibration Process Report - Printing
		Given the 'MajorMix' solution is present in 'Vial C'
		# If the solution has recently been changed, then purge the Sample Fluidics
			And the Instrument Setup process has the following Mass Calibration 'X' slots selected
				| Mass  | POS SENS | NEG SENS | POS RES | NEG RES |
				| 1000  |    X     |    X     |    X    |    X    |
				| 2000  |    X     |    X     |    X    |    X    |
				| 4000  |          |          |         |         |
			And the Instrument Setup process is 'Run'
			And the 'Instrument Setup Mass Calibration' process has completes successfully for each selected slot
		
		# Quick check of multiple reports	
		When the 'Success' link is opened for each slot
			And each displayed report is printed using the available report 'Print' button
			# Suggest using the Microsoft XPS printer, selecting a unique name for each slot report
		Then the correct slot name should be present in each printed report above the Summary table
			And the correct 'Status' should be present in each printed report within the Summary table
			And a signature area should be present at the bottom of each printed report

		# Detailed check of a single report			
		When the contents of the 'POS SENS 1000' printed report is inspected	
		Then the printed report contents and layout will match the display report contents


# ---------------------------------------------------------------------------------------------------------------------------------------------------
	@Updated
	Scenario Outline: RPT-08 - Mass Calibration Process Report - Persistance Test
		Given the expected reference solution is present in 'vial B'
			And the Instrument Setup process has the following Mass Calibration 'X' slots ticked
				| Mass  | POS SENS | NEG SENS | POS RES | NEG RES |
				| 1000  |    X     |    X     |    X    |    X    |
				| 2000  |    X     |    X     |    X    |    X    |
				| 4000  |          |          |         |         |
			And the Instrument Setup process is 'Run'
			And the 'Instrument Setup Mass Calibration' process completes successfully for each selected slot
		
		When a <Persistance Test> is performed
			
		# Quick check of multiple reports	
			And the 'Success' link is opened for each slot
		Then an 'Instrument Setup Mass Calibration' report is available in a seperate window for each selected slot
			And the correct slot name should be present in each report above the Summary table
			And the correct 'Status' should be present in each report within the Summary table
			
		# Detailed check of a single report			
		When the contents of the 'POS SENS 1000' report is inspected	
		Then it will contain the expected information for the following panes / sections
			| Pane / Section            | Type                   |
			| Header                    | Graphical (Logo)       |
			| Title                     | Text                   |
			| Summary                   | Table (Text / Numeric) |
			| Acceptance Criteria       | Table (Text / Numeric) |
			| Reference Peaks           | Table (Text / Numeric) |
			| Reference Peaks           | Graphical              |
			| Matched Peaks             | Graphical              |
			| Residuals                 | Graphical              |
			| Linear Residuals          | Graphical              |
			| Environmental Information | Table (Text)           |
			| Footer                    | Text                   |
			# See RPT-01 for detailed report content information

# ---------------------------------------------------------------------------------------------------------------------------------------------------

#END