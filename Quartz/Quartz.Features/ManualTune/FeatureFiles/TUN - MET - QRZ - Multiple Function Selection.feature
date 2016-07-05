
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # MET - QRZ - Multiple Function Selection (Tune Page Plot)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 11-FEB-15 (Updated 19-OCT-15)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Method files are located in the '\Typhoon\Config\methods\' folder
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Method files are located in the '\Typhoon\Config\methods\' folder
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # 19-OCT-15 - Updates to removed references to Acquisition Record and to enable testing of DT plot type where applicable.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-430)                 # The m/z plot should display a list of all available functions running within the method.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-458)                 # The user will be able to select a specific function to display on the plot.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-459)                 # Upon selection of the function, only that function should be displayed on the plot.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-460)                 # This is applicable to all the pop-outs for the m/z plots.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-461)                 # By default, the first function should be selected.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-462)                 # This is applicable for tuning methods as well as methods used for acquiring data.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
Feature: Multiple Function Selection (Live Tune Plot)
	In order to display Method Functions within the Live Tune Page Plot
	I want to be able to load a prevously saved / created method and check that the expected number of m/z functions are available for selection


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the browser is opened on the Tune page
 
# ---------------------------------------------------------------------------------------------------------------------------------------------------

@ignore
@updated
Scenario Outline: MET-MultipleFunctionSelection-01 - Manually Created Method (Non-HD)
	When an Acquisition '<Method Type>' with '<Lock Mass>' is manually created and loaded using Acquisition | Custom Tune
		And this Acquisition is viewed during tuning, within the '<Plot Type>'
	Then the individual '<Functions>' will be '<Enabled'> and can be selected within the 'Plot View' and 'Function 1' will be selected by default
		| Plot View |
		| MZ        |
		| BPI       |
		| TIC       |
					
		Examples: Methods with Lock Mass (Normal Tune Page plot)
		| Plot Type | Method Type | Lock Mass | Functions                                   | Enabled |
		| Tune Page | MS          | Yes       | 1:MS, 2:MS(LockMass)                        | Yes     |
		| Tune Page | MSMS        | Yes       | 1:MSMS, 2:MS(LockMass)                      | Yes     |
		| Tune Page | MSe         | Yes       | 1:MS(Low CE), 2:MS(High CE), 3:MS(LockMass) | Yes     |
		
		Examples: Methods with Lock Mass (Pop-out Plot)
		| Plot Type | Method Type | Lock Mass | Functions                                   | Enabled |
		| Pop-out   | MS          | Yes       | 1:MS, 2:MS(LockMass)                        | Yes     |
		| Pop-out   | MSMS        | Yes       | 1:MSMS, 2:MS(LockMass)                      | Yes     |
		| Pop-out   | MSe         | Yes       | 1:MS(Low CE), 2:MS(High CE), 3:MS(LockMass) | Yes     |
					
		Examples: Methods without Lock Mass (Normal Tune Page plot)
		| Plot Type | Method Type | Lock Mass | Functions                   | Enabled |
		| Tune Page | MS          | No        | 1:MS                        | No      |
		| Tune Page | MSMS        | No        | 1:MSMS                      | No      |
		| Tune Page | MSe         | No        | 1:MS(Low CE), 2:MS(High CE) | Yes     |

		Examples: Methods without Lock Mass (Pop-out Plot)
		| Plot Type | Method Type | Lock Mass | Functions                   | Enabled |
		| Pop-out   | MS          | No        | 1:MS                        | No      |
		| Pop-out   | MSMS        | No        | 1:MSMS                      | No      |
		| Pop-out   | MSe         | No        | 1:MS(Low CE), 2:MS(High CE) | Yes     |
		# Where functions are not selectable, 'Function 1' will automatically be selected but disabled
			
@ignore
@updated
Scenario Outline: MET-MultipleFunctionSelection-02 - Manually Created Method (HD)
	When an Acquisition '<Method Type>' with '<Lock Mass>' is manually created and loaded using Acquisition | Custom Tune
		And this Acquisition is viewed during tuning, within the '<Plot Type>'
	Then the individual '<Functions>' will be '<Enabled'> and can be selected within the 'Plot View' and 'Function 1' will be selected by default
		| Plot View |
		| MZ        |
	    | DT        |
		| BPI       |
		| TIC       |
	   	   				
		Examples: Methods with Lock Mass (Normal Tune Page plot)
		| Plot Type | Method Type | Lock Mass | Functions                                        | Enabled |
		| Tune Page | HD-MS       | Yes       | 1:HDMS, 2:MS (LockMass)                          | Yes     |
		| Tune Page | HD-MSMS     | Yes       | 1:HDMSMS, 2:MS (LockMass)                        | Yes     |
		| Tune Page | HD-MSe      | Yes       | 1:HDMS(Low CE), 2:HDMS(High CE), 3:MS (LockMass) | Yes     |
		
		Examples: Methods with Lock Mass (Pop-out Plot)
		| Plot Type | Method Type | Lock Mass | Functions                                       | Enabled |
		| Pop-out   | HD-MS       | Yes       | 1:HDMS, 2:MS(LockMass)                          | Yes     |
		| Pop-out   | HD-MSMS     | Yes       | 1:HDMSMS, 2:MS(LockMass)                        | Yes     |
		| Pop-out   | HD-MSe      | Yes       | 1:HDMS(Low CE), 2:HDMS(High CE), 3:MS(LockMass) | Yes     |

		Examples: Methods without Lock Mass (Normal Tune Page plot)
		| Plot Type | Method Type | Lock Mass | Functions                       | Enabled |
		| Tune Page | HD-MS       | No        | 1:HDMS                          | No      |
		| Tune Page | HD-MSMS     | No        | 1:HDMSMS                        | No      |
		| Tune Page | HD-MSe      | No        | 1:HDMS(Low CE), 2:HDMS(High CE) | Yes     |

		Examples: Methods without Lock Mass (Pop-out Plot)
		| Plot Type | Method Type | Lock Mass | Functions                       | Enabled |
		| Pop-out   | HD-MS       | No        | 1:HDMS                          | No      |
		| Pop-out   | HD-MSMS     | No        | 1:HDMSMS                        | No      |
		| Pop-out   | HD-MSe      | No        | 1:HDMS(Low CE), 2:HDMS(High CE) | Yes     |
		# Where functions are not selectable, 'Function 1' will automatically be selected but disabled

@ignore
@updated
Scenario Outline: MET-MultipleFunctionSelection-03 - Pre-Existing Method (Non-HD)
	When a pre-existing Acquisition '<Method Type>' is run using Acquisition | Custom Tune
		And this Acquisition is viewed during tuning, within the '<Plot Type>'
	Then the individual '<Functions>' will be '<Enabled'> and can be selected within the 'Plot View' and 'Function 1' will be selected by default
		| Plot View |
		| MZ        |
		| BPI       |
		| TIC       |
			   	
		Examples: Viewed in Normal Tune Page plot
		| Plot Type | Method Type          | Functions                    | Enabled |
		| Tune Page | ms.xml               | 1:MS                         | No      |
		| Tune Page | ms_dual_lockmass.xml | 1:MS, 2:MS(LockMass)         | Yes     |
		| Tune Page | ms_edc.xml           | 1:MS                         | No      |
		| Tune Page | ms_lockmass.xml      | 1:MS, 2:MS(LockMass)         | Yes     |
		| Tune Page | msms.xml             | 1:MSMS                       | No      |
		| Tune Page | tune.xml             | 1:Tune                       | No      |
		| Tune Page | TofMRM.xml           | 1:MRM, 2:MRM, 3:MS(LockMass) | Yes     |
		| Tune Page | mse.xml              | 1:MS(Low CE), 2:MS(High CE)  | Yes     |
		| Tune Page | mse_trend            | 1:MS(Low CE), 2:MS(High CE)  | Yes     |

		Examples: Viewed in Pop-out plot
		| Plot Type | Method Type          | Functions                    | Enabled |
		| Pop-out   | ms.xml               | 1:MS                         | No      |
		| Pop-out   | ms_dual_lockmass.xml | 1:MS, 2:MS(LockMass)         | Yes     |
		| Pop-out   | ms_edc.xml           | 1:MS                         | No      |
		| Pop-out   | ms_lockmass.xml      | 1:MS, 2:MS(LockMass)         | Yes     |
		| Pop-out   | msms.xml             | 1:MSMS                       | No      |
		| Pop-out   | tune.xml             | 1:Tune                       | No      |
		| Pop-out   | TofMRM.xml           | 1:MRM, 2:MRM, 3:MS(LockMass) | Yes     |
		| Pop-out   | mse.xml              | 1:MS(Low CE), 2:MS(High CE)  | Yes     |
		| Pop-out   | mse_trend            | 1:MS(Low CE), 2:MS(High CE)  | Yes     |
		# Where functions are not selectable, 'Function 1' will automatically be selected but disabled

@ignore
@updated
Scenario Outline: MET-MultipleFunctionSelection-04 - Pre-Existing Method (HD)
	When a pre-existing Acquisition '<Method Type>' is run using Acquisition | Custom Tune
		And this Acquisition is viewed during tuning, within the '<Plot Type>'
	Then the individual '<Functions>' will be '<Enabled'> and can be selected within the 'Plot View' and 'Function 1' will be selected by default
		| Plot View |
		| MZ        |
	    | DT        |
		| BPI       |
		| TIC       |
		
		Examples: Viewed in Normal Tune Page plot
		| Plot Type | Method Type    | Functions                        | Enabled |
		| Tune Page | hdms.xml       | 1:HDMS                           | No      |
		| Tune Page | hdmsms.xml     | 1:HDMSMS                         | No      |
		| Tune Page | HDMRM.xml      | 1:HDMRM, 2:HDMRM, 3:MS(LockMass) | Yes     |
		| Tune Page | mse_fullhd.xml | 1:HDMS(Low CE), 2:HDMS(High CE)  | Yes     |
		
		Examples: Viewed in Pop-out plot
		| Plot Type | Method Type    | Functions                        | Enabled |
		| Pop-out   | hdms.xml       | 1:HDMS                           | No      |
		| Pop-out   | hdmsms.xml     | 1:HDMSMS                         | No      |
		| Pop-out   | HDMRM.xml      | 1:HDMRM, 2:HDMRM, 3:MS(LockMass) | Yes     |
		| Pop-out   | mse_fullhd.xml | 1:HDMS(Low CE), 2:HDMS(High CE)  | Yes     |
		# Where functions are not selectable, 'Function 1' will automatically be selected but disabled
		
@ignore
@updated
Scenario: MET-MultipleFunctionSelection-05 - Custom Tune - Multiple Plot Type
	When an Acquisition multi-function method is run using Acquisition | Custom Tune 
		And this Acquisition is viewed during the recording, within the 'Tune Page' plot
		And is additionally viewed within a 'Pop-out' plot
	Then the 'Plot Type 1' function number can be changed without affecting the 'Plot Type 2' function selection
		| Plot Type 1 | Plot Type 2 |
		| Tune Page   | Pop-out     |
		| Pop-out     | Tune Page   |
		

# Removed - Acquisition Record is not currently not applicable in the current Quartz version
#
# Scenario: MET-MultipleFunctionSelection-06 - Acquisition Record - Multiple Plot Type
#	When an Acquisition multi-function method is set Recording using Acquisition | Record 
#		And this Acquisition is viewed during the recording, within the 'Tune Page' plot
#		And is additionally viewed within a 'Pop-out' plot
#	Then the 'Plot Type 1' function number can be changed without affecting the 'Plot Type 2' function selection
#		| Plot Type 1 | Plot Type 2 |
#		| Tune Page   | Pop-out     |
#		| Pop-out     | Tune Page   |
	
		
@ignore
@updated
Scenario Outline: MET-MultipleFunctionSelection-07 - Custom Tune - Manually Created
	Given that the following 'Setting Name' 'Values' are manually modified for '\Typhoon\Config\methods\ms.xml'
		| Setting Name | Values |
		| StartMass    | 50     |
		| EndMass      | 2000   |
		| ScanTime     | 5.0    |
		And and the file is Saved as 'ms-modified.xml'
	When the 'ms-modified.xml' method is run using Acquisition | XML Tuning
		And this Acquisition is viewed during tuning, within the '<Plot Type>'
	Then an individual 'Function 1' will be automatically selected
		But 'Function 1' will be disabled in each '<Plot View>'
		Examples: Viewed in Normal Tune Page plot
		| Plot Type | Plot View |
		| Tune Page | MZ        |
		| Tune Page | BPI       |
		| Tune Page | TIC       |

		Examples: Viewed in Pop-out plot
		| Plot Type | Plot View |
		| Pop-out   | MZ        |
		| Pop-out   | BPI       |
		| Pop-out   | TIC       |
				

# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END