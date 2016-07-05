# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - EDC Setup (Target Enhancement)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # MH/CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 16-Jul-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:	   # Engineer Dashboard is installed and the following settings are being monitored;
#                          # CELL2_EDC_PUSHER_SYNCH_DELAY_SETTING
#                          # CELL2_CONTROL_REGISTER_SETTING
#                          # PUSHER_PULSE_WIDTH_SETTING
#                          # PUSHER_FREQUENCY_SETTING
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Typoon and Quartz installed for Opsrey instrument
#                          # Leucine Enkephalin peaks should be available when reservoir 'B' is selected for Sample or Reference
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# Basis
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# Dev Console Software Specification
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-592)                 # It shall be possible to set EDC mass, when EDC is enabled.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-593)                 # It shall be possible for a service user to select EDC Setup mode.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-594)                 # It shall be possible to set the EDC coefficient and offset values uniquely for each polarity and optic mode.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-596)                 # It shall be possible to save EDC setup parameters as Factory defaults.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-597)                 # It shall be possible to save and load different set of values for EDC coefficient and offset for Tof mass range of m/z.
# ---------------------------------------------------------------------------------------------------------------------------------------------------



@ignore
Feature: EDC Setup (Target Enhancement)
	In order to optimise EDC (Enhanced Duty Cycle) for the instrument
	I want to be able to set the instrument to EDC Setup mode which will allow me to optimise the EDC Delay Coefficient and EDC Delay Offset

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given that the factory defaults have been reset
		And the tune page is viewed


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: TUN-01 - EDC Setup tab GUI elements
	When the MS Profile tab is viewed
	Then the following elements are available
			| Select Mode Dropdown (None, EDC) |
			| EDC Mass Text field              |
			| Low Mass Delay Coefficient       |
			| High Mass Delay Coefficient      |
			| Low Mass Delay Offset            |
			| High Mass Delay Offset           |
		And the following labels are present
			| Mass (m/z):|
			| Low:       |
			| High:      |
	

Scenario Outline: TUN-02 - EDC Setup tab GUI - Select Mode
	When the MS Profile tab is viewed
		And the Select Mode Dropdown is set to <EDC Mode>
	Then the folloing text fields will be set to <State>
			| EDC Mass                    |
			| Low Mass Delay Coefficient  |
			| High Mass Delay Coefficient |
			| Low Mass Delay Offset       |
			| High Mass Delay Offset      |

			Examples:
			| EDC Mode | State    |
			| None     | Disabled |
			| EDC      | Enabled  |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-03 - EDC Setup  - Cell2 Control Register Setting
	Given the instrument polarity <Polarity> is set
		And the instrument mode <Mode> is set
		And the Select Mode dropdown <Select Mode> is set
	Then the Cell2 Control Register setting <Cell2 CR> is set

		Examples:
		| Polarity | Mode        | Select Mode | Cell2 CR |
		| Positive | Sensitivity | None        | 65       |
		| Positive | Sensitivity | EDC         | 4163     |
		| Negative | Resolution  | None        | 65       |
		| Negative | Resolution  | EDC         | 4163     |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-04 - EDC Setup  - EDC Pusher Delay - Low Mass Positive Sensitivity
	Given the instrument polarity is 'Positive'
		And the instrument mode is set to 'Sensitivity'
	When the Select Mode Dropdown is set to 'EDC'
		And the tuning mass range end mass <End Mass> is set
		And the EDC Mass <EDC Mass> is set
		And the Low Mass Delay Coeffient <Low Mass Delay Co> is set
		And the Low Mass Delay Offset <Low Mass Delay Off> is set
	Then the EDC Pusher Delay <EDC Pusher Delay> is set
	# Note: This value can be checked using Engineer Dashboard to monitor 'CELL2_EDC_PUSHER_SYNCH_DELAY_SETTING' and is calculated using the following formula: TD=k√m+T0  where TD = EDC pusher delay, k = EDC coefficient, m = mass-to-charge ratio, T0 = EDC Offset

		Examples: (Low/High mass changeover >2000)
		| End Mass | EDC Mass | Low Mass Delay Co | Low Mass Delay Off | EDC Pusher Delay |
		| 800      | 450      | 2.15 (Default)    | 0.00 (Default)     | 45.61            |
		| 1200     | 750      | 2.45              | 1.22               | 68.32            |
		| 2000     | 850      | 3.03              | 2.51               | 90.85            |
		
Scenario Outline: TUN-05 - EDC Setup  - EDC Pusher Delay - Low Mass Negative Resolution
	Given the instrument polarity is 'Negative'
		And the instrument mode is set to 'Resolution'
	When the Select Mode Dropdown is set to 'EDC'
		And the tuning mass range end mass <End Mass> is set
		And the EDC Mass <EDC Mass> is set
		And the Low Mass Delay Coeffient <Low Mass Delay Co> is set
		And the Low Mass Delay Offset <Low Mass Delay Off> is set
	Then the EDC Pusher Delay <EDC Pusher Delay> is set
	# Note: This value can be checked using Engineer Dashboard to monitor 'CELL2_EDC_PUSHER_SYNCH_DELAY_SETTING' and is calculated using the following formula: TD=k√m+T0  where TD = EDC pusher delay, k = EDC coefficient, m = mass-to-charge ratio, T0 = EDC Offset

		Examples: (Low/High mass changeover >1000)
		| End Mass | EDC Mass | Low Mass Delay Co | Low Mass Delay Off | EDC Pusher Delay |
		| 500      | 250      | 3.10 (Default)    | 0.00 (Default)     | 49.02            |
		| 800      | 450      | 2.45              | 1.22               | 53.19            |
		| 1000     | 850      | 3.03              | 2.51               | 90.85            |
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-06 - EDC Setup  - EDC Pusher Delay - High Mass Positive Sensitivity
	Given the instrument polarity is 'Positive'
		And the instrument mode is set to 'Sensitivity'
	When the Select Mode Dropdown is set to 'EDC'
		And the tuning mass range end mass <End Mass> is set
		And the EDC Mass <EDC Mass> is set
		And the High Mass Delay Coeffient <High Mass Delay Co> is set
		And the High Mass Delay Offset <High Mass Delay Off> is set
	Then the EDC Pusher Delay <EDC Pusher Delay> is set
	# Note: This value can be checked using Engineer Dashboard to monitor 'CELL2_EDC_PUSHER_SYNCH_DELAY_SETTING' and is calculated using the following formula: TD=k√m+T0  where TD = EDC pusher delay, k = EDC coefficient, m = mass-to-charge ratio, T0 = EDC Offset

		Examples: (Low/High mass changeover >2000)
		| End Mass | EDC Mass | High Mass Delay Co | High Mass Delay Off | EDC Pusher Delay |
		| 2001     | 850      | 2.15 (Default)     | 0.00 (Default)      | 62.68            |
		| 4000     | 1255     | 2.45               | 1.22                | 88.01            |
		| 8000     | 1255     | 3.03               | 2.51                | 109.85           |
		| 8000     | 4000     | 3.03               | 2.51                | 194.14           |


Scenario Outline: TUN-07 - EDC Setup  - EDC Pusher Delay - High Mass Negative Resolution
	Given the instrument polarity is 'Negative'
		And the instrument mode is set to 'Resolution'
	When the Select Mode Dropdown is set to 'EDC'
		And the tuning mass range end mass <End Mass> is set
		And the EDC Mass <EDC Mass> is set
		And the High Mass Delay Coeffient <High Mass Delay Co> is set
		And the High Mass Delay Offset <High Mass Delay Off> is set
	Then the EDC Pusher Delay <EDC Pusher Delay> is set
	# Note: This value can be checked using Engineer Dashboard to monitor 'CELL2_EDC_PUSHER_SYNCH_DELAY_SETTING' and is calculated using the following formula: TD=k√m+T0  where TD = EDC pusher delay, k = EDC coefficient, m = mass-to-charge ratio, T0 = EDC Offset

		Examples: (Low/High mass changeover >1000)
		| End Mass | EDC Mass | High Mass Delay Co | High Mass Delay Off | EDC Pusher Delay |
		| 1001     | 750      | 2.15 (Default)     | 0.00 (Default)      | 58.88            |
		| 4000     | 1255     | 2.45               | 1.22                | 88.01            |
		| 8000     | 1255     | 3.03               | 2.51                | 109.85           |
		| 8000     | 4000     | 3.03               | 2.51                | 194.14           |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-08 - EDC Setup  - Mass Trapping Frequency
	Given the instrument polarity <Polarity> is set
		And the instrument mode <Mode> is set
	When the Select Mode Dropdown is set to 'EDC'
		And the EDC Mass is set to '500'
		And the tuning mass range end mass <End Mass> is set
	Then the Pusher Frequency <Pusher Frequency> is set
		And the Pusher Pulse Width <Pulse Width> is set
		# Note: These values can be checked using Engineer Dashboard to monitor 'PUSHER_PULSE_WIDTH_SETTING' and 'PUSHER_FREQUENCY_SETTING'

			Examples: Low
			| Polarity | Mode        | End Mass | Pusher Frequency | Pulse Width |
			| Positive | Sensitivity | 2000     | 100              | 1.25        |
			| Negative | Resolution  | 1000     | 100              | 1.25        |

			Examples: High
			| Polarity | Mode        | End Mass | Pusher Frequency | Pulse Width |
			| Positive | Sensitivity | 2001     | 400              | 3.75        |
			| Negative | Resolution  | 1001     | 400              | 3.75        |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@ManualOnly
Scenario Outline: TUN-09 - EDC Setup  - Beam Check
	Given the instrument polarity <Polarity> is set
		And the instrument mode <Mode> is set
		And a good 'LenEnk' beam is avaiable when the Select Mode Dropdown is set to 'None'
	When the Select Mode Dropdown is then set to 'EDC'
		And the EDC Mass is set to '555'
	Then the 'LeuEnk' beam should increase in intensity at the expected mass
	# Note: Expected mass for LeuEnk in POS = 556.28, NEG = 554.26


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline:  TUN-10 - EDC Setup - Reset EDC parameter factory defaults to defaults
	Given that I have recorded the current lower and upper EDC_DELAY coefficient factory defaults for <Mode> <Polarity>
		And that I have recorded the current lower and upper EDC_DELAY offset factory defaults for <Mode> <Polarity>
		And I have changed the lower and upper EDC_DELAY coeficient values to non-defaults for <Mode> <Polarity>
		And I have changed the lower and upper EDC_DELAY offset values to non-defaults for <Mode> <Polarity>
	When I 'Reset' the factory defaults
	Then the lower and upper EDC_DELAY coefficient values will be set to their initial defaults for <Mode> <Polarity>
		And the lower and upper EDC_DELAY offset values will be set to their initial defaults for <Mode> <Polarity>
			
			Examples:
			| Mode        | Polarity |
			| Resolution  | Positive |
			| Resolution  | Negative |
			| Sensitivity | positive |
			| Sensitivity | negative |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario:  TUN-11 - EDC Setup - Defaults and Ranges
	When the MS Profile tab is viewed
		And the latest 'Osprey Default Parameters - SAP 721006299' is available
	Then the following parameters will match the defaults and ranges
		| Low mass EDC Coefficient  |
		| Low mass EDC Offset       |
		| High mass EDC Coefficient |
		| High mass EDC Offset      |


# END
# ---------------------------------------------------------------------------------------------------------------------------------------------------

