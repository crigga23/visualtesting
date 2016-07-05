# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # QUD - QRZ - Quad Setup
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # GI
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 19-Nov-14
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Peak Display graphs can not be automated
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Latest version of Osprey Default Document 721006299
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (20-AUG-15) - Updated QUD-03 and QUD-12 post verification testing
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-309)                 # The user will access the Quad setup page from the Instrument tab in the Dev Console.
# (SS-310)                 # The Quad Setup page will be present for all users
# (SS-311)                 # When the user selects the quad setup screen it will automatically start quad setup tuning acquisition.
# (SS-313)                 # The user will be able to select up to 4 different set masses.
# (SS-314)                 # The software will allow the  user to change the span for all select masses.
# (SS-316)                 # The software will allow the  user to change the number of steps to perform for all selected  masses. This setting will apply globally to all real time displays.
# (SS-315)                 # The software will allow the  user to change the time per step for all select masses. 
# (SS-318)                 # The software will allow the  user to change the detector window for all select masses.
# (SS-477)                 # Span relates to the width of the quad window that you will scan over;
#							 Number of Steps is the number of steps that the quad will go through to cover the span;
#							 Time per step is the scan time at each step increment;
#							 Detector window is the width of the TOF
# (SS-320)				   # The software will provide 4 real time displays section within the Scope Mode screen.
# (SS-321)				   # The software will provide a display section containing 4 real time displays within the quad setup screen.
# (SS-322)				   # The user will be able to switch the real time displays between active and non-active.
# (SS-319)				   # The software will remove non-active real time displays.
# (SS-329)				   # The software will provide a control content section within the quad setup screen.
# (SS-327)				   # The software will provide manual control for the instrument hardware, to allow the user to tune the quad setting.
# (SS-328)				   # Control provided will have defaults and ranges set appropriately.
# (SS-326)				   # The software will allow the user to save the current quad settings.
# (SS-332)				   # The software will allow the user to recall the current quad settings.
# (SS-331)				   # The software will allow the user to reset the quad settings back to their default values.
# (SS-334)				   # The software will allow the user to change the mode between normal and align.
# (SS-335)				   # The software will allow the user to switch the polarity applied to the quad rod pairs.
# (SS-330)				   # The software will provide a control content section within the Quad Setup screen
# (SS-333)				   # The software will provide manual control for the instrument hardware, so that the instruments control parameters may be set
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
#
# Note: the following are not applicable and should not be in the SS.
#
# (SS-323)				   # The software will display the relevant  set mass on each active real time display.
# (SS-324)				   # The software will display the relevant  resolution  value on each active real time display.
# (SS-325)				   # The resolution indication on the peak display shall show peak width at half height in Daltons.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@QuadSetup
Feature: CNL - QRZ - QuadSetup
	In order to setup a Quad
	I want to be able to configure the Quad control parameters
	And customize my view of the real-time peaks


Background: 
	Given the browser is opened on the Tune page
		And the mode is Sensitivity and the polarity is Positive
		And the browser is opened on the Quad Setup page


#(SS-311) When the user selects the quad setup screen it will automatically start quad setup tuning acquisition.

@ignore
@ManualOnly
Scenario: QUD - 01 - Automatic Quad Setup Tuning
	Then quad setup tuning will start automatically


# (SS-328) Control provided will have defaults and ranges set appropriately.
Scenario: QUD - 02 - Quad Parameter Ranges
	Then Quad values outside the Min or Max cannot be entered for the following parameters
		| Parameter              | Min   | Max     | Resolution |
		| Low Mass Resolution    | 0.00  | 100.00  | 0.01       |
		| High Mass Resolution   | 0.00  | 100.00  | 0.01       |
		| Linearity              | 0.000 | 100.000 | 0.001      |
		| Low Mass Scale Adjust  | 0.00  | 100.00  | 0.01       |
		| High Mass Scale Adjust | 0.00  | 100.00  | 0.01       |
		| LM Resolution          | 0.0   | 25.0    | 0.1        |
		| HM Resolution          | 0.0   | 25.0    | 0.1        |
		| Ion Energy             | -5.0  | 5.0     | 0.1        |


# (SS-328) Control provided will have defaults and ranges set appropriately.
# (SS-313) The user will be able to select up to 4 different set masses.
# (SS-327) The software will provide manual control for the instrument hardware, to allow the user to tune the quad setting.
Scenario Outline: QUD - 03 - Default Values
	Given the quad is a <Quad>
		And the browser is opened on the Tune page
		And factory defaults have been reset
		And the browser is opened on the Quad Setup page
	Then each field has the following Default Value and Resolution for the Quad Mass <Quad>
		| Field                  | 3940 Default Value | 8000 Default Value | 32000 Default Value | Resolution |
		| Mass 1                 | 172.88             | 172.88             | 172.88              | 0.01       |
		| Mass 2                 | 622.57             | 1971.61            | 1971.61             | 0.01       |
		| Mass 3                 | 1072.25            | 4070.13            | 4220.02             | 0.01       |
		| Mass 4                 | 1971.61            | 5868.86            | 7367.80             | 0.01       |
		| Span(Da)               | 4                  | 4                  | 4                   | na         |
		| Time per Step(Sec)     | 0.023              | 0.023              | 0.023               | na         |
		| No.of Steps            | 20                 | 20                 | 20                  | na         |
		| Detector Window(Da)    | 100                | 100                | 100                 | na         |
		| Mode                   | Normal             | Normal             | Normal              | na         |
		| Polarity               | Position1          | Position1          | Position1           | na         |
		| LM Resolution          | 4.7                | 4.7                | 4.7                 | 0.1        |
		| HM Resolution          | 15.0               | 15.0               | 15.0                | 0.1        |
		| Ion Energy             | 0.4               | 0.4                | 0.4                 | 0.4	        |
		| Low Mass Resolution    | 2.70               | 2.60               | 2.30                | 0.01       |
		| High Mass Resolution   | 27.50              | 26.50              | 3.50                | 0.01       |
		| Linearity              | 52.700             | 52.500             | 66.000              | 0.001      |
		| Low Mass Scale Adjust  | 75.00              | 74.50              | 74.50               | 0.01       |
		| High Mass Scale Adjust | 75.50              | 45.00              | 58.00               | 0.01       |

		@InstrumentOnly
		Examples:
		| Quad  |
		| <get> |

		@SimulatorOnly
		Examples:
		| Quad  |
		| 3940  |

		@ignore
		@Obsolete
		@SimulatorOnly
		Examples:
		| Quad  |
		| 8000  |
		| 32000 |


# (SHM Resolution S-326) The software will allow the user to save the current quad settings.
# (SIon Energy    S-332) The software will allow the user to recall the current quad settings.
# (SS-331) The software will allow the user to reset the quad settings back to their default values.
# (SS-327) The software will provide manual control for the instrument hardware, to allow the user to tune the quad setting.
@SmokeTest
@MiniSmoke
Scenario Outline: QUD - 04 - Recall, Save and Default
	Given the quad is a <Quad>
		And the browser is opened on the Quad Setup page
		And all control parameters are set to
		| Parameter              | Value  |
		| Low Mass Resolution    | 5.12   |
		| High Mass Resolution   | 5.86   |
		| Linearity              | 41.999 |
		| Low Mass Scale Adjust  | 89.69  |
		| High Mass Scale Adjust | 81.66  |
	When I 'Save' the Quad control parameter settings
		And I change all the control parameters to
		| Parameter              | Value |
		| Low Mass Resolution    | 4.36        |
		| High Mass Resolution   | 4.47        |
		| Linearity              | 38.500      |
		| Low Mass Scale Adjust  | 90.90       |
		| High Mass Scale Adjust | 71.50       |
	When I 'Recall' the Quad control parameter settings
	Then the control parameters are equal to
		| Parameter              | Value  |
		| Low Mass Resolution    | 5.12   |
		| High Mass Resolution   | 5.86   |
		| Linearity              | 41.999 |
		| Low Mass Scale Adjust  | 89.69  |
		| High Mass Scale Adjust | 81.66  |
	But when I 'Default' the Quad control parameter settings
	Then the control parameters are equal to the following default values for the Quad Mass <Quad>
		| Parameter              | 3940 Default Value | 8000 Default Value | 32000 Default Value |
		| Low Mass Resolution    | 2.70               | 2.60               | 2.30                |
		| High Mass Resolution   | 27.50              | 26.50              | 3.50                |
		| Linearity              | 52.700             | 52.500             | 66.000              |
		| Low Mass Scale Adjust  | 75.00              | 74.50              | 74.50               |
		| High Mass Scale Adjust | 75.50              | 45.00              | 58.00               | 
	
		@InstrumentOnly
		Examples:
		| Quad  |
		| <get> |

		@SimulatorOnly
		Examples:
		| Quad  |
		| 3940  |
		| 8000  |
		| 32000 |

# (SS-322) The user will be able to switch the real time displays between active and non-active.
# (SS-319) The software will remove non-active real time displays.
# (SS-321) The software will provide a display section containing 4 real time displays within the quad setup screen.
# (SS-320) The software will provide 4 real time displays section within the Scope Mode screen.
# (SS-313) The user will be able to select up to 4 different set masses.
Scenario: QUD - 05 - Displaying Peak Display Windows 
	Given all 4 masses are selected
	When I deselect quad 'Mass 1'
		And I deselect quad 'Mass 3'
	Then the 'Mass 1' Peak Display graph is removed
		And the 'Mass 3' Peak Display graph is removed
		And 2 Peak Display graphs are displayed
	When I select quad 'Mass 3'
	#Then the 'Mass 3' Peak Display graph is displayed
		Then 3 Peak Display graphs are displayed
	

# (SS-322) The user will be able to switch the real time displays between active and non-active.
# (SS-319) The software will remove non-active real time displays.
# (SS-321) The software will provide a display section containing 4 real time displays within the quad setup screen.
# (SS-320) The software will provide 4 real time displays section within the Scope Mode screen.
# (SS-313) The user will be able to select up to 4 different set masses.
@ManualOnly
@ignore
Scenario: QUD - 06 - Displaying Peak Display Windows - ordering
	Given all 4 masses are selected
		And the graphs are ordered left to right starting with 'Mass 1' through to 'Mass 4'
		# use the mass value and chart axis to determine this.
		And each m/z axis correctly represents the Mass value 	
	When I deselect quad 'Mass 1' and 'Mass 3'
	Then the 'Mass 1' Peak Display graph is removed
		And the the 'Mass 3' Peak Display graph is removed
	When I reselect quad 'Mass 3'
	Then the 'Mass 3' Peak Display graph is displayed as the middle of the 3 graphs
	# use the mass value and chart axis to determine this.
		And each m/z axis correctly represents the Mass value
	

# (SS-319) The software will remove non-active real time displays.
Scenario: QUD - 07 - Remove All Peak Display Windows
	Given all 4 masses are selected
	When I deselect quad 'Mass 1, Mass 2 and Mass 4'
	Then it is not possibe to deselect 'Mass 3'


@ManualOnly
@ignore
Scenario: QUD - 08 - Changing mass ion values
	Given all 4 masses are selected
	When I change all Mass values 
	Then the m/z axis for each Peak Display graph will correctly represent the new Mass value 


@ManualOnly
@ignore
Scenario Outline: QUD - 09 - Mass ion values validation
	Given the quad is a <Quad>
		And all 4 masses are selected
	Then the following values will not be accepted in either 'Mass 1', 'Mass 2', 'Mass 3' or 'Mass 4' parameters 
		| Value   |
		| 0       |
		| -100    |
		| 100000  |
		| abc     |
		| <blank> |
		And the maximum value accepted is <Maximum Mass>
		And the Peak Displays will continue plotting

		Examples:
		| Quad | Maximum Mass |
		| 4k   | 3940         |
		| 8k   | 8000         |
		| 32k  | 32000        |


# (SS-314) The software will allow the  user to change the span for all select masses.
Scenario: QUD - 10 - Span options 
	Then the 'Span' parameter is available with the following dropdown options
		| Options |
		| 1       |
		| 2       |
		| 4       |
		| 10      |
		| 20      |
		| 50      |


# (SS-314) The software will allow the  user to change the span for all select masses.
@ManualOnly
@ignore
Scenario Outline: QUD - 11 - Changing Span value
	Given all 4 masses are selected
	When I change the Span to <Value>
	Then the m/z axis for each Peak Display graph will span this range
		And the Peak Displays will continue plotting

		Examples: 
			| Value |
			| 1     |
			| 2     |
			| 4     |
			| 10    |
			| 20    |
			| 50    |


# change mass ion to a low number e.g. 10 and have a span greater than 10 - What happens when should go below 0 ?
# (SS-314) The software will allow the  user to change the span for all select masses.
@ManualOnly
@ignore
Scenario: QUD - 12 - Changing Span - where mass is below minimum
	Given 'Detector Window' is set to '10'
		And 'Span' is set to '10'
		And 'Mass 1' is set to '10'
	When 'Span' is changed to '50'
	Then 'Mass 1' will change to '30'
		And the Peak Displays will continue plotting
		And the chart axis will look correct
		# The mass will automatically change to the minimim value if set below it [where minimum value = (Span + Detector Window) / 2]


# Number of Steps is the number of steps that the quad will go through to cover the span
# the number of plot points ? can we visually see if this changes ?
#Scenario: QUD - 12 - Number Of Steps


# (SS-316) The software will allow the  user to change the number of steps to perform for all selected  masses. This setting will apply globally to all real time displays.
Scenario: QUD - 13 - Number Of Steps options 
	Then the 'Number of Steps' parameter is available with the following dropdown options
		| Options |
		| 10      |
		| 20      |
		| 30      |
		| 50      |


# Time per step is the scan time at each step increment
# unable to check this, but maybe we can check the value is sent to Typhoon etc
#Scenario: QUD - 13 - Time per second


# (SS-315) The software will allow the  user to change the time per step for all select masses. 
Scenario: QUD - 14 - Time Per Second options
	Then the 'Time per second' parameter is available with the following dropdown options
		| Options |
		| 0.023   |
		| 0.04    |
		| 0.06    |
		| 0.1     |


# Detector window is the width of the TOF window that is scanned for each step increment.
# Unable to test this, but maybe we can check the value is sent to Typhoon etc
#Scenario: QUD - 14 - Detector window


# (SS-318) The software will allow the  user to change the detector window for all select masses.
Scenario: QUD - 15 - Detector Window options
	Then the 'Detector window' parameter is available with the following dropdown options
		| Options |
		| 1       |
		| 2       |
		| 4       |
		| 10      |
		| 100     |


# (SS-334) The software will allow the user to change the mode between normal and align.
# (SS-335) The software will allow the user to switch the polarity applied to the quad rod pairs.
Scenario: QUD - 16 - Mode and Polarity options
	Then the 'Mode' parameter is available with the following dropdown options
		| Options |
		| Align   |
		| Normal  |
		And the 'Polarity' parameter is available with the following dropdown options
			| Options   |
			| Position1 |
			| Position2 |

# I would like to perform a more detailed test of this value, or at least check that the value is being passed to Typhoon or Typhoon is sending the message
#Scenario: QUD - Polarity


Scenario Outline: QUD - 17 - Quad Configuration - Align 
	Given the quad is a <Quad>
		And the browser is opened on the Quad Setup page
		And all 4 masses are selected
	When the Quad Mode parameter is set to 'Align'
	Then the Rectified RF readback will stay the same over all scans within tolerance '1.0'

	@InstrumentOnly
	Examples:
	| Quad  |
	| <get> |

	@SimulatorOnly
	Examples:
	| Quad  |
	| 3940  |
	| 8000  |
	| 32000 |


@InstrumentOnly
#@CR_Simulator_does_not_support_varying_RF_readback
Scenario: QUD - 18 - Quad Configuration - Normal 
	Given all 4 masses are selected
	When the Quad Mode parameter is set to 'Normal'
	Then the Rectified RF readback will vary over all scans


Scenario: QUD - 19 - Quad Setup Mode - ADC
	Then the ADC frequency will be 3600 MHz



