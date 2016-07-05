# ----------------------
# Author: 	CDH
# Date:   	25-JUL-14
# Reviewer: MH
# Rev.Date: 28-JUL-14
# ----------------------

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# Basis:   	Osprey UNIFI ICS Software Specification
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# Coverage:	See Below...
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#           • The user will access the Vacuum page from the Instrument tab in the Dev Console.
#           • The page will only be accessible from the Dev Console.
#           • The software will show the current vacuum status
#           • The software will show a warning message indicating the pump override switch is active.
#           • The software will have the ability to pump the instrument.
#           • The software will have the ability to vent the instrument.
#           • The software will have the ability to display the instruments pressures regions.
#           • The software will have the ability to display the instruments turbo speeds.
#           • The software will have the ability to display the instruments turbo operation times.
#           • The software will have the ability to configure the pressures panel from capabilities.
#           • The software will have the ability to configure the turbo speeds panel from capabilities.
#           • The software will have the ability to configure the turbo operation time panel from capabilities.
# ---------------------------------------------------------------------------------------------------------------------------------------------------

@ignore
Feature: Vacuum
	In order to check / change the 'Vacuum' status
	I want to be able to access information related to 'Vacuum Status', 'Vacuum pressures', 'Turbo Speeds' and 'Turbo Operation Times'
	And I want to be able to 'Vent' / 'Pump down' the instrument as required


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# • The user will access the Vacuum page from the Instrument tab in the Dev Console.
Scenario: QRZ-01 - Vacuum Availability
	Given that a Quartz Development Console environment is available
	And Vacuum page is open
	#Then there will be Vacuum status page available


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# General Test
Scenario Outline: QRZ-02 - Pumping / Venting
	Given that a Quartz Development Console environment is available
	And Vacuum page is open
	When the option to '<Toggle Instrument Vacuum Status>' is selected
	Then a '<New Option>' will be shown
		Examples:
		| Toggle Instrument Vacuum Status | New Option      |
		| Pump Instrument                 | Vent Instrument |
		| Vent Instrument                 | Pump Instrument |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# •	The software will show a warning message indicating the pump override switch is active.
Scenario: QRZ-03 - Pump Override active Warning Status
	Given that a Quartz Development Console environment is available
	And Pump Override Switch is Active
	And Vacuum page is open
	Then warning panel is available 
	And warning 'Pump override active' will be displayed

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario: QRZ-04 - Pump Override not active Warning Status
	Given that a Quartz Development Console environment is available
	And Pump Override Switch is not active
	And Vacuum page is open
	Then there will not be a warning related to the pump override switch being active

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# •	The software will have the ability to display the instruments pressures regions.
Scenario Outline: QRZ-05 - Vacuum Pressure Gauges
	Given that a Quartz Development Console environment is available
	And Vacuum page is open
	Then 'Pressures' widget is available
	And there will be a series of '<Gauges>' gauges available
	And the pressures will be measured in 'mbar'
		Examples:
		| Gauges                 |
		| Backing                |
		| Collision Cell         |
		| TOF                    |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# •	The software will have the ability to display the instruments turbo speeds.
Scenario Outline: QRZ-06 - Turbo Speed Gauges
	Given that a Quartz Development Console environment is available
	And Vacuum page is open
	Then 'Turbo Speed' widget is available
	And there will be a series of '<Gauges>' gauges available
	And the speeds will be measured in '%'
		Examples:
		| Gauges             |
		| Source             |
		| Quadrupole         |
		| TOF                |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# •	The software will have the ability to display the instruments turbo operation times.
Scenario Outline: QRZ-07 - Turbo Operation Times
	Given that a Quartz Development Console environment is available
	And Vacuum page is open
	Then 'Turbo Operation Time' widget is available
	And there will be a series of '<Turbo Operation Times>' available
	And the times will be measured in 'Hours'
	And the time will increase in single units as the number of hours of operation increases
		Examples:
		| Turbo Operation Times |
		| Source                |
		| Quadrupole            |
		| TOF                   |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# •	The software will have the ability to pump the instrument.
# •	The software will have the ability to vent the instrument.
# •	The software will show the current vacuum status
Scenario Outline: QRZ-08 - Action Changing Instrument Vacuum Status
	Given that a Quartz Development Console environment is available
	And the instrument 'Pump Override Switch' is 'Off'
		And there is an '<Initial>' instrument vacuum state
	When the Vacuum page is accessed
		And an '<Action>' is attempted
	Then there will be an '<Intermediate>' instrument vacuum status
		And after some time there will be a '<Final>' instrument vacuum status
		Examples: Pump
			| Initial | Action          | Intermediate | Final  |
			| Vented  | Pump Instrument | Pumping      | Pumped |
			| Venting | Pump Instrument | Pumping      | Pumped |
			
			Examples: Vent
			| Initial | Action          | Intermediate | Final  |
			| Pumped  | Vent Instrument | Venting      | Vented |
			| Pumping | Vent Instrument | Venting      | Vented |
			# 'Pumped' is equivalent to 'Vacuum OK'
			# 'Venting' to 'Vented' process may take several minutes
			# 'Pumping' to 'Pumped' process may take several hours


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# General Tests
Scenario: QRZ-09 - General - Monitoring Turbo Speed Gauges (Pumping Down)
	Given that a Quartz Development Console environment is available
		And the instrument is 'Vented'
	When the Vacuum page is accessed
		And the instrument is 'Pumped Down'
		And the 'Turbo Speed Gauges' are monitored over the period of the pumping down process
	Then all the 'Turbo Speed Gauges' will progressively increase, from less than 2% to 100% (+/- 2%)
		And all the 'Turbo Speed Gauges' gauges will move from the 'Red' region into the 'Green' region
		
Scenario: QRZ-10 - General - Monitoring Turbo Speed Gauges (Venting)
	Given that a Quartz Development Console environment is available
		And the instrument is 'Pumped' (Vacuum OK)
	And the instrument 'Pump Override Switch' is 'Off'
	When the Vacuum page is accessed
		And the instrument is 'Vented'
		And the 'Turbo Speed Gauges' are monitored over the period of the venting process
	Then all the 'Turbo Speed Gauges' will progressively drop, from 100% (+/- 2%) to less than 2%
		And all the 'Turbo Speed Gauges' gauges will move from the 'Green' region into the 'Red' region

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# General Tests
Scenario Outline: QRZ-11 - General - Monitoring Vacuum Pressure Gauges (Pumping Down) - Backing / Collision
	Given that a Quartz Development Console environment is available
		And the instrument is 'Vented'
	When the Vacuum page is accessed
		And the instrument is 'Pumped Down'
		And the '<Vacuum Pressure Gauges>' are monitored over the period of the pumping down process
	Then '<Vacuum Pressure Gauges>' will move from the 'Red' region into the 'Green' region
		Examples:
		| Vacuum Pressure Gauges |
		| Backing                |
		| Collision Cell         |

Scenario: QRZ-12 - General - Monitoring Vacuum Pressure Gauges (Pumping Down) - TOF
	Given that a Quartz Development Console environment is available
		And the instrument is 'Vented'
	When the Vacuum page is accessed
		And the instrument is 'Pumped Down'
		And after some time the 'TOF Turbo Speed Gauge' has moved into the 'Green' region
	Then the 'TOF Pressure Gauge' will move from the 'Red' region into the 'Amber' region
		And will continue through the 'Yellow' region
		And will finally settle into the 'Green' region

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# General Tests
Scenario Outline: QRZ-13 - General - Monitoring Vacuum Pressure Gauges (Venting) - Backing / Collision
	Given that a Quartz Development Console environment is available
		And the instrument is 'Pumped' (Vacuum OK)
		And the instrument 'Pump Override Switch' is 'Off'
	When the Vacuum page is accessed
		And the instrument is 'Vented'
		And the '<Vacuum Pressure Gauges>' are monitored over the period of the pumping down process
	Then '<Vacuum Pressure Gauges>' will move from the 'Green' region into the 'Red' region
		Examples:
		| Vacuum Pressure Gauges |
		| Backing                |
		| Collision Cell         |

Scenario: QRZ-14 - General - Monitoring Vacuum Pressure Gauges (Venting) - TOF
	Given that a Quartz Development Console environment is available
		And the instrument is 'Pumped' (Vacuum OK)
		And the instrument 'Pump Override Switch' is 'Off'
	When the Vacuum page is accessed
		And the instrument is 'Vented'
	Then the 'TOF Pressure Gauge' will move from the 'Green' region, through the 'Yellow' region, into the 'Amber' region
		And the 'TOF Pressure Gauge' will finally move into the 'Red' region when the 'TOF Turbo Speed Gauge' has moved into its 'Red' region


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# •	The software will have the ability to configure the pressures panel from capabilities.
# •	The software will have the ability to configure the turbo speeds panel from capabilities.
# •	The software will have the ability to configure the turbo operation time panel from capabilities.
Scenario Outline: QRZ-15 - Configuring Panel Elements
	Given that a Quartz Development Console environment is available
	When the Vacuum page is accessed
		And a specific '<Page Element>' is inspected
	Then relevant 'details' will become available for the selected page element
		And the 'details' can be configured
			Examples: Vacuum pressures panel
			| Page Element             |
			| Backing pressure gauge   |
			| Collision pressure gauge |
			| TOF pressure gauge       |

			Examples: Turbo speeds panel
			| Page Element                 |
			| Source turbo speed gauge     |
			| Quadrupole turbo speed gauge |
			| TOF turbo speed gauge        |
			| Source operation time        |

			Examples: Turbo operation time panel
			| Page Element                    |
			| Source turbo operation time     |
			| Quadrupole turbo operation time |
			| TOF turbo operation time        |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
