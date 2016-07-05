# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # VAC - QRZ - Vacuum 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------	
# Date:                    # 18-AUG-14  (Updated 12-MAY-15, Christopher D Hughes)    
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # On an instrument turning Pump Override on and off is via a physical switch.
#						   # Venting an instrument could result in it taking a long time to recover afterwards, therefore scenarios venting it need to be run in isolation
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------	
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # 12-MAY-15 (Several scenarios updated to include 'Trap' gauge)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification (4.2.11)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-276)                 # The user will access the Vacuum page from the Instrument tab in the Dev Console.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-278)                 # The software will show the current valid vacuum state as a simple text message.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-279)                 # The software will show a warning message indicating the pump override switch is active.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-280)                 # The software will alolow the user to pump the instrument.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-281)                 # The software will allow rthe user to to vent the instrument.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-282)                 # The software will display instrument pressure regions of the instrument.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-283)                 # The software will display instrument turbo speeds of the instrument.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-284)                 # The software will display instrument turbo operation times of the instrument.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-285)                 # The software will configure the pressures panel for the given instrument type.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-286)                 # The software will configure the turbo speeds panel for the given instrument type.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-287)                 # The software will configure the turbo operation time panel for the given instrument type.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-521)				   # The software will provide a framework and a set of components to allow the user access to vacuum control and monitoring.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# NOTE: The following SS is not covered in this feature file - it will be covered in a seperate feature related to Quartz user access
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-277)                 # The Vacuum page will be present for all users
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@Vacuum
Feature: VAC - QRZ - Vacuum
	In order to check / change the 'Vacuum' status
	I want to be able to access information related to 'Vacuum Status', 'Vacuum pressures', 'Turbo Speeds' and 'Turbo Operation Times'
	And I want to be able to 'Vent' / 'Pump down' the instrument as required
# ---------------------------------------------------------------------------------------------------------------------------------------------------


#Background:

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-276)                 # The user will access the Vacuum page from the Instrument tab in the Dev Console.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

Scenario: VAC-01 - Vacuum Availability
	When the Vacuum page is accessed	
	Then the following vacuum page sections will be available
			| Sections						|
			| Status						|
			| Pressures (mBar)				|
			| Turbo Speeds (%)				|
			| Turbo Operation Times (hours) |
		

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-279)                 # The software will show a warning message indicating the pump override switch is active.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
@SimulatorOnly
@SmokeTest
Scenario Outline: VAC-02 - Pump Override Warning Status
	Given the Vacuum page is accessed
		And the Pump Override status is '<Pump Override>'
	When the Vacuum page is accessed
	Then '<Warning>' will be displayed related to the pump override
		Examples:
		| Pump Override | Warning              |
		| Active        | Pump override active |
		| Not Active    | N/A (No Warning)     |


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-284)                 # The software will display instrument turbo operation times of the instrument.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: VAC-03 - Turbo Operation Times
	When the Vacuum page is accessed
	Then Turbo Operation Time controls are available 
		And the Turbo Operation Times display the correct units of measure		


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-278)                 # The software will show the current valid vacuum state as a simple text message.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-280)                 # The software will alolow the user to pump the instrument.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-281)                 # The software will allow rthe user to to vent the instrument.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
@SimulatorOnly
Scenario Outline: VAC-04 - Pumping / Venting
	When the Vacuum page is accessed
		And the vacuum status is '<Initial State>'
		And the option to '<Toggle Instrument Vacuum Status>' is selected
	Then the vacuum instrument button caption will be '<New Option>'
		Examples:
		| Initial State            | Toggle Instrument Vacuum Status | New Option      |
		| Venting: Vent Valve Open | Pump Instrument                 | Vent Instrument |
		| Instrument Pumped        | Vent Instrument                 | Pump Instrument |

@SimulatorOnly
Scenario Outline: VAC-05 - Action Changing Instrument Vacuum Status - Pump Override OFF
	Given the Vacuum page is accessed
		And the Pump Override status is '<Pump Override>'
		And the vacuum is not venting or pumping 	
		And the vacuum status is '<Initial State>'		
	When a vacuum '<Action>' action is attempted
	Then there will be an '<Intermediate 1>' followed by an '<Intermediate 2>' and finally '<Final>' instrument vacuum status

			Examples: Vent Instrument
			| Pump Override | Initial State     | Action          | Intermediate 1          | Intermediate 2 | Final                    |
			| Not Active    | Instrument Pumped | Vent Instrument | Venting: Pump slow down | Venting delay  | Venting: Vent valve open |

			Examples: Pump Instrument
			| Pump Override | Initial State            | Action          | Intermediate 1                  | Intermediate 2                  | Final             |
			| Not Active    | Venting: Vent Valve Open | Pump Instrument | Rough Pumping - Turbo Pumps Off | Pumping: Waiting for Pump Speed | Instrument Pumped |  
			# 'Instrument Pumped' is equivalent to 'Vacuum OK'
			#  Venting process may take several minutes
			#  Pumping process may take several hours

@SimulatorOnly
Scenario Outline: VAC-06 - Action Changing Instrument Vacuum Status - Pump Override ON
	Given the Vacuum page is accessed
		And the vacuum status is '<Initial State>'
		And the Pump Override status is '<Pump Override>'			
	When a vacuum '<Action>' action is attempted
	Then there will be an '<Intermediate 1>' followed by an '<Intermediate 2>' and finally '<Final>' instrument vacuum status

			Examples: Pump Override ON-Pump
			| Pump Override | Initial State            | Action | Intermediate 1                  | Intermediate 2                  | Final             |
			| Active        | Venting: Vent Valve Open | N/A    | Rough Pumping - Turbo Pumps Off | Pumping: Waiting for Pump Speed | Instrument Pumped |  

@SimulatorOnly
Scenario: VAC-07 - Instrument Vacuum Status - Fully Pumped and Pump Override ON
	Given the Vacuum page is accessed
		And the vacuum status is 'Instrument Pumped'
		And the Pump Override status is 'Active'			
	Then the vacuum status will remain at 'Instrument Pumped'


@ignore
@ManualOnly
Scenario: VAC-08 - Instrument Crash Vent (part 1)
	Given the Vacuum Status is 'Instrument Pumped'
	When the instrument source cone is removed
		And the instrument source cone valve is opened fully
	Then the instrument will start crash venting
		And after some time the Vacuum Status will read "PUMP FAIL: Set Vent to recover"
		And the option to "Vent Instrument" is available

@ignore
@ManualOnly			
Scenario: VAC-09 - Instrument Crash Vent (part 2)
	Given the instrument has been crash vented
		And the Vacuum Status reads "PUMP FAIL: Set Vent to recover"
		And the option to 'Vent Instrument' is available
	When 'Vent Instrument' is selected
	Then the Vacuum Status will read "Venting: Vent Valve Open"
		And the button text will read "Pump Instrument"


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-282)                 # The software will display instrument pressure regions of the instrument.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: VAC-10 - Vacuum Pressure Gauges
	When the Vacuum page is accessed
	Then the vacuum pressure gauges are available
		And the pressures will be measured in 'mBar'
			
@SimulatorOnly
Scenario: VAC-11 - Monitoring Vacuum Pressure Gauges (Pumping Down) - Backing / Collision
	Given the Vacuum page is accessed
		And the vacuum status is 'Venting: Vent Valve Open'
	When the option to 'Pump Instrument' is selected
	Then the Vacuum Pressure Gauges will move from the 'Red' region into the 'Green' region over the period of the 'pumping down' process


@SimulatorOnly
Scenario: VAC-12 - Monitoring Vacuum Pressure Gauges (Venting) - Backing / Collision
	Given the Vacuum page is accessed
		And the vacuum status is 'Instrument Pumped'
		And the Pump Override status is 'Not Active'
	When the option to 'Vent Instrument' is selected
	Then the Vacuum Pressure Gauges will move from the 'Green' region into the 'Red' region over the period of the 'venting' process

@SimulatorOnly
@SmokeTest
Scenario: VAC-13 - Monitoring Vacuum Pressure Gauges (Pumping Down) - TOF
	Given the Vacuum page is accessed
		And the vacuum status is 'Venting: Vent Valve Open'
	When the option to 'Pump Instrument' is selected		
	Then the 'TOF' Pressure Gauge is in the 'Red' region
		And after some time the 'TOF' Turbo Speed Gauge will move into the 'Green' region
		And the 'TOF' Pressure Gauge will move from the 'Orange' region to 'Yellow' and then to 'Green'

@SimulatorOnly
Scenario: VAC-14 - Monitoring Vacuum Pressure Gauges (Venting) - TOF
	Given the Vacuum page is accessed
		And the vacuum status is 'Instrument Pumped'
		And the Pump Override status is 'Not Active'
	When the Vacuum page is accessed
		And the option to 'Vent Instrument' is selected
	Then the 'TOF' Pressure Gauge will move from the 'Green' region to 'Yellow' and then to 'Orange'
		And after some time the 'TOF' Turbo Speed Gauge will move into the 'Red' region
		And the 'TOF' Pressure Gauge will finally move into the 'Red' region


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-283)                 # The software will display instrument turbo speeds of the instrument.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: VAC-15 - Turbo Speed Gauges
	When the Vacuum page is accessed
	Then the Turbo Speed Gauges are available
		And the speeds will be measured in '%'

@SimulatorOnly
Scenario: VAC-16 - Monitoring Turbo Speed Gauges (Pumping Down)
	Given the Vacuum page is accessed
		And the vacuum status is 'Venting: Vent Valve Open'
		And all Turbo Speed Gauges are in the 'Red' region
		And all Turbo Speed Gauges are at 0%
	When the option to 'Pump Instrument' is selected
	Then all Turbo Speed Gauges will progressively increase to 100%
		And all Turbo Speed Gauges will be in the 'Green' region

@SimulatorOnly
@SmokeTest		
Scenario: VAC-17 - Monitoring Turbo Speed Gauges (Venting)
	Given the Vacuum page is accessed
		And the vacuum status is 'Instrument Pumped'
		And the Pump Override status is 'Not Active'
		And all Turbo Speed Gauges are in the 'Green' region
		And all Turbo Speed Gauges are at 100%
	When the option to 'Vent Instrument' is selected
	Then all Turbo Speed Gauges will progressively decrease to 0%
		And all Turbo Speed Gauges will be in the 'Red' region



# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-285)                 # The software will configure the pressures panel for the given instrument type.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-286)                 # The software will configure the turbo speeds panel for the given instrument type.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-287)                 # The software will configure the turbo operation time panel for the given instrument type.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario: VAC-18 - Capabilities - Vacuum Gauges
	When the Vacuum page is accessed
	Then the correct number of Pressure Gauges are displayed
		And the Pressure Gauges are of the correct type

Scenario: VAC-19 - Capabilities - Turbo Speed Gauges
	When the Vacuum page is accessed
	Then the correct number of Turbo Speed gauges are displayed
		And each Turbo Speed gauge has the correct red and green zones

Scenario: VAC-20 - Capabilities - Turbo Operation Times
	When the Vacuum page is accessed
	Then each Turbo Operation Time is to the correct precision


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
