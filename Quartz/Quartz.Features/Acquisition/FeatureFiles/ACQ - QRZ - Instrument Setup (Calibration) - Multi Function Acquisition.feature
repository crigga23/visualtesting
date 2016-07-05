 
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
# (SS-173)                 #	The user will be able to start a manual tune record
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-174)                 #	The user will be able to stop a manual tune record
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-177)                 #	The user will be able to select a locally stored method and run it
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# CR ID: FW#9125           #    Mass Range not rest after lock mass setup (Scenario ACQ-14)
# -------------------------#------------------------------------------------------------------------------------------------------------------------

@InstrumentSetupAcquisition
Feature: ACQ - QRZ - Instrument Setup (Calibration) - Multi Function Acquisition
	In order to acquire multi function methods and have each function calibrated properly
	I want to be able to check the calibration used for each method function

# ---------------------------------------------------------------------------------------------------------------------------------------------------

Background:
	Given I have set positive and negative ADC values
		And the browser is opened on the Tune page
		And reference fluidics are set to 
			| Baffle Position | Reservoir | Flow Path | Flow Rate |
			| Reference       | B         | Infusion  | 40.00     |
		And the reference fluidic level is not less than '25.00' minutes
		And the instrument has a beam
		And the Instrument Setup page is accessed	
		And the Instrument Setup process is not running
		And ADC Setup, Instrument Setup Detector Setup and Resolution Optimisation has been run for all modes
		And Instrument Setup Calibration has been run successfully for the following 'X' slots
			| Mass                   | POS RES | NEG RES | POS SENS | NEG SENS |
			| Mass Calibration 1000  |         | X       | X        |          |
			| Mass Calibration 2000  | X       | X       | X        | X        |
			| Mass Calibration 4000  | X       |         | X        |          |
			#| Mass Calibration 5000  | X       |         | X        |          |
			#| Mass Calibration 8000  | X       | X       |          | X        |
			#| Mass Calibration 14000 |         |         |          |          |
			#| Mass Calibration 32000 |         |         |          | X        |
			#| Mass Calibration 70000 | X       |         |          |          |	
		# Calibration above 8000 is not required.	
		# Mass in the above table corresponds to 'High Mass' in an Acquisition Create method or 'EndMass' in a Custom Tune XML file

# ---------------------------------------------------------------------------------------------------------------------------------------------------

	Scenario Outline: ACQ-01 - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune
		Given a new Acquisition Method '<Method Type>' XML file is created called '<Method Name>'
			And the XML file <Method Name> method has a short Run Duration with Low Mass <Low Mass>, High Mass <High Mass>, Lock Mass 1 <LockMass 1> and Lock Mass 2 <LockMass 2> parameters set
			And that the browser is opened on the Tune page
			And the mode is <Mode> and the polarity is <Polarity>
		When the '<Method Name>' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And Tuning is aborted
		Then the acquisition has had the calibration applied for mass <High Mass>, polarity <Polarity> and mode <Mode>
			Examples: MSe Methods
			| Test Name          | Method Type | LockMass 1 | LockMass 2 | Low Mass | High Mass | Polarity | Mode        | Slot Calibration Used                                  | Method Name                                                  |
			| MSe                | MSe         | N/A        | N/A        | 1900     | 2000      | Positive | Resolution  | 1: POS RES 2000,  2: POS RES 2000                      | Automation_MultiFunctionAcquisition_MSe.xml                  |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| MSe + Single LM    | MSe         | 556.27     | N/A        | 3900     | 4000      | Positive | Sensitivity | 1: POS SENS 4000, 2: POS SENS 4000, 3: POS SENS 4000   | Automation_MultiFunctionAcquisition_MSe_SingleLockMass.xml   |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| MSe + Dual LM      | MSe         | 556.27     | 278.1      | 900      | 1000      | Negative | Resolution  | 1: NEG RES 1000,   2: NEG RES 1000  , 3: NEG RES 1000  | Automation_MultiFunctionAcquisition_MSe_DualLockMass.xml     |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| HD-MSe             | HDMSe       | N/A        | N/A        | 1900     | 2000      | Negative | Sensitivity | 1: NEG SENS 2000, 2: NEG SENS 2000                     | Automation_MultiFunctionAcquisition_HDMSe.xml                |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| HD-MSe + Single LM | HDMSe       | 556.27     | N/A        | 1900     | 2000      | Positive | Resolution  | 1: POS RES  2000, 2: POS RES  2000, 3: POS RES 2000    | Automation_MultiFunctionAcquisition_HDMSe_SingleLockMass.xml |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------
			| HD-MSe + Dual LM   | HDMSe       | 556.27     | 278.1      | 900      | 1000      | Positive | Sensitivity | 1: POS SENS 1000 , 2: POS SENS 1000 , 3: POS SENS 1000 | Automation_MultiFunctionAcquisition_HDMSe_DualLockMass.xml   |
			#----------------------------------------------------------------------------------------------------------------------------------------------------------
			# The slot calibration for the High Mass specified within a method will be used for every function within that method.


	Scenario Outline: ACQ-02 - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Acquisition Create - No Calibration Applied
		Given a new Acquisition Method '<Method Type>' XML file is created called '<Method Name>'
			And the XML file <Method Name> method has a short Run Duration with Low Mass <Low Mass>, High Mass <High Mass>, Lock Mass 1 <LockMass 1> and Lock Mass 2 <LockMass 2> parameters set
			And that the browser is opened on the Tune page
			And the mode is <Mode> and the polarity is <Polarity>
		When the '<Method Name>' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And Tuning is aborted
		Then no calibration has been applied to all '2' functions			
			Examples: MSe Methods - No Calibration
			| Test Name            | Method Type | LockMass 1 | LockMass 2 | Low Mass | High Mass | Polarity | Mode       | Slot Calibration Used         | Method Name                                               |
			| MSe + No Calibration | MSe         | N/A        | N/A        | 50       | 500       | Positive | Resolution | 1: None (N/A),  2: None (N/A) | Automation_MultiFunctionAcquisition_MSe_NoCalibration.xml |

	@SmokeTest
	Scenario Outline: ACQ-03 - InstrumentSetupMultiFunctionAcquisition - Custom Tune (Pre-existing)
		Given that the browser is opened on the Tune page
			And the mode is <Mode> and the polarity is <Polarity>
			And Leucine Enkephalin is selected via the Fluidics Reference vial
			And a new '<Method Name>' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And Tuning is aborted
		Then the acquisition has had the calibration applied for mass <Calibration Applied>, polarity <Polarity> and mode <Mode>
			Examples:
			| Method Name          | LockMass 1 | LockMass 2 | StartMass | EndMass | Calibration Applied | Polarity | Mode        | Slot Calibration Used                                |
			| mse_fullhd.xml       | N/A        | N/A        | 100       | 1200    | 2000                | Positive | Sensitivity | 1: POS SENS 2000, 2: POS SENS 2000                   |
			| mse_trend            | N/A        | N/A        | 100       | 1200    | 2000                | Negative | Resolution  | 1: NEG RES 2000,  2: NEG RES 2000                    |
			#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------  
			| TofMRM.xml           | N/A        | N/A        | 50        | 1200    | 2000                | Positive | Sensitivity | 1: POS SENS 2000, 2: POS SENS 2000, 3: POS SENS 2000 |
			| HDMRM.xml            | N/A        | N/A        | 50        | 1200    | 2000                | Negative | Resolution  | 1: NEG RES 2000,  2: NEG RES 2000,  3: NEG RES 2000  |
			| mse.xml              | N/A        | N/A        | 100       | 1200    | 2000                | Positive | Resolution  | 1: POS RES 2000,  2: POS RES 2000                    |
			#-------------------------------------------------------------------------------------------------------------------------------------------------------------------						
			| HSMRM.xml            | N/A        | N/A        | 50        | 1200    | 2000                | Negative | Sensitivity | 1: NEG SENS 2000, 2: NEG SENS 2000, 3: NEG SENS 2000 |
			#------------------------------------------------------------------------------------------------------------------------------------------------   
			# The slot calibration for the highest EndMass specified within a method will be used for every function within that method.


	Scenario Outline: ACQ-04 - InstrumentSetupMultiFunctionAcquisition - Custom Tune (Pre-existing) - LockMass Setup Fails
		Given that the browser is opened on the Tune page
			And the mode is <Mode> and the polarity is <Polarity>
			And Leucine Enkephalin is selected via the Fluidics Reference vial
		When I try to run '<Method Name>' method via Acquisition | Custom Tune XML
		Then no scan data is received

			Examples:
			| Method Name          | LockMass 1 | LockMass 2 | StartMass | EndMass | Polarity | Mode        | Slot Calibration Used                                |
			| ms_lockmass.xml      | 556.27     | N/A        | 100       | 1000    | Negative | Sensitivity | 1: NEG SENS 1000, 2: NEG SENS 1000                   |
			| ms_dual_lockmass.xml | 556.27     | 278.1      | 100       | 1000    | Positive | Resolution  | 1: POS RES 1000,  2: POS RES 1000                    |

	Scenario: ACQ-05 - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune - Multi Function MS - High Mass 4000
		Given a new 'MS_4Functions.xml' XML file is manually created and saved with the following functions 
			| Functions | Type  | LockMass 1 | LockMass 2 | StartMass | EndMass |
			| 1         | MS    | N/A        | N/A        | 450       | 500     |
			| 2         | MS    | N/A        | N/A        | 950       | 1000    |
			| 3         | MS    | N/A        | N/A        | 1950      | 2000    |
			| 4         | MS    | N/A        | N/A        | 3950      | 4000    |
			And that the browser is opened on the Tune page
			And the mode is Resolution and the polarity is Positive
			And 'MS_4Functions.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '30' seconds
			And Tuning is aborted
		Then the acquisition has had the calibration applied to all '4' functions of mass '4000', polarity 'Positive' and mode 'Resolution'
		# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.
	

	Scenario: ACQ-06 - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune - Multi Function MS - 3 functions	
		Given a new 'MS_3Functions.xml' XML file is manually created and saved with the following functions
			| Functions | Type  | LockMass 1 | LockMass 2 | StartMass  | EndMass |
			| 1         | MS    | N/A        | N/A        | 450        | 500     |
			| 2         | MS    | N/A        | N/A        | 950        | 1000    |
			| 3         | MS    | N/A        | N/A        | 1950       | 2000    |
			And that the browser is opened on the Tune page
			And the mode is Sensitivity and the polarity is Positive
			And 'MS_3Functions.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And Tuning is aborted
		Then the acquisition has had the calibration applied to all '3' functions of mass '2000', polarity 'Positive' and mode 'Sensitivity'
		# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.

	@SmokeTest
	Scenario: ACQ-07 - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune - Multi Function MS with Single Lock Mass
		Given a new 'MS_2Functions_SingleLockMass.xml' XML file is manually created and saved with the following functions
			| Functions | Type     | LockMass 1 | LockMass 2 | StartMass | EndMass |
			| 1         | MS       | N/A        | N/A        | 450       | 500     |
			| 2         | MS       | N/A        | N/A        | 1900      | 2000    |
			| 3         | LockMass | 554.27     | N/A        | N/A       | N/A     |
			And that the browser is opened on the Tune page
			And the mode is Resolution and the polarity is Negative
			And 'MS_2Functions_SingleLockMass.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And Tuning is aborted
		Then the acquisition has had the calibration applied to all '3' functions of mass '2000', polarity 'Negative' and mode 'Resolution'
		# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.


	Scenario: ACQ-08 - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune - Multi Function MS - No Calibration Applied
		Given a new 'MS_3Functions_NoCalibration.xml' XML file is manually created and saved with the following functions
			| Functions | Type | LockMass 1 | LockMass 2 | StartMass | EndMass |
			| 1         | MS   | N/A        | N/A        | 550       | 600     |
			| 2         | MS   | N/A        | N/A        | 1950      | 2000    |
			| 3         | MS   | N/A        | N/A        | 3900      | 4000    |
			And that the browser is opened on the Tune page
			And the mode is Sensitivity and the polarity is Negative
			And 'MS_3Functions_NoCalibration.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And Tuning is aborted
		Then no calibration has been applied to all '3' functions
		

	Scenario: ACQ-09 - InstrumentSetupMultiFunctionAcquisition - Custom Tune Data Acquired Using - Multi Function MRM
		Given a new 'MRM_4Functions.xml' XML file is manually created and saved with the following functions
			| Functions | Type | LockMass 1 | LockMass 2 | StartMass | EndMass | SetMass |
			| 1         | MRM  | N/A        | N/A        | 450       | 500     | 460.9   |
			| 2         | MRM  | N/A        | N/A        | 950       | 1000    | 966.9   |
			| 3         | MRM  | N/A        | N/A        | 1950      | 2000    | 1952.8  |
			| 4         | MRM  | N/A        | N/A        | 3950      | 4000    | 3962.6  |	
			And that the browser is opened on the Tune page
			And the mode is Resolution and the polarity is Positive
			And 'MRM_4Functions.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And Tuning is aborted
		Then the acquisition has had the calibration applied to all '4' functions of mass '4000', polarity 'Positive' and mode 'Resolution'
		# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.


	Scenario: ACQ-10 - InstrumentSetupMultiFunctionAcquisition - Custom Tune Data Acquired Using - Multi Function MRM with Dual Lock Mass
		Given a new 'MRM_2Functions_DualLockMass.xml' XML file is manually created and saved with the following functions
			| Functions | Type     | LockMass 1 | LockMass 2 | StartMass | EndMass | SetMass |
			| 1         | MRM      | N/A        | N/A        | 450       | 500     | 452.9   |
			| 2         | MRM      | N/A        | N/A        | 1900      | 2000    | 1950.8  |
			| 3         | LockMass | 475.27     | 1150.1     | N/A       | N/A     | N/A     | 
			And that the browser is opened on the Tune page
			And the mode is Sensitivity and the polarity is Negative
			And 'MRM_2Functions_DualLockMass.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And Tuning is aborted
		Then the acquisition has had the calibration applied to all '3' functions of mass '2000', polarity 'Negative' and mode 'Sensitivity'
		# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.			


	Scenario: ACQ-11 - InstrumentSetupMultiFunctionAcquisition - Custom Tune Data Acquired Using - Multi Function MRM - No Calibration Applied
		Given a new 'MRM_3Functions_NoCalibration.xml' XML file is manually created and saved with the following functions
			| Functions | Type | LockMass 1 | LockMass 2 | StartMass | EndMass | SetMass |
			| 1         | MRM  | N/A        | N/A        | 2450      | 2500    | 2451.9  |
			| 2         | MRM  | N/A        | N/A        | 2950      | 3000    | 2951.9  |
			| 3         | MRM  | N/A        | N/A        | 3950      | 4000    | 3960.8  |
			And that the browser is opened on the Tune page
			And the mode is Sensitivity and the polarity is Negative
			And 'MRM_3Functions_NoCalibration.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
		Then no calibration has been applied to all '3' functions
		# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.


	# Simulator unable to calibrate for masses above 8000
	@Obsolete
	@ignore
	Scenario: ACQ-12 - InstrumentSetupMultiFunctionAcquisition - Data Acquired Using Custom Tune - Multi Function MS - High Mass 70000
		Given a new 'MS_8Functions.xml' XML file is manually created and saved with the following functions 
			| Functions | Type  | LockMass 1 | LockMass 2 | StartMass | EndMass |
			| 1         | MS    | N/A        | N/A        | 450       | 500     |
			| 2         | MS    | N/A        | N/A        | 950       | 1000    |
			| 3         | MS    | N/A        | N/A        | 1950      | 2000    |
			| 4         | MS    | N/A        | N/A        | 4950      | 5000    |
			| 5         | MS    | N/A        | N/A        | 7950      | 8000    |
			| 6         | MS    | N/A        | N/A        | 13950     | 14000   |
			| 7         | MS    | N/A        | N/A        | 31950     | 32000   |
			| 8         | MS    | N/A        | N/A        | 69950     | 70000   |
			And that the browser is opened on the Tune page
			And the mode is Resolution and the polarity is Positive
			And 'MS_8Functions.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '30' seconds
			And Tuning is aborted
		Then the acquisition has had the calibration applied to all '5' functions of mass '70000', polarity 'Positive' and mode 'Resolution'
		# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.


	# Simulator unable to calibrate for masses above 8000
	@Obsolete
	@ignore
	Scenario: ACQ-13 - InstrumentSetupMultiFunctionAcquisition - Custom Tune Data Acquired Using - Multi Function MRM with Lock Mass - High Mass 32000
		Given a new 'MRM_3Functions_DualLockMass.xml' XML file is manually created and saved with the following functions
			| Functions | Type     | LockMass 1 | LockMass 2 | StartMass | EndMass | SetMass |
			| 1         | MRM      | N/A        | N/A        | 50        | 500     | 452.9   |
			| 2         | MRM      | N/A        | N/A        | 50        | 32000   | 2900.5  |
			| 3         | MRM      | N/A        | N/A        | 50        | 2000    | 1268.8  |
			| 4         | LockMass | 556.27     | 278.1      | N/A       | N/A     | N/A     |	
			And that the browser is opened on the Tune page
			And the mode is Sensitivity and the polarity is Negative
			And 'MRM_3Functions_DualLockMass.xml' is selected to be run via Acquisition | Custom Tune XML
			And during the method run an acquisition is 'Started'
			And the acquisition is Stopped after '10' seconds
			And Tuning is aborted
		Then the acquisition has had the calibration applied to all '4' functions of mass '32000', polarity 'Negative' and mode 'Sensitivity'
	# The slot calibration for the highest High Mass specified within a method will be used for every function within that method.	
	
	@ignore
	@Updated
	Scenario Outline: ACQ-14 - InstrumentSetupMultiFunctionAcquisition - Custom Tune Data Acquired Using - Custom Tune (Pre-existing) - Low Mass
		Given the browser is opened on the Instrument Setup page
			And no Mass Calibrations have been caried out ( Slot status: 'Not run')
			And the Tune page is accessed
			And a <Lock Mass Method> is selected to be run via Acquisition | Custom Tune XML
			# Lock Mass Methods location: Waters\UNIFI\Instruments\Osprey\2.0.0\Typhoon\config\methods
		When the acquisition is 'Started'
			And the acquisition is 'Stopped' after '15' seconds
			And the 'Tune' button is pressed
		Then the Mass(m/z) axis from Plot Data displays the following <StartMass> and <EndMass> 
	Examples: 
	| Lock Mass Method        | StartMass | EndMass |
	| ms_dual_lockmass.xml    | 100.0     | 1000.0  |
	| ms_lockmass.xml         | 100.0     | 1000.0  |
	| ms_lockmassFluidics.xml | 100.0     | 1000.0  |
	| ms_manual_lm.xml        | 100.0     | 1000.0  |


# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END