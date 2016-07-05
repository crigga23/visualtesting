
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Instrument Setup (Resolution Optimisation) Reporting
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Mike Hodgkinson (Updated 06-OCT-15 by Christopher D Hughes)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 23-MAR-15
#                          # 17-MAY-16 - UPDATED - Chris D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # a). Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference, unless otherwise stated
#                          # 
#                          # b). 'minResolution', 'sensitivityModeResolution' and 'resolutionModeResolution' values used throughout the feature file
#                          #     need to be substituted for the current values found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
#                          #
#                          # c). Manually Setting Resolution:
#                          #     When manually determining a peak's resolution, the tune page 'Ions Per Push' should be approximately '2.0'
#                          #     otherwise an inaccurate value may be set. This can be done by changing the 'System 2' tab 'pDRE Attenuate' percentage
#                          #     value until the desired 'Ions Per Push' is observed (MZ Plot Data: top left blue value).
#                          #     Once the 'Ions Per Push' value is set to approximately 2.0 the peak's resolution can be changed by adjusting the 
#                          #     'Pusher Offset' or 'Reflectron Grid' value for that mode.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (06-OCT-15) - Updates to reflect changes in functionality due to FW#7327 and FW#7325
#                          # (17-MAY-16) - Updates to include initial Resolution Check (http://devtools/jira/browse/VION-254)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Quartz EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-165)                 # The software will render a report in a separate window.
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
Feature: Instrument Setup (Resolution Optimisation) Process Reporting
	In order to view details of the 'Instrument Setup (Resolution Optimisation)' results
	I want to be able to view the 'Resolution Optimisation' reports for each mode
	So that determining success criteria and diagnosing issues can be achieved


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the Instrument Setup slots have been 'Reset'
		And the following Instrument Setup 'Processes' have been succesfully run for both polarities
			| Processes      |
			| ADC Setup      |
			| Detector Setup |					


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@Ignore, @Updated
Scenario: RPT-01 - Resolution Optimisation Process Report - All Modes (Optimisation Performed - Resolution Improved)
	Given the resolution for all modes has been set approximately to between '15000' and '20000'
		# See the header notes above for 'Manual Test Notes - Manually Setting Resolution'
		# This resolution range will ensure that the process will not Error and will be optimised
		And the Instrument Setup process has 'Resolution Optimisaton' slots selected for all 'Modes'
			| Modes                |
			| Positive Sensitivity |
			| Positive Resolution  |
			| Negative Sensitivity |
			| Negative Resolution  |
		And the Instrument Setup process is 'Run'
		And the Instrument Setup 'Resolution Optimisation' process has successfully completed for all modes
	
	# Display Report
	When the Instrument Setup Resolution Optimisation 'Success' link is opened for each mode
	Then each 'Instrument Setup Resolution Optimisation' report will be displayed within a separate window
		And each 'Instrument Setup Resolution Optimisation' report will contain the following header information
			| Header Information                         | Comment                                           |
			| Title containing Waters logo               | i.e. Waters - THE SCIENCE OF WHAT'S POSSIBLE      |
			| Report Type / instrument polarity and mode | i.e. Resolution Optimisation Positive Sensitivity |
		And each report will contain the following 'Summary' section |
			| Summary Pane             | Comment                                                             |
			| Last Update Performed on | Day, Date, Time, GMT offset (i.e. Tue, 17 May 2016 10:38:02 +01:00) |
			| Message                  | Resolution Optimisation parameters optimised                        |
			| Initial Resolution       | Number (between 15000 and 20000)                                    |
			| Optimised Resolution     | Number (greater than Initial Resolution)                            |
		And each report will contain the following 'Environment Information'
			| Environment Information           | Comment                   |
			| Instrument type and serial number | i.e. Vion IMS QTof SAA077 |
			| Instrument driver version number  | i.e. v2.0.0.95            |
			| Quartz / Typhoon version number   | Number                    |
			| User logged into Quartz           | i.e. C Hughes             |
		And each report will contain the following footer information
			| Footer Information | Comments                                                         |
			| Date               | with room to the right to insert the date on a printed report    |
			| Signature          | with room to the right to insert a signature on z printed report |
	
	# Printed Report
	When each displayed report is printed using the available report 'Print' button
	# Suggest using the Microsoft XPS printer, selecting a unique name for each slot report
		And the contents of each report is inspected	
	Then the printed report contents / layout will match the display report contents for each mode
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: RPT-02 - Resolution Optimisation Process Report - All Modes (Optimisation NOT Performed)
	Given the resolution has already been optimised for all modes to at least the following
		| Polarity | Mode        | Initial Resolution                      |
		| Positive | Sensitivity | above 'sensitivityModeResolution' value |
		| Positive | Resolution  | above 'resolutionModeResolution' value  |
		| Negative | Sensitivity | above 'sensitivityModeResolution' value |
		| Negative | Resolution  | above 'resolutionModeResolution' value  |
		# 'sensitivityModeResolution' and 'resolutionModeResolution' values can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
		# This resolution will ensure that the process will not optimise the current parameter settings
		And the Instrument Setup process has 'Resolution Optimisaton' slots selected for all 'Modes'
			| Modes                |
			| Positive Sensitivity |
			| Positive Resolution  |
			| Negative Sensitivity |
			| Negative Resolution  |
		And the Instrument Setup process is 'Run'
		And the Instrument Setup 'Resolution Optimisation' process has successfully completed for all modes
	
	# Display Report
	When the Instrument Setup Resolution Optimisation 'Success' link is opened for each mode
	Then each 'Instrument Setup Resolution Optimisation' report will be displayed within a separate window
		And each 'Instrument Setup Resolution Optimisation' report will contain the following header information
			| Header Information                         | Comment                                           |
			| Title containing Waters logo               | i.e. Waters - THE SCIENCE OF WHAT'S POSSIBLE      |
			| Report Type / instrument polarity and mode | i.e. Resolution Optimisation Positive Sensitivity |
		And each report will contain the following 'Summary' section |
			| Summary Pane             | Comment                                                             |
			| Last Update Performed on | Day, Date, Time, GMT offset (i.e. Tue, 17 May 2016 10:38:02 +01:00) |
			| Message                  | Resolution did not need to be optimised                             |
			| Initial Resolution       | Number (between 15000 and 20000)                                    |
			| Threshold Resolution     | Number ('sensitivityModeResolution' or 'resolutionModeResolution')  |
		And each report will contain the following 'Environment Information'
			| Environment Information           | Comment                   |
			| Instrument type and serial number | i.e. Vion IMS QTof SAA077 |
			| Instrument driver version number  | i.e. v2.0.0.95            |
			| Quartz / Typhoon version number   | Number                    |
			| User logged into Quartz           | i.e. C Hughes             |
		# Footer information
		And each report will contain the following footer information
			| Footer Information | Comments                                                         |
			| Date               | with room to the right to insert the date on a printed report    |
			| Signature          | with room to the right to insert a signature on z printed report |
	
	# Printed Report
	When each displayed report is printed using the available report 'Print' button
	# Suggest using the Microsoft XPS printer, selecting a unique name for each slot report
		And the contents of each report is inspected	
	Then the printed report contents / layout will match the display report contents for each mode
	

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: RPT-03 - Resolution Optimisation Process Report - All Modes (Optimisation Performed - Resolution NOT Improved)
	Given the Instrument Setup 'Resolution Optimisation' process has been run successfully for <Polarity> <Mode>
		And the Resolution reported for that <Polarity> <Mode> has been recorded 
		# This can be found from the Report
		And the 'Precheck Parameter' for <Mode> is modified to a value 10000 higher than the resolution value attained during the run
			| Mode        | PreCheck Parameter        |
			| Sensitivity | sensitivityModeResolution |
			| Resolution  | resolutionModeResolution  |
			# PreCheck parameters can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
			# e.g. if the Report suggests a resolution of 55000 was attained in Sensitivity mode, then modify and save the 'sensitivityModeResolution' value to 65000. 
		And Typhoon is restarted
		And the Instrument Setup process has 'Resolution Optimisaton' slots selected for <Polarity> <Mode>
		And the Instrument Setup process is 'Run'
		And the Instrument Setup 'Resolution Optimisation' process has successfully completed
	
	# Display Report
	When the Instrument Setup Resolution Optimisation 'Success' link is opened for <Polarity> <Mode>
	Then each 'Instrument Setup Resolution Optimisation' report will be displayed within a separate window
		And the 'Instrument Setup Resolution Optimisation' report will contain the following header information
			| Header Information                         | Comment                                           |
			| Title containing Waters logo               | i.e. Waters - THE SCIENCE OF WHAT'S POSSIBLE      |
			| Report Type / instrument polarity and mode | i.e. Resolution Optimisation Positive Sensitivity |
		And each report will contain the following 'Summary' section |
			| Summary Pane             | Comment                                                                                                   |
			| Last Update Performed on | Day, Date, Time, GMT offset (i.e. Tue, 17 May 2016 10:38:02 +01:00)                                       |
			| Message                  | Resolution Optimisation parameters unchanged                                                              |
			| Initial Resolution       | Number                                                                                                    |
			| Optimised Resolution     | Number                                                                                                    |
			| Message                  | Optimised Resolution needed to be greater than initial resolution + standard tolerance [Tolerance Number] |
			#                            Where [Tolerance Number] is a value greater than 'Optimised Resolution' minus 'Initial Resolution'  
		And each report will contain the following 'Environment Information'
			| Environment Information           | Comment                   |
			| Instrument type and serial number | i.e. Vion IMS QTof SAA077 |
			| Instrument driver version number  | i.e. v2.0.0.95            |
			| Quartz / Typhoon version number   | Number                    |
			| User logged into Quartz           | i.e. C Hughes             |
		And each report will contain the following footer information
			| Footer Information | Comments                                                         |
			| Date               | with room to the right to insert the date on a printed report    |
			| Signature          | with room to the right to insert a signature on z printed report |
	
	# Printed Report
	When the displayed <Polarity> <Mode> report is printed using the available report 'Print' button
	# Suggest using the Microsoft XPS printer, selecting a unique name for the report
		And the contents of the printed report is inspected	
	Then the printed report contents / layout will match the display report contents for <Polarity> <Mode>
		
		Examples:
		| Polarity | Mode             |
		| Positive | Sensitivity only |
		| Negative | Resolution only  |
		# When the test has completed, return the 'sensitivityModeResolution' and 'resolutionModeResolution' values (\Typhoon\config\TofResolutionOptimisationConfiguration.xml)
		# to their original values and restart Typhoon.
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: RPT-04 - Resolution Optimisation Process Report - All Modes (Various Results)
	Given the Instrument Setup 'Resolution Optimisation' process has been run successfully for all modes
		# Positive Sensitivity Setup
		And the 'Positive Sensitivity' resolution has already been optimised to at least the 'sensitivityModeResolution' value
		# 'sensitivityModeResolution' value can be found in \Typhoon\config\TofResolutionOptimisationConfiguration.xml
		# A resolution of at least this value will ensure that the process will NOT optimise the current parameter settings for this mode
	
		# Positive Resolution Setup
		And the 'Positive Resolution' Tune page System 1 'Entrance' value has been set to zero
		# This will force the Positive Resolution slot to Error 
	
		#-Negative Sensitivity
		And the resolution for 'Negative Sensitivity' has been set approximately to between '15000' and '20000'
		# See the header notes above for 'Manual Test Notes - Manually Setting Resolution'
		# This resolution range will ensure that the process WILL be optimised
	
		#-Negative Resolution
		# This slot will be manually 'Aborted' and does not need a Setup
		
		And the Instrument mode is set to 'Positive Sensitivity'
		And the Instrument Setup process has 'Resolution Optimisaton' slots selected for all modes
	
	When the Instrument Setup process is 'Run'
		And the Instrument Setup 'Resolution Optimisation' process has 'Completed' for the following
			| Completed            |
			| Positive Sensitivity |
			| Positive Resolution  |
			| Negative Sensitivity |
		But during the 'Negative Resolution' Resolution Optimisation process the process is manually aborted
	
	# Display Report
	Then the 'Positive Sensitivity' Resolution Optimisation 'Success' link opens a report that shows the mode has NOT been Optimised
		But the 'Positive Resolution' Resolution Optimisation 'Error' link does not open a report
		And the 'Negative Sensitivity' Resolution Optimisation 'Success' link opens a report that shows the mode HAS been Optimised
		But the 'Negative Resolution' Resolution Optimisation 'Aborted' link does not open a report	
		# When the test has completed, return 'sensitivityModeResolution' (\Typhoon\config\TofResolutionOptimisationConfiguration.xml) to its original value and restart Typhoon.
		# When the test has completed, return the 'Positive Resolution' Tune page System 1 'Entrance' to its original value


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@Ignore, @Updated
Scenario: RPT-05 - Resolution Optimisation Process Report - All Modes Error (Missing Solution)
	Given the expected reference solution is 'NOT' present in 'vial B'
	# This could also be aceived by setting the Detector Voltage to zero for each polarity 
	When the Instrument Setup process has 'Resolution Optimisaton' slots selected for all modes
		And the Instrument Setup process is 'Run'
	Then the eventually the Instrument Setup Resolution Optimisation process goes to 'Error' for all modes
		But the 'Error' slots do NOT link to a report
	# Set the Detector Voltage back to the initial value for Positive and Negative, if there were changed


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@Ignore, @Updated
Scenario: RPT-06 - Resolution Optimisation Process Report - All Modes Error (Above standard deviation limit)
	Given the maximum standard deviation is set to 0.0
	# Note: Set the standard deviation limit (maxRSD) to 0.0 in the 'TofResolutionOptimisationConfiguration.xml'
		And Typhoon is restarted
	When the Instrument Setup process has all 'Resolution Optimisaton' slots selected
		And the Instrument Setup process is 'Run'
	Then the Instrument Setup Resolution Optimisation process goes to 'Error' for all modes
		But the 'Error' slots do NOT link to a report
	# Set 'maxRSD' in 'TofResolutionOptimisationConfiguration.xml' back to its initial value and restart Typhoon
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
@Ignore, @Updated
Scenario: RPT-07 - Resolution Optimisation Process Report - All Modes Error (Resolution out of tolerance)
	Given the resolution for all modes is less than 10000
		# See the header notes above for 'Manual Test Notes - Manually Setting Resolution'
	When the Instrument Setup process has all 'Resolution Optimisaton' slots selected
		And the Instrument Setup process is 'Run'
	Then the Instrument Setup Resolution Optimisation process goes to 'Error' for all modes
		But the 'Error' slots do NOT link to a report
		# Set the Detector Voltage back to the initial value for Positive and Negative, if there were changed                    


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@Ignore, @Updated
Scenario Outline: RPT-08 - Resolution Optimisation Process Report - Slots Manually Aborted
	Given the Instrument Setup process has 'Resolution Optimisaton' slots selected for <Polarity> <Mode>
		And the Instrument Setup process is 'Run'
		And the <Polarity> <Mode> slot is manually aborted
	Then the Instrument Setup Resolution Optimisation process goes to 'Aborted' for <Polarity> <Mode>
		But the 'Aborted' slot does NOT link to a report
			
			Examples:
			| Polarity | Mode             |
			| Positive | Sensitivity only |
			| Negative | Resolution only  |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@Ignore, @Updated
Scenario Outline: RPT-09 - Resolution Optimisation Process Report - Persistance Test
	Given the Instrument Setup 'Resolution Optimisation' process has been run successfully for all modes
	When a <Persistance Test> is performed
		And the 'Success' link is opened for each mode
	Then an 'Instrument Setup Resolution Optimisation' report is available in a seperate window for each selected slot
		And the correct slot name should be present in each report above the Summary table
	# Detailed check of a single report			
	When the contents of the 'Positive Sensitivity' report is inspected	
	Then it will contain the expected information for the following panes / sections
		| Pane / Section          | Type                   |
		| Header                  | Graphical (Logo)       |
		| Title                   | Text                   |
		| Summary                 | Table (Text / Numeric) |
		| Environment Information | Table (Text)           |
		| Footer                  | Text                   |
		# See RPT-02 for detailed report content information
		
			Examples:
			| Persistance Test                                           |
			| Browser closed,        Browser Reopened                    |
			| Browser closed,        Typhoon Restarted, Browser Reopened |
			| Typhoon Restarted,     Browser Refreshed                   |
			| Clear Browser History, Browser Refreshed                   |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END