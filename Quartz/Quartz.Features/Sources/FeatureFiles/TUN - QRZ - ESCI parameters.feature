# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - ESCI source parameters
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
Feature: ESCI source parameters
	In order to use an ESCI source on the instrument
	I want to be able to see ESCI source specific parametere with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given ESCI source is attached to the instrument
		And factory defaults have been loaded

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario: ESCI-01 - ESCI parameters availability
	When the browser is opened on the Tune page
		And the 'ESCI' tab is selected
	Then the following 'ESCI' source parameters and readbacks are available
		| Source | Parameter               | Readback |
		| ESCI   | Capillary               | Yes      |
		| ESCI   | LockSpray Capillary     | Yes      |
		| ESCI   | Corona mode             | No       |
		| ESCI   | Corona Current          | Yes      |
		| ESCI   | Corona Voltage          | Yes      |
		| ESCI   | Cone                    | Yes      |
		| ESCI   | Source Temperature      | Yes      |
		| ESCI   | Desolvation Temperature | Yes      |
		| ESCI   | Cone Gas                | Yes      |
		| ESCI   | Desolvation Gas         | Yes      |
		And only these '10' parameters are displayed on the 'ESCI' tab



Scenario: ESCI-02 - ESCI parameters availability - Corona mode
	When the browser is opened on the Tune page
		And the 'ESCI' tab is selected
	Then the Corona mode parameter is available with following dropdown options
			| Corona mode |
			| Current     |
			| Voltage     |
		And the default Corona Mode option is 'Current'

# ---------------------------------------------------------------------------------------------------------------------------------------------------

# TODO - check UOM
@ignore
@FunctionalityIncomplete
Scenario Outline: ESCI-03 - ESCI default parameters - Positive polarity
	When the browser is opened on the Tune page
		And the 'ESCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter               | Default Value | Resolution | UOM    |
			| Capillary               | 3.00          | 0.01       | kV     |
			| LockSpray Capillary     | 3.00          | 0.01       | kV     |
			| Corona Current          | 3             | 0          | µA     |
			| Corona Voltage          | 2.00          | 0.01       | kV     |
			| Cone                    | 40            | 0          | V      |
			| Source Temperature      | 100           | 0          | °C     |
			| Desolvation Temperature | 20            | 0          | °C     |
			| Cone Gas                | 50            | 0          | L/hour |
			| Desolvation Gas         | 300           | 0          | L/hour |

		Examples:
			| Test Name            | Polarity | Mode        |
			| Positive_Resolution  | Positive | Resolution  |
			| Positive_Sensitivity | Positive | Sensitivity |

# TODO - check UOM
@ignore
@FunctionalityIncomplete
Scenario Outline: ESCI-04 - ESCI default parameters - Negative polarity
	When the browser is opened on the Tune page
		And the 'ESCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| ESCI Parameter          | Default Value | Resolution | UOM    |
			| Capillary               | 2.50          | 0.01       | kV     |
			| LockSpray Capillary     | 2.50          | 0.01       | kV     |
			| Corona Current          | 3             | 0          | µA     |
			| Corona Voltage          | 2.00          | 0.01       | kV     |
			| Cone                    | 40            | 0          | V      |
			| Source Temperature      | 100           | 0          | °C     |
			| Desolvation Temperature | 20            | 0          | °C     |
			| Cone Gas                | 50            | 0          | L/hour |
			| Desolvation Gas         | 300           | 0          | L/hour |

		Examples:
			| Test Name            | Polarity | Mode        |
			| Negative_Resolution  | Negative | Resolution  |
			| Negative_Sensitivity | Negative | Sensitivity |

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario: ESCI-05 - ESCI parameters range
	When the browser is opened on the Tune page
		And the 'ESCI' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		| Parameter               | Min  | Max  | Resolution |
		| Capillary               | 0.00 | 5.00 | 0.01       |
		| LockSpray Capillary     | 0.00 | 5.00 | 0.01       |
		| Corona Current          | 0    | 35   | 1          |
		| Corona Voltage          | 0.00 | 5.00 | 0.01       |
		| Cone                    | 0    | 150  | 1          |
		| Source Temperature      | 20   | 150  | 1          |
		| Desolvation Temperature | 20   | 650  | 1          |
		| Cone Gas                | 0    | 300  | 1          |
		| Desolvation Gas         | 300  | 1200 | 1          |

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario Outline: ESCI-06 - Load factory defaults ESCI parameters - Positive
	Given the browser is opened on the Tune page
		And the 'APCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| Capillary               | 1.18  |
		| LockSpray Capillary     | 3.50  |
		| Corona Current          | 13    |
		| Corona Voltage          | 4.25  |
		| Cone                    | 58    |
		| Source Temperature      | 124   |
		| Desolvation Temperature | 472   |
		| Cone Gas                | 120   |
		| Desolvation Gas         | 985   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter               | Default Value |
		| Capillary               | 3.00          |
		| LockSpray Capillary     | 3.00          |
		| Corona Current          | 3             |
		| Corona Voltage          | 2.00          |
		| Cone                    | 40            |
		| Source Temperature      | 100           |
		| Desolvation Temperature | 20            |
		| Cone Gas                | 50            |
		| Desolvation Gas         | 300           |

	Examples:
		| Test Name           | Polarity | Mode |
		| Positive_Resolution | Positive | Resolution    |
		| Positive_Sensitivity| Positive | Sensitivity   |


Scenario Outline: ESCI-07 - Load factory defaults ESCI parameters - Negative
	Given the browser is opened on the Tune page
		And the 'APCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| Capillary               | 4.26  |
		| LockSpray Capillary     | 3.80  |
		| Corona Current          | 13    |
		| Corona Voltage          | 4.25  |
		| Cone                    | 58    |
		| Source Temperature      | 124   |
		| Desolvation Temperature | 472   |
		| Cone Gas                | 120   |
		| Desolvation Gas         | 985   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter               | Default Value |
		| Capillary               | 2.50          |
		| LockSpray Capillary     | 2.50          |
		| Corona Current          | 3             |
		| Corona Voltage          | 2.00          |
		| Cone                    | 40            |
		| Source Temperature      | 100           |
		| Desolvation Temperature | 20            |
		| Cone Gas                | 50            |
		| Desolvation Gas         | 300           |

	Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: ESCI-08 - Save and Load factory defaults ESCI parameters
	Given the browser is opened on the Tune page
		And the 'ESCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| Capillary               | 4.26  |
		| LockSpray Capillary     | 3.80  |
		| Corona Current          | 13    |
		| Corona Voltage          | 4.25  |
		| Cone                    | 58    |
		| Source Temperature      | 124   |
		| Desolvation Temperature | 472   |
		| Cone Gas                | 120   |
		| Desolvation Gas         | 985   |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter               | Value |
		| Capillary               | 2.80  |
		| LockSpray Capillary     | 2.95  |
		| Corona Current          | 7     |
		| Corona Voltage          | 3.25  |
		| Cone                    | 70    |
		| Source Temperature      | 150   |
		| Desolvation Temperature | 420   |
		| Cone Gas                | 136   |
		| Desolvation Gas         | 785   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter               | Default Value |
		| Capillary               | 4.26          |
		| LockSpray Capillary     | 3.80          |
		| Corona Current          | 13            |
		| Corona Voltage          | 4.25          |
		| Cone                    | 58            |
		| Source Temperature      | 124           |
		| Desolvation Temperature | 472           |
		| Cone Gas                | 120           |
		| Desolvation Gas         | 985           |

	Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: ESCI-09 - Save and Load ESCI parameters
	Given the browser is opened on the Tune page
		And the 'ESCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| Capillary               | 1.18  |
		| LockSpray Capillary     | 2.38  |
		| Corona Current          | 12    |
		| Corona Voltage          | 4.35  |
		| Cone                    | 56    |
		| Source Temperature      | 119   |
		| Desolvation Temperature | 476   |
		| Cone Gas                | 128   |
		| Desolvation Gas         | 918   |
		And a 'Save Set' is performed 
	When I enter different values for the following parameters
		| Parameter               | Value |
		| Capillary               | 2.84  |
		| LockSpray Capillary     | 2.98  |
		| Corona Current          | 8     |
		| Corona Voltage          | 3.30  |
		| Cone                    | 71    |
		| Source Temperature      | 151   |
		| Desolvation Temperature | 421   |
		| Cone Gas                | 138   |
		| Desolvation Gas         | 790   |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter               | Value |
		| Capillary               | 1.18  |
		| LockSpray Capillary     | 2.38  |
		| Corona Current          | 12    |
		| Corona Voltage          | 4.35  |
		| Cone                    | 56    |
		| Source Temperature      | 119   |
		| Desolvation Temperature | 476   |
		| Cone Gas                | 128   |
		| Desolvation Gas         | 918   |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |

# ---------------------------------------------------------------------------------------------------------------------------------------------------
		

Scenario Outline: ESCI-10 - ESCI readbacks - Positive polarity
	Given the browser is opened on the Tune page
		And the 'ESCI' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
			| Parameter               | Default Value | New Value |
			| Capillary               | 3.00          | 1.18      |
			| LockSpray Capillary     | 3.00          | 3.75      |
			| Corona Current          | 3             | 13        |
			| Corona Voltage          | 2.00          | 4.25      |
			| Cone                    | 40            | 58        |
			| Source Temperature      | 100           | 124       |
			| Desolvation Temperature | 20            | 60        |
			| Cone Gas                | 50            | 120       |
			| Desolvation Gas         | 300           | 600       |
			
		Examples:
		| Test Name           | Polarity | Mode        |
		| Positive_Resolution | Positive | Resolution  |
		| Positive_Sensitivity| Positive | Sensitivity |


Scenario Outline: ESCI-11 - ESCI readbacks - Negative
	Given the browser is opened on the Tune page
		And the 'ESCI' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
			| Parameter               | Default Value | New Value |
			| Capillary               | 2.50          | 4.26      |
			| LockSpray Capillary     | 2.50          | 1.20      |
			| Corona Current          | 3             | 10        |
			| Corona Voltage          | 2.00          | 4.25      |
			| Cone                    | 40            | 80        |
			| Source Temperature      | 100           | 150       |
			| Desolvation Temperature | 20            | 300       |
			| Cone Gas                | 50            | 120       |
			| Desolvation Gas         | 300           | 550       |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Negative_Resolution | Negative | Resolution  |
		| Negative_Sensitivity| Negative | Sensitivity |
			
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
