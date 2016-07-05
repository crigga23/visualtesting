# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Sample Fluidics Control
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 08-OCT-13
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Revised by: 	 		   # MH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date Revised:            # 11-FEB-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # New format applied, some scenarios modified
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-490)                 # The software will provide a fluidics control component, which can be used by any instrument that requires fluidics control. This fluidics control component will support the following functionality.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-493)                 # This software component shall provide the user with the status of the sample fluidics and the reference fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-496) 				   # This software will allow the user to start the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-497) 	               # This software will allow the user to stop the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-500) 				   # This software will allow the user to refill the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-501) 		    	   # This software will allow the user to purge the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-504) 				   # This software will allow the user to select which Reservoir to be used (A, B, C or Wash).
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-506) 				   # The software will allow the user to set the infusion flow rate
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-508) 				   # The software will allow the user to set the divert valve flow state to LC, Infusion, Combined or Waste.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-509) 				   # The software will allow the user to view the volume remaining in the syringe.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-511) 				   # The software will allow the user to view any fluidices error messages.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-513) 				   # The software will allow the user to reinitialise the fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-515) 				   # The software will allow the user to select inject, which is a pseudo loop injection.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-519) 				   # The APGC source has no fluidics connections, so sample fluidics will not be available to the user when an APGC source is fitted. The lockspray fluidics will still be available.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-520) 				   # On recognition of an APGC source being fitted, sample fluidics will be set to waste and the controls grayed out.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-560) 				   # The software will allow the user to set the sample reservoir illunination to Automatic, All or Off.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
@manualonly
Feature: Sample Fluidics Control
   In order to control the instrument sample syringe
   I want to be able to perform functions on the sample fluidics
   And view status of the sample fluidics system


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-490)                 # The software will provide a fluidics control component, which can be used by any instrument that requires fluidics control. This fluidics control component will support the following functionality.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Background:
	Given the sample fluidics control is available
		And the source pressure test is in a 'Passed' state


Scenario: TUN 01 - Sample Fluidics - Dropdown options
	When the sample fluidics control is inspected
	Then the following drop down 'Parameters' with 'Options' are available
		| Parameters   | Options    |
		| Reservoir    | A          |
		| Reservoir    | B          |
		| Reservoir    | C          |
		| Reservoir    | Wash       |
		| Flow path    | Infusion   |
		| Flow path    | LC         |
		| Flow path    | Combined   |
		| Flow path    | Waste      |
		| Fill volume  | 50         |
		| Fill volume  | 100        |
		| Fill volume  | 150        |
		| Fill volume  | 200        |
		| Fill volume  | 250        |
		| Wash cycles  | 1          |
		| Wash cycles  | 2          |
		| Wash cycles  | 3          |
		| Wash cycles  | 4          |
		| Illumination | Always on  |
		| Illumination | Always off |
		| Illumination | Automatic  |


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-496) 				   # This software will allow the user to start the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-493)                 # This software component shall provide the user with the status of the sample fluidics and the reference fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-02 Sample Fluidics - Start infusion from full
	Given that the sample syringe is full
		And that the fluidics is stopped
		And the status is idle
	When the sample fluidics 'start infusion' option is selected
	Then the fluidics is started at the expected flow rate
		And the 'start infusion' option is replaced by a 'stop infusion' option
		And the sample fluidics status is updated to running

Scenario: TUN-03 Sample Fluidics - Start infusion when empty
	Given that the sample syringe is empty
		And the fluidics are stopped
		And the status is at idle
	When the sample syringe 'start infusion' option is inspected
	Then the option is disabled


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-497) 	               # This software will allow the user to stop the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-493)                 # This software component shall provide the user with the status of the sample fluidics and the reference fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-04 Sample Fluidics - Stop infusion
	Given that the sample syringe is infusing
		And the status is infusing
	When the sample fluidics 'stop infusion' option is selected
	Then the fluidics are stopped
		And the 'stop infusion' option is replaced by a 'start infusion' option
		And the status is updated to idle


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-500) 				   # This software will allow the user to refill the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-493)                 # This software component shall provide the user with the status of the sample fluidics and the reference fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-05 Sample Fluidics - Refilling from empty
	Given that the sample syringe is empty
		And the sample fluidics are stopped
		And the status is at idle
	When the sample syringe 'refill' option is selected
	Then the sample syringe starts refilling
		And the 'refill' option is replaced by a 'stop refill' option
		And the status is updated to refilling

Scenario: TUN-06 Sample Fluidics - Stopping a refill
	Given that the sample syringe is refilling
		And the status is refilling
	When the sample syringe 'stop refill' option is selected
	Then the sample syringe stops refilling
		And the 'stop refill' option is replaced by a 'refill' option
		And the status is updated to idle

Scenario: TUN-07 Sample Fluidics - Refill option when full
	Given that the sample syringe is full
		And the fluidics are stopped
		And the status is at idle
	When the sample syringe 'refill' option is inspected
	Then the sample option is disabled
		
Scenario Outline: TUN-08 Sample Fluidics - Refill and syring volume
	Given that the sample syringe is empty
		And the status is at idle
	When the syring volume is set to <Volume>
		And the user selects to perform a 'refill'
	Then the sample syringe refills to the <Fill> level
		Examples:
		| Volume | Fill |
		| 50     | 20%  |
		| 100    | 40%  |
		| 150    | 60%  |
		| 200    | 80%  |
		| 250    | 100% |
		

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-501) 		    	   # This software will allow the user to purge the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-493)                 # This software component shall provide the user with the status of the sample fluidics and the reference fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-09 Sample Fluidics - Purge from stopped
	Given that the sample syringe is stopped
		And the status is idle
	When the sample fluidics 'purge' option is selected
	Then the sample purging process begins
		And the 'purge' option is replaced by a 'stop purge' option
		And the status is updated to purging
	
Scenario: TUN-10 Sample Fluidics - Stopping a purge
	Given that the sample syringe is purging
		And the status is purging
	When the sample fluidics stop is selected
	Then the sample purging process stops
		And the status is updated to Stopped Recover

Scenario: TUN-11 Sample Fluidics - Purge from stopped recover
	Given that the fluidics are in a Stopped Recover state
		And the status is stopped
	When the sample fluidics purged is selected
	Then the sample purging process begins
		And the status is updated to purging

Scenario Outline: TUN-12 Sample Fluidics - Wash cycles
	Given that the sample syringe status is idle
	When the wash cycle is set to <Cycles>
		And the user selects to perform a 'wash'
	Then the <Action> is carried out with the correct <Status>
		Examples:
		| Cycles | Action       | Status  |
		| 1      | 1 wash cycle | Washing |
		| 2      | 2 wash cycle | Washing |
		| 3      | 3 wash cycle | Washing |
		| 4      | 4 wash cycle | Washing |

Scenario: TUN-13 Sample Fluidics - Stopping a wash
	Given that the sample syringe is washing
		And the status is washing
	When the sample fluidics 'stop wash' option is selected
	Then the washing process stops
		And the status is updated to Stopped Recover


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-504) 				   # This software will allow the user to select which Reservoir to be used (A, B, C or Wash).
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-14 Sample Fluidics - Selecting reservoir
	Given that the sample fluidics vial is initially set to <Intial Vial>
	When I make another fluidics vial <Selection>
	Then the system performs an <Action>
		And then the <Final Vial> is selected
		Examples:
		| Initial Vial | Selection | Action  | Final Vial |
		| Vial A       | Vial A    | Nothing | Vial A     |
		| Vial A       | Vial B    | Purge   | Vial B     |
		| Vial A       | Vial C    | Purge   | Vial C     |
		| Vial A       | Vial Wash | Purge   | Vial Wash  |
		| Vial B       | Vial B    | Nothing | Vial B     |
		| Vial B       | Vial A    | Purge   | Vial A     |
		| Vial B       | Vial C    | Purge   | Vial C     |
		| Vial B       | Vial Wash | Purge   | Vial Wash  |
		| Vial C       | Vial C    | Nothing | Vial C     |
		| Vial C       | Vial A    | Purge   | Vial A     |
		| Vial C       | Vial B    | Purge   | Vial B     |
		| Vial C       | Vial Wash | Purge   | Vial Wash  |
		| Vial Wash    | Vial Wash | Nothing | Vial Wash  |
		| Vial Wash    | Vial A    | Purge   | Vial A     |
		| Vial Wash    | Vial B    | Purge   | Vial B     |
		| Vial Wash    | Vial C    | Purge   | Vial C     |


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-508) 				   # The software will allow the user to set the divert valve flow state to LC, Infusion, Combined or Waste.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-15 Sample Fluidics - Divert valve
	Given that the Flow State is initially set to <Intial State>
	When I make another Flow State <Selection>
	Then the system performs an <Action>
		And the Flow State <Final State> is automatically selected
		Examples:
		| Initial State | Selection | Action       | Final State |
		| LC            | LC        | Nothing      | LC          |
		| LC            | Infusion  | Valve Change | Infusion    |
		| LC            | Combined  | Valve Change | Combined    |
		| LC            | Waste     | Valve Change | Waste       |
		| Infusion      | LC        | Valve Change | LC          |
		| Infusion      | Infusion  | Nothing      | Infusion    |
		| Infusion      | Combined  | Valve Change | Combined    |
		| Infusion      | Waste     | Valve Change | Waste       |
		| Combined      | LC        | Valve Change | LC          |
		| Combined      | Infusion  | Valve Change | Infusion    |
		| Combined      | Combined  | Nothing      | Combined    |
		| Combined      | Waste     | Valve Change | Waste       |
		| Waste         | LC        | Valve Change | LC          |
		| Waste         | Infusion  | Valve Change | Infusion    |
		| Waste         | Combined  | Valve Change | Combined    |
		| Waste         | Waste     | Nothing      | Waste       |

	
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-506) 				   # The software will allow the user to set the infusion flow rate
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-16 Sample Fluidics - Flow rates
	Given that <Source Type> is fitted
	When the sample flow rate is set
	Then the default value is <Default> with <Resolution>
		And the flow range is <Min> and <Max>
		Examples: (Priority 1)
		| Source Type    | Default | Min | Max   | Resolution |
		| ESI Lockspray  | 5       | 0.2 | 400.0 | 0.1        |
		| APCI Lockspray | 5       | 0.2 | 400.0 | 0.1        |
		| NanoLockspray  | 0.5     | 0.2 | 10.0  | 0.1        |
		| APGC           | n/a     | n/a | n/a   | n/a        |
		# NOTE: The above values are obtained from Osprey Defaults Document

		#Examples: (Priority 2)
		#| Source Type | Default | Min | Max   | Resolution |
		#| APPI        | 5       | 0.2 | 400.0 | 0.1        |
		#| NanoFlow    | 0.5     | 0.2 | 10.0  | 0.1        |
		#| IonKey      | 3       | 0.2 | 10.0  | 0.1        |
		#| Trizaic     | 0.5     | 0.2 | 10.0  | 0.1        |
		#| ASAP        | 5       | 0.2 | 400.0 | 0.1        |
		# Note: Priority 2 sources for Opsrey second release
	

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-509) 				   # The software will allow the user to view the volume remaining in the syringe.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-17 Sample Fluidics - Volume remaining
	Given the fluidics are not purging or in an error state
	When the sample fluidics are viewed
	Then the sample syringe volume remaining will be visible

Scenario: TUN-18 Sample Fluidics - Volume remaining
	Given the fluidics are not purging or in an error state
		And the fluidics are not purging or in an error state
	When the sample fluidics 'flow rate' is changed
	Then the sample syringe volume remaining will be updated


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-511) 				   # The software will allow the user to view any fluidices error messages.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-19 Sample Fluidics - Error message
	Given that the sample sysringe is in an error state
	When the sample fluidics controls are viewed
	Then an appropriate error message will be visable in the status
		

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-513) 				   # The software will allow the user to reinitialise the fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-20 Sample Fluidics - Reinitialise
	Given that the fluidics are in a <State>
	When the user attempts to perform an <Action>
	Then the action is <Available / Not Available> to perform
		Examples:
		| State  | Action | Available / Not Available |
		| Error  | Reset  | Available                 |
		| Normal | Reset  | Not Available             |

Scenario: TUN-21 Sample Fluidics - Reinitialise
	Given that the fluidics are in an error state
	When the sample fluidics reset is selected
	Then the sample fluidics will start the reinitialise process


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-560) 				   # The software will allow the user to set the sample reservoir illunination to Automatic, All or Off.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-22 Sample Fluidics - Reservoir illuminiation
	Given that the <Current Vial> is selected
	When I set the reservoir illumination <Selection>
	Then the system automatically sets the instrument <Illumination>
		Examples:
		| Current Vial | Selection | Illumination |
		| A            | Automatic | A            |
		| B            | Automatic | B            |
		| C            | Automatic | C            |
		| Wash         | Automatic | None         |
		| A            | All       | A, B & C     |
		| B            | All       | A, B & C     |
		| C            | All       | A, B & C     |
		| Wash         | All       | A, B & C     |
		| A            | Off       | None         |
		| B            | Off       | None         |
		| C            | Off       | None         |
		| Wash         | Off       | None         |


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-515) 				   # The software will allow the user to select inject, which is a pseudo loop injection.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-23 Sample Fluidics - Inject (pseudo loop injection)
	Given that the fluidics are stopped
	When the sample fluidics inject option is selected
	Then the sample pseudo loop injection process begins


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-519) 				   # The APGC source has no fluidics connections, so sample fluidics will not be available to the user when an APGC source is fitted. The lockspray fluidics will still be available.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-520) 				   # On recognition of an APGC source being fitted, sample fluidics will be set to waste and the controls grayed out.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-24 Sample Fluidics - Availability
	Given that <Source Type> is fitted
	When the sample fluidics control is viewed
	Then the sample fluidics <Status> will be observed with <Flow State>
		Examples: (Priority 1)
		| Source Type    | Status      | Flow State        |
		| ESI Lockspray  | Available   | Enabled           |
		| APCI Lockspray | Available   | Enabled           |
		| NanoLockspray  | Available   | Enabled           |
		| APGC           | Unavailable | Disabled at waste |
		
		#Examples: (Priority 2)
		#| Source Type | Status    | Flow State |
		#| APPI        | Available | Enabled    |
		#| NanoFlow    | Available | Enabled    |
		#| IonKey      | Available | Enabled    |
		#| Trizaic     | Available | Enabled    |
		#| ASAP        | Available | Enabled    |
		# Note: Priority 2 sources for Opsrey second release

# END
