# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # HLP - QRZ - About Quartz
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # IP
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 31-Oct-14
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-132)	               # The software will have an About option to display the following information; software version and builds
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@General
@AboutQuartz
Feature: HLP - QRZ - About Box (Quartz)
	In order to access relevant and accurate software version information from the Quartz. I want to be able to access a modal dialog
	that displays the credits and revision information of the Quartz software. This should include the product name, the installed version and the various application 
	names with their respective versions along with the company name and copyright information.
# ---------------------------------------------------------------------------------------------------------------------------------------------------

@SmokeTest
Scenario: HLP-QRZ-01 - About Quartz availability
Then the 'About Quartz' software information is available


Scenario: HLP-QRZ-02 - Versioning - Default modules installed
#Given that no additional modules are installed in Quartz
When the 'About Quartz' software information is displayed
Then the content of the 'About Quartz' software information is available in the following Format
	| Product | Format      |
	| Quartz  | Build, Date |
	| Typhoon | Build, Date |
	| Osprey  | Build, Date |
# TODO: Add additional check to ensure that the build is a valid number, the Revision is a valid number and the Date is a valid date

Scenario: HLP-QRZ-04 - User is unable to edit the 'About Quartz' software information
Given the 'About Quartz' software information is displayed
Then the 'About Quartz' software information should be readonly

Scenario: HLP-QRZ-05 - 'About Quartz' software information displays the Company and Copyright information
When the 'About Quartz' software information is displayed
Then Company and Copyright information is displayed at bottom of the dialog	

Scenario: HLP-QRZ-06 - 'About Quartz' software information can be closed using the OK button
Given the 'About Quartz' software information is displayed
When the 'OK' button is clicked
Then the 'About Quartz' software information is no longer displayed

Scenario: HLP-QRZ-07 - 'About Quartz' software information can be closed using the Close icon
Given the 'About Quartz' software information is displayed
When the 'Close' icon is clicked
Then the 'About Quartz' software information is no longer displayed

Scenario: HLP-QRZ-08 - 'About Quartz' software information can be closed via the keyboard by pressing the Escape button
Given the 'About Quartz' software information is displayed
When the 'Esc' button is pressed on the keyboard
Then the 'About Quartz' software information is no longer displayed

# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END 		