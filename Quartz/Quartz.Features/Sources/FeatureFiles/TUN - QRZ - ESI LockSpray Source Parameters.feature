# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - ESI LockSpray source parameters
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # GI
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 27-Feb-15
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
#
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-198)                 # The software will provide the manual control for the instrument hardware, so thaat the instruments control parameters may be set
# (SS-199)				   # Controls provided will have defaults and ranges set appropriately
# (SS-444)				   # All priority 1 sources should be identified and supported
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@ManualTune
@Sources
@cleanup_SourceSwitching
Feature: TUN - QRZ - ESI LockSpray Source Parameters
	In order to use an ESI LockSpray source on the instrument
	I want to be able to see ESI LockSpray source specific parameters with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given ESI Lockspray source is attached to the instrument
	And factory defaults have been loaded

# ---------------------------------------------------------------------------------------------------------------------------------------------------

@SmokeTest
Scenario: ESI-01 - ESI LockSpray Parameters availability 
	When the browser is opened on the Tune page
		And the 'ESI LockSpray' tab is selected
	Then the following 'ESI' source parameters and readbacks are available
		| Source        | Parameter                    | Readback |
		| ESI LockSpray | Reference Capillary (kV)     | Yes      |
		| ESI LockSpray | Capillary (kV)               | Yes      |
		| ESI LockSpray | Sampling Cone (V)            | No       |
		| ESI LockSpray | Source Temperature (°C)      | Yes      |
		| ESI LockSpray | Desolvation Temperature (°C) | Yes      |
		| ESI LockSpray | Cone Gas (L/hour)            | Yes      |
		| ESI LockSpray | Desolvation Gas (L/hour)     | Yes      |
		| ESI LockSpray | Source Offset (V)            | Yes      |
		And only these '8' parameters are displayed on the 'ESI LockSpray' tab


Scenario Outline: ESI-02 - ESI LockSpray default parameters - Positive
	When the browser is opened on the Tune page
		And the 'ESI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter                    | Default Value | Resolution | UOM    |
		| Reference Capillary (kV)     | 3.00          | 0.01       | kV     |
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



Scenario Outline: ESI-03 - ESI LockSpray default parameters - Negative
	Given the browser is opened on the Tune page
		And the 'ESI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter                    | Default Value | Resolution | UOM    |
		| Reference Capillary (kV)     | 2.50          | 0.01       | kV     |
		| Capillary (kV)               | 2.00          | 0.01       | kV     |
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


Scenario: ESI-04 - ESI LockSpray parameters ranges
	When the browser is opened on the Tune page
		And the 'ESI LockSpray' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		| Parameter                    | Min  | Max  | Resolution |
		| Reference Capillary (kV)     | 0.00 | 5.00 | 0.01       |
		| Capillary (kV)               | 0.00 | 5.00 | 0.01       |
		| Sampling Cone (V)            | 0    | 150  | 1          |
		| Source Temperature (°C)      | 20   | 150  | 1          |
		| Desolvation Temperature (°C) | 20   | 650  | 1          |
		| Cone Gas (L/hour)            | 0    | 300  | 1          |
		| Desolvation Gas (L/hour)     | 300  | 1200 | 1          |
		| Source Offset (V)            | 0    | 150  | 1          |

@SmokeTest
Scenario Outline: ESI-05 - ESI LockSpray readbacks - Positive
	Given the browser is opened on the Tune page
		And the 'ESI LockSpray' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter                    | Default Value | New Value |
		| Reference Capillary (kV)     | 3.00          | 4.50      |
		| Capillary (kV)               | 3.00          | 4.50      |
		| Source Temperature (°C)      | 100           | 140       |
		| Desolvation Temperature (°C) | 250           | 300       |
		| Cone Gas (L/hour)            | 50            | 80        |
		| Desolvation Gas (L/hour)     | 600           | 800       |
		| Source Offset (V)            | 80            | 120       |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		
@SmokeTest
Scenario Outline: ESI-06 - ESI LockSpray readbacks - Negative
	Given the browser is opened on the Tune page	
		And the 'ESI LockSpray' tab is selected	
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter                    | Default Value | New Value |
		| Reference Capillary (kV)     | 2.50          | 1.80      |
		| Capillary (kV)               | 2.50          | 1.50      |
		| Source Temperature (°C)      | 100           | 140       |
		| Desolvation Temperature (°C) | 250           | 290       |
		| Cone Gas (L/hour)            | 50            | 80        |
		| Desolvation Gas (L/hour)     | 600           | 500       |
		| Source Offset (V)            | 80            | 30        |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |



Scenario Outline: ESI-07 - Load factory default ESI LockSpray parameters - Positive
	Given the browser is opened on the Tune page
		And the 'ESI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
			| Parameter                    | Value |
			| Reference Capillary (kV)     | 4.50  |
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
		| Reference Capillary (kV)     | 3.00          |
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
			

Scenario Outline: ESI-08 - Load factory defaults ESI LockSpray parameters - Negative
	Given the browser is opened on the Tune page
		And the 'ESI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                    | Value |
		| Reference Capillary (kV)     | 4.50  |
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
		| Reference Capillary (kV)     | 2.50          |
		| Capillary (kV)               | 2.00          |
		| Sampling Cone (V)            | 40            |
		| Source Temperature (°C)      | 100           |
		| Desolvation Temperature (°C) | 250           |
		| Cone Gas (L/hour)            | 50            |
		| Desolvation Gas (L/hour)     | 600           |
		| Source Offset (V)            | 80            | 

			Examples:
			| Test Name           | Polarity | Mode |
			| Negative_Sensitivity| Negative | Sensitivity   |
			| Negative_Resolution | Negative | Resolution    |


Scenario Outline: ESI-09 - Save and Load factory defaults ESI LockSpray parameters
	Given the browser is opened on the Tune page
		And the 'ESI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                    | Value |
		| Reference Capillary (kV)     | 1.75  |
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
		| Reference Capillary (kV)     | 4.20  |
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
		| Reference Capillary (kV)     | 1.75          |
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


Scenario Outline: ESI-10 - Save and Load ESI LockSpray parameters - Positive
	Given the browser is opened on the Tune page
		And the 'ESI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                    | Value |
		| Reference Capillary (kV)     | 1.00  |
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
		| Reference Capillary (kV)     | 3.80  |
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
		| Reference Capillary (kV)     | 1.00  |
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


Scenario Outline: ESI-11 - Save and Load ESI LockSpray parameters - Negative
	Given the browser is opened on the Tune page
		And the 'ESI LockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                    | Value |
		| Reference Capillary (kV)     | 0.50  |
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
		| Reference Capillary (kV)     | 1.30  |
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
		| Reference Capillary (kV)     | 0.50  |
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