# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - System1 Tab parameters
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Dragos Marian
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 26.Iun.2015
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

Scenario: TUN-QRZ-01 - System1 tab available parameters
	Given The browser is open on tune page
	When the 'System1' tab is selected 
	Then the following System1 parameters and readbacks are available
	| Parameter           | Readback |
	| Acceleration 1 (V)  | Yes      |
	| Acceleration 2 (V)  | Yes      |
	| Aperture 3 (V)      | Yes      |
	| Transport 1 (V)     | Yes      |
	| Transport 2 (V)     | Yes      |
	| Steering (V)        | Yes      |
	| Tube Lens (V)       | Yes      |
	| Entrance (V)        | Yes      |
	| Pusher (V)          | Yes      |
	| Pusher Offset (V)   | Yes      |
	| Puller (V)          | Yes      |
	| Puller Offset (V)   | Yes      |
	| Strike Plate (kV)   | Yes      |
	| Flight Tube (kV)    | Yes      |
	| Reflectron(kV)      | Yes      |
	| Reflectron Grid(kV) | Yes      |
	And only these '16' parameters are displayed on the 'System1' tab

Scenario: TUN-QRZ-02 System1 tab default parameters Positive Sensitivity
	When the browser is opened on the Tune page
		And the 'System1' tab is selected
		And the mode is 'Sensitivity' and the polarity is 'Positive'
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter           | Default Value | Resolution | UOM |
		| Acceleration 1 (V)  | 30            | 1          | V   |
		| Acceleration 2 (V)  | 100           | 1          | V   |
		| Aperture 3 (V)      | 30            | 1          | V   |
		| Transport 1 (V)     | 30            | 1          | V   |
		| Transport 2 (V)     | 30            | 1          | V   |
		| Steering (V)        | 0.00          | 0.01       | V   |
		| Tube Lens (V)       | 40            | 1          | V   |
		| Entrance (V)        | 23            | 1          | V   |
		| Pusher (V)          | 1900          | 1          | V   |
		| Pusher Offset (V)   | -1.30         | 0.01       | V   |
		| Puller (V)          | 1400          | 1          | V   |
		| Puller Offset (V)   | 0.00          | 0.01       | V   |
		| Strike Plate (kV)   | 0.00          | 0.01       | kV  |
		| Flight Tube (kV)    | 0.00          | 0.01       | kV  |
		| Reflectron(kV)      | 0.000         | 0.001      | kV  |
		| Reflectron Grid(kV) | 0.000         | 0.001      | kv  |

Scenario: TUN-QRZ-03 System1 tab default parameters Positive Resolution
	When the browser is opened on the Tune page
		And the 'System1' tab is selected
		And the mode is 'Resolution' and the polarity is 'Positive'
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter           | Default Value | Resolution | UOM |
		| Acceleration 1 (V)  | 15            | 1          | V   |
		| Acceleration 2 (V)  | 0             | 1          | V   |
		| Aperture 3 (V)      | 5             | 1          | V   |
		| Transport 1 (V)     | 40            | 1          | V   |
		| Transport 2 (V)     | 20            | 1          | V   |
		| Steering (V)        | 0.00          | 0.01       | V   |
		| Tube Lens (V)       | 48            | 1          | V   |
		| Entrance (V)        | 23            | 1          | V   |
		| Pusher (V)          | 1900          | 1          | V   |
		| Pusher Offset (V)   | -1.30         | 0.01       | V   |
		| Puller (V)          | 1400          | 1          | V   |
		| Puller Offset (V)   | 0.00          | 0.01       | V   |
		| Strike Plate (kV)   | 0.00          | 0.01       | kV  |
		| Flight Tube (kV)    | 0.00          | 0.01       | kV  |
		| Reflectron(kV)      | 0.000         | 0.001      | kV  |
		| Reflectron Grid(kV) | 0.000         | 0.001      | kv  |

Scenario: TUN-QRZ-04 System1 tab default parameters Negative Resolution
	When the browser is opened on the Tune page
		And the 'System1' tab is selected
		And the mode is 'Resolution' and the polarity is 'Negative'
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter           | Default Value | Resolution | UOM |
		| Acceleration 1 (V)  | 15            | 1          | V   |
		| Acceleration 2 (V)  | 0             | 1          | V   |
		| Aperture 3 (V)      | 5             | 1          | V   |
		| Transport 1 (V)     | 40            | 1          | V   |
		| Transport 2 (V)     | 20            | 1          | V   |
		| Steering (V)        | 0.00          | 0.01       | V   |
		| Tube Lens (V)       | 48            | 1          | V   |
		| Entrance (V)        | 23            | 1          | V   |
		| Pusher (V)          | 1900          | 1          | V   |
		| Pusher Offset (V)   | -1.58         | 0.01       | V   |
		| Puller (V)          | 1400          | 1          | V   |
		| Puller Offset (V)   | -0.80         | 0.01       | V   |
		| Strike Plate (kV)   | 0.00          | 0.01       | kV  |
		| Flight Tube (kV)    | 0.00          | 0.01       | kV  |
		| Reflectron(kV)      | 0.000         | 0.001      | kV  |
		| Reflectron Grid(kV) | 0.000         | 0.001      | kv  |

Scenario: TUN-QRZ-05 System1 tab default parameters Negative Sensitivity
	When the browser is opened on the Tune page
		And the 'System1' tab is selected
		And the mode is 'Sensitivity' and the polarity is 'Negative'
	Then each Parameter has the following Default Value, Resolution and UOM
		| Parameter           | Default Value | Resolution | UOM |
		| Acceleration 1 (V)  | 30            | 1          | V   |
		| Acceleration 2 (V)  | 100           | 1          | V   |
		| Aperture 3 (V)      | 30            | 1          | V   |
		| Transport 1 (V)     | 30            | 1          | V   |
		| Transport 2 (V)     | 30            | 1          | V   |
		| Steering (V)        | 0.00          | 0.01       | V   |
		| Tube Lens (V)       | 40            | 1          | V   |
		| Entrance (V)        | 23            | 1          | V   |
		| Pusher (V)          | 1900          | 1          | V   |
		| Pusher Offset (V)   | -1.58         | 0.01       | V   |
		| Puller (V)          | 1400          | 1          | V   |
		| Puller Offset (V)   | -0.80         | 0.01       | V   |
		| Strike Plate (kV)   | 0.00          | 0.01       | kV  |
		| Flight Tube (kV)    | 0.00          | 0.01       | kV  |
		| Reflectron(kV)      | 0.000         | 0.001      | kV  |
		| Reflectron Grid(kV) | 0.000         | 0.001      | kv  |			


Scenario: TUN-QRZ-06 - System1 tab parameters ranges
	When the browser is opened on the Tune page
		And the 'System1' tab is selected
	Then values outside the Min or Max cannot be entered for the following parameters
		| Parameter           | Min    | Max   |
		| Acceleration 1 (V)  | 0      | 200   |
		| Acceleration 2 (V)  | 0      | 200   |
		| Aperture 3 (V)      | 0      | 200   |
		| Transport 1 (V)     | 0      | 200   |
		| Transport 2 (V)     | 0      | 200   |
		| Steering (V)        | -5.00  | 5.00  |
		| Tube Lens (V)       | 0      | 200   |
		| Entrance (V)        | 0      | 100   |
		| Pusher (V)          | 0      | 2200  |
		| Pusher Offset (V)   | -5.00  | 5.00  |
		| Puller (V)          | 0      | 2200  |
		| Puller Offset (V)   | -5.00  | 5.00  |
		| Strike Plate (kV)   | -11.00 | 11.00 |
		| Flight Tube (kV)    | -8.00  | 8.00  |
		| Reflectron(kV)      | -2.500 | 2.500 |
		| Reflectron Grid(kV) | -2.500 | 2.500 |

Scenario: TUN-QRZ-07 - System1 tab readbacks - Positive Sensitivity
	Given the browser is opened on the Tune page
		And the 'System1' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is 'Sensitivity' and the polarity is 'Positive'
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter           | Default Value | New Value |
		| Acceleration 1 (V)  | 30            | 20        |
		| Acceleration 2 (V)  | 100           | 120       |
		| Aperture 3 (V)      | 30            | 15        |
		| Transport 1 (V)     | 30            | 15        |
		| Transport 2 (V)     | 30            | 15        |
		| Steering (V)        | 0.00          | 2.5       |
		| Tube Lens (V)       | 40            | 60        |
		| Entrance (V)        | 23            | 46        |
		| Pusher (V)          | 1900          | 1500      |
		| Pusher Offset (V)   | -1.30         | 1         |
		| Puller (V)          | 1400          | 1700      |
		| Puller Offset (V)   | 0.00          | 2.50      |
		| Strike Plate (kV)   | 0.00          | 2.50      |
		| Flight Tube (kV)    | 0.00          | 2.50      |
		| Reflectron(kV)      | 0.000         | -1.000    |
		| Reflectron Grid(kV) | 0.000         | -1.000    |

Scenario: TUN-QRZ-08 - System1 tab readbacks - Positive Resolution
	Given the browser is opened on the Tune page
		And the 'System1' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is 'Resolution' and the polarity is 'Positive'
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter           | Default Value | New Value |
		| Acceleration 1 (V)  | 15            | 45        |
		| Acceleration 2 (V)  | 0             | 45        |
		| Aperture 3 (V)      | 5             | 45        |
		| Transport 1 (V)     | 40            | 45        |
		| Transport 2 (V)     | 20            | 45        |
		| Steering (V)        | 0.00          | -2        |
		| Tube Lens (V)       | 48            | 20        |
		| Entrance (V)        | 23            | 12        |
		| Pusher (V)          | 1900          | 1400      |
		| Pusher Offset (V)   | -1.30         | 2.3       |
		| Puller (V)          | 1400          | 1900      |
		| Puller Offset (V)   | 0.00          | 2.20      |
		| Strike Plate (kV)   | 0.00          | 2.20      |
		| Flight Tube (kV)    | 0.00          | 2.20      |
		| Reflectron(kV)      | 0.000         | 2.200     |
		| Reflectron Grid(kV) | 0.000         | 2.200     |

Scenario: TUN-QRZ-09 - System1 tab readbacks - Negative Resolution
	Given the browser is opened on the Tune page
		And the 'System1' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is 'Resolution' and the polarity is 'Negative'
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter           | Default Value | New Value |
		| Acceleration 1 (V)  | 15            | 45        |
		| Acceleration 2 (V)  | 0             | 45        |
		| Aperture 3 (V)      | 5             | 45        |
		| Transport 1 (V)     | 40            | 45        |
		| Transport 2 (V)     | 20            | 45        |
		| Steering (V)        | 0.00          | -2        |
		| Tube Lens (V)       | 48            | 20        |
		| Entrance (V)        | 23            | 12        |
		| Pusher (V)          | 1900          | 1400      |
		| Pusher Offset (V)   | -1.30         | 2.3       |
		| Puller (V)          | 1400          | 1900      |
		| Puller Offset (V)   | 0.00          | 2.20      |
		| Strike Plate (kV)   | 0.00          | 2.20      |
		| Flight Tube (kV)    | 0.00          | 2.20      |
		| Reflectron(kV)      | 0.000         | 2.200     |
		| Reflectron Grid(kV) | 0.000         | 2.200     |

Scenario: TUN-QRZ-10 - System1 tab readbacks - Positive Resolution
	Given the browser is opened on the Tune page
		And the 'System1' tab is selected
		And the instrument is in 'Operate' mode
	When the mode is 'Sensitivity' and the polarity is 'Positive'
	Then if the Default Value is changed to a New Value	the Readback starts updating towards the new value
		| Parameter           | Default Value | New Value |
		| Acceleration 1 (V)  | 15            | 45        |
		| Acceleration 2 (V)  | 0             | 45        |
		| Aperture 3 (V)      | 5             | 45        |
		| Transport 1 (V)     | 40            | 20        |
		| Transport 2 (V)     | 20            | 45        |
		| Steering (V)        | 0.00          | 2.5       |
		| Tube Lens (V)       | 48            | 60        |
		| Entrance (V)        | 23            | 46        |
		| Pusher (V)          | 1900          | 1500      |
		| Pusher Offset (V)   | -1.30         | 1         |
		| Puller (V)          | 1400          | 1700      |
		| Puller Offset (V)   | 0.00          | 2.50      |
		| Strike Plate (kV)   | 0.00          | 2.50      |
		| Flight Tube (kV)    | 0.00          | 2.50      |
		| Reflectron(kV)      | 0.000         | -1.000    |
		| Reflectron Grid(kV) | 0.000         | -1.000    |

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# End
