# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Dual APCI/APPI source parameters
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # AB
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 01-October-2014
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
Feature: Dual APCI/APPI source paramaters
	In order to use a dual APCI/APPI source on the instrument
	I want to be able to see the APCI/APPI source specific parametere with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given Dual APCI/APPI source is attached to the instrument
		And factory defaults have been loaded

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario: DUAL-01 - APCI/APPI parameters availability
	When the browser is opened on the Tune page
		And the 'APCI/APPI' tab is selected
	Then the following 'APCI/APPI' source parameters and readbacks are available
		| Source    | Parameter          | Readback |
		| Dual APPI5 | Lamp        | No       |
		| Dual APPI5 | Repeller           | Yes      |
		| Dual APPI5 | Corona mode        | No       |
		| Dual APPI5 | Corona Current     | Yes      |
		| Dual APPI5 | Corona Voltage     | Yes      |
		| Dual APPI5 | Cone               | Yes      |
		| Dual APPI5 | Source Temperature | Yes      |
		| Dual APPI5 | Probe Temperature  | Yes      |
		| Dual APPI5 | Cone Gas           | Yes      |
		| Dual APPI5 | Desolvation Gas    | Yes      |
	And only these '10' parameters are displayed on the 'Dual APPI5' tab



Scenario: DUAL-02 - APCI/APPI parameters availability - Corona mode
	When the browser is opened on the Tune page
		And the 'Dual APPI' tab is selected
	Then the Corona mode parameter is available with following dropdown options
			| Corona mode |
			| Current     |
			| Voltage     |
		And the default Corona Mode option is 'Current'


Scenario: DUAL-03 - APCI/APPI parameters availability - Lamp on/off
	When the browser is opened on the Tune page
		And the 'Dual APPI' tab is selected
	Then the APCI/APPI Lamp parameter is available with the following dropdown options
			| Lamp |
			| On   |
			| Off  |
		And the default APCI/APPI Lamp option is 'On'

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario Outline: DUAL-04 - APCI/APPI default parameters
	When the browser is opened on the Tune page
		And the 'Dual APPI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter          | Default Value | Resolution | UOM    |
			| Corona Current     | 3             | 0          | µA     |
			| Corona Voltage     | 2.00          | 0.01       | kV     |
			| Repeller           | 1.00          | 0.01       | kV     |
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

Scenario Outline: DUAL-05 - APCI/APPI parameters range
	When the browser is opened on the Tune page
		And the 'Dual APPI' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		Examples:
		| Parameter          | Min | Max  | Resolution |
		| Repeller           | 0   | 3.00 | 0.01       |
		| Corona Current     | 0   | 35   | 0          |
		| Corona Voltage     | 0   | 5.00 | 0.01       |
		| Cone               | 0   | 150  | 0          |
		| Source Temperature | 20  | 150  | 0          |
		| Probe Temperature  | 20  | 650  | 0          |
		| Cone Gas           | 0   | 300  | 0          |
		| Desolvation Gas    | 300 | 1200 | 0          |


# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario Outline: DUAL-06 - Load factory defaults APCI/APPI parameters
	When the browser is opened on the Tune page
		And the 'Dual APPI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter          | Value |
		| Repeller           | 2.03  |
		| Corona Current     | 13    |
		| Corona Voltage     | 4.25  |
		| Cone               | 58    |
		| Source Temperature | 124   |
		| Probe Temperature  | 472   |
		| Cone Gas           | 120   |
		| Desolvation Gas    | 985   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter          | Default Value |
		| Repeller           | 1.00          |
		| Corona Current     | 3             |
		| Corona Voltage     | 2.00          |
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


Scenario Outline: DUAL-07 - Save and Load factory defaults APCI/APPI parameters
	When the browser is opened on the Tune page
		And the 'Dual APPI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter          | Value |
		| Repeller           | 2.10  |
		| Corona Current     | 15    |
		| Corona Voltage     | 3.25  |
		| Cone               | 47    |
		| Source Temperature | 128   |
		| Probe Temperature  | 50    |
		| Cone Gas           | 70    |
		| Desolvation Gas    | 330   |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter          | Value |
		| Repeller           | 1.03  |
		| Corona Current     | 9     |
		| Corona Voltage     | 2.25  |
		| Cone               | 56    |
		| Source Temperature | 102   |
		| Probe Temperature  | 56    |
		| Cone Gas           | 99    |
		| Desolvation Gas    | 365   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter          | Value |
		| Repeller           | 2.10  |
		| Corona Current     | 15    |
		| Corona Voltage     | 3.25  |
		| Cone               | 47    |
		| Source Temperature | 128   |
		| Probe Temperature  | 50    |
		| Cone Gas           | 70    |
		| Desolvation Gas    | 330   |

	Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |



Scenario Outline: DUAL-08 - Save and Load APCI/APPI parameters
	Given the browser is opened on the Tune page
		And the 'Dual APPI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter          | Value |
		| Repeller           | 1.25  |
		| Corona Current     | 13    |
		| Corona Voltage     | 4.25  |
		| Cone               | 58    |
		| Source Temperature | 124   |
		| Probe Temperature  | 472   |
		| Cone Gas           | 120   |
		| Desolvation Gas    | 985   |
		And a 'Save Set' is performed
	When I enter different values for the following parameters
		| Parameter          | Value |
		| Repeller           | 2.10  |
		| Corona Current     | 15    |
		| Corona Voltage     | 3.25  |
		| Cone               | 47    |
		| Source Temperature | 128   |
		| Probe Temperature  | 50    |
		| Cone Gas           | 70    |
		| Desolvation Gas    | 330   |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter          | Value |
		| Repeller           | 1.25  |
		| Corona Current     | 13    |
		| Corona Voltage     | 4.25  |
		| Cone               | 58    |
		| Source Temperature | 124   |
		| Probe Temperature  | 472   |
		| Cone Gas           | 120   |
		| Desolvation Gas    | 985   |
			
	Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario Outline: DUAL-09 - APCI/APPI readbacks
	Given the browser is opened on the Tune page
		And the 'Dual APPI' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
			| Parameter          | Default Value | New Value |
			| Corona Current     | 3             | 13        |
			| Corona Voltage     | 2.00          | 4.25      |
			| Cone               | 40            | 78        |
			| Source Temperature | 100           | 70        |
			| Probe Temperature  | 20            | 160       |
			| Cone Gas           | 50            | 90        |
			| Desolvation Gas    | 300           | 500       |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END


