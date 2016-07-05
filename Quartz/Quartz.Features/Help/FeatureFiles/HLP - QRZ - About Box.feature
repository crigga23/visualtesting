# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # HLP - QRZ - About Box
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
@AboutBoxInfo
Feature: About Box software information
	In order to access relevant and accurate software version information from the Quartz top level, I want to be able to access a modal dialog box 
	that displays the credits and revision information of the Quartz software, product name and the installed version and the various application 
	names with their respective versions and company and copyright information
# ---------------------------------------------------------------------------------------------------------------------------------------------------


Scenario: HLP-QRZ-01 - About Box availability
	When Quartz top level page is accessed
	Then access to the 'About Box' is available

@Defect	
@CR_Build_and_version_only_appear_in_MSI_installer 	
Scenario: HLP-QRZ-02 - Versioning - all modules installed
	Given that Dev Console, WRENS,AMITS and Man Test are installed
	When the About Box is accessed
	Then the content of the About Quartz is available with Format
		| About Quartz | Format                |
		| Quartz       | Build, Revision,Date  |
		| Typhoon      | Build, Revision,Date  |
		#| Dev Console  | x.x.xx |
		#| WRENS        | x.x.xx |
		#| AMITS        | x.x.xx |
		#| Man Test     | x.x.xx |
		#And the version number from 'About Box' can be manualy checked to match the version number from the build server 
#For Dev console , wrens, Amits and man test format is not yet known hence it is kept as it is for now

@Defect		
@CR_Build_and_version_only_appear_in_MSI_installer 	
Scenario: HLP-QRZ-03 - Versioning - subset of modules installed
	Given that Dev Console, WRENS,AMITS and Man Test are not installed
	When the About Box is accessed
	Then the content of the About Quartz is available with Format
		| About Quartz | Format               | 
		| Quartz       | Build, Revision,Date | 
		| Typhoon      | Build, Revision,Date | 
		| Dev Console  |                      | 
		| WRENS        |                      | 
		| AMITS        |                      | 
		| Man Test     |                      | 
		#And the version number from 'About Box' can be manualy checked to match the version number from the build server 

@ignore
Scenario: HLP-QRZ-04 - About Box edit
	Given that About Box is open
	Then the content can not be edited

Scenario: HLP-QRZ-05 - About Box content - copyright information
	When the About Box is accessed
	Then Company information and copyright information is displayed at bottom of the dialog	

Scenario: HLP-QRZ-06 - About Box closure OK button
	Given that About Box is open
	When the 'OK' button is pressed
	Then the About Box information is no longer displayed

Scenario: HLP-QRZ-07 - About Box closure top right X
	Given that About Box is open
	When the top right 'X' button is pressed
	Then the About Box information is no longer displayed

Scenario: HLP-QRZ-08 - About Box closure keyboard Esc
	Given that About Box is open
	When 'Esc' is pressed on the keyboard
	Then the About Box information is no longer displayed

#Scenario Outline: HLP-QRZ-06 - Closing About Box
#	Given the 'About Box' is accessed
#	When closing the About Box using the <Closing mode>
#	Then the 'About Box' will close
#	Examples: 
#	| Closing mode                 |
#	| Esc key                      |
#	| X button                     |
#	| OK button                    |
#	| Left click outside About Box |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END 		