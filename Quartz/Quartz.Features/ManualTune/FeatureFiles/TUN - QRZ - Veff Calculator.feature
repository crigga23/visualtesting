# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Calculate new veff
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # DM (Updated by CM)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 20-JUN-16
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # This Veff Calculotor feature file no longer covers both analyzer modes (Resolution and Sensitivity)
#						   # This Veff Calculator feature file will now work for both Osprey and Peregrine instruments
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Veff calculator can be found on Manual tuning page on TOF tab
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Latest version of Osprey Default Document 721006299
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # Tune Page Detailed Design
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-352)                 # The software will provide a veff calculator to allow the user to determine the optimum veff value.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@ManualTune
@cleanup-Veff
Feature: TUN - QRZ - Veff Calculator
	In order to set the correct Veff value
	I want to be able to provide details (related to Reference Mass and Measured mass) so that a new Veff can be calculated

	# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given the browser is opened on the Tune page
# ---------------------------------------------------------------------------------------------------------------------------------------------------

# (SS-352) The software will provide a veff calculator to allow the user to determine the optimum veff value.
Scenario: VEF - 01 - Calculator availability
	Then the veff calculator will be available
		And the veff calculator controls are in the expected state

Scenario: VEF - 02 - Check Min and Max values
	When the calculator is accessed
	Then the Calculator parameters have the expected Min, Max and Resolution limits

Scenario: VEF - 03 - Original Veff value persisted
	When the calculator is accessed
	Then the Original Veff value corresponds to the Veff applied to the instrument currently

Scenario: VEF - 04 - Cancel Calculated Veff
	When the calculator is accessed
		And 'Reference' Mass is set to '256.56'
		And 'Measured' Mass is set to '785.54'
		And the veff is calculated	
	Then the calculated New Veff value is '1719.24'
		And the veff is cancelled the new veff is not applied and the original veff remains unchanged

Scenario Outline: VEF - 05 - Calculate
	When the polarity is '<Polarity>'
		And Veff value is set to '<Initial Veff Value>' 
		And the calculator is accessed
	    And 'Reference' Mass is set to '<Reference Mass>'
		And 'Measured' Mass is set to '<Measured Mass>'
		And the veff is calculated
		And the calculated Gain value is '<Gain>'
		And the calculated New Veff value is '<New Veff>'
	Then the veff is applied the new veff of '<New Veff>' is applied to the instrument
		Examples:
		| Polarity | Initial Veff Value | Reference Mass | Measured Mass | Gain   | New Veff |
		| Positive | 5000               | 785.84         | 785.54        | 1.0004 | 5001.91  |				
		| Negative | 5000               | 150            | 100           | 1.5000 | 7500.00  |
		# Gain = Reference Mass / Measured Mass
			# New Veff = Gain * Original Veff

Scenario Outline: VEF - 06 - New Veff Outside Field Limits
	When the Original Veff is set to '<Original Veff>'
		And the calculator is accessed
		And 'Reference' Mass is set to '<Reference Mass>'
		And 'Measured' Mass is set to '<Measured Mass>'
		And the veff is calculated
	Then the calculated New Veff value is '<New Veff>'
	Examples:
	| Original Veff | Reference Mass | Measured Mass | New Veff | 
	| 1234          | 123            | 321           | 472.84   | 
	| 5000          | 123            | 321           | 1915.89  | 
	| 5000          | 412            | 100           | 20600.00 | 


Scenario Outline: VEF - 07 - New Veff Value Persistence Check
	When the polarity is '<Polarity>'
		And Veff value is set to '<Initial Veff Value>' 
		And the calculator is accessed
		And 'Reference' Mass is set to '<Reference Mass>'
		And 'Measured' Mass is set to '<Measured Mass>'
		And the veff is calculated
		And New Veff value is equal to <New Veff Value>
		And veff calculator settings are '<Saved Status>'
		And user logs out and back in again
	Then Veff value applied to the instrument is equal to '<Relogin Veff Value>'
		Examples: Not Saved
		| Polarity | Initial Veff Value | Reference Mass | Measured Mass | New Veff Value | Saved Status | Relogin Veff Value |
		| Positive | 6338               | 123            | 321           | 2428.58        | Not Saved    | 6338.00            |
		| Negative | 6338               | 123            | 321           | 2428.58        | Not Saved    | 6338.00            |
		
		Examples: Saved
		| Polarity | Initial Veff Value | Reference Mass | Measured Mass | New Veff Value | Saved Status | Relogin Veff Value |
		| Positive | 6338               | 123            | 321           | 2428.58        | Saved        | 2428.58            |
		| Negative | 6338               | 123            | 321           | 2428.58        | Saved        | 2428.58            |
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END