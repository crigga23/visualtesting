@visualtestingfeature
Feature: SMK - SmokeTest With Eyes
	As a Quartz user
	I want to be be able to perform the basic functions

Scenario: Quartz Navigation 
Given that I am logged into Quartz
Then it is possible to navigate through the instrument pages

# Commented out the Source Pressure Test line in the above data table as the plot data 'widget' has temporarily been removed from the UI and will return at some point in the future.

Scenario: Instrument power indicator is displaying correct status the to the user
Given that I am logged into Quartz
#Then the  instrument should display the correct status for each mode
Then the instrument power indicator should be visible
	And the correct status should be displayed
	| instrument power button | status |
	| Source                  | yellow |
	| Standby                 | red    |
	| Operate                 | green  |
#
## SAME AS CHECK BEAM - SAMPLE SODIUM FORMATE TEST BELOW
#Scenario: SMK - 04 - Basic Plot - Start Tuning
#Given that the Quartz Tune page is open
#When the detector voltage is set to 3000
#	And Sample Vial A is selected
#	And Tuning is started
#Then Sodium Formate plot is displayed and refreshes correctly
#
Scenario: Basic Plot - Abort Tuning
Given that the Quartz Tune page is open
	And the detector voltage is set to 3000
	And Sample Vial A is selected
	And Tuning is started
When Tuning is aborted
Then Sodium Formate plot is halted
#
Scenario: Basic Plot Types - Check Plot BPI
Given that the Quartz Tune page is open
	And Quartz is in Mobility mode
When the plot BPI button is clicked
Then the expected live plot is shown and should match the baseline
#
Scenario: Basic Plot Types - Check Plot MZ
Given that the Quartz Tune page is open
	And Quartz is in Mobility mode
When the plot MZ button is clicked
Then the expected live plot is shown and should match the baseline
#
Scenario: Basic Plot Types - Check Plot TIC 
Given that the Quartz Tune page is open
	And Quartz is in Mobility mode
When the plot TIC button is clicked
Then the expected live plot is shown and should match the baseline
#
Scenario: Basic Plot Types - Check Drift Time
Given that the Quartz Tune page is open
	And Quartz is in Mobility mode
When the plot DT button is clicked
Then the expected live drift time pop-out dialog is displayed


