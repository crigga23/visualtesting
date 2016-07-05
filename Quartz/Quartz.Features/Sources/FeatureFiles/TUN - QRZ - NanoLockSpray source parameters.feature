# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - NanoLockSpray source parameters
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


@SimulatorOnly
@ManualTune
@Sources
@cleanup_SourceSwitching
Feature: TUN - QRZ - NanoLockSpray Source Parameters
	In order to use an NanoLockSpray source on the instrument
	I want to be able to see NanoLockSpray source specific parametere with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given NanoFlow Lockspray source is attached to the instrument
		And factory defaults have been loaded

# ---------------------------------------------------------------------------------------------------------------------------------------------------


Scenario: NANO-01 - Parameters availability
	When the browser is opened on the Tune page
		And the 'NanoLockSpray' tab is selected
	Then the following 'NanoLockSpray' source parameters and readbacks are available
		| Source        | Parameter                | Readback |
		| NanoLockSpray | Reference Capillary (kV) | Yes      |
		| NanoLockSpray | Capillary (kV)           | Yes      |
		| NanoLockSpray | Sampling Cone (V)        | No       |
		| NanoLockSpray | Source Temperature (°C)  | Yes      |
		| NanoLockSpray | Cone Gas (L/hour)        | Yes      |
		| NanoLockSpray | NanoFlow Gas (Bar)       | Yes      |
		| NanoLockSpray | Purge Gas (L/hour)       | Yes      |
		| NanoLockSpray | Source Offset (V)        | Yes      |
	And only these '8' parameters are displayed on the 'NanoLockSpray' tab


Scenario Outline: NANO-02 - NanoLockSpray default parameters - Positive
	When the browser is opened on the Tune page
		And the 'NanoLockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter                | Default Value | Resolution | UOM    |
		| Reference Capillary (kV) | 3.00          | 0.01       | kV     |
		| Capillary (kV)           | 1.00          | 0.01       | kV     |
		| Sampling Cone (V)        | 40            | 1          | V      |
		| Source Offset (V)        | 80            | 1          | V      |
		| Source Temperature (°C)  | 100           | 1          | °C     |
		| Cone Gas (L/hour)        | 50            | 1          | L/hour |
		| NanoFlow Gas (Bar)       | 0.30          | 0.01       | Bar    |
		| Purge Gas (L/hour)       | 350           | 1          | L/hour |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |


Scenario Outline: NANO-03 - NanoLockSpray default parameters - Negative
	When the browser is opened on the Tune page
		And the 'NanoLockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter                | Default Value | Resolution | UOM    |
		| Reference Capillary (kV) | 2.50          | 0.01       | kV     |
		| Capillary (kV)           | 1.00          | 0.01       | kV     |
		| Sampling Cone (V)        | 40            | 1          | V      |
		| Source Offset (V)        | 80            | 1          | V      |
		| Source Temperature (°C)  | 100           | 1          | °C     |
		| Cone Gas (L/hour)        | 50            | 1          | L/hour |
		| NanoFlow Gas (Bar)       | 0.30          | 0.01       | Bar    |
		| Purge Gas (L/hour)       | 350           | 1          | L/hour |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |	


Scenario: NANO-04 - NanoLockSpray parameters ranges
	When the browser is opened on the Tune page
		And the 'NanoLockSpray' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		| Parameter                | Min  | Max  | Resolution |
		| Reference Capillary (kV) | 0.00 | 5.00 | 0.01       |
		| Capillary (kV)           | 0.00 | 5.00 | 0.01       |
		| Sampling Cone (V)        | 0    | 150  | 1          |
		| Source Offset (V)        | 0    | 150  | 1          |
		| Source Temperature (°C)  | 20   | 150  | 1          |
		| Cone Gas (L/hour)        | 0    | 300  | 1          |
		| NanoFlow Gas (Bar)       | 0.00 | 2.00 | 0.01       |
		| Purge Gas (L/hour)       | 0    | 800  | 1          |


Scenario Outline: NANO-05 - NanoLockSpray readbacks - Positive
	Given the browser is opened on the Tune page
		And the 'NanoLockSpray' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter                | Default Value | New Value |
		| Reference Capillary (kV) | 3.00          | 1.80      |
		| Capillary (kV)           | 1.00          | 2.30      |
		| Source Offset (V)        | 80            | 115       |
		| Source Temperature (°C)  | 100           | 131       |
		| Cone Gas (L/hour)        | 50            | 66        |
		| NanoFlow Gas (Bar)       | 0.30          | 0.75      |
		| Purge Gas (L/hour)       | 350           | 555       |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |


Scenario Outline: NANO-06 - NanoLockSpray readbacks - Negative
	Given the browser is opened on the Tune page
		And the 'NanoLockSpray' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter                | Default Value | New Value |
		| Reference Capillary (kV) | 2.50          | 4.30      |
		| Capillary (kV)           | 1.00          | 2.80      |
		| Source Offset (V)        | 80            | 50        |
		| Source Temperature (°C)  | 100           | 149       |
		| Cone Gas (L/hour)        | 50            | 116       |
		| NanoFlow Gas (Bar)       | 0.30          | 1.66      |
		| Purge Gas (L/hour)       | 350           | 520       |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: NANO-07 - Load factory defaults NanoLockSpray parameters - Positive
When the browser is opened on the Tune page
		And the 'NanoLockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 4.30  |
		| Capillary (kV)           | 2.30  |
		| Sampling Cone (V)        | 55    |
		| Source Offset (V)        | 70    |   
		| Source Temperature (°C)  | 133   |
		| Cone Gas (L/hour)        | 95    |
		| NanoFlow Gas (Bar)       | 1.23  |
		| Purge Gas (L/hour)       | 280   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                | Default Value |
		| Reference Capillary (kV) | 3.00          |
		| Capillary (kV)           | 1.00          |
		| Sampling Cone (V)        | 40            |
		| Source Offset (V)        | 80            |
		| Source Temperature (°C)  | 100           |
		| Cone Gas (L/hour)        | 50            |
		| NanoFlow Gas (Bar)       | 0.30          |
		| Purge Gas (L/hour)       | 350           |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |


Scenario Outline: NANO-08 - Load factory defaults NanoLockSpray parameters - Negative
When the browser is opened on the Tune page
		And the 'NanoLockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 4.45  |
		| Capillary (kV)           | 2.80  |
		| Sampling Cone (V)        | 85    |
		| Source Offset (V)        | 60    |
		| Source Temperature (°C)  | 149   |
		| Cone Gas (L/hour)        | 116   |
		| NanoFlow Gas (Bar)       | 1.66  |
		| Purge Gas (L/hour)       | 520   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                | Default Value |
		| Reference Capillary (kV) | 2.50          |
		| Capillary (kV)           | 1.00          |
		| Sampling Cone (V)        | 40            |
		| Source Offset (V)        | 80            |
		| Source Temperature (°C)  | 100           |
		| Cone Gas (L/hour)        | 50            |
		| NanoFlow Gas (Bar)       | 0.30          |
		| Purge Gas (L/hour)       | 350           |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |
	

Scenario Outline: NANO-09 - Save and Load factory defaults NanoLockSpray parameters
	When the browser is opened on the Tune page
		And the 'NanoLockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 4.30  |
		| Capillary (kV)           | 2.80  |
		| Sampling Cone (V)        | 85    |
		| Source Offset (V)        | 65    |
		| Source Temperature (°C)  | 95    |
		| Cone Gas (L/hour)        | 116   |
		| NanoFlow Gas (Bar)       | 1.66  |
		| Purge Gas (L/hour)       | 520   |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 4.99  |
		| Capillary (kV)           | 3.80  |
		| Sampling Cone (V)        | 96    |
		| Source Offset (V)        | 99    |
		| Source Temperature (°C)  | 149   |
		| Cone Gas (L/hour)        | 156   |
		| NanoFlow Gas (Bar)       | 1.78  |
		| Purge Gas (L/hour)       | 555   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                | Default Value |
		| Reference Capillary (kV) | 4.30          |
		| Capillary (kV)           | 2.80          |
		| Sampling Cone (V)        | 85            |
		| Source Offset (V)        | 65            |
		| Source Temperature (°C)  | 95            |
		| Cone Gas (L/hour)        | 116           |
		| NanoFlow Gas (Bar)       | 1.66          |
		| Purge Gas (L/hour)       | 520           |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: NANO-10 - Save and Load NanoLockSpray parameters
	Given the browser is opened on the Tune page
		And the 'NanoLockSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 4.38  |
		| Capillary (kV)           | 3.88  |
		| Sampling Cone (V)        | 101   |
		| Source Offset (V)        | 88    |
		| Source Temperature (°C)  | 139   |
		| Cone Gas (L/hour)        | 188   |
		| NanoFlow Gas (Bar)       | 1.28  |
		| Purge Gas (L/hour)       | 750   |
		And a 'Save Set' is performed
	When I enter different values for the following parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 4.30  |
		| Capillary (kV)           | 2.80  |
		| Sampling Cone (V)        | 85    |
		| Source Offset (V)        | 50    |
		| Source Temperature (°C)  | 110   |
		| Cone Gas (L/hour)        | 116   |
		| NanoFlow Gas (Bar)       | 1.66  |
		| Purge Gas (L/hour)       | 520   |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter                | Value |
		| Reference Capillary (kV) | 4.38  |
		| Capillary (kV)           | 3.88  |
		| Sampling Cone (V)        | 101   |
		| Source Offset (V)        | 88    |
		| Source Temperature (°C)  | 139   |
		| Cone Gas (L/hour)        | 188   |
		| NanoFlow Gas (Bar)       | 1.28  |
		| Purge Gas (L/hour)       | 750   |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |
		
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
