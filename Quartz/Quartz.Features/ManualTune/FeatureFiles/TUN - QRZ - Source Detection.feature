
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Source Detection
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # MH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 26-NOV-14
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # 16-Mar-2015 - Updated to reflect the current requirements for Dev Console
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-438)                 # User can see the configuration parameters related to connected source in Source Tab Tune Page
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-577)                 # The software will provide the facility to detect and identify a supported source fitted on the instrument.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-440)                 # The software will provide the facility to identify and display the appropriate source configuration.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-441) 				   # The software will automatically identify a connected source.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-442)                 # The software will provide an appropiate source configuration based on the source type. This will be displayed in the Source tab of Tune page with appropriate titles.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-443)	               # The software will privide appropriate information if no source is detected (this will only be applicable after reboot).
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-444)                 # Each instrument will support the source types specified in that instruments Instrument Control Requirements document.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-522)				   # The software will maintain the current source type when the interlock is enabled (source door open)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Future Requirements:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-563) 				   # The user shall be prompted to either confirm or cancel all source type changes.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-454)                 # The software will allow the user to be able to select any source types regardless of the source type detected.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-456)                 # The software will provide a facility for the user to be able to disable automatic source recognition.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
Feature: Source detection and identification
	In order to tune the instrument with the appropiate source and ionisation mode
	I want to system be able to identify the connected source and display the appropriate source ionisation mode.

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given that no source is fitted
		And the 'Tune' page has been accessed
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN 01 - Automatic Source Detection
	When a <Source Type> is fitted to the instrument
		And the <Source Ionisation Mode> is set
		And the appropiate tune page <Source Tab> will be displayed
		And the option to control <Reference Capillary> will be avaiable
		And the option to control <Fluidics> will be avaiable
		Examples:
		| Source Type    | Source Ionisation Mode | Source Tab     | Reference Capillary | Fluidics |
		| ESI LockSpray  | ESI                    | ESI LockSpray  | Yes                 | Yes      |
		| ESI            | ESI                    | ESI            | No                  | Yes      |
		| APCI Lockspray | APCI                   | APC Lockspray  | Yes                 | Yes      |
		| APCI           | APCI                   | APCI           | Yes                 | Yes      |
		| Nano LockSpray | Nanoflow               | Nano LockSpray | Yes                 | Yes      |
		| APGC           | APGC                   | APGC           | No                  | No       |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@ManualOnly
Scenario Outline: TUN 02 - Automatic Source Detection - Source Interlock Trigger
	When a <Source Type> is fitted to the instrument
		And the <Source Ionisation Mode> is set
		And the source interlock is triggered
	Then the <Source Tab> will remain set
		Examples:
		| Source Type    | Source Ionisation Mode | Source Tab     |
		| ESI LockSpray  | ESI LockSpray          | ESI LockSpray  | 
		| ESI            | ESI                    | ESI            | 
		| APCI Lockspray | APCI                   | APC Lockspray  | 
		| APCI           | APCI                   | APCI           | 
		| Nano LockSpray | Nano LockSpray         | Nano LockSpray | 
		| APGC           | APGC                   | APGC           |
		# Notes for triggering the source interlock
		# ESI and APCI: Open the source door
		# Nanoflow: Withdraw the XYZ platform
		# APGC: Withdraw the transfer line


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@ManualOnly
Scenario: TUN 03 - Automatic Source Detection - No Source Detected (after hardware reset)
	 When the instrument electronics are reset
	 #Note: no source is fitted to the instrument (see background)
		And the instrument EPC is rebooted
	Then 'No Source Identified' will be displayed
		And source configuration parameters will be unavailable


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@ignore
# Note: This test should be done at Typhoon level
Scenario Outline: TUN 11 - Source Detection (Typhoon) - Register
	When a new '<Source Type>' is fitted to the instrument
		And the 'Automatic Source Recognition' is enabled
	Then the 'Source Status Register' will be set to '<Register>'
		Examples:(Priority 1)
		| Source Type    | Register |
		| ESI LockSpray  | 0100     |
		| ESI            | 0001     |
		| APCI Lockspray | 0101     |
		| APCI           | 0010     |
		| NanoLockSpray  | 0110     |
		| APGC           | 1000     |

		#Examples:(Priority 2)
		#| APPI              | 0011     |
		#| NanoFlow          | 0111     |
		#| Trizaic LockSpray | 1011     |
		#| Trizaic           | 1010     |
		#| ASAP              | See Note |
		# Note: Change from 0100 to 0101, or 0101 to 0100 should be interpreted as ASAP (See SAP Doc 721005052 Section 9.7 for details about ASAP)

# ---------------------------------------------------------------------------------------------------------------------------------------------------

#END
