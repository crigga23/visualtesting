# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - APCI source parameters
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
@Obsolete
@ManualTune
@Sources
@cleanup_SourceSwitching
@ignore
Feature: APCI source parameters
	In order to use an APCI source on the instrument
	I want to be able to see APCI source specific parametere with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given APCI source is attached to the instrument
		And factory defaults have been loaded		

# ---------------------------------------------------------------------------------------------------------------------------------------------------


Scenario: APCI-01 - APCI parameters availability
	When the browser is opened on the Tune page
		And the 'APCI' tab is selected
	Then the following 'APCI' source parameters and readbacks are available
		| Source           | Parameter                | Readback |
		| APCI   | Corona mode              | No       |
		| APCI   | Corona Current (µA)      | Yes      |
		| APCI   | Corona Voltage (kV)      | Yes      | 
		| APCI   | Sampling Cone (V)        | No       |
		| APCI   | Source Temperature (°C)  | Yes      |
		| APCI   | Probe Temperature (°C)   | Yes      |
		| APCI   | Cone Gas (L/hour)        | Yes      |
		| APCI   | Desolvation Gas (L/hour) | Yes      |
	And only these '8' parameters are displayed on the 'APCI' tab

@Defect
@CR_FW4708
Scenario: APCI-02 - APCI parameters availability - Corona mode
	When the browser is opened on the Tune page
		And the 'APCI' tab is selected
	Then the Corona mode parameter is available with following dropdown options
			| Corona mode |
			| Current     |
			| Voltage     |
		And the default Corona Mode option is 'Current'

@Defect
@CR_Default_values_are_incorrect
Scenario Outline: APCI-03 - APCI default parameters - Positive
	When the browser is opened on the Tune page
		And the 'APCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter                | Default Value | Resolution | UOM    |
			| Corona Current (µA)      | 3             | 1          | µA     |
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

@Defect
@CR_Default_values_are_incorrect
Scenario Outline: APCI-04 - APCI default parameters - Negative
	When the browser is opened on the Tune page
		And the 'APCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter                | Default Value | Resolution | UOM    |
			| Corona Current (µA)      | 3             | 1          | µA     |
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


Scenario: APCI-05 - APCI parameters range
	When the browser is opened on the Tune page
		And the 'APCI' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		| Parameter                | Min  | Max  | Resolution |
		| Corona Current (µA)      | 0    | 35   | 1          |
		| Corona Voltage (kV)      | 0.00 | 5.00 | 0.01       |
		| Sampling Cone (V)        | 0    | 200  | 1          |
		| Source Temperature (°C)  | 20   | 150  | 1          |
		| Probe Temperature (°C)   | 20   | 650  | 1          |
		| Cone Gas (L/hour)        | 0    | 300  | 1          |
		| Desolvation Gas (L/hour) | 300  | 1200 | 1          |

@Defect
@CR_Default_Values_Incorrect
Scenario Outline: APCI-06 - Load factory defaults APCI parameters - Positive
	Given the browser is opened on the Tune page
		And the 'APCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
			| Parameter                | Value |
			| Corona Current (µA)      | 13    |
			| Corona Voltage (kV)      | 4.25  |
			| Sampling Cone (V)        | 58    |
			| Source Temperature (°C)  | 124   |
			| Probe Temperature (°C)   | 472   |
			| Cone Gas (L/hour)        | 120   |
			| Desolvation Gas (L/hour) | 985   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                | Default Value |
		| Corona Current (µA)      | 3             |
		| Corona Voltage (kV)      | 2.00          |
		| Sampling Cone (V)        | 40            |
		| Source Temperature (°C)  | 100           |
		| Probe Temperature (°C)   | 20            |
		| Cone Gas (L/hour)        | 50            |
		| Desolvation Gas (L/hour) | 300           |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |

@Defect
@CR_Default_Values_Incorrect
Scenario Outline: APCI-07 - Load factory defaults APCI parameters - Negative
	Given the browser is opened on the Tune page
		And the 'APCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
			| Parameter                | Value |
			| Corona Current (µA)      | 13    |
			| Corona Voltage (kV)      | 4.25  |
			| Sampling Cone (V)        | 58    |
			| Source Temperature (°C)  | 124   |
			| Probe Temperature (°C)   | 472   |
			| Cone Gas (L/hour)        | 120   |
			| Desolvation Gas (L/hour) | 985   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                | Default Value |
		| Corona Current (µA)      | 3             |
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


Scenario Outline: APCI-08 - Save and Load factory defaults APCI parameters
	Given the browser is opened on the Tune page
		And the 'APCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                | Value |
		| Corona Current (µA)      | 13    |
		| Corona Voltage (kV)      | 4.25  |
		| Sampling Cone (V)        | 58    |
		| Source Temperature (°C)  | 124   |
		| Probe Temperature (°C)   | 472   |
		| Cone Gas (L/hour)        | 120   |
		| Desolvation Gas (L/hour) | 985   |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter                | Value |
		| Corona Current (µA)      | 10    |
		| Corona Voltage (kV)      | 2.25  |
		| Sampling Cone (V)        | 50    |
		| Source Temperature (°C)  | 120   |
		| Probe Temperature (°C)   | 40    |
		| Cone Gas (L/hour)        | 60    |
		| Desolvation Gas (L/hour) | 350   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter                | Default Value |
		| Corona Current (µA)      | 13            |
		| Corona Voltage (kV)      | 4.25          |
		| Sampling Cone (V)        | 58            |
		| Source Temperature (°C)  | 124           |
		| Probe Temperature (°C)   | 472           |
		| Cone Gas (L/hour)        | 120           |
		| Desolvation Gas (L/hour) | 985           |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: APCI-09 - Save and Load APCI parameters
	Given the browser is opened on the Tune page
		And the 'APCI' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter                | Value |
		| Corona Current (µA)      | 13    |
		| Corona Voltage (kV)      | 4.25  |
		| Sampling Cone (V)        | 58    |
		| Source Temperature (°C)  | 124   |
		| Probe Temperature (°C)   | 472   |
		| Cone Gas (L/hour)        | 120   |
		| Desolvation Gas (L/hour) | 985   |
		And a 'Save Set' is performed 
	When I enter different values for the following parameters
		| Parameter                | Value |
		| Corona Current (µA)      | 10    |
		| Corona Voltage (kV)      | 3.25  |
		| Sampling Cone (V)        | 35    |
		| Source Temperature (°C)  | 110   |
		| Probe Temperature (°C)   | 30    |
		| Cone Gas (L/hour)        | 70    |
		| Desolvation Gas (L/hour) | 350   |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter                | Value |
		| Corona Current (µA)      | 13    |
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



Scenario Outline: APCI-10 - APCI readbacks - Positive
	Given the browser is opened on the Tune page
		And the 'APCI' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter                | Default Value | New Value |
		| Corona Current (µA)      | 3             | 13        |
		| Corona Voltage (kV)      | 2.00          | 4.25      |
		| Source Temperature (°C)  | 100           | 145       |
		| Probe Temperature (°C)   | 20            | 90        |
		| Cone Gas (L/hour)        | 50            | 10        |
		| Desolvation Gas (L/hour) | 300           | 425       |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Positive_Resolution | Positive | Resolution  |
		| Positive_Sensitivity| Positive | Sensitivity |


Scenario Outline: APCI-11 - APCI readbacks - Negative
	Given the browser is opened on the Tune page
		And the 'APCI' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter                | Default Value | New Value |
		| Corona Current (µA)      | 3             | 20        |
		| Corona Voltage (kV)      | 2.00          | 1.25      |
		| Source Temperature (°C)  | 100           | 50        |
		| Probe Temperature (°C)   | 20            | 150       |
		| Cone Gas (L/hour)        | 50            | 150       |
		| Desolvation Gas (L/hour) | 300           | 500       |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Negative_Resolution | Negative | Resolution  |
		| Negative_Sensitivity| Negative | Sensitivity |
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
