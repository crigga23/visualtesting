# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - APCI LockSpray source parameters
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # GI
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 06-March-2015
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
#
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-198)                 # The software will provide the manual control for the instrument hardware, so thaat the instruments control parameters may be set
# (SS-199)				   # Controls provided will have defaults and ranges set appropriately
# (SS-444)				   # All priority 1 sources should be identified and supported
# -------------------------#-------------------------------------------------------------------------------------------------------------------------



# ---------------------------------------------------------------------------------------------------------------------------------------------------

@SimulatorOnly
@ManualTune
@Sources
@cleanup_SourceSwitching
Feature: TUN - QRZ - APCI LockSpray Source Parameters
	In order to use an APCI LockSpray source on the instrument
	I want to be able to see APCI LockSpray source specific parameters with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given APCI Lockspray source is attached to the instrument
		And factory defaults have been loaded		

# ---------------------------------------------------------------------------------------------------------------------------------------------------


Scenario: APCI-01 - APCI LockSpray parameters availability
	When the browser is opened on the Tune page
		And the 'APCI LockSpray' tab is selected
	Then the following 'APCI LockSpray' source parameters and readbacks are available
		| Source         | Parameter                | Readback |
		| APCI LockSpray | Reference Capillary (kV) | Yes      |
		| APCI LockSpray | Corona mode              | No       |
		| APCI LockSpray | Corona Current (µA)      | Yes      |
		| APCI LockSpray | Sampling Cone (V)        | No       |
		| APCI LockSpray | Source Temperature (°C)  | Yes      |
		| APCI LockSpray | Probe Temperature (°C)   | Yes      |
		| APCI LockSpray | Cone Gas (L/hour)        | Yes      |
		| APCI LockSpray | Desolvation Gas (L/hour) | Yes      |
	When the Corona Mode option is 'Voltage'
	Then the following 'APCI LockSpray' source parameters and readbacks are available
	| Source         | Parameter           | Readback |
	| APCI LockSpray | Corona Voltage (kV) | Yes      | 
	And only these '8' parameters are displayed on the 'APCI LockSpray' tab


Scenario: APCI-02 - APCI LockSpray parameters availability - Corona mode
	When the browser is opened on the Tune page
		And the 'APCI LockSpray' tab is selected
	Then the Corona mode parameter is available with following dropdown options
			| Corona mode |
			| Current     |
			| Voltage     |
		And the default Corona Mode option is 'Current'


Scenario Outline: APCI-03 - APCI LockSpray default parameters - Positive
	When the browser is opened on the Tune page
		And the 'APCI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter                | Default Value | Resolution | UOM    |
			| Reference Capillary (kV) | 3.00          | 0.01       | kV     |
			| Corona Current (µA)      | 3.0           | 0.1        | µA     |
			| Corona Voltage (kV)      | 2.00          | 0.01       | kV     |
			| Sampling Cone (V)        | 40            | 1          | V      |
			| Source Temperature (°C)  | 100           | 1          | °C     |
			| Probe Temperature (°C)   | 20            | 1          | °C     |
			| Cone Gas (L/hour)        | 50            | 1          | L/hour |
			| Desolvation Gas (L/hour) | 300           | 1          | L/hour |

			Examples:
			| Test Name            | Polarity | Mode        |
			| Positive_Resolution  | Positive | Resolution  |
			| Positive_Sensitivity | Positive | Sensitivity |


Scenario Outline: APCI-04 - APCI LockSpray default parameters - Negative
	When the browser is opened on the Tune page
		And the 'APCI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter                | Default Value | Resolution | UOM    |
			| Reference Capillary (kV) | 2.50          | 0.01       | kV     |
			| Corona Current (µA)      | 3.0           | 0.1        | µA     |
			| Corona Voltage (kV)      | 2.00          | 0.01       | kV     |
			| Sampling Cone (V)        | 40            | 1          | V      |
			| Source Temperature (°C)  | 100           | 1          | °C     |
			| Probe Temperature (°C)   | 20            | 1          | °C     |
			| Cone Gas (L/hour)        | 50            | 1          | L/hour |
			| Desolvation Gas (L/hour) | 300           | 1          | L/hour |

			Examples:
			| Test Name            | Polarity | Mode        |
			| Negative_Resolution  | Negative | Resolution  |
			| Negative_Sensitivity | Negative | Sensitivity |


Scenario: APCI-05 - APCI LockSpray parameters range
	When the browser is opened on the Tune page
		And the 'APCI LockSpray' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		| Parameter                | Min  | Max  | Resolution |
		| Reference Capillary (kV) | 0.00 | 5.00 | 0.01       |
		| Corona Current (µA)      | 0.0  | 35.0 | 0.1        |
		| Corona Voltage (kV)      | 0.00 | 5.00 | 0.01       |
		| Sampling Cone (V)        | 0    | 150  | 1          |
		| Source Temperature (°C)  | 20   | 150  | 1          |
		| Probe Temperature (°C)   | 20   | 650  | 1          |
		| Cone Gas (L/hour)        | 0    | 300  | 1          |
		| Desolvation Gas (L/hour) | 300  | 1200 | 1          |


Scenario Outline: APCI-06 - Load factory defaults APCI LockSpray parameters - Positive
	Given the browser is opened on the Tune page
		And the 'APCI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
			| Parameter                | Value |
			| Reference Capillary (kV) | 3.50  |
			| Corona Current (µA)      | 13.0  |
			| Corona Voltage (kV)      | 4.25  |
			| Sampling Cone (V)        | 58    |
			| Source Temperature (°C)  | 124   |
			| Probe Temperature (°C)   | 472   |
			| Cone Gas (L/hour)        | 120   |
			| Desolvation Gas (L/hour) | 985   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                | Default Value |
		| Reference Capillary (kV) | 3.00          |
		| Corona Current (µA)      | 3.0           |
		| Corona Voltage (kV)      | 2.00          |
		| Sampling Cone (V)        | 40            |
		| Source Temperature (°C)  | 100           |
		| Probe Temperature (°C)   | 20            |
		| Cone Gas (L/hour)        | 50            |
		| Desolvation Gas (L/hour) | 300           |

		Examples:
		| Test Name           | Polarity | Mode |
		| Positive_Resolution | Positive | Resolution    |
		| Positive_Sensitivity| Positive | Sensitivity   |


Scenario Outline: APCI-07 - Load factory defaults APCI LockSpray parameters - Negative
	Given the browser is opened on the Tune page
		And the 'APCI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
			| Parameter                | Value |
			| Reference Capillary (kV) | 3.50  |
			| Corona Current (µA)      | 13.0  |
			| Corona Voltage (kV)      | 4.25  |
			| Sampling Cone (V)        | 58    |
			| Source Temperature (°C)  | 124   |
			| Probe Temperature (°C)   | 472   |
			| Cone Gas (L/hour)        | 120   |
			| Desolvation Gas (L/hour) | 985   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                | Default Value |
		| Reference Capillary (kV) | 2.50          |
		| Corona Current (µA)      | 3.0           |
		| Corona Voltage (kV)      | 2.00          |
		| Sampling Cone (V)        | 40            |
		| Source Temperature (°C)  | 100           |
		| Probe Temperature (°C)   | 20            |
		| Cone Gas (L/hour)        | 50            |
		| Desolvation Gas (L/hour) | 300           |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: APCI-08 - Save and Load factory defaults APCI LockSpray parameters
	Given the browser is opened on the Tune page
		And the 'APCI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 4.30  |
		| Corona Current (µA)      | 13.0  |
		| Corona Voltage (kV)      | 4.25  |
		| Sampling Cone (V)        | 58    |
		| Source Temperature (°C)  | 124   |
		| Probe Temperature (°C)   | 472   |
		| Cone Gas (L/hour)        | 120   |
		| Desolvation Gas (L/hour) | 985   |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 2.30  |
		| Corona Current (µA)      | 10.0  |
		| Corona Voltage (kV)      | 1.25  |
		| Sampling Cone (V)        | 50    |
		| Source Temperature (°C)  | 120   |
		| Probe Temperature (°C)   | 40    |
		| Cone Gas (L/hour)        | 60    |
		| Desolvation Gas (L/hour) | 350   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                | Default Value |
		| Reference Capillary (kV) | 4.30          |
		| Corona Current (µA)      | 13.0          |
		| Corona Voltage (kV)      | 4.250         |
		| Sampling Cone (V)        | 58            |
		| Source Temperature (°C)  | 124           |
		| Probe Temperature (°C)   | 472           |
		| Cone Gas (L/hour)        | 120           |
		| Desolvation Gas (L/hour) | 985           |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: APCI-09 - Save and Load APCI LockSpray parameters
	Given the browser is opened on the Tune page
		And the 'APCI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 4.00  |
		| Corona Current (µA)      | 13.0  |
		| Corona Voltage (kV)      | 4.25  |
		| Sampling Cone (V)        | 58    |
		| Source Temperature (°C)  | 124   |
		| Probe Temperature (°C)   | 472   |
		| Cone Gas (L/hour)        | 120   |
		| Desolvation Gas (L/hour) | 985   |
		And a 'Save Set' is performed 
	When I enter different values for the following parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 4.50  |
		| Corona Current (µA)      | 10.0  |
		| Corona Voltage (kV)      | 3.25  |
		| Sampling Cone (V)        | 35    |
		| Source Temperature (°C)  | 110   |
		| Probe Temperature (°C)   | 30    |
		| Cone Gas (L/hour)        | 70    |
		| Desolvation Gas (L/hour) | 350   |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 4.00  |
		| Corona Current (µA)      | 13.0  |
		| Corona Voltage (kV)      | 4.25  |
		| Sampling Cone (V)        | 58    |
		| Source Temperature (°C)  | 124   |
		| Probe Temperature (°C)   | 472   |
		| Cone Gas (L/hour)        | 120   |
		| Desolvation Gas (L/hour) | 985   |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: APCI-10 - APCI LockSpray readbacks - Positive
	Given the browser is opened on the Tune page
		And the 'APCI LockSpray' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter                | Default Value | New Value |
		| Reference Capillary (kV) | 3.00          | 3.75      |
		| Corona Current (µA)      | 3.0           | 13.0      |
		| Corona Voltage (kV)      | 2.00          | 4.25      |
		| Source Temperature (°C)  | 100           | 124       |
		| Probe Temperature (°C)   | 20            | 60        |
		| Cone Gas (L/hour)        | 50            | 70        |
		| Desolvation Gas (L/hour) | 300           | 425       |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Positive_Resolution | Positive | Resolution  |
		| Positive_Sensitivity| Positive | Sensitivity |



Scenario Outline: APCI-11 - APCI LockSpray readbacks - Negative
	Given the browser is opened on the Tune page
		And the 'APCI LockSpray' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter                | Default Value | New Value |
		| Reference Capillary (kV) | 2.50          | 1.20      |
		| Corona Current (µA)      | 3.0           | 6.0       |
		| Corona Voltage (kV)      | 2.00          | 3.25      |
		| Source Temperature (°C)  | 100           | 118       |
		| Probe Temperature (°C)   | 20            | 32        |
		| Cone Gas (L/hour)        | 50            | 25        |
		| Desolvation Gas (L/hour) | 300           | 500       |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Negative_Resolution | Negative | Resolution  |
		| Negative_Sensitivity| Negative | Sensitivity |
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
