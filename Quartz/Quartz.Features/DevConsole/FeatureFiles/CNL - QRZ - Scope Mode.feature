
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # CNL - QRZ - Scope Mode
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 21-NOV-14
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (20-AUG-15) - Updated CNL-07, CNL-8, CNL-9 and CNL-12 post verification testing
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# 4.2.15.1                 # Functionality:
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-137)                 # The user will access the Scope Mode screen from the Instrument tab in Dev Console.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-138)                 # The page will be accessible form the Dev Console.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-140)                 # The Scope Mode page will be present for all users.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-142)                 # When the user selects the scope mode screen it will automatically switch to ADC mode and start a tuning acquisition.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-143)                 # The user will be able to specify a mass, valid ranges will be dependent on the configured instrument type.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-144)                 # The user will be able to specify a span, valid ranges will be dependent on the configured instrument type.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-145)                 # The mass shall be always greater than one half of the span.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-146)                 # The span shall always be less than one half of the mass.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-147)                 # The software will provide a real time display section within the Scope Mode screen.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-148)                 # The software will not allow the user to zoom into the spectral data.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-149)                 # The software will provide a control content section within the Scope Mode screen.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-150)                 # The software will provide manual control for the ADC setting.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-151)                 # Control provided will have defaults and ranges set appropriately.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-152)                 # The available setting will be dependent on the configured instrument type.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# 4.3.10                   # Functionality:
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-372)                 # It shall be possible to operate the instrument ADC in Scope Mode.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-374)                 # It shall be possible to specify m/z and Span for the acquisition of data.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-375)                 # The m/z shall be always greater than one half of the Span.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-376)                 # The Span shall always be less than one half of the m/z.
# -------------------------#--------------------

@ScopeMode
Feature: CNL - QRZ - Scope Mode
	In order to run in Scope Mode
	I want to be able to access a Scope Mode page where I have the ability to see a plot for a specific Mass and Span and have easy access to ADC
	parameters that will allow me to set the instrument up in this mode.

# ---------------------------------------------------------------------------------------------------------------------------------------------------


Scenario: CNL-ScopeMode-01 - Scope Mode Plot - Basic Parameters
Given the 'Scope Mode' page has been accessed
Then the following text parameters with a specific type will be available
| Parameters | Type    |
| Mass       | Numeric |
| Span       | Numeric |


@MiniSmoke
Scenario: CNL-ScopeMode-02 - Scope Mode Plot - Parameters (Default and Resolution)
Given I restart Quartz and Typhoon
	And the 'Scope Mode' page has been accessed
Then the following Scope Mode settings have these default values with defined resolutions (dp)
| Scope Mode Settings | Default | Resolution (dp) |
| Mass                | 550     | 0               |
| Span                | 50      | 0               |


Scenario Outline: CNL-ScopeMode-03 - Scope Mode Plot - Mass (Min / Max)
Given the 'Scope Mode' page has been accessed
	And the Mass is set to '550'
	And the Span is set to '<Span>'
Then the 'Mass' value '<Mass>' is allowed or disallowed <Allowed> 

	Examples:
	| Span | Mass  | Allowed |
	| 50   | 14000 | Yes     |
	| 50   | 14001 | No      |
	| 2    | 2     | Yes     |
	| 2    | 1     | No      |

Scenario: CNL-ScopeMode-04 - Scope Mode Plot - Span (Min / Max)
Given the 'Scope Mode' page has been accessed
	And the Mass is set to '14000'
Then the following Span values are allowed or disallowed
	| Span  | Allowed |
	| 14000 | Yes     |
	| 14001 | No      |
	| 2     | Yes     |
	| 1     | No      |

#Note: [Mass Max] - (Span / 2)
Scenario Outline: CNL-ScopeMode-05 - Scope Mode Plot - Span Dependancy
Given the 'Scope Mode' page has been accessed
	And the Span is set to '50'
	And the Mass is set to '550'
When the Mass is set to '<Mass>'
Then the 'Span' value '<Span>' is allowed or disallowed <Allowed>

Examples:
| Mass | Span  | Allowed |
| 550  | 1100  | Yes     |
| 550  | 1101  | No      |
| 6000 | 12000 | Yes     |
| 6000 | 12001 | No      |

#Note: [Mass Max] - (Span / 2)
Scenario Outline: CNL-ScopeMode-06 - Scope Mode Plot - Mass Dependancy
Given the 'Scope Mode' page has been accessed
	And the Span is set to '50'
	And the Mass is set to '550'
When the Span is set to '<Span>'
Then the 'Mass' value '<Mass>' is allowed or disallowed <Allowed>

Examples:
| Span | Mass | Allowed |
| 500  | 250  | Yes     |
| 500  | 249  | No      |
| 1100 | 600  | Yes     |
| 1100 | 549  | No      |


@ignore
@ManualOnly
Scenario: CNL-ScopeMode-07 - Scope Mode Plot - Axes
Given the 'Scope Mode' page has been accessed
Then a plot will be available with the following 'Axis' that has an associated static 'Description'
| Axis | Description              |
| x    | Mass m/z                 |
| y    | Intensity (ADC response) |

@ignore
@ManualOnly
Scenario: CNL-ScopeMode-08 - Scope Mode Plot - Parameters Affecting X-Axis Range
Given the 'Scope Mode' page has been accessed
When the 'Mass' and 'Span' values are set
Then the x-Axis will show the following 'Min' and 'Max' m/z range
| Mass  | Span  | Min   | Max   |
| 550   | 50    | 525   | 575   |
| 550   | 100   | 500   | 600   |
| 2     | 2     | 1     | 3     |
| 7000  | 14000 | 0     | 14000 |

@ignore									
@ManualOnly									
Scenario Outline: CNL-ScopeMode-09 - Scope Mode Plot - Live Peaks									
	Given Fluidics infusion has been stopped								
		And Tuning has been Aborted							
		And the following Tune page 'Tab' 'Parameters' have been set to a specific 'Value'							
		| Tab        | Parameters            | Value           |							
		| Instrument | Ion Energy            | -5              |							
		| ADC2       | Input Channel         | <Input Channel> |							
		| ADC2       | DC Bias A             | 0               |							
		| ADC2       | DC Bias B             | 0               |							
		| ADC2       | Amplitude Threshold A | 0               |							
		| ADC2       | Amplitude Threshold B | 0               |							
		| ADC2       | Area Threshold A      | 0               |							
		| ADC2       | Area Threshold B      | 0               |							
	When Scope Mode is selected								
	Then a baseline noise trace should be visable within the Scope Mode plot								
		Examples:							
		| Input Channel |							
		| A             |							
		| B             |							
		| Dual          |							
		# NOTE: The Given parameter values should be returned to their defaults after the scenario has been run

@ignore
@ManualOnly
Scenario: CNL-ScopeMode-10 - Scope Mode Plot - Zoom has no Effect
Given the 'Scope Mode' page has been accessed
When an attempt is made to Zoom into the Scope Mode plot
Then zooming will not occur on either axis

Scenario: CNL-ScopeMode-11 - Scope Mode Control Tabs
Given the 'Scope Mode' page has been accessed
Then they will be filtered to show only the 'ADC2' tab

Scenario: CNL-ScopeMode-12 - Scope Mode Control - ADC Tab Parameters								
	Given the 'Scope Mode' page has been accessed							
	Then the following text parameters with a specific type will be available							
		| Parameters                   | Type    |
		| DC Bias A                    | Decimal |
		| Amplitude Threshold A        | Numeric |
		| Area Threshold A             | Numeric |
		| Baseline Mean A              | Numeric |
		| DC Bias B                    | Decimal |
		| Amplitude Threshold B        | Numeric |
		| Area Threshold B             | Numeric |
		| Baseline Mean B              | Numeric |
		| Time Delay B                 | Numeric |
		| Channel B Multiplier         | Decimal |
		| Trigger Threshold            | Decimal |
		| Output Scaling Factor        | Numeric |
		| Average Single Ion Intensity | Numeric |
		| Measured m/z                 | Decimal |
		| Measured charge              | Numeric |
		| T0 (ns)                      | Numeric |
		| Veff (V)                     | Numeric |							
		And the following dropdown parameters with specific options will be available						
			| Parameters    | Options                  |
			| ADC Algorithm | ADC, Avg, TDC, PkDet TDC |
			| Input Channel | A, B, Dual               |
			| Signal Source | Detector, Test signal    |
			| Pulse Shaping | OFF, ON                  |
								
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
