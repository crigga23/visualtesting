
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # MET - QRZ - Acquisition (Create & Edit)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 27-JAN-15
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

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# 4.3.5.6                  # Method Editor
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-207)                 # The software will provide a method editor for creating basic instrument methods.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-208)                 # The software will configure the method editor for methods available.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-209)                 # The user will be able to create a basic method from the Manual Tuning screen.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-210)                 # The user will be able to edit an existing method from the Manual Tuning screen.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

#--------------------------#-------------------------------------------------------------------------------------------------------------------------
# 4.3.2.1                  # Support Lock Mass within the Quartz method editor
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-550)                 # User can add single LockMass or dual LockMass with Interval and Mass Window.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-553)                 # The software will provide the ability to add a single LockMass value, with Interval and Mass Window to the method.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-554)                 # The software will optionally provide the ability to add two LockMass values (Dual LockMass), with Interval and Mass Window to the method.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-555)                 # The LockMass / Dual LockMass (including Interval and Mass window) values can be saved with the method and recalled / modified later.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-559)                 # User input should be restricted to valid input and ranges for each field (field validation required).
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
Feature: Quartz Tune Acquisition - Create & Edit
	In order to Create and Edit acquisition methods 
	I want to have the ability to easily creation a method by selecting default parameters, or changing where appropriate
	and be able to Edit these values, once saved, so they are available to be used for acquisition data recording.

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the 'Tune' page has been accessed
 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: MET-AcquisitionCreateEdit-01 - Acquisition Options
	When the 'Tune Page' options are inspected
	Then then an 'Acquisition' option will be available with the following 'Elements'
		| Elements |
		| Create   |
		| Edit     |
		| Record   |

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: MET-AcquisitionCreateEdit-02 - Create - GUI Element Types
	When the Acquisition 'Create' option is selected
	Then these 'Elements' are available of a specific 'Type'
		| Elements           | Type                                                   |
		| Title              | String "Create Acquisition"                            |
		| Filename           | String (Alpha-numeric + space + "_" + "-")             |
		| Description        | String (multiple lines)                                |
		#------------------------------------------------------------------------------
		| Type               | Dropdown (MS, MSMS, MSe, HDMS, HDMSMS, HDMSe)          |
		| Data Format        | Dropdown (Continuum, Centroid)                         |
		| Run Duration       | Number                                                 |
		| Scan Time          | Number                                                 |
		| Run Duration Units | Text "minutes"                                         |
		| Scan Time Units    | Text "seconds"                                         |
		| Low Mass           | Number                                                 |
		| High Mass          | Number                                                 |
		| Precursor Mass     | Number                                                 |
		| Low CE             | Number                                                 |
		| High CE            | Number                                                 |
		#------------------------------------------------------------------------------
		| Use Lock Mass      | Checkbox                                               | 
		| Dual Lock Mass     | Checkbox                                               | 
		| Lock Mass 1	     | Number                                                 | 
	    | Lock Mass 2        | Number                                                 | 
		| Interval           | Number                                                 | 
		| Mass Window +-(Da) | Number                                                 | 
		#------------------------------------------------------------------------------
		| Save               | Button                                                 |
		| Cancel             | Button                                                 |
		| x                  | Button                                                 |

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: MET-AcquisitionCreateEdit-03 - Create - Dynamic Textfield State (General)
	When the Acquisition 'Create' option is selected
		And the <Type> option is set
	Then the <Text Field> will be in a set <State>
		Examples:
		| Type    | Text Field     | State    |
		| TofMS   | Precursor Mass | Disabled |
		| TofMS   | Low CE         | Disabled |
		| TofMS   | High CE        | Disabled |
		| TofMSMS | Precursor Mass | Enabled  |
		| TofMSMS | Low CE         | Disabled |
		| TofMSMS | High CE        | Disabled |
		| MSe     | Precursor Mass | Disabled |
		| MSe     | Low CE         | Enabled  |
		| MSe     | High CE        | Enabled  |
		| HD-MS   | Precursor Mass | Disabled |
		| HD-MS   | Low CE         | Disabled |
		| HD-MS   | High CE        | Disabled |
		| HD-MSMS | Precursor Mass | Enabled  |
		| HD-MSMS | Low CE         | Disabled |
		| HD-MSMS | High CE        | Disabled |
		| HD-MSe  | Precursor Mass | Disabled |
		| HD-MSe  | Low CE         | Enabled  |
		| HD-MSe  | High CE        | Enabled  |

Scenario Outline: MET-AcquisitionCreateEdit-04 - Create - Dynamic Textfield State (LockMass)
	When the Acquisition 'Create' option is selected
		And the <Use LockMass> and <Dual LockMass> option status is set
	Then the <Text Field> will be in a set <State>
		Examples:
		| Use Lock Mass | Dual Lock Mass | Text Field  | State    |
		| Un-ticked     | N/A            | Lock Mass 1 | Disabled |
		| Un-ticked     | N/A            | Lock Mass 2 | Disabled |
		| Un-ticked     | N/A            | Interval    | Disabled |
		| Un-ticked     | N/A            | Mass Window | Disabled |
		#--------------------------------------------------------
		| Ticked        | Un-ticked      | Lock Mass 1 | Enabled  |
		| Ticked        | Un-ticked      | Lock Mass 2 | Disabled |
		| Ticked        | Un-ticked      | Interval    | Enabled  |
		| Ticked        | Un-ticked      | Mass Window | Enabled  |
		#--------------------------------------------------------
		| Ticked        | Ticked         | Lock Mass 1 | Enabled  |
		| Ticked        | Ticked         | Lock Mass 2 | Enabled  |
		| Ticked        | Ticked         | Interval    | Enabled  |
		| Ticked        | Ticked         | Mass Window | Enabled  |
		
Scenario Outline: MET-AcquisitionCreateEdit-05 - Dynamic Save Availability
	When the Acquisition 'Create' option is selected
		And the <Filename> string is set
	Then the <Save> status will be set
		Examples:
		| Filename | Save     |
		| Provided | Enabled  |
		| Empty    | Disabled |

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: MET-AcquisitionCreateEdit-06 - Create - Default (Dropdown) Control Values
	When the Acquisition 'Create' option is selected
		Then the following 'Acquisition Settings' controls have 'Default' values
			| Acquisition Settings | Default   |
			| Type                 | TofMS     |
			| Data Format          | Continuum |

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: MET-AcquisitionCreateEdit-07 - Create - Default Values and Resolutions
	When the Acquisition 'Create' option is selected
		Then the following 'Acquisition Settings' controls have Default' values with a defined 'Resolution (dp)'
			| Acquisition Settings | Default  | Resolution (dp) |
			| Run Duration         | 10.00    | 2               |
			| Scan Time            | 1.000    | 3               |
			| Low Mass             | 50       | 0               |
			| High Mass            | 1200     | 0               |
			| Precursor Mass       | 785.8000 | 4               |
			| Low CE               | 10       | 0               |
			| High CE              | 30       | 0               |
			| Lock Mass 1          | 556.28   | 2               |
			| Lock Mass 2          | 278.11   | 2               |
			| Interval             | 15       | 0               |
			| Mass Windows +- (Da) | 1.0      | 1               |
			# Values will be set as part of FW#2997

Scenario: MET-AcquisitionCreateEdit-08 - Create - Min / Max Ranges
	When the Acquisition 'Create' option is selected
		Then the following 'Acquisition Settings' cannot be set outside the 'Min' 'Max' range
			| Acquisition Settings | Min     | Max        |
			| Run Duration         | 0.10    | 1000.00    |
			| Scan Time            | 0.005   | 10.000     |
			| Low Mass             | 10      | 99000      |
			| High Mass            | 20      | 100000     |
			| Precursor Mass       | 20.0000 | 32000.0000 |
			| Low CE               | 0       | 200        |
			| High CE              | 0       | 200        |
			| Lock Mass 1          | 2.00    | 100000.00  |
			| Lock Mass 2          | 2.00    | 100000.00  |
			| Interval             | 1       | 1000       |
			| Mass Windows +- (Da) | 0.1     | 10.0       |
			# Values will be set as part of FW#2997

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: MET-AcquisitionCreateEdit-09 - Create - Create but Don't Save
	When the Acquisition 'Create' option is selected
		And a unique 'Filename' is specified
		And 'Cancel' is selected
		And the Acquisition 'Edit' option is selected
	Then the previously specified 'Filename' is not available in the method list

Scenario: MET-AcquisitionCreateEdit-10 - Create - Create and Save
	When the Acquisition 'Create' option is selected
		And a unique 'Filename' is specified
		And 'Save' is selected
		And the Acquisition 'Edit' option is selected
	Then the previously specified 'Filename' will be available in the method list

Scenario: MET-AcquisitionCreateEdit-11 - Create - Attempt to Save Non-Unique Filename
	When the Acquisition 'Create' option is selected
		And a non-unique 'Filename' is specified
		And 'Save' is selected
	Then an appropriate warning is issued
		And the Save option is disabled

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: MET-AcquisitionCreateEdit-12 - Edit - Create using Defaults, Save and Re-open (Edit)
	When the Acquisition 'Create' option is selected
		And a unique 'Filename' is specified
		And the remaining 'Parameters' are left as Defaults
			| Parameters           |
			| Description          |
			#-----------------------
			| Type                 |
			| Data Format          |
			| Run Duration         |
			| Scan Time            |
			| Low Mass             |
			| High Mass            |
			| Precursor Mass       |
			| Low CE               |
			| High CE              |
			#-----------------------
			| Use Lock Mass        |
			| Dual Lock Mass       |
			| Lock Mass 1          |
			| Lock Mass 2          |
			| Interval             |
			| Mass Windows +- (Da) |
		And 'Save' is selected and the dialog is 'Closed'
		And the Acquisition 'Edit' option is selected
		And the previously saved method is selected from the list
	Then the previously specified defaults have been retained

Scenario: MET-AcquisitionCreateEdit-13 - Edit - Create using non-Defaults, Save and Re-open (Edit)
	When the Acquisition 'Create' option is selected
		And a unique 'Filename' is specified
		And the remaining 'Parameters' are changed from their Defaults
			| Parameters           |
			| Description          |
			#-----------------------
			| Type                 |
			| Data Format          |
			| Run Duration         |
			| Scan Time            |
			| Low Mass             |
			| High Mass            |
			| Precursor Mass       |
			| Low CE               |
			| High CE              |
			#-----------------------
			| Use Lock Mass        | 
			| Dual Lock Mass       | 
			| Lock Mass 1	       | 
	        | Lock Mass 2          | 
		    | Interval             | 
			| Mass Windows +- (Da) |
		And 'Save' is selected and the dialog is 'Closed'
		And the Acquisition 'Edit' option is selected
		And the previously saved method is selected from the list
	Then the previously specified non-default parameters have been retained

Scenario: MET-AcquisitionCreateEdit-14 - Edit - Open Existing, Change Parameters, Save and Re-open (Edit)
	Given that an Acquisition method has already been created and Saved
	When this Acquisition method is opened for 'Edit'
		And the 'Parameters' are changed from their current settings
			| Parameters           |
			| Description          |
			#-----------------------
			| Type                 |
			| Data Format          |
			| Run Duration         |
			| Scan Time            |
			| Low Mass             |
			| High Mass            |
			| Precursor Mass       |
			| Low CE               |
			| High CE              |
			#-----------------------
			| Use Lock Mass        |
			| Dual Lock Mass       |
			| Lock Mass 1          |
			| Lock Mass 2          |
			| Interval             |
			| Mass Windows +- (Da) |
		And 'Save' is selected and the dialog is 'Closed'
		And the same Acquisition method is opened again
	Then the newly saved parameters have been retained

Scenario: MET-AcquisitionCreateEdit-15 - Edit - Open Existing, Change Parameters and Name, Save and Re-open (Edit)
	Given that an Acquisition method has already been created and Saved
	When this Acquisition method is opened for 'Edit'
		And the 'Parameters' are changed from their current settings
			| Parameters           |
			| Description          |
			#-----------------------
			| Type                 |
			| Data Format          |
			| Run Duration         |
			| Scan Time            |
			| Low Mass             |
			| High Mass            |
			| Precursor Mass       |
			| Low CE               |
			| High CE              |
			#-----------------------
			| Use Lock Mass        |
			| Dual Lock Mass       |
			| Lock Mass 1          |
			| Lock Mass 2          |
			| Interval             |
			| Mass Windows +- (Da) |
		And the Filename is also changed from its current value
		And 'Save' is selected and the dialog is 'Closed'
	Then there should be two methods available for edit (original and new)
		And the 'Original' method will have the original parameter settings
		And the 'New' method will have the new parameter settings
		
Scenario: MET-AcquisitionCreateEdit-16 - Edit - Edit and Change Filename
	Given that an existing method is available
	When the Acquisition 'Edit' option is selected
		And the existing method is opened
		And the 'Filename' is changed to a 'Unique Filename'
		And 'Save' is selected
		And the Acquisition 'Edit' option is selected again
	Then the 'Filename' and the newly saved 'Unique Filename' are both available and can be opened
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
