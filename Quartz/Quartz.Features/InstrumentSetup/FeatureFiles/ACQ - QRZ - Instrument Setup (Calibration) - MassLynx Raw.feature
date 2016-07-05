 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # ACQ - QRZ - Instrument Setup (Calibration) - Multi Function Acquisition
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 12-FEB-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Sample vial set to 'A' (Sodium Formate) and Baffle set to Sample position
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Calibration solution be available for Sample fluidics and Baffle set to Sample position
#                          # There should be a good Smple beam available with peaks consistent with the expected Calibration solution
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
# (SS-132)                 #	The user will be able to automatically calibrate and setup the MS in all the supported modes of the instrument over different mass ranges using the Dev Console.  
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-469)                 #	The user will access the Instrument setup page from the Instrument tab in the Dev Console.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-473)                 #	The software will allow the user to select what polarity is enable or disable prior to running the setup process
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


##
#
# This feature file needs writing - currently this is just a copy and paste from another feature file. This new test can be shorter and focus purely on the generation of polynomials
#
##
@CR_feature_needs_refactor
@ignore
Feature: Instrument Setup (Calibration) - MassLynx Raw
	In order to acquire multi function methods and have each function calibrated properly
	I want to be able to check the calibration used for each method function
	So that I can compare this with a set of MS Method baselines slot calibrations		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given I have set positive and negative ADC values
		And the Instrument Setup page is accessed	
		And all toggles are set to OFF
		And Instrument Setup Calibration has been run successfully for the following 'X' slots
			| Mass                   | POS RES | NEG RES | POS SENS | NEG SENS |
			| Mass Calibration 600   |         | X       | X        |          |
			| Mass Calibration 1200  | X       | X       | X        | X        |
			| Mass Calibration 2000  | X       |         | X        |          |
			| Mass Calibration 5000  | X       |         | X        |          |
			| Mass Calibration 8000  | X       | X       |          | X        |
			#| Mass Calibration 14000 |         |         |          |          |
			#| Mass Calibration 32000 |         |         |          | X        |
			#| Mass Calibration 70000 | X       |         |          |          |
		And a baseline MS Method acquisition has been run to determine / record the calibration polynomials for each 'X' slot
		And none of the 'X' slot polynomials are zero
		# Mass in the above table corresponds to 'High Mass' in an Acquisition Create method or 'EndMass' in a Custom Tune XML file
		# The polynomial data can be found in the .RAW folder '_header.txt' file for each acquisition


# ---------------------------------------------------------------------------------------------------------------------------------------------------
	@ignore
	@Obsolete
	Scenario Outline: ACQ-01 - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Acquisition Create
		Given a new Acquisition Method '<Method Type>' is created using Acquisition Create
			And the method has a short Run Duration with Low Mass <Low Mass>, High Mass <High Mass>, Lock Mass 1 <LockMass 1> and Lock Mass 2 <LockMass 2> parameters set
			And the Method is Saved
			And the mode is <Mode> and the polarity is <Polarity>
		When this Method is run using Acquisition 'Record' 
			And the acquisition runs to completion
		#When the newly saved Method is run via Acquisition Record and the acquisition runs to completion
			And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
		Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
			Examples: MSe Methods
			| Method Type        | LockMass 1 | LockMass 2 | Low Mass | High Mass | Polarity | Mode        | Slot Calibration Used                                |
			| MSe                | N/A        | N/A        | 5000     | 8000      | Positive | Resolution  | 1: POS RES 8000,  2: POS RES 8000                    |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| MSe + Single LM    | 556.27     | N/A        | 100      | 5000      | Positive | Sensitivity | 1: POS SENS 5000, 2: POS SENS 5000, 3: POS SENS 5000 |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| MSe + Dual LM      | 556.27     | 278.1      | 100      | 600       | Negative | Resolution  | 1: NEG RES 600,   2: NEG RES 600  , 3: NEG RES 600   |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| HD-MSe             | N/A        | N/A        | 5000     | 8000      | Negative | Sensitivity | 1: NEG SENS 8000, 2: NEG SENS 8000                   |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| HD-MSe + Single LM | 556.27     | N/A        | 100      | 2000      | Positive | Resolution  | 1: POS RES  2000, 2: POS RES  2000, 3: POS RES 2000  |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| HD-MSe + Dual LM   | 556.27     | 278.1      | 100      | 600       | Positive | Sensitivity | 1: POS SENS 600 , 2: POS SENS 600 , 3: POS SENS 600  |
			#----------------------------------------------------------------------------------------------------------------------------------------------------------
			# The slot calibration for the High Mass specified within a method will be used for every function within that method.

			Examples: MSe Methods - No Calibration
			| Method Type | LockMass 1 | LockMass 2 | Low Mass | High Mass | Polarity | Mode       | Slot Calibration Used         |
			| MSe          | N/A        | N/A        | 50       | 500       | Positive | Resolution | 1: None (N/A),  2: None (N/A) |
			#----------------------------------------------------------------------------------------------------------------------------------------------------------


	Scenario Outline: ACQ-01b - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Acquisition Create
		Given a new Acquisition Method '<Method Type>' XML file is created called '<Method Name>'
	#		And the XML file <Method Name> method has a short Run Duration with Low Mass <Low Mass>, High Mass <High Mass>, Lock Mass 1 <LockMass 1> and Lock Mass 2 <LockMass 2> parameters set
	#		And the mode is <Mode> and the polarity is <Polarity>
	#	When the '<Method Name>' is selected to be run via Acquisition | Custom Tune XML
	#		And during the method run an acquisition is 'Started'
	#		And the acquisition is Stopped after '10' seconds
	#		And Tuning is aborted
	#		And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
	#	Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
			Examples: MSe Methods
			| Test Name          | Method Type | LockMass 1 | LockMass 2 | Low Mass | High Mass | Polarity | Mode        | Slot Calibration Used                                | Method Name                                                  |
			| MSe                | MSe         | N/A        | N/A        | 5000     | 8000      | Positive | Resolution  | 1: POS RES 8000,  2: POS RES 8000                    | Automation_MultiFunctionAcquisition_MSe.xml                  |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| MSe + Single LM    | MSe         | 556.27     | N/A        | 100      | 5000      | Positive | Sensitivity | 1: POS SENS 5000, 2: POS SENS 5000, 3: POS SENS 5000 | Automation_MultiFunctionAcquisition_MSe_SingleLockMass.xml   |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| MSe + Dual LM      | MSe         | 556.27     | 278.1      | 100      | 600       | Negative | Resolution  | 1: NEG RES 600,   2: NEG RES 600  , 3: NEG RES 600   | Automation_MultiFunctionAcquisition_MSe_DualLockMass.xml     |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| HD-MSe             | HDMSe       | N/A        | N/A        | 5000     | 8000      | Negative | Sensitivity | 1: NEG SENS 8000, 2: NEG SENS 8000                   | Automation_MultiFunctionAcquisition_HDMSe.xml                |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| HD-MSe + Single LM | HDMSe       | 556.27     | N/A        | 100      | 2000      | Positive | Resolution  | 1: POS RES  2000, 2: POS RES  2000, 3: POS RES 2000  | Automation_MultiFunctionAcquisition_HDMSe_SingleLockMass.xml |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| HD-MSe + Dual LM   | HDMSe       | 556.27     | 278.1      | 100      | 600       | Positive | Sensitivity | 1: POS SENS 600 , 2: POS SENS 600 , 3: POS SENS 600  | Automation_MultiFunctionAcquisition_HDMSe_DualLockMass.xml   |
			#----------------------------------------------------------------------------------------------------------------------------------------------------------
			# The slot calibration for the High Mass specified within a method will be used for every function within that method.

			Examples: MSe Methods - No Calibration
			| Test Name            | Method Type | LockMass 1 | LockMass 2 | Low Mass | High Mass | Polarity | Mode       | Slot Calibration Used         | Method Name                                               |
			| MSe + No Calibration | MSe         | N/A        | N/A        | 50       | 500       | Positive | Resolution | 1: None (N/A),  2: None (N/A) | Automation_MultiFunctionAcquisition_MSe_NoCalibration.xml |
			#----------------------------------------------------------------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------------------------------------------------------
	Scenario Outline: ACQ-02 - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune (Pre-existing)
		Given the mode is <Mode> and the polarity is <Polarity>
			And a new '<Method Name>' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And Tuning is aborted
			#And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
		#Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
			Examples:
			| Method Name          | LockMass 1 | LockMass 2 | StartMass | EndMass | Polarity | Mode        | Slot Calibration Used                                |
			| mse.xml              | N/A        | N/A        | 100       | 1200    | Positive | Resolution  | 1: POS RES 1200,  2: POS RES 1200                    |
			| mse_fullhd.xml       | N/A        | N/A        | 100       | 1200    | Positive | Sensitivity | 1: POS SENS 1200, 2: POS SENS 1200                   |
			| mse_trend            | N/A        | N/A        | 100       | 1200    | Negative | Resolution  | 1: NEG RES 1200,  2: NEG RES 1200                    |
			#------------------------------------------------------------------------------------------------------------------------------
			| ms_lockmass.xml      | 556.27     | N/A        | 100       | 1200    | Negative | Sensitivity | 1: NEG SENS 1200, 2: NEG SENS 1200                   |
			| ms_dual_lockmass.xml | 556.27     | 278.1      | 100       | 1200    | Positive | Resolution  | 1: POS RES 1200,  2: POS RES 1200                    |
			#------------------------------------------------------------------------------------------------------------------------------  
			| TofMRM.xml           | N/A        | N/A        | 50        | 1200    | Positive | Sensitivity | 1: POS SENS 1200, 2: POS SENS 1200, 3: POS SENS 1200 |
			| HDMRM.xml            | N/A        | N/A        | 50        | 1200    | Negative | Resolution  | 1: NEG RES 1200,  2: NEG RES 1200,  3: NEG RES 1200  |
			| HSMRM.xml            | N/A        | N/A        | 50        | 1200    | Negative | Sensitivity | 1: NEG SENS 1200, 2: NEG SENS 1200, 3: NEG SENS 1200 |
			#------------------------------------------------------------------------------------------------------------------------------------------------   
			# The slot calibration for the highest EndMass specified within a method will be used for every function within that method.


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#	Scenario Outline: ACQ-03 - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune (Multi Function Methods - Maually Created MS)
#		Given a new <Method Name> XML file is manually created and saved with <Functions> of <Type> with <LockMass 1> <LockMass 2> <StartMass> and <EndMass>
#			And the mode is <Mode> and the polarity is <Polarity>
#			And '<Method Name>' is selected to be run via Acquisition | Custom Tune XML
#			And during the method run an acquisition is 'Started'
#			And the acquisition is Stopped after '10' seconds
#			And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
#		Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
#			Examples: MS Methods
#			| Method Name | Functions | Type  | LockMass 1 | LockMass 2 | StartMass | EndMass | Polarity | Mode        | Slot Calibration Used |
#			| MS 8        | 1         | MS    | N/A        | N/A        | 50        | 500     | Positive | Resolution  | 1: POS RES 70000      |
#			|             | 2         | MS    | N/A        | N/A        | 501       | 1000    | Positive | Resolution  | 2: POS RES 70000      |
#			|             | 3         | MS    | N/A        | N/A        | 1001      | 2000    | Positive | Resolution  | 3: POS RES 70000      |
#			|             | 4         | MS    | N/A        | N/A        | 2001      | 5000    | Positive | Resolution  | 4: POS RES 70000      |
#			|             | 5         | MS    | N/A        | N/A        | 5001      | 8000    | Positive | Resolution  | 5: POS RES 70000      |
#			|             | 6         | MS    | N/A        | N/A        | 8001      | 14000   | Positive | Resolution  | 6: POS RES 70000      |
#			|             | 7         | MS    | N/A        | N/A        | 14001     | 32000   | Positive | Resolution  | 7: POS RES 70000      |
#			|             | 8         | MS    | N/A        | N/A        | 32001     | 70000   | Positive | Resolution  | 8: POS RES 70000      |
#			#------------------------------------------------------------------------------------------------------------
#			| MS 3        | 1         | MS    | N/A        | N/A        | 50        | 500     | Positive | Sensitivity | 1: POS SENS 2000      |
#			|             | 2         | MS    | N/A        | N/A        | 50        | 1000    | Positive | Sensitivity | 2: POS SENS 2000      |
#			|             | 3         | MS    | N/A        | N/A        | 50        | 2000    | Positive | Sensitivity | 3: POS SENS 2000      |
#			#------------------------------------------------------------------------------------------------------------
#			| MS 3 + LM1  | 1         | MS    | N/A        | N/A        | 50        | 500     | Negative | Resolution  | 1: NEG RES 8000       |
#			|             | 2         | MS    | N/A        | N/A        | 50        | 7900    | Negative | Resolution  | 2: NEG RES 8000       |
#			|             | 3         | MS-LM | 556.27     | N/A        | N/A       | N/A     | Negative | Resolution  | 3: NEG RES 8000       |
#			#------------------------------------------------------------------------------------------------------------
#			# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.
#
#			Examples: MS Method - No Calibration 
#			| Method Name | Functions | Type | LockMass 1 | LockMass 2 | StartMass | EndMass | Polarity | Mode        | Slot Calibration Used |
#			| MS 3 None   | 1         | MS   | N/A        | N/A        | 50        | 5000    | Negative | Sensitivity | 1: None (N/A)         |
#			|             | 2         | MS   | N/A        | N/A        | 50        | 14000   | Negative | Sensitivity | 2: None (N/A)         |
#			|             | 3         | MS   | N/A        | N/A        | 50        | 70000   | Negative | Sensitivity | 3: None (N/A)         |
#			#---------------------------------------------------------------------------------------------------------------------------------------


	Scenario: ACQ-03a - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune (Multi Function Methods - Manually Created MS) - 8 Functions
		Given a new 'MS_8Functions.xml' XML file is manually created and saved with the following functions 
			| Functions | Type  | LockMass 1 | LockMass 2 | StartMass | EndMass |
			| 1         | MS    | N/A        | N/A        | 50        | 500     |
			| 2         | MS    | N/A        | N/A        | 501       | 1000    |
			| 3         | MS    | N/A        | N/A        | 1001      | 2000    |
			| 4         | MS    | N/A        | N/A        | 2001      | 5000    |
			| 5         | MS    | N/A        | N/A        | 5001      | 8000    |
			| 6         | MS    | N/A        | N/A        | 8001      | 14000   |
			| 7         | MS    | N/A        | N/A        | 14001     | 32000   |
			| 8         | MS    | N/A        | N/A        | 32001     | 70000   |
			And the mode is Resolution and the polarity is Positive
			And 'MS_8Functions.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
		Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
			| Slot Calibration Used |
			| 1: POS RES 70000      |
			| 2: POS RES 70000      |
			| 3: POS RES 70000      |
			| 4: POS RES 70000      |
			| 5: POS RES 70000      |
			| 6: POS RES 70000      |
			| 7: POS RES 70000      |
			| 8: POS RES 70000      |
	# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.


	Scenario: ACQ-03b - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune (Multi Function Methods - Manually Created MS)	- 3 functions	
		Given a new 'MS_3Functions.xml' XML file is manually created and saved with the following functions
			| Functions | Type  | LockMass 1 | LockMass 2 | StartMass | EndMass |
			| 1         | MS    | N/A        | N/A        | 50        | 500     |
			| 2         | MS    | N/A        | N/A        | 50        | 1000    |
			| 3         | MS    | N/A        | N/A        | 50        | 2000    |
			And the mode is Sensitivity and the polarity is Positive
			And 'MS_3Functions.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
		Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
			| Slot Calibration Used |
			| 1: POS SENS 2000      |
			| 2: POS SENS 2000      |
			| 3: POS SENS 2000      |
	# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.


	Scenario: ACQ-03c - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune (Multi Function Methods - Manually Created MS
		Given a new 'MS_2Functions_SingleLockMass.xml' XML file is manually created and saved with the following functions
			| Functions | Type     | LockMass 1 | LockMass 2 | StartMass | EndMass |
			| 1         | MS       | N/A        | N/A        | 50        | 500     |
			| 2         | MS       | N/A        | N/A        | 50        | 7900    |
			| 3         | LockMass | 556.27     | N/A        | N/A       | N/A     |
			And the mode is Resolution and the polarity is Negative
			And 'MS_2Functions_SingleLockMass.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
		Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
			| Slot Calibration Used |
			| 1: NEG RES 8000       |
			| 2: NEG RES 8000       |
			| 3: NEG RES 8000       |
	# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.


	Scenario: ACQ-03d - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune (Multi Function Methods - Manually Created MS) - No Appropriate Calibration
		Given a new 'MS_3Functions_NoCalibration.xml' XML file is manually created and saved with the following functions
			| Functions | Type | LockMass 1 | LockMass 2 | StartMass | EndMass |
			| 1         | MS   | N/A        | N/A        | 50        | 5000    |
			| 2         | MS   | N/A        | N/A        | 50        | 14000   |
			| 3         | MS   | N/A        | N/A        | 50        | 70000   |
			And the mode is Sensitivity and the polarity is Negative
			And 'MS_3Functions_NoCalibration.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
		Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
			| Slot Calibration Used |
			| 1: None (N/A)         |
			| 2: None (N/A)         |
			| 3: None (N/A)         |
		



# ---------------------------------------------------------------------------------------------------------------------------------------------------
#Scenario Outline: ACQ-04 - InstrumentSetupMultiFunctionAcquisition - Custom Tune Data Acquired Using (Multi Function Methods - Maually Created MRM)
#	Given a new <Method Name> XML file is created and saved with <Functions> of <Type> with <LockMass 1> <LockMass 2> <StartMass> <EndMass> and <SetMass>
#		And the mode is <Mode> and the polarity is <Polarity>
#		And '<Method Name>' is selected to be run via Acquisition | Custom Tune XML
#		And during the method run an acquisition is 'Started'
#		And the acquisition is Stopped after '10' seconds
#		And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
#	Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
#		Examples: 
#		| Method Name | Functions | Type  | LockMass 1 | LockMass 2 | StartMass | EndMass | SetMass | Polarity | Mode        | Slot Calibration Used |
#		| MRM 4       | 1         | MRM   | N/A        | N/A        | 50        | 500     | 430.9   | Positive | Resolution  | 1: POS RES 5000       |
#		|             | 2         | MRM   | N/A        | N/A        | 501       | 1000    | 566.9   | Positive | Resolution  | 2: POS RES 5000       |
#		|             | 3         | MRM   | N/A        | N/A        | 1001      | 2000    | 1042.8  | Positive | Resolution  | 3: POS RES 5000       |
#		|             | 4         | MRM   | N/A        | N/A        | 2001      | 5000    | 2062.6  | Positive | Resolution  | 4: POS RES 5000       |
#		#--------------------------------------------------------------------------------------------------------------------- 
#		| MRM 4 + LM2 | 1         | MRM   | N/A        | N/A        | 50        | 500     | 452.9   | Negative | Sensitivity | 1: POS SENS 32000     |
#		|             | 2         | MRM   | N/A        | N/A        | 50        | 32000   | 2900.5  | Negative | Sensitivity | 2: POS SENS 32000     |
#		|             | 3         | MRM   | N/A        | N/A        | 50        | 2000    | 1268.8  | Negative | Sensitivity | 3: POS SENS 32000     |
#		|             | 4         | MS-LM | 556.27     | 278.1      | N/A       | N/A     | N/A     | Negative | Sensitivity | 4: POS SENS 32000     |
#		#-------------------------------------------------------------------------------------------------------------------------------------------------
#		# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.
#
#		Examples: MRM Method - No Calibration
#		| Method Name | Functions | Type | LockMass 1 | LockMass 2 | StartMass | EndMass | SetMass | Polarity | Mode        | Slot Calibration Used |
#		| MRM 4 None  | 1         | MRM  | N/A        | N/A        | 50        | 2500    | 430.9   | Positive | Sensitivity | 1: None (N/A)         |
#		|             | 2         | MRM  | N/A        | N/A        | 501       | 3000    | 566.9   | Positive | Sensitivity | 2: None (N/A)         |
#		|             | 3         | MRM  | N/A        | N/A        | 1001      | 5000    | 1042.8  | Positive | Sensitivity | 3: None (N/A)         |
#		|             | 4         | MRM  | N/A        | N/A        | 2001      | 8000    | 2062.6  | Positive | Sensitivity | 4: None (N/A)         |
			#-------------------------------------------------------------------------------------------------------------------------------------------------

	Scenario: ACQ-04a - InstrumentSetupMultiFunctionAcquisition - Custom Tune Data Acquired Using (Multi Function Methods - Manually Created MRM)
		Given a new 'MRM_4Functions.xml' XML file is manually created and saved with the following functions
			| Functions | Type | LockMass 1 | LockMass 2 | StartMass | EndMass | SetMass |
			| 1         | MRM  | N/A        | N/A        | 50        | 500     | 430.9   |
			| 2         | MRM  | N/A        | N/A        | 501       | 1000    | 566.9   |
			| 3         | MRM  | N/A        | N/A        | 1001      | 2000    | 1042.8  |
			| 4         | MRM  | N/A        | N/A        | 2001      | 5000    | 2062.6  |	
			And the mode is Resolution and the polarity is Positive
			And 'MRM_4Functions.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
		Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
			| Slot Calibration Used |
			| 1: POS RES 5000       |
			| 2: POS RES 5000       |
			| 3: POS RES 5000       |
			| 4: POS RES 5000       |
	# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.


	Scenario: ACQ-04b - InstrumentSetupMultiFunctionAcquisition - Custom Tune Data Acquired Using (Multi Function Methods - Manually Created MRM)
		Given a new 'MRM_3Functions_DualLockMass.xml' XML file is manually created and saved with the following functions
			| Functions | Type     | LockMass 1 | LockMass 2 | StartMass | EndMass | SetMass |
			| 1         | MRM      | N/A        | N/A        | 50        | 500     | 452.9   |
			| 2         | MRM      | N/A        | N/A        | 50        | 32000   | 2900.5  |
			| 3         | MRM      | N/A        | N/A        | 50        | 2000    | 1268.8  |
			| 4         | LockMass | 556.27     | 278.1      | N/A       | N/A     | N/A     |	
			And the mode is Sensitivity and the polarity is Negative
			And 'MRM_3Functions_DualLockMass.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
		Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
			| Slot Calibration Used |
			| 1: POS SENS 32000     |
			| 2: POS SENS 32000     |
			| 3: POS SENS 32000     |
			| 4: POS SENS 32000     |
	# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.		


	Scenario: ACQ-04c - InstrumentSetupMultiFunctionAcquisition - Custom Tune Data Acquired Using (Multi Function Methods - Manually Created MRM)
		Given a new 'MRM_4Functions_NoCalibration.xml' XML file is manually created and saved with the following functions
			| Functions | Type | LockMass 1 | LockMass 2 | StartMass | EndMass | SetMass |
			| 1         | MRM  | N/A        | N/A        | 50        | 2500    | 430.9   |
			| 2         | MRM  | N/A        | N/A        | 501       | 3000    | 566.9   |
			| 3         | MRM  | N/A        | N/A        | 1001      | 5000    | 1042.8  |
			| 4         | MRM  | N/A        | N/A        | 2001      | 8000    | 2062.6  |	
			And the mode is Sensitivity and the polarity is Positive
			And 'MRM_4Functions_NoCalibration.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And the calibration polynomials in the new acquisition .RAW folder '_header.txt' file are determined
		Then these new polynomials will exactly match the 'baseline' polynomials for the <Slot Calibration Used>
			| Slot Calibration Used |
			| 1: None (N/A)         |
			| 2: None (N/A)         |
			| 3: None (N/A)         |
			| 4: None (N/A)         |
	# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END

