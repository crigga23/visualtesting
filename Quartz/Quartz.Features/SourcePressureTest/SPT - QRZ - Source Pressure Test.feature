# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # SPT - QRZ - Source Pressure Test
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # AB / CDH / JS
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 22-October-2014
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # JS - Added 2 extra scenarios at the end for the SPT RB plots being displayed
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-340)                 # The user will access the Source Pressure screen from the Instrument tab in the  Dev Console.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-341)                 # The Source Pressure test page will be present for all users
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-342)                 # The software will allow the user to perform a source pressure test.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-349)                 # The user will be able to override the source pressure test, to allow the fluidics to be used.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-350)                 # The software will clear the source pressure tests override once the user has logged out.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-351)                 # The software will display source pressure test status messages.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-355)                 # The software will display results of source pressure test.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-356)                 # On start of source pressure test, the Vacuum.SourcePressure.Readback readback is plotted
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-357)                 # On completion of source pressure test readback plot is stopped
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-358)                 # On next source pressure test plot is cleared and restarted
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@ignore
@SourcePressureTest
Feature: Source Pressure Test
	In order to test Source Pressure Test
	I want to have the ability to run a Source Pressure Test, view the results and Override it, if it fails
	And I want to see corresponding changes to the Sample Fluidics when the test fails, and is re-run and passes.

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given Quartz is logged in and running
	And the instrument is in 'Operate'


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (HDD-171)                # Tests bases on HDD
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: SPT-01 Page Elements
	When the 'Source Pressure Test' page is inspected
	Then these 'Elements' are available of a specific 'Type'
		| Elements       | Type        |
		| Status         | Text Word   |
		| Advice Message | Text String |
		| Run Test       | Button      |
		| Override Test  | Button      |

Scenario Outline: SPT-02 SPT Process State vs SPT Status and Button State
	When the Source Pressure Test is '<SPT Process State>'
		And an '<Action>' is performed
	Then the Source Pressure Test is '<SPT Status>'
		And the Run Test button state is '<Button State>'
		Examples:
		| SPT Process State  | Action     | SPT Status | Button State |
		| Not Started        | N/A (None) | Idle       | Enabled      |
		| Started            | N/A (None) | Running    | Disabled     |
		| Completed (Passed) | N/A (None) | Idle       | Enabled      | 
		| Completed (Failed) | N/A (None) | Idle       | Enabled      |
		| Completed (Failed) | Override   | Idle       | Enabled      |

Scenario Outline: SPT-03 Test Status and Test Advice vs 'Override' Button State
	When the Source Pressure Test is in the '<Test Status>' state
		And the Advice message contains '<Test Advice String>'
	Then the '<Override Button State>' will be set
		Examples: Override Button Disabled
		| Test Status | Test Advice String | Override Button State |
		| Running     | N/A                | Disabled              |
		| Idle        | Passed             | Disabled              |

		Examples: Override Button Enabled
		| Test Status | Test Advice String | Override Button State |
		| Idle        | Failed             | Enabled               |


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-342)                 # The software will allow the user to perform a source pressure test.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: SPT-04 Perform source pressure test
	Given the source pressure test is 'Idle'
	When an attempt is made to start the source pressure test
	Then the source pressure test will 'Start'


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-349)                 # The user will be able to override the source pressure test, to allow the fluidics to be used.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: SPT-05 Fluidics Status During a SPT
	Given the '<Type of Fluidics>' flow state is initially at 'Infusion'
	When the source pressure test is being run
	Then the '<Type of Fluidics>' is set to '<Flow State>'
		And the '<Type of Fluidics>' controls are '<Controls State>'
			Examples:
			| Type of Fluidics | Flow State     | Controls State |
			| Sample           | Waste          | Disabled       |
			| Reference        | N/A (Previous) | Enabled        |

Scenario Outline: SPT-06 Fluidics Status After a SPT
	Given a source pressure test has already 'Passed'
		And the Sample Fluidics Flow State is set to '<Initial Fluidics Flow State>'
		And the sample '<Initial Fluidics Status>' status will be set
	When the source pressure test is run
		And the source pressure test '<Result>'
	Then the Sample '<Final Fluidics Status>' status will be set
		And the Sample Fluidics controls will be '<Controls Status>'
		And the Sample Fluidics Flow State will be set to '<Final Fluidics Flow State>'
			Examples: Passes
			| Initial Fluidics Flow State | Result | Initial Fluidics Status | Final Fluidics Status | Controls Status | Final Fluidics Flow State |
			| Infusion                    | Passes | Idle                    | Idle                  | Enabled         | Infusion                  |
			| Combined                    | Passes | Idle                    | Idle                  | Enabled         | Combined                  |
			| LC                          | Passes | Idle                    | Idle                  | Enabled         | LC                        |
			| Waste                       | Passes | Idle                    | Idle                  | Enabled         | Waste                     |

			Examples: Fails
			| Initial Fluidics Flow State | Result | Initial Fluidics Status | Final Fluidics Status | Controls Status | Final Fluidics Flow State |
			| Infusion                    | Fails  | Idle                    | Stopped               | Disabled        | Waste                     |
			| Combined                    | Fails  | Idle                    | Stopped               | Disabled        | Waste                     |
			| LC                          | Fails  | Idle                    | Stopped               | Disabled        | Waste                     |
			| Waste                       | Fails  | Idle                    | Stopped               | Disabled        | Waste                     |

Scenario: SPT-07 Previous SPT Fail - Fluidics Status After a SPT (Pass and Purge)
	Given a Source Pressure Test has previously 'Failed'
		And the initial Sample Fluidics Status is 'Stopped'
		And the Sample Fluidics Controls are 'Disabled'
	When the source pressure test is run and 'Passes'
		And the Sample Fluidics Controls are automatically 'Enabled'
		And the final Sample Fluidics Status is 'Stopped - Select Purge to Recover'
		And a Sample Fluidics 'Purge' is initiated
	Then after the purge has completed, the final Sample Fluidics Flow State will be 'Idle'
		And the Sample Fluidics Controls will 'Enabled'

Scenario: SPT-08 Previous SPT Fail - Fluidics Status After a SPT (Override and Purge)
	Given a Source Pressure Test has previously 'Failed'
	When the source pressure test result is 'Overridden'
		And the final Sample Fluidics Status is 'Stopped - Select Purge to Recover'
		And a Sample Fluidics 'Purge' is initiated
	Then after the purge has completed, the final Sample Fluidics Flow State will be 'Idle'
		And the Sample Fluidics Controls will 'Enabled'


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-350)                 # The software will clear the source pressure tests override once the user has logged out.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: SPT-09 Clear Override on Log Out
	Given the source pressure test has 'failed'
		And the source pressure test has been 'Overridden'
	When the current users' browser session is logged out
		And the same user logs back in
	Then the previous source pressure test override is cleared
		And a new source pressure test can be successfully run

Scenario: SPT-09b Not Overriden on Changing Tab
	Given the source pressure test has 'failed'
		And the source pressure test has been 'Overridden'
	When I leave and return to the Source Pressure Page
	Then the previous source pressure test override is still set

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-351)                 # The software will display source pressure test status messages.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-355)                 # The software will display results of source pressure test.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: SPT-10 Status Messages - Failure Condition (During SPT Run)
	Given a Source pressure test is NOT currently running
	When a '<Type>' of source pressure test is run
		And a specific instrument '<Failure Condition>' is forced during the run
	Then a specific '<Source Pressure Test Advice>' message will be shown with some '<Source Pressure Test Extra Information>'
		Examples: Automatic
		| Type      | Failure Condition | Source Pressure Test Advice                             | Source Pressure Test Extra Information                           |
		| Automatic | API GAS too Low   | Source Pressure Test Failed - Low API Gas Pressure      | Check API gas supply is at 7 bar, rerun source pressure test     |
		| Automatic | Exhaust Blocked   | Source Pressure Test Failed - Exhaust Pressure too high | Check exhaust system for restriction, rerun source pressure test |
		| Automatic | Source Leak       | Source Pressure Test Failed - Source Leak               | Check source and exhaust seals, rerun source pressure test       |
		| Automatic | N/A - None        | Source Pressure Test Passed                             | N/A - None                                                       |

		Examples: Manual
		| Type      | Failure Condition | Source Pressure Test Advice                             | Source Pressure Test Extra Information                           |
		| Manual    | API GAS too Low   | Source Pressure Test Failed - Low API Gas Pressure      | Check API gas supply is at 7 bar, rerun source pressure test     |
		| Manual    | Exhaust Blocked   | Source Pressure Test Failed - Exhaust Pressure too high | Check exhaust system for restriction, rerun source pressure test |
		| Manual    | Source Leak       | Source Pressure Test Failed - Source Leak               | Check source and exhaust seals, rerun source pressure test       |
		| Manual    | N/A - None        | Source Pressure Test Passed                             | N/A - None                                                       |

Scenario Outline: SPT-11 Status Messages - Failure Condition (SPT Not Running)
	Given a Source pressure test is NOT currently running
	When a specific instrument '<Failure Condition>' is forced
	Then a specific '<Source Pressure Test Status>' message will be shown with some '<Extra Information>'
		Examples:
		| Failure Condition | Source Pressure Test Status   | Extra information                                              |
		| API GAS too Low   | Warning: API Gas Pressure Low | Check API gas supply is at 7 bar                               |
		| Exhaust Blocked   | High Exhaust Pressure Trip    | Check exhaust system for restriction, run source pressure test |
		| Source Leak       | Warning: Source Leak          | Check source and exhaust seals                                 |

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-356)                 # On start of source pressure test, the Vacuum.SourcePressure.Readback readback is plotted
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-357)                 # On completion of source pressure test readback plot is stopped
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: SPT-12 Display Source Pressure Readback Plot when SPT in Progress
	Given a Source Pressure Test has 'Started'
	When a Source pressure Test is '<SPT Status>'
	Then a graphical display showing the Source Pressure Readback 'Vacuum.SourcePressure.Readback' will be '<SPT RB Plot State>'
		Examples:
		| SPT Status | SPT RB Plot State |
		| Running    | Plotting          |
		| Idle       | Not Plotting      | 
		
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-358)                 # On next source pressure test plot is cleared and restarted
# -------------------------#-------------------------------------------------------------------
Scenario: SPT-13 Display Source Pressure Readback Plot
	Given a Source Pressure Test has previously 'Completed'
		When the next Source Pressure Test has 'Started'
	Then the previous Source Pressure Readback 'Vacuum.SourcePressure.Readback' plot is cleared
		And a new Source Pressure Readback 'Vacuum.SourcePressure.Readback' starts to plot
	
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END