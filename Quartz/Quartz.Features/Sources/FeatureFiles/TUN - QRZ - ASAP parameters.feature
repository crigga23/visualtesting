# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - ASAP source parameters
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
@ignore
@Obsolete
@cleanup_SourceSwitching
Feature: ASAP source parameters
	In order to use an ASAP source on the instrument
	I want to be able to see ASAP source specific parameters with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument


# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given ASAP source is attached to the instrument
		And factory defaults have been loaded

# ---------------------------------------------------------------------------------------------------------------------------------------------------

@CR_Corona_Voltage_readback_named_incorrectly
@CR_Sample_Cone_field_not_displayed
Scenario: ASAP-01 - Parameters availability
	When the browser is opened on the Tune page
		And the 'ASAP1' tab is selected
	Then the following 'ASAP' source parameters and readbacks are available
		| Source | Parameter               | Readback |
		| ASAP1   | LockSpray Capillary     | Yes      |
		| ASAP1   | Corona mode             | No       |
		| ASAP1   | Corona Current          | Yes      |
		| ASAP1   | Corona Voltage          | Yes      |
		| ASAP1   | Cone                    | Yes      |
		| ASAP1   | Source Temperature      | Yes      |
		| ASAP1   | Desolvation Temperature | Yes      |
		| ASAP1   | Cone Gas                | Yes      |
		| ASAP1   | Desolvation Gas         | Yes      |
		And only these '8' parameters are displayed on the 'ASAP1' tab


Scenario: ASAP-02 - Parameters availability - Corona mode
	When the browser is opened on the Tune page
		And the 'ASAP1' tab is selected
	Then the Corona mode parameter is available with following dropdown options
		| Corona mode |
		| Current     |
		| Voltage     |
		And the default Corona Mode option is 'Current'


@CR_Default_values_incorrect
@CR_Corona_Voltage_is_not_editable
@ignore
@FunctionalityIncomplete
Scenario Outline: ASAP-03 - ASAP default parameters - Positive
	When the browser is opened on the Tune page
		And the 'ASAP1' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter               | Default Value | Resolution | UOM    |
			| LockSpray Capillary     | 3.00          | 0.01       | kV     |
			| Corona Current          | 3             | 1          | µA     |
			| Corona Voltage          | 2.00          | 0.01       | kV     |
			| Cone                    | 40            | 1          | V      |
			| Source Temperature      | 100           | 1          | °C     |
			| Desolvation Temperature | 250           | 1          | °C     |
			| Cone Gas                | 50            | 1          | L/hour |
			| Desolvation Gas         | 600           | 1          | L/hour |

			Examples:
			| Test Name            | Polarity | Mode        |
			| Positive_Resolution  | Positive | Resolution  |
			| Positive_Sensitivity | Positive | Sensitivity |

			
@CR_Default_values_incorrect
@CR_Corona_Voltage_is_not_editable
@ignore
@FunctionalityIncomplete
Scenario Outline: ASAP-04 - ASAP default parameters - Negative
	When the browser is opened on the Tune page
		And the 'ASAP1' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
			| Parameter               | Default Value | Resolution | UOM    |
			| LockSpray Capillary     | 2.50          | 0.01       | kV     |
			| Corona Current          | 3             | 1          | µA     |
			| Corona Voltage          | 2.00          | 0.01       | kV     |
			| Cone                    | 40            | 1          | V      |
			| Source Temperature      | 100           | 1          | °C     |
			| Desolvation Temperature | 250           | 1          | °C     |
			| Cone Gas                | 50            | 1          | L/hour |
			| Desolvation Gas         | 600           | 1          | L/hour |

			Examples:
			| Test Name            | Polarity | Mode        |
			| Negative_Resolution  | Negative | Resolution  |
			| Negative_Sensitivity | Negative | Sensitivity |

@CR_Sample_Cone_field_not_displayed
@CR_Corona_Current_max_is_incorrect
@CR_Corona_Voltage_is_not_editable	
Scenario: ASAP-05 - ASAP parameters ranges
	When the browser is opened on the Tune page
		And the 'ASAP1' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		| Parameter               | Min  | Max  | Resolution |
		| LockSpray Capillary     | 0.00 | 5.00 | 0.01       |
		| Corona Current          | 0    | 35   | 1          |
		| Corona Voltage          | 0    | 5.00 | 0.01       |
		| Cone                    | 0    | 150  | 1          |
		| Source Temperature      | 20   | 150  | 1          |
		| Desolvation Temperature | 20   | 650  | 1          |
		| Cone Gas                | 0    | 300  | 1          |
		| Desolvation Gas         | 300  | 1200 | 1          |
	

@CR_Corona_Current_max_is_incorrect
@CR_Corona_Voltage_not_editable
@CR_Sample_Cone_field_is_not_displayed
Scenario Outline: ASAP-06 - ASAP readbacks - Positive
	Given the browser is opened on the Tune page
		And the 'ASAP1' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
			| Parameter               | Default Value | New Value |
			| LockSpray Capillary     | 3.00          | 3.75      |
			| Corona Current          | 3             | 13        |
			| Corona Voltage          | 2.00          | 4.25      |
			| Cone                    | 40            | 58        |
			| Source Temperature      | 100           | 124       |
			| Desolvation Temperature | 250           | 320       |
			| Cone Gas                | 50            | 120       |
			| Desolvation Gas         | 600           | 885       |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Positive_Resolution | Positive | Resolution  |
		| Positive_Sensitivity| Positive | Sensitivity |


@CR_Corona_Current_max_is_incorrect
@CR_Corona_Voltage_not_editable
@CR_Sample_Cone_field_is_not_displayed
Scenario Outline: ASAP-07 - ASAP readbacks - Negative
	Given the browser is opened on the Tune page
		And the 'ASAP1' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
			| Parameter               | Default Value | New Value |
			| LockSpray Capillary     | 2.50          | 1.20      |
			| Corona Current          | 3             | 6         |
			| Corona Voltage          | 2.00          | 1.75      |
			| Cone                    | 40            | 52        |
			| Source Temperature      | 100           | 118       |
			| Desolvation Temperature | 250           | 170       |
			| Cone Gas                | 50            | 45        |
			| Desolvation Gas         | 600           | 425       |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Negative_Resolution | Negative | Resolution  |
		| Negative_Sensitivity| Negative | Sensitivity |

@CR_Corona_Voltage_is_not_editable
Scenario Outline: ASAP-08 - Load factory defaults ASAP parameters - Positive
	Given the browser is opened on the Tune page
		And the 'ASAP1' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 3.50  |
		| Corona Current          | 5     |
		| Corona Voltage          | 3.33  |
		| Cone                    | 55    |
		| Source Temperature      | 111   |
		| Desolvation Temperature | 472   |
		| Cone Gas                | 66    |
		| Desolvation Gas         | 985   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter               | Default Value |
		| LockSpray Capillary     | 3.00          |
		| Corona Current          | 3             |
		| Corona Voltage          | 2.00          |
		| Cone                    | 40            |
		| Source Temperature      | 100           |
		| Desolvation Temperature | 250           |
		| Cone Gas                | 50            |
		| Desolvation Gas         | 600           | 

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
	

@CR_Corona_Voltage_is_not_editable
Scenario Outline: ASAP-09 - Load factory defaults ASAP parameters - Negative
	Given the browser is opened on the Tune page
		And the 'ASAP1' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 3.50  |
		| Corona Current          | 5     |
		| Corona Voltage          | 3.33  |
		| Cone                    | 55    |
		| Source Temperature      | 111   |
		| Desolvation Temperature | 472   |
		| Cone Gas                | 66    |
		| Desolvation Gas         | 985   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter               | Default Value |
		| LockSpray Capillary     | 2.50          |
		| Corona Current          | 3             |
		| Corona Voltage          | 2.00          |
		| Cone                    | 40            |
		| Source Temperature      | 100           |
		| Desolvation Temperature | 250           |
		| Cone Gas                | 50            |
		| Desolvation Gas         | 600           | 

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


@CR_Corona_Current_max_is_incorrect
@CR_Corona_Voltage_is_not_editable
Scenario Outline: ASAP-10 - Save and Load factory defaults ASAP parameters
	Given the browser is opened on the Tune page
		And the 'ASAP1' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 4.30  |
		| Corona Current      | 13    |
		| Corona Voltage      | 4.25  |
		| Cone                | 58    |
		| Source Temperature  | 124   |
		| Cone Gas            | 120   |
		| Desolvation Gas     | 985   |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter          | Value |
		| LockSpray Capillary | 2.30  |
		| Corona Current     | 10    |
		| Corona Voltage     | 5.25  |
		| Cone               | 50    |
		| Source Temperature | 120   |
		| Cone Gas           | 60    |
		| Desolvation Gas    | 350   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter           | Default Value |
		| LockSpray Capillary | 4.30          |
		| Corona Current      | 13            |
		| Corona Voltage      | 4.250         |
		| Cone                | 58            |
		| Source Temperature  | 124           |
		| Cone Gas            | 120           |
		| Desolvation Gas     | 985           |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


@CR_Sample_Cone_field_is_not_displayed
Scenario Outline: ASAP-11 - Save and Load ASAP parameters
	Given the browser is opened on the Tune page
		And the 'ASAP1' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 4.00  |
		| Corona Current           | 5     |
		| Corona Voltage          | 3.33  |
		| Cone                    | 55    |
		| Source Temperature      | 111   |
		| Desolvation Temperature | 472   |
		| Cone Gas                | 66    |
		| Desolvation Gas         | 985   |
		And a 'Save Set' is performed 
	When I enter different values for the following parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 4.80  |
		| Corona Current           | 5.5   |
		| Corona Voltage          | 4.50  |
		| Cone                    | 70    |
		| Source Temperature      | 140   |
		| Desolvation Temperature | 520   |
		| Cone Gas                | 80    |
		| Desolvation Gas         | 700   |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 4.00  |
		| Corona Curent           | 5     |
		| Corona Voltage          | 3.33  |
		| Cone                    | 55    |
		| Source Temperature      | 111   |
		| Desolvation Temperature | 472   |
		| Cone Gas                | 66    |
		| Desolvation Gas         | 985   |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensivitity | Negative | Sensitivity |
		| Negative_Resolution  | Negative | Resolution  |
		
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END