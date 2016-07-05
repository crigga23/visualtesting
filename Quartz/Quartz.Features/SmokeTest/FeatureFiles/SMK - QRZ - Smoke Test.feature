# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # SMK - Smoke Test
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CM
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 22-DEC-14
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

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # \\tu-server-sw\tu-server1\docs\Quartz\Quartz Smoke Test.xlsx
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-124				   # The software will require all users to login using a corporate username and password
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-127				   # The software will have a logout option available on the main dashboard
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-124				   # The software will display the currently logged in user on the main dashboard
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-178				   # The user will be able to abort a running acquisition
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-193				   # The user will be able to switch the instrument into Standby
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-195				   # The software will indicate the current operate status of the instrument
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-209				   # It will be possible to see real time plots of the following: Mass Spectrum; Drift Time; BPI; TIC; XIC; Arbitrary Readbacks; Peak Properties
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-418				   # The software will display Ion Per Push on the Tuning screen
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-534				   # The health configuration option will be available to all users
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-569				   # Software shall provide a plot panel which can used in Tune page, Scope Mode page and Quad Setup page
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@SmokeTest
Feature: SMK - QRZ - Smoke Test
	As a Quartz user
	I want to be be able to perform the basic functions

@Defect
@CR_FW9680
@CR_FW9764
Scenario: SMK - 01 - Quartz Versioning
Given the installer is present
When I navigate to the about page
Then the installed build matches the installer version
	And the installed build matches the version in add remove programs
	And I close the about page

Scenario: SMK - 02 - Quartz Navigation
Given that the Quartz Tune page is open
Then it is possible to navigate to the following instrument pages
| instrument page      | number of widgets | widget title                                                               |
| Tune                 | 3                 | Plot Data, Controls                                                        |
| Manual Calibration   | 2                 | Calibrate Slot, Progress Log                                               |
| Instrument Setup     | 4                 | Instrument Setup                                                           |
| Vacuum               | 4                 | Vacuum status, Pressures (mBar), Turbo Speeds (%), Turbo Operation Times   |
| Quad Setup           | 3                 | Controls, Plot Data, Quad Setup                                            |
| Detector Setup       | 4                 | Detector Setup, Positive Mass Results, Negative Mass Results, Progress Log |
| Scope Mode           | 3                 | Scope Mode:, Plot Data, Controls                                           |
| Source Pressure Test | 1                 | Source Pressure Test                                                       |
| IMS Pressure Control | 1                 | IMS Pressure Control                                                       |
| Health Status        | 1                 | Health Status                                                              |

Scenario: SMK - 03 - Instrument power indicator is displaying correct status the to the user
Given that the Quartz Tune page is open
Then the instrument power indicator should be visible
	And the correct status should be displayed
	| instrument power button | status |
	| Source                  | yellow |
	| Standby                 | red    |
	| Operate                 | green  |


@ignore
@ManualOnly
Scenario: SMK - 04 - Basic Plot - Start Tuning
Given that the Quartz Tune page is open
When the detector voltage is set to 3000
	And Sample Vial A is selected
	And Tuning is started
Then Sodium Formate plot is displayed and refreshes correctly

@ignore
@ManualOnly
Scenario: SMK - 05 - Basic Plot - Abort Tuning
Given that the Quartz Tune page is open
	And the detector voltage is set to 3000
	And Sample Vial A is selected
	And Tuning is started
When Tuning is aborted
Then Sodium Formate plot is halted

@ignore
@ManualOnly
Scenario: SMK - 06 - Basic Plot - Starting and Abort Tuning Consecutively
Given that the Quartz Tune page is open
Given the detector voltage is set to 3000
	And Sample Vial A is selected
When Tuning is started and aborted multiple times in succession
Then the Sodium Formate plot refreshes correctly when tuning and is halted when aborted

@ignore
@ManualOnly
Scenario Outline: SMK - 07 - Basic Plot Types - Check Plot 
Given that the Quartz Tune page is open
	And Quartz is in Mobility mode
When the plot <button> button is clicked
Examples: 
| button |
| BPI    |
| MZ     |
| TIC    |
Then the expected live plot is shown

@ignore
@ManualOnly
Scenario: SMK - 08 - Basic Plot Types - Check Drift Time
Given that the Quartz Tune page is open
	And Quartz is in Mobility mode
When the plot DT button is clicked
Then the expected live drift time pop-out dialog is displayed

@Obsolete
@ignore
@ManualOnly
Scenario: SMK - 09 - Basic Plot Types - Chart Readback Modal - GUI
Given that the Quartz Tune page is open
	And Quartz is in Mobility mode
When the plot RB button is clicked
Then the 'Chart Readback' dialog should be displayed
	And all the 'Chart Readback' controls should be present
	And click the 'Chart Readback' Cancel button

@Obsolete
@ignore
@ManualOnly
Scenario: SMK - 10 - Basic Plot Types - Chart Readback Modal - Currently Plotted List
Given that the Quartz Tune page is open
	And Quartz is in Mobility mode
When the plot RB button is clicked
	And the 'Chart Readback' dialog is displayed
Then items can be added and removed from the Available List to the Currently Plotted List
	And click the 'Chart Readback' Cancel button

@Obsolete
@ignore
@ManualOnly
Scenario: SMK - 11 - Basic Plot Types - Chart Readback Modal - No items in the Currently Plotted List
Given that the Quartz Tune page is open
	And Quartz is in Mobility mode
When the plot RB button is clicked
	And the 'Chart Readback' dialog is displayed
	And there are no items in the currently plotted list
Then the ChartReadback Plot button should be disabled
	And click the 'Chart Readback' Cancel button

@Obsolete
@ignore
@ManualOnly
Scenario: SMK - 12 - Basic Plot Types - Plot Peak Properties Modal - GUI
Given that the Quartz Tune page is open
	And Quartz is in Mobility mode
When the plot PP button is clicked
Then the 'Plot Peak Properties' dialog should be displayed
	And all the 'Plot Peak Properties' controls should be present
	And click the 'Plot Peak Properties' Cancel button


@ignore
@ManualOnly
Scenario: SMK - 13 - Basic Plot Types - DT button status and Plot
Given that the Quartz Tune page is open
	And Quartz is in Mobility mode
	And the plot DT button is clicked
When Quartz is switched into TOF mode
Then the DT button should be disabled
	And the DT plot should stop updating if it is still visible


@ignore
@ManualOnly
Scenario: SMK - 14 - Acquisition Tuning
Given that the Quartz Tune page is open
When Tuning is started
	And the Fluidics tabs has been selected from the Controls widget
Then a plot should be generated for the following sample
| Sample |
| A      |
| B      |
| C      |
| Wash   |


Scenario: SMK - 15 - Quartz pages do not require a dependency upon http or https
Given Quartz does not contain any pages that are dependent upon http or https
| quartz page          |
| Tune                 |
| Manual Calibration   |
| Instrument Setup     |
| Vacuum               |
| Quad Setup           |
| Detector Setup       |
| Scope Mode           |
| Source Pressure Test |

@ignore
@FunctionalityIncomplete
Scenario: SMK - 16 - Check for a beam
Given I am able to log into Quartz
Then I am able to get a beam

@ignore
@FunctionalityIncomplete
Scenario: SMK - 17 - Quartz Logging In
Given that Typhoon has been started
And that Quartz has just been started
When I am on the Quartz login page
Then I am able to log in using a corporate username and password

@ignore
@FunctionalityIncomplete
Scenario: SMK - 18 - Quartz Logging Out
Given I am logged into Quartz as a corporate user
Then Quartz will an option to log out is presented to the user on the Quartz Dashboard
	And I am able to log out of Quartz

@ignore
@FunctionalityIncomplete
Scenario: SMK - 19 - Quartz User is able to log back in after logging out
Given I am able to log into Quartz as a corporate user
Then I am able to log out of Quartz
	And I am able to log back into Quartz

@ignore
@FunctionalityIncomplete
Scenario: SMK - 20 - Quartz Currently Logged in user is displayed
Given I am logged into Quartz as a corporate user
Then the user currently logged in is displayed on the Quartz Dashboard