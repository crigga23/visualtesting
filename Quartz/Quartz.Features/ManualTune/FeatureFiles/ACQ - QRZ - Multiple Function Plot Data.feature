
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # ACQ - QRZ - Multiple Function Plot Data (Tune Page)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 27-NOV-14
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-212)                 # The user will be able to run an existing method from the Manual Tuning screen.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@ignore
Feature: Multiple Function Plot Data (Tune Page)
	In order to display Mutiple Function m/z Data within the Live Tune Page Plot
	I want to be able to load a prevously saved / created method, selected one of the Functions and see the expected m/z data


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the 'Tune' page has been accessed
 
# ---------------------------------------------------------------------------------------------------------------------------------------------------


@ManualOnly
Scenario: ACQ-MultipleFunctionPlotData-01 - Acquisition Record
	When an Acquisition '<Method Type>' with '<Lock Mass?>' is set Recording (using Acquisition | Record) 
		And each individual '<m/z Function>' is selected, within the live Tune page plot
	Then for each function, the live Tune page m/z plot will be populated with the expected <'Data'>
			Examples: Without Lock Mass Function
			| Method Type | Lock Mass | m/z Function | Data         |
			| TofMS       | No        | 1            | MS           |
			| TofMSMS     | No        | 1            | MSMS         |
			| MSe         | No        | 1            | MS (Low CE)  |
			| MSe         | No        | 2            | MS (High CE) |
			| HD-MS       | No        | 1            | MS           |
			| HD-MSMS     | No        | 1            | MSMS         |
			| HD-MSe      | No        | 1            | MS (Low CE)  |
			| HD-MSe      | No        | 2            | MS (High CE) |
		
			Examples: With MS Lock Mass Function
			| Method Type | Lock Mass | m/z Function | Data          |
			| TofMS       | Yes (MS)  | 1            | MS            |
			| TofMS       | Yes (MS)  | 2            | MS (LockMass) |
			| TofMSMS     | Yes (MS)  | 1            | MSMS          |
			| TofMSMS     | Yes (MS)  | 2            | MS (LockMass) |
			| MSe         | Yes (MS)  | 1            | MS (Low CE)   |
			| MSe         | Yes (MS)  | 2            | MS (High CE)  |
			| MSe         | Yes (MS)  | 3            | MS (LockMass) |
			| HD-MS       | Yes (MS)  | 1            | MS            |
			| HD-MS       | Yes (MS)  | 2            | MS (LockMass) |
			| HD-MSMS     | Yes (MS)  | 1            | MSMS          |
			| HD-MSMS     | Yes (MS)  | 2            | MS (LockMass) |
			| HD-MSe      | Yes (MS)  | 1            | MS (Low CE)   |
			| HD-MSe      | Yes (MS)  | 2            | MS (High CE)  |
			| HD-MSe      | Yes (MS)  | 3            | MS (LockMass) |

			Examples: With MSMS Lock Mass Function
			| Method Type | Lock Mass  | m/z Function | Data            |
			| TofMSMS     | Yes (MSMS) | 1            | MSMS            |
			| TofMSMS     | Yes (MSMS) | 2            | MSMS (LockMass) |
			| HD-MSMS     | Yes (MSMS) | 1            | MSMS            |
			| HD-MSMS     | Yes (MSMS) | 2            | MSMS (LockMass) |
			

@ManualOnly
Scenario: ACQ-MultipleFunctionPlotData-02 - XML Tuning
	When an Acquisition '<Method Type>' is run (using Acquisition | XML Tuning) 
		And each individual '<m/z Function>' is selected, within the live Tune page plot
	Then for each function, the live Tune page m/z plot will be populated with the expected <'Data'>
		Examples: Without Lock Mass Function
		| Method Type          | m/z Function | Data          |
		| hdms.xml             | 1            | MS            |
		| hdmsms.xml           | 1            | MSMS          |
		| ms.xml               | 1            | MS            |
		| ms_dual_lockmass.xml | 1            | MS            |
		| ms_dual_lockmass.xml | 2            | MS (LockMass) |
		| ms_edc.xml           | 1            | MS            |
		| ms_lockmass.xml      | 1            | MS            |
		| ms_lockmass.xml      | 2            | MS (LockMass) |
		| msms.xml             | 1            | MSMS          |
		| tune.xml             | 1            | MS            |
		| HDMRM.xml            | 1            | MRM           |
		| HDMRM.xml            | 2            | MRM           |
		| HDMRM.xml            | 3            | RADAR         |
		| TofMRM.xml           | 1            | MRM           |
		| TofMRM.xml           | 2            | MRM           |
		| TofMRM.xml           | 3            | RADAR         |
		| mse.xml              | 1            | MS (Low CE)   |
		| mse.xml              | 2            | MS (High CE)  |
		| mse_fullhd.xml       | 1            | MS (Low CE)   |
		| mse_fullhd.xml       | 2            | MS (High CE)  |
		| mse_trend            | 1            | MS (Low CE)   |
		| mse_trend            | 2            | MS (High CE)  |  
		
# An additional scenario should probably be created for a manually created XML file.  


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END

