# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - TRIZAIC source parameters
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # DM
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 02-Oct-14
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Parameters are on Manual tuning page - source tab
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Latest version of Osprey Default Document 721006299
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-352)                 #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@ManualTune
@Sources
@Obsolete
@ignore
@cleanup_SourceSwitching
Feature: TRIZAIC source parameters
	In order to use an TRIZAIC source on the instrument
	I want to be able to see TRIZAIC source specific parametere with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given TRIZAIC source is attached to the instrument
		And factory defaults have been loaded

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario: TRI-01 - Parameters availability
	When the browser is opened on the Tune page
		And the 'Trizaic' tab is selected
	Then the following 'TRIZAIC' source parameters and readbacks are available
		| Source  | Parameter           | Readback |
		| TRIZAIC | LockSpray Capillary | Yes      |
		| TRIZAIC | Capillary           | Yes      |
		| TRIZAIC | Cone                | Yes      |
		| TRIZAIC | Source Temperature  | Yes      |
		| TRIZAIC | Cone Gas            | Yes      |
		| TRIZAIC | Trap Cooling Gas    | Yes      |
		| TRIZAIC | Nanoflow Gas        | Yes      |
	And only these '7' parameters are displayed on the 'TRIZAIC' tab


# TODO - Test UOM
@FunctionalityIncomplete
Scenario Outline: TRI-02 - TRIZAIC default parameters - Positive
	When the browser is opened on the Tune page
		And the 'Trizaic' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter           | Default Value | Resolution | UOM    |
			| LockSpray Capillary | 3.00          | 0.01       | kV     |
			| Capillary           | 1.00          | 0.01       | kV     |
			| Cone                | 40            | 1          | V      |
			| Source Temperature  | 100           | 1          | °C     |
			| Cone Gas            | 50            | 1          | L/hour |
			| Trap Cooling Gas    | 1000          | 1          | L/hour |
			| Nanoflow Gas        | 0.30          | 0.01       | bar    |
		
		Examples:
			| Test Name            | Polarity | Mode        |
			| Positive_Resolution  | Positive | Resolution  |
			| Positive_Sensitivity | Positive | Sensitivity |

# TODO - Test UOM
@FunctionalityIncomplete
Scenario Outline: TRI-03 - TRIZAIC default parameters - Negative
	When the browser is opened on the Tune page
		And the 'Trizaic' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter           | Default Value | Resolution | UOM    |
			| LockSpray Capillary | 2.50          | 0.01       | kV     |
			| Capillary           | 1.00          | 0.01       | kV     |
			| Cone                | 40            | 1          | V      |
			| Source Temperature  | 100           | 1          | °C     |
			| Cone Gas            | 50            | 1          | L/hour |
			| Trap Cooling Gas    | 1000          | 1          | L/hour |
			| Nanoflow Gas        | 0.30          | 0.01       | bar    |
		
		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |

	
Scenario: TRI-04 - TRIZAIC parameters ranges
		When the browser is opened on the Tune page
		And the 'Trizaic' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		| Parameter           | Min  | Max  | Resolution |
		| LockSpray Capillary | 0.00 | 5.00 | 0.01       |
		| Capillary           | 0.00 | 4.00 | 0.01       |
		| Cone                | 0    | 200  | 1          |
		| Source Temperature  | 20   | 150  | 1          |
		| Cone Gas            | 0    | 300  | 1          |
		| Trap Cooling Gas    | 0    | 1200 | 1          |
		| Nanoflow Gas        | 0.00 | 2.00 | 0.01       |	


Scenario Outline: TRI-05 - TRIZAIC readbacks - Positive
	Given the browser is opened on the Tune page
		And the 'Trizaic' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter           | Default Value | New Value |
		| LockSpray Capillary | 3.00          | 3.75      |
		| Capillary           | 1.00          | 2.30      |
		| Cone                | 40            | 75        |
		| Source Temperature  | 100           | 141       |
		| Cone Gas            | 50            | 76        |
		| Trap Cooling Gas    | 1000          | 888       |
		| Nanoflow Gas        | 0.30          | 0.75      |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Positive_Resolution | Positive | Resolution  |
		| Positive_Sensitivity| Positive | Sensitivity |


Scenario Outline: TRI-06 - TRIZAIC readbacks - Negative
	Given the browser is opened on the Tune page
		And the 'Trizaic' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter           | Default Value | New Value |
		| LockSpray Capillary | 2.50          | 1.75      |
		| Capillary           | 1.00          | 2.80      |
		| Cone                | 40            | 10        |
		| Source Temperature  | 100           | 75        |
		| Cone Gas            | 50            | 90        |
		| Trap Cooling Gas    | 1000          | 1150      |
		| Nanoflow Gas        | 0.30          | 1.75      |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Negative_Resolution | Negative | Resolution  |
		| Negative_Sensitivity| Negative | Sensitivity |



Scenario Outline: TRI-07 - Load factory defaults TRIZAIC parameters - Positive
	Given the browser is opened on the Tune page
		And the 'Trizaic' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 3.50  |
		| Capillary           | 2.30  |
		| Cone                | 100   |
		| Source Temperature  | 111   |
		| Cone Gas            | 66    |
		| Trap Cooling Gas    | 888   |
		| Nanoflow Gas        | 0.75  |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter           | Default Value |
		| LockSpray Capillary | 3.00          |
		| Capillary           | 1.00          |
		| Cone                | 40            |
		| Source Temperature  | 100           |
		| Cone Gas            | 50            |
		| Trap Cooling Gas    | 1000          |
		| Nanoflow Gas        | 0.30          |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
	

Scenario Outline: TRI-08 - Load factory defaults TRIZAIC parameters - Negative
	Given the browser is opened on the Tune page
		And the 'Trizaic' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 3.55  |
		| Capillary           | 2.35  |
		| Cone                | 150   |
		| Source Temperature  | 115   |
		| Cone Gas            | 70    |
		| Trap Cooling Gas    | 895   |
		| Nanoflow Gas        | 0.80  |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter           | Default Value |
		| LockSpray Capillary | 2.50          |
		| Capillary           | 1.00          |
		| Cone                    | 40            |
		| Source Temperature  | 100           |
		| Cone Gas            | 50            |
		| Trap Cooling Gas    | 1000          |
		| Nanoflow Gas        | 0.30          |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: TRI-09 - Save and Load factory defaults TRIZAIC parameters
	Given the browser is opened on the Tune page
		And the 'Trizaic' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 3.55  |
		| Capillary           | 2.35  |
		| Cone                | 90    |
		| Source Temperature  | 115   |
		| Cone Gas            | 70    |
		| Trap Cooling Gas    | 895   |
		| Nanoflow Gas        | 0.80  |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 1.50  |
		| Capillary           | 1.30  |
		| Cone                | 150   |
		| Source Temperature  | 140   |
		| Cone Gas            | 40    |
		| Trap Cooling Gas    | 750   |
		| Nanoflow Gas        | 1.50  |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter           | Default Value |
		| LockSpray Capillary | 3.55          |
		| Capillary           | 2.35          |
		| Cone                | 90            |
		| Source Temperature  | 115           |
		| Cone Gas            | 70            |
		| Trap Cooling Gas    | 895           |
		| Nanoflow Gas        | 0.80          |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |



Scenario Outline: TRI-10 - Save and Load TRIZAIC parameters
	Given the browser is opened on the Tune page
		And the 'Trizaic' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 3.30  |
		| Capillary           | 2.30  |
		| Cone                | 50    |
		| Source Temperature  | 111   |
		| Cone Gas            | 66    |
		| Trap Cooling Gas    | 888   |
		| Nanoflow Gas        | 0.75  |
		And a 'Save Set' is performed 
	When I enter different values for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 1.50  |
		| Capillary           | 1.30  |
		| Cone                | 90    |
		| Source Temperature  | 140   |
		| Cone Gas            | 40    |
		| Trap Cooling Gas    | 750   |
		| Nanoflow Gas        | 1.50  |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter           | Value |
		| LockSpray Capillary | 3.30  |
		| Capillary           | 2.30  |
		| Cone                | 50    |
		| Source Temperature  | 111   |
		| Cone Gas            | 66    |
		| Trap Cooling Gas    | 888   |
		| Nanoflow Gas        | 0.75  |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |

# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END