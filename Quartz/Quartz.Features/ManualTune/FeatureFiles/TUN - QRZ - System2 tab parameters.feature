# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - System2 Tab parameters
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Dragos Marian
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 25.Iun.2015
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Parameters are on Manual tuning page
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

Scenario: TUN-QRZ-01 - System2 tab available parameters
	Given The browser is open on tune page
	When the 'System2' tab is selected 
	Then the following System2 parameters and readbacks are available
	| Parameter                | Readback |
	| Collector (V)            | Yes      |
	| Collector Pulse (V)      | No       |
	| Stopper (V)              | Yes      |
	| Stopper Pulse (V)        | No       |
	| pDRE Attenuate           | No       |
	| pDRE Transmission (%)    | No       |
	| pDRE HD Attenuate        | No       |
	| pDRE HD Transmission (%) | No       |
	And only these '8' parameters are displayed on the 'System2' tab

Scenario Outline: TUN-QRZ-02 System2 tab default parameters 
	When the browser is opened on the Tune page
		And the 'System2' tab is selected
		And the mode is <Mode> and the polarity is <Polarity>
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter                | Default Value | Resolution | UOM |
		| Collector (V)            | 60            | 1          | V   |
		| Collector Pulse (V)      | 10.0          | 0.1        | V   |
		| Stopper (V)              | 10            | 1          | V   |
		| Stopper Pulse (V)        | 20.0          | 0.1        | V   |
		| pDRE Attenuate           | Off           | NA         | NA  |
		| pDRE Transmission (%)    | 99.8          | 0.1        | %   |
		| pDRE HD Attenuate        | Off           | NA         | NA  |
		| pDRE HD Transmission (%) | 100.0         | 0.1        | NA  |

		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |
		| Negative_Resolution  | Negative | Resolution  |

Scenario: TUN-QRZ-03 - System2 tab DRE settings on/off
	Given the browser is open on the tune page
		And the 'System2' tab is selected
	When 'pDRE Attenuate' and  'pDRE HD Attenuate' are set to 'State'
	Then 'pDRE Transmission (%)' and 'pDRE HD Transmission (%)' can be 'Editable'
		| State | Editable     |
		| Off   | Not editable |
		| On    | Editable     |
	
Scenario: TUN-QRZ-04 - System2 tab parameters ranges
	When the browser is opened on the Tune page
		And the 'System2' tab is selected
		And 'pDRE Attenuate' and  'pDRE HD Attenuate' are set to On
	Then values outside the Min or Max cannot be entered for the following parameters
		| Parameter                | Min | Max  |
		| Collector (V)            | 0   | 120  |
		| Collector Pulse (V)      | 0.0 | 20.0 |
		| Stopper (V)              | 0   | 120  |
		| Stopper Pulse (V)        | 0.0 | 20.0 |
		| pDRE Transmission (%)    | 0.1 | 99.9 |
		| pDRE HD Transmission (%) | 0.1 | 100  |

Scenario Outline: TUN-QRZ-05 - System2 tab readbacks 
	Given the browser is opened on the Tune page
		And the 'System2' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is <Mode> and the polarity is <Polarity>
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter                | Default Value | New Value |
		| Collector (V)            | 60            | 110       |
		| Stopper (V)              | 10            | 110       |
		
		Examples:
		| Test Name            | Polarity | Mode        |
		| Positive_Sensitivity | Positive | Sensitivity |
		| Positive_Resolution  | Positive | Resolution  |
		| Negative_Sensitivity | Negative | Sensitivity |
		| Negative_Resolution  | Negative | Resolution  |

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# End