# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # ACQ - QRZ - Acquisition (Record)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 27-JAN-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Ensure the Sample Reservior is set to C and the Reference Reservior is set to B
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

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# 4.3.5.6                  # Method Editor
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-212)                 # The user will be able to run an existing method from the Manual Tuning screen.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

#--------------------------#-------------------------------------------------------------------------------------------------------------------------
# 4.3.2.1                  # Support Lock Mass within the Quartz method editor
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-558)                 # A user should be able to run a method saved with LockMass values and view the reference data in real time.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@Acquisition
Feature: ACQ - QRZ - Acquisition (Record)
	In order to Record acquisition data
	I want to be able to select a previously saved method and record data based on the details contained within in, so data of the expected type can be created 
	
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
Given that the Quartz Tune page is open
 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: ACQ-AcquisitionRecord-01 - Acquisition Options - Creating and Recording
When an Acquisition Method Type is created and Saved with a unique name using the '<Method XML Path>' custom xml file
	And this Method is run using Acquisition 'Record'
Then the Functions list is <Functions list is enabled> in the plot toolbar
	And the Main Sample Data is Selectable <Main Sample Data is Selectable> for real time viewing in the MZ plot window
	And the Lock Mass is Selectable <Lock Mass Sample Data is Selectable> for real time viewing in the MZ plot window
	And Tuning is aborted
	And a .RAW subfolder with the Method name will be created
	And the .RAW subfolder will contain a '_extern.inf' file
	And the .RAW subfolder will contain a 'DAT' file <DAT File> for each main Sample data Function
	And the .RAW subfolder will contain a 'IDX' file <IDX File> for each main Sample data Function
	And the .RAW subfolder will contain a 'STS' file <STS File> for each main Sample data Function
	And the .RAW subfolder will contain Mobility files <Mobility Data Files>
	And all .RAW subfolder files generated are non-zero in size
	# Standard Method Without Lock Mass Function
	@MiniSmoke
	@Osprey
	Examples:  Standard Method without lockmass - Osprey
	| Method Type | Lock Mass  | Functions list is enabled | Main Sample Data is Selectable | Lock Mass Sample Data is Selectable | Number | DAT File | IDX File | STS File | Mobility Data Files  | Method XML Path |
	| MS		  | None       | Disabled                  | false                          | false                               | 1      | true     | true     | true     | false                | MS\ms.xml       |
	| MSMS        | None       | Disabled                  | false                          | false                               | 1      | true     | true     | true     | false                | MSMS\msms.xml   |
	| MSe         | None       | Enabled                   | true                           | false                               | 2      | true     | true     | true     | false                | MSe\mse.xml     |

	@Peregrine
	Examples:  Standard Method without lockmass - Peregrine
	| Method Type | Lock Mass | Functions list is enabled | Main Sample Data is Selectable | Lock Mass Sample Data is Selectable | Number | DAT File | IDX File | STS File | Mobility Data Files  | Method XML Path |
	| MS          | None      | Disabled                  | false                          | false                               | 1      | true     | true     | true     | false                | MS\ms.xml       |
	| MSe         | None      | Enabled                   | true                           | false                               | 2      | true     | true     | true     | false                | MSe\mse.xml     |

	
	# HD Method Without Lock Mass Function
	@Osprey
	Examples:  HD without lockmass
	| Method Type | Lock Mass  | Functions list is enabled | Main Sample Data is Selectable | Lock Mass Sample Data is Selectable | Number | DAT File | IDX File | STS File | Mobility Data Files | Method XML Path      |
	| HDMS        | None       | Disabled                  | false                          | false                               | 1      | true     | true     | true     | true                | HDMS\hdms.xml        |
	| HDMSMS      | None       | Disabled                  | false                          | false                               | 1      | true     | true     | true     | true                | HDMSMS\hdmsms.xml    |
	| HDMSe       | None       | Enabled                   | true                           | false                               | 2      | true     | true     | true     | true                | HDMSe\mse_fullhd.xml |
	
	# Standard Method With Lock Mass Function
	@Osprey
	Examples:  Standard Method with lockmass - Osprey
	| Method Type | Lock Mass    | Functions list is enabled | Main Sample Data is Selectable | Lock Mass Sample Data is Selectable | Number | DAT File | IDX File | STS File | Mobility Data Files | Method XML Path  |
	| MS          | Single       | Enabled                   | true                           | true                                | 2      | true     | true     | true     | false               | MS\ms_lockmass.xml          |
	| MS          | Dual         | Enabled                   | true                           | true                                | 2      | true     | true     | true     | false               | MS\ms_dual_lockmass.xml     |
	| MSMS        | Single       | Enabled                   | true                           | true                                | 2      | true     | true     | true     | false               | MSMS\msms_lockmass.xml      |
	| MSMS        | Dual         | Enabled                   | true                           | true                                | 2      | true     | true     | true     | false               | MSMS\msms_dual_lockmass.xml |
	| MSe         | Single       | Enabled                   | true                           | true                                | 3      | true     | true     | true     | false               | MSe\mse_lockmass.xml        |
	| MSe         | Dual         | Enabled                   | true                           | true                                | 3      | true     | true     | true     | false               | MSe\mse_dual_lockmass.xml   |

	@Peregrine
	Examples:  Standard Method with lockmass - Peregrine
	| Method Type | Lock Mass    | Functions list is enabled | Main Sample Data is Selectable | Lock Mass Sample Data is Selectable | Number | DAT File | IDX File | STS File | Mobility Data Files | Method XML Path  |
	| MS          | Single       | Enabled                   | true                           | true                                | 2      | true     | true     | true     | false               | MS\ms_lockmass.xml          |
	| MS          | Dual         | Enabled                   | true                           | true                                | 2      | true     | true     | true     | false               | MS\ms_dual_lockmass.xml     |
	| MSe         | Single       | Enabled                   | true                           | true                                | 3      | true     | true     | true     | false               | MSe\mse_lockmass.xml        |
	| MSe         | Dual         | Enabled                   | true                           | true                                | 3      | true     | true     | true     | false               | MSe\mse_dual_lockmass.xml   |

	# HD Method With Lock Mass Function
	@Osprey
	Examples: HDMS and HDMSe with lockmass
	| Method Type | Lock Mass   | Functions list is enabled | Main Sample Data is Selectable | Lock Mass Sample Data is Selectable | Number | DAT File | IDX File | STS File | Mobility Data Files | Method XML Path                    |
	| HDMS        | Single      | Enabled                   | true                           | true                                | 2      | true     | true     | true     | true                | HDMS\hdms_lockmass.xml             |
	| HDMS        | Dual        | Enabled                   | true                           | true                                | 2      | true     | true     | true     | true                | HDMS\hdms_dual_lockmass.xml        |
	| HDMSe       | Single      | Enabled                   | true                           | true                                | 3      | true     | true     | true     | true                | HDMSe\mse_fullhd_lockmass.xml      |
	| HDMSe       | Dual        | Enabled                   | true                           | true                                | 3      | true     | true     | true     | true                | HDMSe\mse_fullhd_dual_lockmass.xml |

	@Osprey
	Examples: HDMSMS with lockmass
	| Method Type | Lock Mass     | Functions list is enabled | Main Sample Data is Selectable | Lock Mass Sample Data is Selectable | Number | DAT File | IDX File | STS File | Mobility Data Files | Method XML Path                    |
	| HDMSMS      | Single        | Enabled                   | true                           | true                                | 2      | true     | true     | true     | true                | HDMSMS\hdmsms_lockmass.xml         |
	| HDMSMS      | Dual          | Enabled                   | true                           | true                                | 2      | true     | true     | true     | true                | HDMSMS\hdmsms_dual_lockmass.xml    |
	
	# Where applicable only a single LockMass function will be added to the data, regardless of whether the LockMass selected within the method is Single or Dual 
	# If LockMass is selected within the Method, then a LockMass function will only be added to the data if the LockMass peak selected within the method is found in the data
	# If LockMass is selected within the Method, then LockMass data should be visible after selecting the last Function from the MZ plot dropdown

# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END