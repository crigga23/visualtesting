# -----------------------------------------------------------------------------------------------------------------
# Revision:		01
# Author:     	CS, Date: 09-May-14
# Revised by: 	TBD, date revised TBD
# Basis:      	Discussion at Scrum Board
# -----------------------------------------------------------------------------------------------------------------

@ignore
@Performance
Feature: GeneralGUI
	In order to stress test the Quartz GUI
	As a automated version of Chris Hughes
	I want to click as many buttons as possible in as many combinations as possible

Scenario: RandomStressTestLeftHandTabs
When I select a random left hand side tabs 100 times
Then Quartz should not crash 

Scenario: LeftHandTabs_OrderedStressTest
When I select each left hand side tab in order 100 times with a 0 ms sleep
Then Quartz should not crash 

Scenario: LeftHandTabs_OrderedStressTestWithSleep
When I select each left hand side tab in order 100 times with a 5000 ms sleep
Then Quartz should not crash 
