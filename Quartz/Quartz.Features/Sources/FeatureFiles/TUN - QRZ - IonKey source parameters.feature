# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - IonKey source parameters
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
@Obsolete
@ignore
@cleanup_SourceSwitching
Feature: IonKey source parameters
	In order to use an IonKey source on the instrument
	I want to be able to see IonKey source specific parametere with readbacks for settings
	And to be able to modify, save and load the settings
	And apply the setting to the instrument


# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given IonKey source is attached to the instrument
		And factory defaults have been loaded	

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario: ION-01 - Parameters availability
	When the browser is opened on the Tune page
		And the 'IonKey' tab is selected
	Then the following 'IonKey' source parameters and readbacks are available
		| Source | Parameter           | Readback |
		| IonKey | LockSpray Capillary | Yes      |
		| IonKey | Capillary           | Yes      |
		| IonKey | Cone                | Yes      |
		| IonKey | Source Temperature  | Yes      |
		| IonKey | Cone Gas            | Yes      |
		| IonKey | Purge Gas           | Yes      |
		| IonKey | Nano Flow Gas       | Yes      |
		| IonKey | Trap Cooling Gas    | Yes      |	
		And only these '7' parameters are displayed on the 'IonKey' tab


#TODO - UOM
@FunctionalityIncomplete
Scenario Outline: ION-02 - IonKey default parameters - Positive
	When the browser is opened on the Tune page
		And the 'IonKey' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter           | Default Value | Resolution | UOM    |
		| Lockspray Capillary | 3.00          | 0.01       | kV     |
		| Capillary           | 3.00          | 0.01       | kV     |
		| Cone                | 40            | 1          | V      |
		| Source Temperature  | 100           | 1          | °C     |
		| Cone Gas            | 50            | 1          | L/hour |
		| Purge Gas           | 350           | 1          | L/hour |
		| Nano Flow Gas       | 0.30          | 0.01       | bar    |
		| Trap Cooling Gas    | 0             | 1          | L/hour |
		
		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |


#TODO - UOM		
@FunctionalityIncomplete
Scenario Outline: ION-03 - IonKey default parameters - Negative
	When the browser is opened on the Tune page
		And the 'IonKey' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter           | Default Value | Resolution | UOM    |
		| LockSpray Capillary | 2.50          | 0.01       | kV     |
		| Capillary           | 2.50          | 0.01       | kV     |
		| Cone                | 40            | 1          | V      |
		| Source Temperature  | 100           | 1          | °C     |
		| Cone Gas            | 50            | 1          | L/hour |
		| Purge Gas           | 350           | 1          | L/hour |
		| Nano Flow Gas       | 0.30          | 0.01       | bar    |
		| Trap Cooling Gas    | 0             | 1          | L/hour |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |

	
Scenario: ION-04 - IonKey parameters ranges
	When the browser is opened on the Tune page
		And the 'IonKey' tab is selected
	Then Source values outside the Min or Max cannot be entered for the following parameters
		| Parameter           | Min | Max  | Resolution |
		| LockSpray Capillary | 0   | 5    | 0.01       |
		| Capillary           | 0   | 5    | 0.01       |
		| Cone                | 0   | 150  | 1          |
		| Source Temperature  | 20  | 150  | 1          |
		| Cone Gas            | 0   | 300  | 1          |
		| Purge Gas           | 0   | 800  | 1          |
		| Nano Flow Gas       | 0   | 2    | 0.01       |
		| Trap Cooling Gas    | 0   | 1200 | 1          |
		


Scenario Outline: ION-05 - IonKey readbacks - Positive
	Given the browser is opened on the Tune page
		And the 'IonKey' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter           | Default Value | New Value |
		| LockSpray Capillary | 3.00          | 2.70      |
		| Capillary           | 3.00          | 2.30      |
		| Cone                | 40            | 55        |
		| Source Temperature  | 100           | 111       |
		| Cone Gas            | 50            | 66        |
		| Purge Gas           | 800           | 950       |
		| Nano Flow Gas       | 0.30          | 0.75      |
		| Trap Cooling Gas    | 0             | 120       |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Positive_Resolution | Positive | Resolution  |
		| Positive_Sensitivity| Positive | Sensitivity |
		

Scenario Outline: ION-06 - IonKey readbacks - Negative
	Given the browser is opened on the Tune page
		And the 'IonKey' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter           | Default Value | New Value |
		| LockSpray Capillary | 3.50          | 2.20      |
		| Capillary           | 2.5           | 1.5       |
		| Cone                | 40            | 80        |
		| Source Temperature  | 100           | 160       |
		| Cone Gas            | 50            | 90        |
		| Purge Gas           | 800           | 999       |
		| Nano Flow Gas       | 0.30          | 1.60      |
		| Trap Cooling Gas    | 0             | 500       |

		Examples:
		| Test Name           | Polarity | Mode        |
		| Negative_Resolution | Negative | Resolution  |
		| Negative_Sensitivity| Negative | Sensitivity |


Scenario Outline: ION-07 - Load factory defaults IonKey parameters - Positive
	Given the browser is opened on the Tune page
		And the 'IonKey' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 2.30  |
		| Capillary           | 2.30  |
		| Cone                | 55    |
		| Source Temperature  | 111   |
		| Cone Gas            | 66    |
		| Purge Gas           | 999   |
		| Nano Flow Gas       | 0.75  |
		| Trap Cooling Gas    | 10    |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters			
		| Parameter           | Default Value |
		| LockSpray Capillary | 3.00          |
		| Capillary           | 3.00          |
		| Cone                | 40            |
		| Source Temperature  | 100           |
		| Cone Gas            | 50            |
		| Purge Gas           | 800           |
		| Nano Flow Gas       | 0.30          |
		| Trap Cooling Gas    | 0             |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		
	
Scenario Outline: ION-08 - Load factory defaults IonKey parameters - Negative
	Given the browser is opened on the Tune page
		And the 'IonKey' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 1.50  |
		| Capillary           | 1.60  |
		| Cone                | 25    |
		| Source Temperature  | 150   |
		| Cone Gas            | 96    |
		| Purge Gas           | 888   |
		| Nano Flow Gas       | 1.75  |
		| Trap Cooling Gas    | 100   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters			
		| Parameter           | Default Value |
		| LockSpray Capillary | 2.50          |
		| Capillary           | 2.50          |
		| Cone                | 40            |
		| Source Temperature  | 100           |
		| Cone Gas            | 50            |
		| Purge Gas           | 800           |
		| Nano Flow Gas       | 0.30          |
		| Trap Cooling Gas    | 0             |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


Scenario Outline: ION-09 - Save and Load factory defaults IonKey parameters
	Given the browser is opened on the Tune page
		And the 'IonKey' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 2.30  |
		| Capillary           | 2.30  |
		| Cone                | 55    |
		| Source Temperature  | 111   |
		| Cone Gas            | 66    |
		| Purge Gas           | 999   |
		| Nano Flow Gas       | 0.75  |
		| Trap Cooling Gas    | 10    |
		And Factory Defaults are 'Saved'
	When I enter different values for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 1.50  |
		| Capillary           | 1.60  |
		| Cone                | 25    |
		| Source Temperature  | 150   |
		| Cone Gas            | 96    |
		| Purge Gas           | 888   |
		| Nano Flow Gas       | 1.75  |
		| Trap Cooling Gas    | 100   |
		And Factory Defaults are 'Loaded'
	Then the following default values are loaded for the parameters
		| Parameter           | Default Value |
		| LockSpray Capillary | 2.30          |
		| Capillary           | 2.30          |
		| Cone                | 55            |
		| Source Temperature  | 111           |
		| Cone Gas            | 66            |
		| Purge Gas           | 999           |
		| Nano Flow Gas       | 0.75          |
		| Trap Cooling Gas    | 10            |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |



Scenario Outline: ION-10 - Save and Load IonKey parameters - Positive
	Given the browser is opened on the Tune page
		And the 'IonKey' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	When new values are entered for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 1.50  |
		| Capillary           | 1.60  |
		| Cone                | 25    |
		| Source Temperature  | 150   |
		| Cone Gas            | 96    |
		| Purge Gas           | 888   |
		| Nano Flow Gas       | 1.75  |
		| Trap Cooling Gas    | 100   |
		And a 'Save Set' is performed 
	When I enter different values for the following parameters
		| Parameter           | Value |
		| LockSpray Capillary | 2.30  |
		| Capillary           | 2.30  |
		| Cone                | 55    |
		| Source Temperature  | 111   |
		| Cone Gas            | 66    |
		| Purge Gas           | 999   |
		| Nano Flow Gas       | 0.75  |
		| Trap Cooling Gas    | 10    |
		And a 'Load Set' is performed
	Then the following values are loaded for the parameters
		| Parameter           | Value |
		| LockSpray Capillary | 1.50  |
		| Capillary           | 1.60  |
		| Cone                | 25    |
		| Source Temperature  | 150   |
		| Cone Gas            | 96    |
		| Purge Gas           | 888   |
		| Nano Flow Gas       | 1.75  |
		| Trap Cooling Gas    | 100   |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Resolution  | Negative | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Negative_Sensitivity | Negative | Sensitivity |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END