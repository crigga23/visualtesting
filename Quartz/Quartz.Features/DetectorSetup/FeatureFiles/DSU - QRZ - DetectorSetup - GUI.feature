# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # DSU - DetectorSetup - GUI
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 20-Mar-14
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # GI, Revision 01: 31-May-2016
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # How to Implement Detector setup for Quartz.doc
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-296)                 # The user will be able to specify a corresponding mass to be used for positive polarity.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-297)                 # The user will be able to specify a corresponding mass to be used for negative polarity.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-294)                 # The user will be able to specify which polarities the procedure will be run in.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-295)                 # This will allow Positive, Negative or Both polarities to be selected, where at least one must be selected.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@DetectorSetup
Feature: DSU - QRZ - DetectorSetup - GUI
	In order to check 'Detector Setup' GUI elements within a Quartz Environment
	I want to check that the GUI elements are in place and respond to user input / process state changes as expected


# -----------------------------------------------------------------------------------------------------------------
Background: 
Given that the Quartz Detector Setup page is open

Scenario: DSU - 01 - DetectorSetup - GUI - Panel Availability
Then the following Panels should be available on the detector setup page
| Panels                |
| Detector Setup        |
| Positive Mass Results |
| Negative Mass Results |
| Progress Log          |

Scenario: DSU - 02 - DetectorSetup - GUI - Default Values
Then the Detector Setup fields should have the following default values
| Field                      | Value          |
| Negative Mass              | 554.2          |
| Positive Mass              | 556.2          |
| Checkbox (POS)             | True           |
| Checkbox (NEG)             | True           |
| Process Selection Dropdown | Detector Setup |
| Start Button               | Start          |
| Positive Detector Voltage  |                |
| Positive Ion Area          |                |
| Positive Status Text       |                |
| Negative Detector Voltage  |                |
| Negative Ion Area          |                |
| Negative Status Text       |                |
| Progress Log               |                |
| Follow Tail Checkox        | True           |


Scenario Outline: DSU - 03 - DetectorSetup - GUI - Mode Checkbox Dependencies
When the '<Checkbox status>' is set
Then the '<Edit box Status>' will be changed accordingly 
	And the button state will be '<Button Status>'
Examples:
| Checkbox status                         | Edit box Status                         | Button Status |
| Positive (un-ticked), Negative (ticked) | Positive (disabled), Negative (enabled) | Enabled       |
| Positive (ticked), Negative (ticked)    | Positive (enabled), Negative (enabled)  | Enabled       |
| Positive (ticked), Negative (un-ticked) | Positive (enabled), Negative (disabled) | Enabled       |


Scenario: DSU - 04 - DetectorSetup - GUI - Follow Tail
Given 'Follow Tail' is ticked
When I scroll up the log
Then 'Follow Tail' should become automatically unticked