# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - APPI source parameters
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # AB
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 02-October-2014
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Parameters are on Tune page
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




# ---------------------------------------------------------------------------------------------------------------------------------------------------

@ManualTune
@ignore
@Obsolete
@cleanup_SourceSwitching
Feature: APPI source parameters
	In order to use an APPI source on the instrument
	I want to be able to see APPI source specific parametere with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given APPI source is attached to the instrument
		And factory defaults have been loaded

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario: APPI-01 - APPI prameters availability
	When the browser is opened on the Tune page
		And the 'APPI' tab is selected
	Then the following 'APPI' source parameters and readbacks are available
		| Parameter          | Readback |
		| Lamp               | No       |
		| Repeller           | Yes      |
		| Cone               | Yes      |
		| Source Temperature | Yes      |
		| Probe Temperature  | Yes      |
		| Cone Gas           | Yes      |
		| Desolvation Gas    | Yes      |
	And only these '7' parameters are displayed on the 'APPI' tab


# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario: APPI-02 - APPI parameters availability - Lamp on/off
	When the browser is opened on the Tune page
		And the 'APPI' tab is selected
	Then the APPI Lamp parameter is available with the following dropdown options
			| Lamp on/off |
			| On          |
			| Off         |
		And the default APPI Lamp option is 'On'

# ---------------------------------------------------------------------------------------------------------------------------------------------------

@ignore
@ManualOnly
Scenario Outline: APPI-03 - APPI - Lamp on/off
	When the browser is opened on the Tune page
		And the 'APPI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then if the 'Setting' is changed from 'State 1' to 'State 2', the  physical lamp will be in a 'Final State'
			| Setting | State 1 | State 2 | Final State |
			| Lamp    | On      | Off     | Off         |
			| Lamp    | Off     | On      | On          |

			Examples:
			| Polarity | Analyzer Mode |
			| Positive | Resolution    |
			| Negative | Resolution    |
			| Positive | Sensitivity   |
			| Negative | Sensitivity   |

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario Outline: APPI-04 - APPI default parameters
	When the browser is opened on the Tune page
		And the 'APPI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter          | Default Value | Resolution | UOM    |
			| Repeller           | 1             | 0.01       | kV     |
			| Cone               | 40            | 0          | V      |
			| Source Temperature | 100           | 0          | °C     |
			| Probe Temperature  | 20            | 0          | °C     |
			| Cone Gas           | 50            | 0          | L/hour |
			| Desolvation Gas    | 300           | 0          | L/hour |

		Examples:
			| Test Name            | Polarity | Mode        |
			| Positive_Resolution  | Positive | Resolution  |
			| Negative_Resolution  | Negative | Resolution  |
			| Positive_Sensitivity | Positive | Sensitivity |
			| Negative_Sensitivity | Negative | Sensitivity |

	
# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario Outline: APPI-05 - APPI parameters range
	When the browser is opened on the Tune page
		And the 'APPI' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		Examples:
		| Parameter          | Min  | Max  | Resolution |
		| Repeller           | 0.00 | 3.00 | 0.01       |
		| Cone               | 0    | 150  | 1          |
		| Source Temperature | 20   | 150  | 1          |
		| Probe Temperature  | 20   | 650  | 1          |
		| Cone Gas           | 0    | 300  | 1          |
		| Desolvation Gas    | 300  | 1200 | 1          |

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario Outline: APPI-06 - Load factory defaults APPI parameters
	When the browser is opened on the Tune page
		And the 'APPI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter          | Value |
		| Repeller           | 0.25  |
		| Cone               | 36    |
		| Source Temperature | 78    |
		| Probe Temperature  | 421   |
		| Cone Gas           | 229   |
		| Desolvation Gas    | 1019  |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter          | Default Value |
		| Repeller           | 1.00          |
		| Cone               | 40            |
		| Source Temperature | 100           |
		| Probe Temperature  | 20            |
		| Cone Gas           | 50            |
		| Desolvation Gas    | 300           |

	Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |


# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario Outline: APPI-07 - Save and Load factory defaults APPI parameters
	When the browser is opened on the Tune page
		And the 'APPI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter          | Value |
		| Repeller           | 0.50  |
		| Cone               | 55    |
		| Source Temperature | 80    |
		| Probe Temperature  | 450   |
		| Cone Gas           | 240   |
		| Desolvation Gas    | 1000  |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter          | Value |
		| Repeller           | 0.25  |
		| Cone               | 36    |
		| Source Temperature | 78    |
		| Probe Temperature  | 421   |
		| Cone Gas           | 229   |
		| Desolvation Gas    | 1019  |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter          | Default Value |
		| Repeller           | 0.50          |
		| Cone               | 55            |
		| Source Temperature | 80            |
		| Probe Temperature  | 450           |
		| Cone Gas           | 240           |
		| Desolvation Gas    | 1000          |

	Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario Outline: APPI-08 - Save and Load APPI parameters
	Given the browser is opened on the Tune page
		And the 'APPI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter          | Value |
		| Repeller           | 0.25  |
		| Cone               | 36    |
		| Source Temperature | 78    |
		| Probe Temperature  | 421   |
		| Cone Gas           | 229   |
		| Desolvation Gas    | 1019  |
		And a 'Save Set' is performed
	When I enter different values for the following parameters
		| Parameter          | Value |
		| Repeller           | 0.85  |
		| Cone               | 58    |
		| Source Temperature | 68    |
		| Probe Temperature  | 380   |
		| Cone Gas           | 250   |
		| Desolvation Gas    | 800   |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter          | Value |
		| Repeller           | 0.25  |
		| Cone               | 36    |
		| Source Temperature | 78    |
		| Probe Temperature  | 421   |
		| Cone Gas           | 229   |
		| Desolvation Gas    | 1019  |

	Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
		

Scenario Outline: APPI-09 - APPI readbacks
	Given the browser is opened on the Tune page
		And the 'APPI' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter          | Default Value | New Value |
		| Repeller           | 1.00          | 0.25      |
		| Cone               | 40            | 78        |
		| Source Temperature | 100           | 124       |
		| Probe Temperature  | 20            | 150       |
		| Cone Gas           | 50            | 80        |
		| Desolvation Gas    | 300           | 600       |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
