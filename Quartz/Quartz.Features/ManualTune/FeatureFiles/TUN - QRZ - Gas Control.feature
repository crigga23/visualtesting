
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Gas Control
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 30-JUN-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # NOTE: Trap gas status can be determined from the Engineering Dashboard symbol 'TRAP_FLOWRATE_RB'.
#                          # NOTE: IMS gas status can be determined from the Engineering Dashboard symbol 'IMS_FLOWRATE_RB'
#                          # NOTE: API gas status can be determined from the Engineering Dashboard symbol 'APCI_GAS_STATUS'
#                          # NOTE: CC1 gas status can be determined from the Engineering Dashboard symbol 'CC1_GAS_STATUS'
#                          # NOTE: CC2 gas status can be determined from the Engineering Dashboard symbol 'CC2_GAS_STATUS'
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #  As above for 'Automation Test Notes'
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # - Quartz Beta msi is installed
#                          # - Typhoon is running on a real instrument
#                          # - Quartz EAP is running within a Chrome browser
#                          # - The Quartz Tune page is available
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-408)                 # Control of gases shall be fully automated. It shall be possible to set the following states for each of the gases. 
#                          # (See Typhoon EAP Software Specification for further details)
#                          # Partial coverage - 'Make-up Gas' and 'Helium on' is not tested in this feature as they are not applicable to this release
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-187)                 # The user will be able to switch instrument gasses on or off.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-587)                 # The software will provide a control mechanism within the Tuning application to switch an instruments gasses on and off
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-588)                 # The software will provide the user with a visual indication when the instruments gasses are on or off.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@Ignore
Feature: Gas Control
	 In order to check that automatic and manual gas control is working as expected
	 I want to be able to change the instrument operate state and also manually override gas settings
	 So that a corresponding change is seen in the gas control GUI and in the associated RIO readbacks.
	 
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline TUN-01 - Manual Gas Control (GUI and RIO) - IMS, CC1 and CC2
	Given that the instrument is in an 'Operate' State 
	When the <Gas> control is changed from <Original State> to <New State>
		And the <Gas> control is reselected after a few seconds
	Then the <Gas> control will have changed to <New State>
		And the associated RIO readback for the <Gas> <New State> will be set as expected 	
			Examples:
			| Gas              | Original State | New State |
			| Trap             | Off            | On        |
			| Trap             | On             | Off       |
			| IMS              | Off            | On        |
			| IMS              | On             | Off       |
			| Collision Cell 1 | Off            | On        |
			| Collision Cell 1 | On             | Off       |
			| Collision Cell 2 | Off            | On        |
			| Collision Cell 2 | On             | Off       |
			# The status should be initially checked using the Gas Control dropdown GUI.
			# Whilst the gas control is on the process of changing from one state to another a spinner may be present for a few seconds.
			# Selection will be identified by a tick against the relevant gas state within the control drop-down.
			# Expected RIO readback details for each gas state can be obtained from the Instrument Control development team.
			# As extra confirmation that states are changing, there should be a corresponding change in vacuum pressure for each gas (visible on the respective gauges in the Vacuum page). 
		
Scenario Outline TUN-02 - Manual Gas Control (RIO) - API
	Given that the instrument is in an 'Operate' State 
	When the API control is changed from <Original State> to <New State>
	Then the API control will stay in the <New State>
		And the associated RIO readback for the API gas <New State> will be set as expected
		Examples:
		| Original State | New State |
		| Off            | On        |
		| On             | Off       |

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------							
Scenario Outline TUN-03 - Automatic Gas Control (Instrument State Dependant)
	Given an instrument <Initial Operate State>
	When the instrument is switched to a <New Operate State> 
	Then the status will be set for <API Gas> 
		And the status will be set for <Trap Gas>
		And the status will be set for <IMS Gas>
		And the status will be set for <Collision Cell 1>
		And the status will be set for <Collision Cell 2> 
		And the associated RIO readback for all gases will be set as expected 	
			Examples:
			| Initial Operate State | New Operate State | API Gas | Trap Gas | IMS Gas | Collision Cell 1 | Collision Cell 2 |
			| Standby               | Source Standby    | Off     | Off      | Off     | Argon On         | Argon On         |
			| Source Standby        | Operate           | On      | On       | On      | Argon On         | Argon On         |
			| Operate               | Standby           | Off     | Off      | Off     | Off              | Off              |
			| Standby               | Operate           | On      | On       | On      | Argon On         | Argon On         |
			| Operate               | Source Standby    | Off     | Off      | Off     | Argon On         | Argon On         |
			| Source Standby        | Standby           | Off     | Off      | Off     | Off              | Off              | 
			# The status should be initially checked using the Gas Control dropdown GUI.
			# As extra confirmation that states are changing, there should be a corresponding change in vacuum pressure for each gas (visible on the respective gauges in the Vacuum page). 

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END
