# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - APGC source parameters
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


@SimulatorOnly
@ManualTune
@Sources
@cleanup_SourceSwitching
Feature:TUN - QRZ - APGC Source Parameters
	In order to use an APGC source on the instrument
	I want to be able to see APGC source specific parametere with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given APGC source is attached to the instrument
		And factory defaults have been loaded

# ---------------------------------------------------------------------------------------------------------------------------------------------------


Scenario: APGC-01 - APGC parameters availability
	When the browser is opened on the Tune page
		And the 'APGC' tab is selected
		And the Corona Mode option is 'Current'
	Then the following 'APGC' source parameters and readbacks are available
		| Source | Parameter               | Readback | 
		| APGC   | Corona mode             | No       |	
		| APGC   | Corona Current (µA)     | Yes      | 
		| APGC   | Sampling Cone (V)       | No       | 
		| APGC   | Source Temperature (°C) | Yes      | 
		| APGC   | Cone Gas (L/hour)       | Yes      | 
		| APGC   | Purge Gas (L/hour)      | Yes      | 
	When the Corona Mode option is 'Voltage'
	Then the following 'APGC' source parameters and readbacks are available
	| Source | Parameter | Readback |
	| APGC | Corona Voltage (kV) | Yes | 

	And only these '6' parameters are displayed on the 'APGC' tab	

 
Scenario: APGC-02 - APGC parameters availability - Corona mode
	When the browser is opened on the Tune page
		And the 'APGC' tab is selected
	Then the Corona mode parameter is available with following dropdown options
			| Corona mode |
			| Current     |
			| Voltage     |
		And the default Corona Mode option is 'Current'
	

Scenario Outline: APGC-03 - APGC default parameters
	When the browser is opened on the Tune page
		And the 'APGC' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter               | Default Value | Resolution | UOM    |
			| Corona Current (µA)     | 3.0           | 0.1        | µA     |
			| Corona Voltage (kV)     | 2.00          | 0.01       | kV     |
			| Sampling Cone (V)       | 40            | 0          | V      |
			| Source Temperature (°C) | 100           | 0          | °C     |
			| Cone Gas (L/hour)       | 50            | 0          | L/hour |
			| Purge Gas (L/hour)      | 350           | 0          | L/hour |

			Examples:
			| Test Name            | Polarity | Mode        |
			| Positive_Resolution  | Positive | Resolution  |
			| Negative_Resolution  | Negative | Resolution  |
			| Positive_Sensitivity | Positive | Sensitivity |
			| Negative_Sensitivity | Negative | Sensitivity |

# Note: In the 'Osprey Default Parameters 721006299' document, 'Auxiliary Gas (L/hour)' parameter is not available,  'Purge Gas (L/hour)' is a parameter available for APGC. The default value and the range values used for these secarios are those available in the document for 'Purge gas'.  

Scenario: APGC-04 - APGC parameters range
	When the browser is opened on the Tune page
		And the 'APGC' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		| Parameter               | Min  | Max  | Resolution |
		| Corona Current (µA)     | 0.0  | 35.0 | 0.1        |
		| Corona Voltage (kV)     | 0.00 | 5.00 | 0.01       |
		| Sampling Cone (V)       | 0    | 150  | 1          |
		| Source Temperature (°C) | 20   | 150  | 1          |
		| Cone Gas (L/hour)       | 0    | 300  | 1          |
		| Purge Gas (L/hour)      | 0    | 800  | 1          |


Scenario Outline: APGC-05 - Load factory defaults APGC parameters
	When the browser is opened on the Tune page
		And the 'APGC' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| Corona Current (µA)     | 13.0  |
		| Corona Voltage (kV)     | 4.25  |
		| Sampling Cone (V)       | 58    |
		| Source Temperature (°C) | 124   |
		| Cone Gas (L/hour)       | 120   |
		| Purge Gas (L/hour)      | 743   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter               | Default Value |
		| Corona Current (µA)     | 3.0           |
		| Corona Voltage (kV)     | 2.00          |
		| Sampling Cone (V)       | 40            |
		| Source Temperature (°C) | 100           |
		| Cone Gas (L/hour)       | 50            |
		| Purge Gas (L/hour)      | 350           |
			
		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: APGC-06 - Save and Load factory defaults APGC parameters
	Given the browser is opened on the Tune page
		And the 'APGC' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| Corona Current (µA)     | 13.0  |
		| Corona Voltage (kV)     | 4.25  |
		| Sampling Cone (V)       | 58    |
		| Source Temperature (°C) | 124   |
		| Cone Gas (L/hour)       | 120   |
		| Purge Gas (L/hour)      | 743   |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter               | Value |
		| Corona Current (µA)     | 7.0   |
		| Corona Voltage (kV)     | 3.25  |
		| Sampling Cone (V)       | 50    |
		| Source Temperature (°C) | 130   |
		| Cone Gas (L/hour)       | 70    |
		| Purge Gas (L/hour)      | 200   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter               | Default Value |
		| Corona Current (µA)     | 13.0          |
		| Corona Voltage (kV)     | 4.25          |
		| Sampling Cone (V)       | 58            |
		| Source Temperature (°C) | 124           |
		| Cone Gas (L/hour)       | 120           |
		| Purge Gas (L/hour)      | 743           |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: APGC-07 - Save and Load APGC parameters
	Given the browser is opened on the Tune page
		And the 'APGC' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| Corona Current (µA)     | 13.0  |
		| Corona Voltage (kV)     | 4.25  |
		| Sampling Cone (V)       | 58    |
		| Source Temperature (°C) | 124   |
		| Cone Gas (L/hour)       | 120   |
		| Purge Gas (L/hour)      | 743   |
		And a 'Save Set' is performed
	When I enter different values for the following parameters
		| Parameter               | Value |
		| Corona Current (µA)     | 7.0   |
		| Corona Voltage (kV)     | 3.25  |
		| Sampling Cone (V)       | 50    |
		| Source Temperature (°C) | 130   |
		| Cone Gas (L/hour)       | 70    |
		| Purge Gas (L/hour)      | 200   |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter               | Value |
		| Corona Current (µA)     | 13.0  |
		| Corona Voltage (kV)     | 4.25  |
		| Sampling Cone (V)       | 58    |
		| Source Temperature (°C) | 124   |
		| Cone Gas (L/hour)       | 120   |
		| Purge Gas (L/hour)      | 743   |
			
		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: APGC-08 - APGC readbacks
	Given the browser is opened on the Tune page
		And the 'APGC' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter               | Default Value | New Value |
		| Corona Current (µA)     | 3.0           | 13.0      |
		| Corona Voltage (kV)     | 2.00          | 4.25      |
		| Source Temperature (°C) | 100           | 124       |
		| Cone Gas (L/hour)       | 50            | 120       |
		| Purge Gas (L/hour)      | 350           | 623       |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
