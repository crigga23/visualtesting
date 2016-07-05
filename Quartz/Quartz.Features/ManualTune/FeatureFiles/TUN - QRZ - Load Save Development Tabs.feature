# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Load Save Development Tabs
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Chris Stephens
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 11-Decemeber-2014
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

# --------------------------------------------------------------------------------------------------------------------------------------------------
# Basis: Dev Console Software Specification (current 0.7)                  
# --------------------------------------------------------------------------------------------------------------------------------------------------
# Coverage:
#	SS-201 - The software will provide a configurable control section where custom controls can be added.
#	SS-201 - Configuration control will only be available within the Dev Console.
#	SS-201 - The user will be able to save the custom configuration.
#	SS-201 - The user will be able to load a previously saved custom configuration.
#	SS-201 - The user will be able to clear all the custom configuration.

# (SS-170)		# The user will be able to save instrument setttings under a specified name
# (SS-171)		# The user will be able to load previously saved instrument settings. It should be possible to select a set of previously saved instrument settings from a list
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# CR ID: FW#9039 # Tick icons missing from tabs customisation menu (Scenario 12)
# ---------------#-----------------------------------------------------------------------------------------------------------------------------------

@ManualTune
@CustomTabCleanup
Feature: TUN - QRZ - Load Save Development Tabs
	In order to customise the Dev Console Tune Page
	As a research scientist
	I want to add and delete custom tabs containing custom controls
	And I want to be able to save and load sets of these tabs
	And I want to be able to clear all custom tabs to return to a default view

Background: 
Given All custom tabs are cleared

# Adding tabs

Scenario: 01 - Adding Many Empty Tabs and renaming
Given I add '10' custom tabs
And I rename all custom tabs
When I leave and return to the 'Tune Page'
Then '10' custom tabs should be visible
And all custom tabs should have the correct name

Scenario: 02 - Adding Many Randomly Populated Tabs
Given I add '10' custom tabs
And I add multiple random custom controls
When I leave and return to the 'Tune Page'
Then '10' custom tabs should be visible
And  all controls should be visible and correct

# Adding and deleting tabs

Scenario: 03 - Adding and Deleting Single Empty Tab
Given I add '1' custom tabs
When I delete the last '1' custom tabs
Then '0' custom tabs should be visible

Scenario: 04 - Adding Multiple and Deleting Some Random Empty Tabs
Given I add '10' custom tabs
When I delete a random '5' custom tabs
Then '5' custom tabs should be visible
And the correct custom tabs are visible

Scenario: 05 - Adding and Deleting Single Populated Tab
Given I add '1' custom tabs
And I add multiple random custom controls
When I delete the last '1' custom tabs
Then '0' custom tabs should be visible

Scenario: 06 - Adding Multiple and Deleting Random Populated Tab
Given I add '10' custom tabs
And I add multiple random custom controls
When I delete a random '5' custom tabs
Then '5' custom tabs should be visible
And the correct custom tabs are visible
And  all controls should be visible and correct

# Adding and clearing tabs

Scenario: 07 - Adding Multiple and Clearing Empty Tabs
Given I add '5' custom tabs
And I clear custom tabs
Then '0' custom tabs should be visible

# Adding, Saving, Clearing, Loading

Scenario: 08 - Saving and Loading Multiple Empty Tabs
Given I add '5' custom tabs
And I rename all custom tabs
And I save custom tabs
And I clear custom tabs
When I load custom tabs
Then '5' custom tabs should be visible
And the correct custom tabs are visible
And all custom tabs should have the correct name

Scenario: 09 - Saving and Loading Multiple Populated Tabs
Given I add '8' custom tabs
And I rename all custom tabs
And I add multiple random custom controls
And I save custom tabs
And I clear custom tabs
When I load custom tabs
Then '8' custom tabs should be visible
And the correct custom tabs are visible
And all custom tabs should have the correct name
And  all controls should be visible and correct

# Adding, Saving, Loading, Adding, Saving, Loading

Scenario: 10 - Adding Multiple Renamed Populated Tabs, Clearing, Adding Multiple Renamed Populated Tabs, Saving and Loading
Given I add '20' custom tabs
And I rename all custom tabs
And I add multiple random custom controls
And I clear custom tabs
And I add '15' custom tabs
And I rename all custom tabs
And I add multiple random custom controls
And I save custom tabs
And I clear custom tabs
When I load custom tabs
Then '15' custom tabs should be visible
And the correct custom tabs are visible
And all controls should be visible and correct
And all custom tabs should have the correct name

# Adding, Saving, Loading, Adding, Loading

Scenario: 11 - Adding Multiple Renamed Populated Tabs, Clearing, Adding Multiple Renamed Populated Tabs, Saving and Loading
Given I add '10' custom tabs
And I rename all custom tabs
And I add multiple random custom controls
And I save custom tabs
And I add '7' custom tabs
When I load custom tabs
Then '10' custom tabs should be visible
And the correct custom tabs are visible
And all controls should be visible and correct
And all custom tabs should have the correct name

@ignore
@Updated

Scenario: 12 - Custom Tab view
Given I add '2' custom tabs
And I rename the custom tabs as 'Custom tab 1' and 'Custom tab 2'
Then the 'Tabs' are visible
	| Tabs          |
	| ESI LockSpray |
	| Instrument    |
	| Fluidics      |
	| StepWave      |
	| Trap/IMS      |
	| Cell1         |
	| Cell2         |
	| System1       |
	| System2       |
	| ADC2          |
	| MS Profile    |
	| RF            |
	| Gases         |
	| Custom tab 1  |
	| Custom tab 2  |
When I access the 'Customize tab view' icon
Then a list of tabs open conaining all the tabs from the 'Controls' page
	And a tick icon is present in front of every tab name
When a tab from Custom tab view is in 'State1' and the tab content has 'Visibility1' in the Controls page
	And I select it
	Then the tab from Custom tab view is 'State2' and the tab content has 'Visibility2' in the Controls page
	| State1   | Visibility1 | State2   | Visibility2 |
	| ticked   | visible     | unticked | not visible |
	| unticked | not visible | ticked   | visible     |

#------------------------------------------------------------------------------------------------------------------------------------------------
#END