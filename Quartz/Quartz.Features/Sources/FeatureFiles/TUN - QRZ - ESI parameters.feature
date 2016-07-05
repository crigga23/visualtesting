# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - ESI source parameters
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # DM
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 01-Oct-14
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
Feature: ESI source parameters
	In order to use an ESI source on the instrument
	I want to be able to see ESI source specific parameters with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given ESI source is attached to the instrument
	And factory defaults have been loaded

# ---------------------------------------------------------------------------------------------------------------------------------------------------


Scenario: ESI-01 - ESI Parameters availability 
	When the browser is opened on the Tune page
		And the 'ESI' tab is selected
	Then the following 'ESI' source parameters and readbacks are available
		| Source | Parameter                    | Readback |
		| ESI    | Capillary (kV)               | Yes      |
		| ESI    | Sampling Cone (V)            | No       |
		| ESI    | Source Temperature (°C)      | Yes      |
		| ESI    | Desolvation Temperature (°C) | Yes      |
		| ESI    | Cone Gas (L/hour)            | Yes      |
		| ESI    | Desolvation Gas (L/hour)     | Yes      |
		| ESI    | Source Offset (V)            | Yes      |
		And only these '7' parameters are displayed on the 'ESI' tab

@Defect
@CR_Default_values_are_incorrect
Scenario Outline: ESI-02 - ESI default parameters - Positive
	When the browser is opened on the Tune page
		And the 'ESI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter                    | Default Value | Resolution | UOM    |
		| Capillary (kV)               | 3.00          | 0.01       | kV     |
		| Sampling Cone (V)            | 40            | 1          | V      |
		| Source Temperature (°C)      | 100           | 1          | °C     |
		| Desolvation Temperature (°C) | 250           | 1          | °C     |
		| Cone Gas (L/hour)            | 50            | 1          | L/hour |
		| Desolvation Gas (L/hour)     | 600           | 1          | L/hour |
		| Source Offset (V)            | 80            | 1          | V      |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Positive_Resolution  | Positive | Resolution  |

@Defect
@CR_Default_values_are_incorrect
Scenario Outline: ESI-03 - ESI default parameters - Negative
	Given the browser is opened on the Tune page
		And the 'ESI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter                    | Default Value | Resolution | UOM    |
		| Capillary (kV)               | 2.50          | 0.01       | kV     |
		| Sampling Cone (V)            | 40            | 1          | V      |
		| Source Temperature (°C)      | 100           | 1          | °C     |
		| Desolvation Temperature (°C) | 250           | 1          | °C     |
		| Cone Gas (L/hour)            | 50            | 1          | L/hour |
		| Desolvation Gas (L/hour)     | 600           | 1          | L/hour |
		| Source Offset (V)            | 80            | 1          | V      |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Sensitivity | Negative | Sensitivity |
		| Negative_Resolution  | Negative | Resolution  |


Scenario: ESI-04 - ESI parameters ranges
	When the browser is opened on the Tune page
		And the 'ESI' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		| Parameter                    | Min  | Max  | Resolution |
		| Capillary (kV)               | 0.00 | 5.00 | 0.01       |
		| Sampling Cone (V)            | 0    | 200  | 1          |
		| Source Temperature (°C)      | 20   | 150  | 1          |
		| Desolvation Temperature (°C) | 20   | 650  | 1          |
		| Cone Gas (L/hour)            | 0    | 300  | 1          |
		| Desolvation Gas (L/hour)     | 300  | 1200 | 1          |
		| Source Offset (V)            | 0    | 150  | 1          |


Scenario Outline: ESI-05 - ESI readbacks - Positive
	Given the browser is opened on the Tune page
		And the 'ESI' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter                    | Default Value | New Value |
		| Capillary (kV)               | 3.00          | 4.50      |
		| Source Temperature (°C)      | 100           | 150       |
		| Desolvation Temperature (°C) | 250           | 320       |
		| Cone Gas (L/hour)            | 50            | 80        |
		| Desolvation Gas (L/hour)     | 600           | 800       |
		| Source Offset (V)            | 80            | 120       |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		

Scenario Outline: ESI-06 - NanoLockSpray readbacks - Negative
	Given the browser is opened on the Tune page	
		And the 'ESI' tab is selected	
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter                    | Default Value | New Value |
		| Capillary (kV)               | 2.50          | 1.50      |
		| Source Temperature (°C)      | 100           | 140       |
		| Desolvation Temperature (°C) | 250           | 100       |
		| Cone Gas (L/hour)            | 50            | 80        |
		| Desolvation Gas (L/hour)     | 600           | 500       |
		| Source Offset (V)            | 80            | 30        |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |

@Defect
@CR_Default_values_incorrect
Scenario Outline: ESI-07 - Load factory default ESI parameters - Positive
	Given the browser is opened on the Tune page
		And the 'ESI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
			| Parameter                    | Value |
			| Capillary (kV)               | 3.50  |
			| Sampling Cone (V)            | 55    |
			| Source Temperature (°C)      | 111   |
			| Desolvation Temperature (°C) | 333   |
			| Cone Gas (L/hour)            | 66    |
			| Desolvation Gas (L/hour)     | 555   |
			| Source Offset (V)            | 100   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                    | Default Value |
		| Capillary (kV)               | 3.00          |
		| Sampling Cone (V)            | 40            |
		| Source Temperature (°C)      | 100           |
		| Desolvation Temperature (°C) | 250           |
		| Cone Gas (L/hour)            | 50            |
		| Desolvation Gas (L/hour)     | 600           |
		| Source Offset (V)            | 80            | 

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Positive_Resolution  | Positive | Resolution  |
			
@Defect
@CR_Default_values_incorrect
Scenario Outline: ESI-08 - Load factory defaults ESI parameters - Negative
	Given the browser is opened on the Tune page
		And the 'ESI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                    | Value |
		| Capillary (kV)               | 1.50  |
		| Sampling Cone (V)            | 55    |
		| Source Temperature (°C)      | 111   |
		| Desolvation Temperature (°C) | 333   |
		| Cone Gas (L/hour)            | 66    |
		| Desolvation Gas (L/hour)     | 555   |
		| Source Offset (V)            | 40    |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                    | Default Value |
		| Capillary (kV)               | 2.50          |
		| Sampling Cone (V)            | 40            |
		| Source Temperature (°C)      | 100           |
		| Desolvation Temperature (°C) | 250           |
		| Cone Gas (L/hour)            | 50            |
		| Desolvation Gas (L/hour)     | 600           |
		| Source Offset (V)            | 80            |

			Examples:
			| Test Name            | Polarity | Mode        |
			| Negative_Sensitivity | Negative | Sensitivity |
			| Negative_Resolution  | Negative | Resolution  |


Scenario Outline: ESI-09 - Save and Load factory defaults ESI parameters
	Given the browser is opened on the Tune page
		And the 'ESI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                    | Value |
		| Capillary (kV)               | 1.50  |
		| Sampling Cone (V)            | 55    |
		| Source Temperature (°C)      | 111   |
		| Desolvation Temperature (°C) | 333   |
		| Cone Gas (L/hour)            | 66    |
		| Desolvation Gas (L/hour)     | 555   |
		| Source Offset (V)            | 40    |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter                    | Value |
		| Capillary (kV)               | 2.50  |
		| Sampling Cone (V)            | 40    |
		| Source Temperature (°C)      | 100   |
		| Desolvation Temperature (°C) | 250   |
		| Cone Gas (L/hour)            | 50    |
		| Desolvation Gas (L/hour)     | 600   |
		| Source Offset (V)            | 70    |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                    | Default Value |
		| Capillary (kV)               | 1.50          |
		| Sampling Cone (V)            | 55            |
		| Source Temperature (°C)      | 111           |
		| Desolvation Temperature (°C) | 333           |
		| Cone Gas (L/hour)            | 66            |
		| Desolvation Gas (L/hour)     | 555           |
		| Source Offset (V)            | 40            |

			Examples:
			| Test Name            | Polarity | Mode        |
			| Negative_Sensitivity | Negative | Sensitivity |
			| Positive_Resolution  | Positive | Resolution  |


Scenario Outline: ESI-10 - Save and Load ESI parameters - Positive
	Given the browser is opened on the Tune page
		And the 'ESI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                    | Value |
		| Capillary (kV)               | 3.50  |
		| Sampling Cone (V)            | 55    |
		| Source Temperature (°C)      | 111   |
		| Desolvation Temperature (°C) | 333   |
		| Cone Gas (L/hour)            | 66    |
		| Desolvation Gas (L/hour)     | 555   |
		| Source Offset (V)            | 99    |
		And a 'Save Set' is performed 
	When I enter different values for the following parameters
		| Parameter                    | Value |
		| Capillary (kV)               | 3.55  |
		| Sampling Cone (V)            | 56    |
		| Source Temperature (°C)      | 112   |
		| Desolvation Temperature (°C) | 334   |
		| Cone Gas (L/hour)            | 67    |
		| Desolvation Gas (L/hour)     | 555   |
		| Source Offset (V)            | 25    |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter                    | Value |
		| Capillary (kV)               | 3.50  |
		| Sampling Cone (V)            | 55    |
		| Source Temperature (°C)      | 111   |
		| Desolvation Temperature (°C) | 333   |
		| Cone Gas (L/hour)            | 66    |
		| Desolvation Gas (L/hour)     | 555   |
		| Source Offset (V)            | 99    |
		
		Examples:
		| Test Name           | Polarity | Mode        |
		| Positive_Sensitivity| Positive | Sensitivity |
		| Positive_Resolution | Positive | Resolution  |


Scenario Outline: ESI-11 - Save and Load ESI parameters - Negative
	Given the browser is opened on the Tune page
		And the 'ESI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                    | Value |
		| Capillary (kV)               | 1.50  |
		| Sampling Cone (V)            | 55    |
		| Source Temperature (°C)      | 111   |
		| Desolvation Temperature (°C) | 333   |
		| Cone Gas (L/hour)            | 66    |
		| Desolvation Gas (L/hour)     | 555   |
		| Source Offset (V)            | 140   |
		And a 'Save Set' is performed
	When I enter different values for the following parameters
		| Parameter                    | Value |
		| Capillary (kV)               | 1.70  |
		| Sampling Cone (V)            | 57    |
		| Source Temperature (°C)      | 113   |
		| Desolvation Temperature (°C) | 335   |
		| Cone Gas (L/hour)            | 68    |
		| Desolvation Gas (L/hour)     | 556   |
		| Source Offset (V)            | 50    |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter                    | Value |
		| Capillary (kV)               | 1.50  |
		| Sampling Cone (V)            | 55    |
		| Source Temperature (°C)      | 111   |
		| Desolvation Temperature (°C) | 333   |
		| Cone Gas (L/hour)            | 66    |
		| Desolvation Gas (L/hour)     | 555   |
		| Source Offset (V)            | 140   |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Sensitivity | Negative | Sensitivity |
		| Negative_Resolution  | Negative | Resolution  |



# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END