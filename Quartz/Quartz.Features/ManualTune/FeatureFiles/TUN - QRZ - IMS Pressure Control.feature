# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - IMS Pressure Control
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # MH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 28-Apr-2015
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Quartz and Typhoon are installed.
#                          # Typhoon is running
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-579)                 # The software will provide the ability to initiate an IMS Pressure setup.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-580)                 # The software will only make the IMS Pressure setup available when the instrument is in the operate state.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-581)                 # The software will allow a user to enable IMS Pressure Lock.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-583)                 # The software will allow a user to disable IMS Pressure Lock.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-584)                 # The software will notify to the user if the IMS Pressure Lock fails.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Typhoon Documentation	   # http://typhoon-build/job/Typhoon-Release/Typhoon_Documentation - IMS Pressure Control
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@ignore
Feature: IMS Pressure Control
	In order to set and maintain the IMS Gas Pressure
	I want to have the ability to initiate an automated IMS Pressure Setup and lock the pressure at the optimum level
	And I want to be able to unlock the IMS Pressure for diagnostic purposes


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given that a Quartz Development Console is open
		And the 'Instrument' section is selected
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-01 Page Elements
	When the 'IMS Pressure Control' page is inspected
	Then these 'Elements' are available of a specific 'Type'
		| Elements      | Type        |
		| Setup Status  | Text String |
		| Lock Status   | Text String |
		| Run Setup     | Button      |
		| Pressure Lock | Button      |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-02 IMS Pressure Control - Setup Button Status
	When the instrument state is <Instrument State>
		And the IMS Pressure Control is inspected
		And the Set-up status is <Set-up Status>
		And the Lock status is <Lock Status>
	Then the setup button state <Setup Button State> is observed
		Examples: Disabled
		| Instrument State | Set-up Status     | Lock Status | Setup Button State |
		| Standby          | Needs to be run   | Unlocked    | Disabled           |
		| Source Standby   | Needs to be run   | Unlocked    | Disabled           |
		| Standby          | Passed            | Unlocked    | Disabled           |
		| Source Standby   | Passed            | Unlocked    | Disabled           |
		| Operate          | Running           | Unlocked    | Disabled           |
		| Operate          | Passed            | Locked      | Disabled           |
		| Standby          | Passed            | Locked      | Disabled           |
		| Source Standby   | Passed            | Locked      | Disabled           |
		| Source Standby   | Failed (ID Error) | Unlocked    | Disabled           |
		| Source           | Failed (ID Error) | Unlocked    | Disabled           |
		| Source Standby   | Failed (SD Error) | Unlocked    | Disabled           |
		| Source           | Failed (SD Error) | Unlocked    | Disabled           |

		Examples: Enabled
		| Instrument State | Set-up Status     | Lock Status      | Setup Button State |
		| Operate          | Needs to be run   | Unlocked         | Enabled            |
		| Operate          | Passed            | Unlocked         | Enabled            |
		| Operate          | Failed (ID Error) | Unlocked         | Enabled            |
		| Operate          | Failed (SD Error) | Unlocked         | Enabled            |
		| Operate          | Needs to be run   | Error (ID Error) | Enabled            |
		| Operate          | Needs to be run   | Error (T Error)  | Enabled            |
		# Note: The following abbreviations are used for error states;
		# Failed ID Error is Insufficient Devices error
		# Failed SD Error is a Standard Deviation error
		# ID Error is Insufficient Devices error
		# T Error is Tolerance error
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-03 IMS Pressure Control - Lock Button Status
	When the instrument state is <Instrument State>
		And the IMS Pressure Control is inspected
		And the Set-up status is <Set-up Status>
		And Lock status is <Lock Status>
	Then the lock button state <Lock Button State> is observed
		Examples: Disabled
		| Instrument State | Set-up Status     | Lock Status      | Lock Button State |
		| Standby          | Needs to be run   | Unlocked         | Disabled          |
		| Source Standby   | Needs to be run   | Unlocked         | Disabled          |
		| Standby          | Passed            | Unlocked         | Disabled          |
		| Source Standby   | Passed            | Unlocked         | Disabled          |
		| Operate          | Needs to be run   | Unlocked         | Disabled          |
		| Operate          | Running           | Unlocked         | Disabled          |
		| Operate          | Failed (ID Error) | Unlocked         | Disabled          |
		| Source Standby   | Failed (ID Error) | Unlocked         | Disabled          |
		| Standby          | Failed (ID Error) | Unlocked         | Disabled          |
		| Operate          | Failed (SD Error) | Unlocked         | Disabled          |
		| Source Standby   | Failed (SD Error) | Unlocked         | Disabled          |
		| Standby          | Failed (SD Error) | Unlocked         | Disabled          |
		| Operate          | Needs to be run   | Error (ID Error) | Disabled          |
		| Operate          | Needs to be run   | Error (T Error)  | Disabled          |
		# Note: The following abbreviations are used for error states;
		# Failed ID Error is Insufficient Devices error
		# Failed SD Error is a Standard Deviation error
		# ID Error is Insufficient Devices error
		# T Error is Tolerance error

				
		Examples: Enabled
		| Instrument State | Set-up Status | Lock Status | Lock Button State |
		| Operate          | Passed        | Unlocked    | Enabled - Lock    |
		| Operate          | Passed        | Locked      | Enabled - Unlock  |

		
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-04 IMS Pressure Setup Status, Actions, Errors and Final Setup Status
	When the IMS Pressure Control is inspected
		And the initial set-up status is <Initial Set-up Status>
		And an action <Action> is performed
		And the setup running state is <Setup Running>
		And the instrument encounters a hardware error <Hardware Error>
	Then the final set-up status <Final Set-up Status> is observed
		Examples: Needs to be run
		| Initial Set-up Status | Action    | Setup Running | Hardware Error       | Final Set-up Status |
		| Needs to be run       | Run Setup | Running       | Insufficient Devices | Failed (ID Error)   |
		| Needs to be run       | Run Setup | Running       | SD Error             | Failed (SD Error)   |
		| Needs to be run       | Run Setup | Running       | None                 | Passed              |
		
		Examples: Passed
		| Initial Set-up Status | Action    | Setup Running | Hardware Error       | Final Set-up Status |
		| Passed                | Run Setup | Running       | Insufficient Devices | Failed (ID Error)   |
		| Passed                | Run Setup | Running       | SD Error             | Failed (SD Error)   |
		| Passed                | Run Setup | Running       | None                 | Passed              |
		
		Examples: Failed (Insufficient Devices)
		| Initial Set-up Status | Action    | Setup Running | Hardware Error       | Final Set-up Status |
		| Failed (ID Error)     | Run Setup | Running       | Insufficient Devices | Failed (ID Error)   |
		| Failed (ID Error)     | Run Setup | Running       | SD Error             | Failed (SD Error)   |
		| Failed (ID Error)     | Run Setup | Running       | None                 | Passed              |
		
		Examples: Failed (SD Error)
		| Initial Set-up Status | Action    | Setup Running | Hardware Error       | Final Set-up Status |
		| Failed (SD Error)     | Run Setup | Running       | Insufficient Devices | Failed (ID Error)   |
		| Failed (SD Error)     | Run Setup | Running       | SD Error             | Failed (SD Error)   |
		| Failed (SD Error)     | Run Setup | Running       | None                 | Passed              |
		# Note: The following abbreviations are used for error states;
		# Failed ID Error is Insufficient Devices error
		# Failed SD Error is a Standard Deviation error
			

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-05 IMS Pressure Lock Status, Actions, Errors and Final Lock Status
	Given the IMS Pressure Set-up has passed
	When the IMS Pressure Control is inspected
		And the initial lock status is <Initial Lock Status>
		And an action <Action> is performed
		And a lock error <Lock Error> is encountered
	Then the final lock status <Final Lock Status> is observed
		Examples: Pressure is unlocked
		| Initial Lock Status | Action        | Lock Error           | Final Lock Status               |
		| Unlocked            | Pressure Lock | None                 | Locked                          |
		| Unlocked            | Pressure Lock | Insufficient Devices | Unlocked (Insufficient Devices) |
		| Unlocked            | Pressure Lock | Tolerance Error      | Unlocked (Tolerance Error)      |
						
		Examples: Pressure is locked
		| Initial Lock Status | Action          | Lock Error           | Final Lock Status               |
		| Locked              | Pressure Unlock | None                 | Unlocked                        |
		| Locked              | None            | Insufficient Devices | Unlocked (Insufficient Devices) |
		| Locked              | None            | Tolerance Error      | Unlocked (Tolerance Error)      |
		# Note: Lock will be forced into Unlock upon a lock error occurring 

		Examples: Pressure is locked - (Source Standby, Standby and Operate)
		| Initial Lock Status | Action          | Lock Error           | Final Lock Status               |
		| Locked              | Source Standby  | None                 | Unlocked                        |
		| Locked              | Standby         | None                 | Unlocked                        |
		| Unlocked            | Operate         | None                 | Locked                          |
		# Note: When the IMS Pressure is locked and the instrument is put into Source Standby or Standby state, the IMS pressure becomes unlocked by firmware. When the instrument is then put back into operate the firmware will re-lock the IMS Pressure.
			

# ---------------------------------------------------------------------------------------------------------------------------------------------------

#END
