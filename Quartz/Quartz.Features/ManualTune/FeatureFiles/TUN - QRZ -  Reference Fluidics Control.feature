# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Reference Fluidics Control
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 09-OCT-13
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Revised by: 	 		   # MH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date Revised:            # 12-FEB-15
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
# (SS-492)                 # The fluidics component will allow control of the instrument sample and reference fluidics system. When an instrument needs only sample fluidics control this component can be configured.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-493)                 # This software component shall provide the user with the status of the sample fluidics and the reference fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-498) 				   # This software will allow the user to start the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-499) 	               # This software will allow the user to stop the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-502) 				   # This software will allow the user to refill the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-503) 		    	   # This software will allow the user to purge the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-505) 				   # This software will allow the user to select which Reservoir to be used (A, B, C or Wash).
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-507) 				   # The software will allow the user to set the infusion flow rate
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-561) 				   # The software will allow the user to set the divert valve flow state to Infusion or Waste.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-510) 				   # The software will allow the user to view the volume remaining in the syringe.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-512) 				   # The software will allow the user to view any fluidices error messages.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-514) 				   # The software will allow the user to reinitialise the fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-516) 				   # The software will allow the user to view whether the flow sensor is present or absent.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-517) 				   # The software will allow the user to view whether the calibration on the flow sensor is present or absent.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-518) 				   # The software will allow the user to view wheather the flow sensor operation mode is closed loop or open loop.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
@manualonly
Feature: Reference Fluidics Control
   In order to control the instrument reference syringe
   I want to be able to perform functions on the reference fluidics
   And view status of the reference fluidics system


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-490)                 # The software will provide a fluidics control component, which can be used by any instrument that requires fluidics control. This fluidics control component will support the following functionality.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-493)                 # This software component shall provide the user with the status of the sample fluidics and the reference fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Background:
	Given the reference fluidics control is available
		And the source pressure test is in a 'Passed' state


Scenario: TUN 01 - Reference Fluidics - Dropdown options
When the reference fluidics control is inspected
	Then the following drop down 'Parameters' with 'Options' are available
		| Parameters      | Options   |
		| Reservoir       | A         |
		| Reservoir       | B         |
		| Reservoir       | C         |
		| Reservoir       | Wash      |
		| Flow path       | Infusion  |
		| Flow path       | Waste     |
		| Baffle position | Sample    |
		| Baffle position | Reference |


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-498) 				   # This software will allow the user to start the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-493)                 # This software component shall provide the user with the status of the sample fluidics and the reference fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-02 Reference Fluidics - Start infusion from full
	Given that the reference syringe is full
		And that the fluidics is stopped
		And the status is idle
	When the reference fluidics 'start infusion' option is selected
	Then the fluidics is started at the expected flow rate
		And the 'start infusion' option is replaced by a 'stop infusion' option
		And the reference fluidics status is updated to running
		# Note: Reference syringe will perform a pre-compression after refill and so volume will reduce

Scenario: TUN-03 Reference Fluidics - Start infusion when empty
	Given that the reference syringe is empty
		And the fluidics are stopped
		And the status is at idle
	When the reference fluidics 'start infusion' option is selected
	Then the reference fluidics remains at idle
		And the status remains at idle


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-499) 	               # This software will allow the user to stop the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-493)                 # This software component shall provide the user with the status of the sample fluidics and the reference fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-04 Reference Fluidics - Stop infusion
	Given that the reference syringe is infusing
		And the status is infusing
	When the reference fluidics 'stop infusion' option is selected
	Then the fluidics are stopped
		And the 'stop infusion' option is replaced by a 'start infusion' option
		And the status is updated to idle


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-502) 				   # This software will allow the user to refill the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-493)                 # This software component shall provide the user with the status of the sample fluidics and the reference fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-05 Reference Fluidics - Refilling from empty
	Given that the reference syringe is empty
		And the reference fluidics are stopped
		And the status is at idle
	When the reference syringe 'refill' option is selected
	Then the reference syringe starts refilling
		And the 'refill' option is replaced by a 'stop refill' option
		And the status is updated to refilling

Scenario: TUN-06 Reference Fluidics - Stopping a refill
	Given that the reference syringe is refilling
		And the status is refilling
	When the reference syringe 'stop refill' option is selected
	Then the reference syringe stops refilling
		And the 'stop refill' option is replaced by a 'refill' option
		And the status is updated to idle

Scenario Outline: TUN-07 Reference Fluidics - Pre-compression/Pre-advance after refill
	Given that the reference syringe is refilling
		And the flow sensor is <status>
	When the refill completes
	Then a '<Compression action>' is automatically performed
		And during this operation the '<Valve position>' is set
			Examples:
			| Status  | Flow rate | Compression Action | Valve position |
			| Present | 6.9       | Pre-Advanced       | Waste          |
			| Present | 7.0       | Pre-Compression    | Infusion       |
			| Present | 30.0      | Pre-Compression    | Infusion       |
			| Present | 30.1      | None               | N/A            |
			| Absent  | 6.9       | Pre-Advanced       | Infusion       |
			| Absent  | 7.0       | Pre-Compression    | Infusion       |
			| Absent  | 30.0      | Pre-Compression    | Infusion       |
			| Absent  | 30.1      | None               | N/A            |


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-503) 		    	   # This software will allow the user to purge the syringe pump.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-493)                 # This software component shall provide the user with the status of the sample fluidics and the reference fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-08 Reference Fluidics - Purge from stopped
	Given that the reference syringe is stopped
		And the status is idle
	When the reference fluidics 'purge' option is selected
	Then the reference purging process begins
		And the 'purge' option is replaced by a 'stop purge' option
		And the status is updated to purging
	
Scenario: TUN-09 Reference Fluidics - Stopping a purge
	Given that the reference syringe is purging
		And the status is purging
	When the reference fluidics 'stop purge' is selected
	Then the reference purging process stops
		And the status is updated to idle


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-505) 				   # This software will allow the user to select which Reservoir to be used (A, B, C or Wash).
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-10 Reference Fluidics - Selecting reservoir
	Given that the Reference fluidics vial is initially set to <Intial Vial>
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
# (SS-561) 				   # The software will allow the user to set the divert valve flow state Infusion or Waste.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-11 Reference Fluidics - Divert valve
	Given that the flow state is initially set to <Intial State>
	When I make another flow state <Selection>
	Then the system performs an <Action>
		And the flow state <Final State> is automatically selected
		Examples:
		| Initial State | Selection | Action       | Final State |
		| Infusion      | Infusion  | Nothing      | Infusion    |
		| Infusion      | Waste     | Valve Change | Waste       |
		| Waste         | Infusion  | Valve Change | Infusion    |
		| Waste         | Waste     | Nothing      | Waste       |

	
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-507) 				   # The software will allow the user to set the infusion flow rate
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-12 Reference Fluidics - Flow rate
	Given that <Source Type> is fitted
	When the reference flow rate is set
	Then the default value is <Default> with <Resolution>
		And the flow range is <Min> and <Max>
		Examples: (Priority 1)
		| Source Type    | Default | Min  | Max   | Resolution |
		| ESI Lockspray  | 10.00   | 0.10 | 60.00 | 0.01       |
		| APCI Lockspray | 10.00   | 0.10 | 60.00 | 0.01       |
		| NanoLockspray  | 0.50    | 0.10 | 10.00 | 0.01       |
		| APGC           | n/a     | n/a  | n/a   | n/a        |
		# NOTE: The above values are obtained from Osprey Defaults Document

		#Examples: (Priority 2)
		#| Source Type | Default | Min  | Max   | Resolution |
		#| APPI        | 10.00   | 0.10 | 60.00 | 0.01       |
		#| NanoFlow    | 0.50    | 0.10 | 10.00 | 0.01       |
		#| IonKey      | 1.00    | 0.10 | 10.00 | 0.01       |
		#| Trizaic     | 1.00    | 0.10 | 10.00 | 0.01       |
		#| ASAP        | 10.00   | 0.10 | 60.00 | 0.01       |
		# Note: Priority 2 sources for Opsrey second release
	

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-510) 				   # The software will allow the user to view the volume remaining in the syringe.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-13 Reference Fluidics - Volume remaining
	Given that the reference fluidics are accessible
		And the fluidics are not purging or in an error state
	When the reference fluidics are viewed
	Then the reference syringe volume remaining will be visible

Scenario: TUN-14 Reference Fluidics - Volume remaining
	Given the fluidics are not purging or in an error state
		And the fluidics are not purging or in an error state
	When the sample fluidics 'flow rate' is changed
	Then the sample syringe volume remaining will be updated


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-512) 				   # The software will allow the user to view any fluidices error messages.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-15 Reference Fluidics - Error message
	Given that the reference fluidics are in an error state
	When the reference fluidics are viewed
	Then an appropriate Reference error message will be visable


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-514) 				   # The software will allow the user to reinitialise the fluidics.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-16 Reference Fluidics - Reinitialise
	Given that the reference fluidics are in a <State>
	When the user attempts to perform an <Action>
	Then the action is <Available / Not Available> to perform
		Examples:
		| State  | Action | Available / Not Available |
		| Error  | Reset  | Available                 |
		| Normal | Reset  | Not Available             |

Scenario: TUN-17 Reference Fluidics - Reinitialise
	Given that the reference fluidics are in an error state
	When the reference fluidics reset option is selected
	Then the reference fluidics will start the reinitialise process


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-516) 				   # The software will allow the user to view whether the flow sensor is present or absent.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-18 Reference Fluidics - Flow sensor status
	Given that the reference fluidics flow sensor hardware is <State>
	When the reference fluidics FSC option is selected
	Then the <Flow Sensor Status> will be displayed
		Examples:
		| State        | Flow Sensor Status |
		| Connected    | Present            |
		| Disconnected | Absent             |
		# FSC is an abreviation of 'Flow Sensor Calibration'


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-517) 				   # The software will allow the user to view whether the calibration on the flow sensor is present or absent.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-19 Reference Fluidics - Flow sensor calibration
	Given that the reference flow sensor is present
	When the reference fluidics FSC option is selected
		And the flow sensor calibration is <Status>
	Then the flow sensor calibration will be <Displayed>
		Examples:
		| Status  | Displayed |
		| Present | Numbers   |
		| Absent  | Empty     |
		# FSC is an abreviation of 'Flow Sensor Calibration'


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-518) 				   # The software will allow the user to view wheather the flow sensor operation mode is closed loop or open loop.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-20 Reference Fluidics - Flow sensor operation mode
	Given that the reference flow sensor is present
	When the reference fluidics FSC option is selected
	Then the reference fluidics flow sensor operation mode will be displayed


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-21 - Lockspray position
	Given the <Initial Baffle Position> is set
	When the gui position is set to <Baffle Position>
	Then the physical baffle will change to <Physical Position>
		Examples:
		| Initial Baffle Position | Baffle Position | Physical Position |
		| Sample                  | Reference       | Reference         |
		| Reference               | Sample          | Sample            |
		| Sample                  | Sample          | Sample            |
		| Reference               | Reference       | Reference         |


# END
