# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Instrument tab parameters
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Dragos Marian
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 23.Iun.2015
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Parameters are on Manual tuning page - source tab
#                          # Quartz is available and logged in
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Latest version of Osprey Default Document 721006299
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-971)                 # The user will be able to switch the instrument polarity
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-972)                 # The user will be able to switch the instrument analyser resolution mode.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-973)                 # The user will be able set all of the instrument parameters related to the current instrument source configuration and current instrument modes.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-976)                 # The user will be able set the collision energy instrument parameter related to the current instrument mode of MS and MSMS.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-978)                 # The user will be able to control the instruments quad resolution (m/z) and Quad resolution (CCS) parameters.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@ignore
Feature: In order to tune the instrument
I want to be able to see parameters with readbacks for settings that are not specific to the source
And to be able to modify them

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background: Given factory defaults have been loaded

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Scenario: TUN-QRZ-01 - Instrument tab available parameters
	Given The browser is open on tune page
	When the 'Instrument' tab is selected 
	Then the following 'Instrument' parameters and readbacks are available
	| Parameter              | Readback |
	| Collision Energy(V)    | No       |
	| Ion Guide Gradient (V) | Yes      |
	| Aperture 2 (V)         | Yes      |
	| LM Resolution (low)    | No       |
	| HM Resolution (high)   | No       |
	| Pre-filter (V)         | Yes      |
	| Ion Energy (V)         | No       |
	| Detector Voltage(V)    | Yes      |
	And only these '8' parameters are displayed on the 'Instrument' tab

Scenario Outline: TUN-QRZ-02 Instrument tab default parameters positive
	When the browser is opened on the Tune page
		And the 'Instrument' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter              | Default Value | Resolution | UOM    |
		| Collision Energy(V)    | 6.0           | 0.1        | V      |
		| Ion Guide Gradient (V) | 0.5           | 0.1        | V      |
		| Aperture 2 (V)         | 2.0           | 0.1        | V      |
		| LM Resolution (low)    | 4.7           | 0.1        | low    |
		| HM Resolution (high)   | 15.0          | 0.1        | high   |
		| Pre-filter (V)         | 2.0           | 0.1        | L/hour |
		| Ion Energy (V)         | 1.0           | 0.1        | V      |
		| Detector Voltage(V)    | 2200          | 1          | V      |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Positive_Resolution  | Positive | Resolution  |

Scenario Outline: TUN-QRZ-03 - Instrument tab default parameters negative
	Given the browser is opened on the Tune page
		And the 'Instrument' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter              | Default Value | Resolution | UOM    |
		| Collision Energy(V)    | 4.0           | 0.1        | V      |
		| Ion Guide Gradient (V) | 0.5           | 0.1        | V      |
		| Aperture 2 (V)         | 2.0           | 0.1        | V      |
		| LM Resolution (low)    | 4.7           | 0.1        | low    |
		| HM Resolution (high)   | 15.0          | 0.1        | high   |
		| Pre-filter (V)         | 10.0          | 0.1        | L/hour |
		| Ion Energy (V)         | 1.0           | 0.1        | V      |
		| Detector Voltage(V)    | 2400          | 1          | V      |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Sensitivity | Negative | Sensitivity |
		| Negative_Resolution  | Negative | Resolution  |

Scenario: TUN-QRZ-04 - Instrument tab parameters ranges
	When the browser is opened on the Tune page
		And the 'Instrument' tab is selected
	Then values outside the Min or Max cannot be entered for the following parameters
		| Parameter              | Min | Max  |
		| Collision Energy(V)    | 0   | 200  |
		| Ion Guide Gradient (V) | 0   | 10   |
		| Aperture 2 (V)         | 0   | 10   |
		| LM Resolution (low)    | 0   | 25   |
		| HM Resolution (high)   | 0   | 25   |
		| Pre-filter (V)         | 0   | 20   |
		| Ion Energy (V)         | -5  | 5    |
		| Detector Voltage(V)    | 0   | 5000 |

Scenario Outline: TUN-QRZ-05 - Instrument tab readbacks - Positive
	Given the browser is opened on the Tune page
		And the 'Instrument' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter              | Default Value | New Value |
		| Ion Guide Gradient (V) | 0.5           | 4.5       |
		| Aperture 2 (V)         | 2.0           | 4         |
		| Pre-filter (V)         | 2.0           | 5         |
		| Detector Voltage(V)    | 2200          | 3300      |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Resolution  | Positive | Resolution  |
		| Positive_Sensitivity | Positive | Sensitivity |
		

Scenario Outline: TUN-QRZ-06 - Instrument readbacks - Negative
	Given the browser is opened on the Tune page	
		And the 'Instrument' tab is selected	
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter              | Default Value | New Value |
		| Ion Guide Gradient (V) | 0.5           | 2         |
		| Aperture 2 (V)         | 2.0           | 6         |
		| Pre-filter (V)         | 10.0          | 7         |
		| Detector Voltage(V)    | 2500          | 1700      |
		
		Examples:
		| Test Name            | Polarity | Mode        |
		| Negative_Resolution  | Negative | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# End
