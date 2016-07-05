# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - GUI 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------	
# Date:                    # 19-MAY-14 (updated: 04-SEP-15)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------	
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (04-SEP-15) Updates to reflect GUI changes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification (4.2.11)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-197)                 # The software will provide a control content section withing the Manual Tuning screen
# (SS-163)				   # The Manual Tuning screen will enable the user to manually tune the instrument while performing tuning acquisitions and monitoring a real time display of the acquired data
# (SS-181)				   # The software will provide a real time displayt section within the Manual Tuning screen
# (SS-185)				   # The user shall be able to switch the instrument into positive polarity
# (SS-182)				   # The user shall be able to switch the instrument into negative polarity
# (SS-186)				   # The user shall be able to switch the instrument into Resoution mode
# (SS-188)				   # The user shall be able to switch the instrument into Sensitivity mode
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@ManualTune
Feature: TUN - QRZ - GUI
	In order to check 'TUNE PAGE' GUI elements within a Quartz Environment
	I want to check that the GUI elements are in place and respond to user input / process state changes as expected

Background: 
	Given that the Quartz Tune page is open
  
# -----------------------------------------------------------------------------------------------------------------------------------------
@SmokeTest
Scenario: TUN - 01 - GUI - Main Panels  
	Then the correct panels are available

@SmokeTest
Scenario: TUN - 02 - GUI - Plot Header Controls
	Then the correct plot header controls are enabled and preselected

@SmokeTest
Scenario: TUN - 03 - GUI - Plot Controls
	Then the correct plot controls are enabled and preselected

@SmokeTest
@cleanup_TUN_04
Scenario: TUN - 04 - GUI - Instrument Controls
	Given the instrument is in Standby
	Then the correct instrument controls are enabled and preselected

@SmokeTest
Scenario: TUN - 05 - GUI - Tab Controls
	Then the correct tab controls are enabled and preselected

@SmokeTest
Scenario: TUN - 06 - GUI - Tabs
	Then the Controls panel will display the correct tabs


Scenario: TUN-07 - Dropdown Options
	Then the following 'Controls' are available with the 'Selections'
		| Controls                  | Selections                            |
		| Factory Parameters         | Reset to Default, Reset to Factory, Load, Save |
		| Acquisition               | Custom Tune                           |
		| User defined tab controls | Delete set, Save set, Load set, Clear |


Scenario: TUN-08 - Customized Tab View Options
	Then the customized tab view displays the correct available tabs


Scenario: TUN-09 - Tab Element Defaults
	And factory defaults have been reset
    Then the Control Parameter defaults match the instrument specification for each polarity mode combination
		# Source tab details will be tested as a seperate test case
		# Fluidics tab details will be tested as a seperate test case
		# Dwell Time and Ramp Time are tested in a seperate scenario


@cleanup_ParameterValues
Scenario: TUN-10 - Tab Element Min / Max / Resolution - Positive
    Then the Control Parameters min, max and resolution match the instrument specification for each 'Positive' mode combination
		# Source tab details will be tested as a seperate test case
		# Fluidics tab details will be tested as a seperate test case
		# Dwell Time and Ramp Time are tested in a seperate scenario


@cleanup_ParameterValues
Scenario: TUN-11 - Tab Element Min / Max / Resolution - Negative
    Then the Control Parameters min, max and resolution match the instrument specification for each 'Negative' mode combination
		# Source tab details will be tested as a seperate test case
		# Fluidics tab details will be tested as a seperate test case
		# Dwell Time and Ramp Time are tested in a seperate scenario


Scenario: TUN-12 - Tab Element Readbacks
	Then the correct readbacks are displayed for each polarity mode combination

@Osprey
@Defect
@CR_FW8512
@cleanup_ParameterValues
Scenario: TUN-13 - Dwell Time and Ramp Time Min / Max / Resolution
	And factory defaults have been reset
	Then the Dwell Time and Ramp Time parameter min, max and resolution match the instrument specification for each polarity mode combination

@Osprey
Scenario: TUN-14 - Dwell Time and Ramp Time Defaults
	And factory defaults have been reset
	Then the Dwell Time and Ramp Time parameter defaults match the instrument specification for each polarity mode combination

# -----------------------------------------------------------------------------------------------------------------------------------------
# END
