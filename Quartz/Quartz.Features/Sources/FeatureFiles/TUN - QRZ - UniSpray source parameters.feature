
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - UniSrpay source parameters
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
@cleanup_SourceSwitching
Feature: UniSpray source parameters
	In order to use an UniSpray source on the instrument
	I want to be able to see UniSpray source specific parametere with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument


# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given UNISPRAY source is attached to the instrument
		And factory defaults have been loaded

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario: UNI-01 - UniSpray parameters availability
	When the browser is opened on the Tune page
		And the 'UniSpray' tab is selected
	Then the following 'UniSpray' source parameters and readbacks are available
		| Source    | Parameter               | Readback |
		| UniSpray  | LockSpray Capillary     | Yes      |
		| UniSpray  | Impactor target         | Yes      |
		| UniSpray  | Cone                    | Yes      |
		| UniSpray  | Source Temperature      | Yes      |
		| UniSpray  | Desolvation Temperature | Yes      |
		| UniSpray  | Cone Gas                | Yes      |
		| UniSpray  | Desolvation Gas         | Yes      |
		And only these '6' parameters are displayed on the 'UniSpray' tab

# TODO - check UOM
@FunctionalityIncomplete
Scenario Outline: UNI-02 - UniSpray default parameters - Positive
	When the browser is opened on the Tune page
		And the 'UniSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter               | Default Value | Resolution | UOM    |
		| LockSpray Capillary     | 3.00          | 0.01       | kV     |
		| Impactor target         | 1.00          | 0.01       | kV     |
		| Cone                    | 40            | 1          | V      |
		| Source Temperature      | 100           | 1          | °C     |
		| Desolvation Temperature | 250           | 1          | °C     |
		| Cone Gas                | 50            | 1          | L/hour |
		| Desolvation Gas         | 600           | 1          | L/hour |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |

# TODO - check UOM
@FunctionalityIncomplete
Scenario Outline: UNI-03 - UniSpray default parameters - Negative
	When the browser is opened on the Tune page
		And the 'UniSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter               | Default Value | Resolution | UOM    |
		| LockSpray Capillary     | 2.50          | 0.01       | kV     |
		| Cone                    | 40            | 1          | V      |
		| Impactor target         | 1             | 0.01       | kV     |
		| Source Temperature      | 100           | 1          | °C     |
		| Desolvation Temperature | 250           | 1          | °C     |
		| Cone Gas                | 50            | 1          | L/hour |
		| Desolvation Gas         | 600           | 1          | L/hour |

		Examples:
			| Test Name            | Polarity | Mode        |
			| Negative_Resolution  | Negative | Resolution  |
			| Negative_Sensitivity | Negative | Sensitivity |



Scenario: UNI-04 - UniSpray parameters ranges
		When the browser is opened on the Tune page
		And the 'UniSpray' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		| Parameter               | Min  | Max  | Resolution |
		| LockSpray Capillary     | 0.00 | 5.00 | 0.01       |
		| Impactor target         | 0.00 | 4.00 | 0.01       |
		| Cone                    | 0    | 200  | 1          |
		| Source Temperature      | 20   | 150  | 1          |
		| Desolvation Temperature | 20   | 650  | 1          |
		| Cone Gas                | 0    | 300  | 1          |
		| Desolvation Gas         | 300  | 1200 | 1          |



Scenario Outline: UNI-05 - UniSpray readbacks - Positive
	Given the browser is opened on the Tune page
		And the 'UniSpray' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter               | Default Value | New Value |
		| LockSpray Capillary     | 3.00          | 3.75      |
		| Impactor target         | 1.00          | 1.70      |
		| Cone                    | 40            | 75        |
		| Source Temperature      | 100           | 131       |
		| Desolvation Temperature | 250           | 333       |
		| Cone Gas                | 50            | 66        |
		| Desolvation Gas         | 600           | 555       |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Positive_Resolution | Positive | Resolution  |
		| Positive_Sensitivity| Positive | Sensitivity |


Scenario Outline: UNI-06 - UniSpray readbacks - Negative
	Given the browser is opened on the Tune page
		And the 'UniSpray' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter               | Default Value | New Value |
		| LockSpray Capillary     | 2.50          | 1.75      |
		| Impactor target         | 1.00          | 2.70      |
		| Cone                    | 40            | 10        |
		| Source Temperature      | 100           | 80        |
		| Desolvation Temperature | 250           | 400       |
		| Cone Gas                | 50            | 90        |
		| Desolvation Gas         | 600           | 450       |

	Examples:
		| Test Name           | Polarity | Mode        |
		| Negative_Resolution | Negative | Resolution  |
		| Negative_Sensitivity| Negative | Sensitivity |



Scenario Outline: UNI-07 - Load factory defaults UniSpray parameters - Positive
	Given the browser is opened on the Tune page
		And the 'UniSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 3.50  |
		| Impactor target         | 1.70  |
		| Cone                    | 100   |
		| Source Temperature      | 111   |
		| Desolvation Temperature | 333   |
		| Cone Gas                | 66    |
		| Desolvation Gas         | 555   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter               | Default Value |
		| LockSpray Capillary     | 3.00          |
		| Impactor target         | 1.00          |
		| Cone                    | 40            |
		| Source Temperature      | 100           |
		| Desolvation Temperature | 250           |
		| Cone Gas                | 50            |
		| Desolvation Gas         | 600           | 

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |


Scenario Outline: UNI-08 - Load factory defaults UniSpray parameters - Negative
	Given the browser is opened on the Tune page
		And the 'UniSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 1.50  |
		| Impactor target         | 0.70  |
		| Cone                    | 150   |
		| Source Temperature      | 80    |
		| Desolvation Temperature | 150   |
		| Cone Gas                | 90    |
		| Desolvation Gas         | 700   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter               | Default Value |
		| LockSpray Capillary     | 2.50          |
		| Impactor target         | 1.00          |
		| Cone                    | 40            |
		| Source Temperature      | 100           |
		| Desolvation Temperature | 250           |
		| Cone Gas                | 50            |
		| Desolvation Gas         | 600           | 

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: UNI-09 - Save and Load factory defaults UniSpray parameters
	Given the browser is opened on the Tune page
		And the 'UniSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 3.50  |
		| Impactor target         | 1.70  |
		| Cone                    | 90    |
		| Source Temperature      | 111   |
		| Desolvation Temperature | 333   |
		| Cone Gas                | 66    |
		| Desolvation Gas         | 555   |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 1.50  |
		| Impactor target         | 0.70  |
		| Cone                    | 150   |
		| Source Temperature      | 80    |
		| Desolvation Temperature | 150   |
		| Cone Gas                | 90    |
		| Desolvation Gas         | 700   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter               | Default Value |
		| LockSpray Capillary     | 3.50          |
		| Impactor target         | 1.70          |
		| Cone                    | 90            |
		| Source Temperature      | 111           |
		| Desolvation Temperature | 333           |
		| Cone Gas                | 66            |
		| Desolvation Gas         | 555           |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |
			

Scenario Outline: UNI-10 - Save and Load UniSpray parameters
	Given the browser is opened on the Tune page
		And the 'UniSpray' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 3.58  |
		| Impactor target         | 1.78  |
		| Cone                    | 50    |
		| Source Temperature      | 115   |
		| Desolvation Temperature | 340   |
		| Cone Gas                | 70    |
		| Desolvation Gas         | 580   |
		And a 'Save Set' is performed 
	When I enter different values for the following parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 1.50  |
		| Impactor target         | 0.70  |
		| Cone                    | 90    |
		| Source Temperature      | 80    |
		| Desolvation Temperature | 150   |
		| Cone Gas                | 90    |
		| Desolvation Gas         | 700   |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter               | Value |
		| LockSpray Capillary     | 3.58  |
		| Impactor target         | 1.78  |
		| Cone                    | 50    |
		| Source Temperature      | 115   |
		| Desolvation Temperature | 340   |
		| Cone Gas                | 70    |
		| Desolvation Gas         | 580   |


		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |
		
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END