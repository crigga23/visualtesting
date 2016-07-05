
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # ABC - XYZ - Short Desription  {e.g. ACQ - QRZ - ESI parameters}
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Name {e.g. Fred Bloggs}
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # nn-MONTH-nn {e.g. 01-JAN-15}
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
# Basis:                   # Path and Document Name {e.g. /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification}
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-nnn1)                # Description from Software Specification line (nnn1)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-nnn2)                # Description from Software Specification line (nnn2)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
Feature: Interaction with widgets
	In order to interact with a widget
	As a user of widgets
	I want to be able to perform certain actions on a widget and for it to respond appropriately

# Prerequisites:
# Given I have a box of widgets
# And the box is open
# And the box is not empty


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-nnn1) Description from Software Specification line (nnn1)
Scenario Outline: Description 1 (e.g. 'MET-01 Creating a New Method') 
                                (e.g. 'DSU-01 Running Detector Setup - Pos Only') 
                                (e.g. 'TUN-01 System 1 Settings')
                                (e.g. 'CAL-01 Running Calibration - Default Settings')
	Given this widget is available within the box
		And and this other thing is set up
	When this <Action> is performed
	Then I get this <Result>
		Examples: Basic Actions
		    | Action                     | Result                           |
			| Basic thing that is done 1 | Thing that happens as a result 1 |
			| Basic thing that is done 2 | Thing that happens as a result 2 |
			| Basic thing that is done 3 | Thing that happens as a result 3 |
		Examples: Other Actions
		    | Action                     | Result                           |
			| Other thing that is done 4 | Thing that happens as a result 4 |
			| Other thing that is done 5 | Thing that happens as a result 5 |
			| Other thing that is done 6 | Thing that happens as a result 6 |

Scenario: Description 2 (e.g. 'MET-02 - Updating a Method')
                        (e.g. 'DSU-02 Running Detector Setup - Neg Only') 
                        (e.g. 'TUN-02 System 2 Settings')
                        (e.g. 'CAL-02 Running Calibration - Custom Settings')
	Given this widget is available within the box with the following characteristics
		| Characteristic 1 | Bottom edge straight   |
		| Characteristic 2 | Whittled in the middle |
	When this action is performed
	Then I get this result


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-nnn2) Description from Software Specification line (nnn2)
Scenario: Description 3
	Given this widget is available within the box
		And and this other thing is set up
		And and yet another thing is set up
	When this action is performed
		And this other action is performed
	Then I get this result
		And this other result happens too
		But I don't get this other result


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
