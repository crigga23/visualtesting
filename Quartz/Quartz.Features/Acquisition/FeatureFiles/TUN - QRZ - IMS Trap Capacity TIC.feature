# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - IMS Trap Capacity TIC
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    #          23-JUN-15
#                          # UPDATED (10-DEC-15)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # \Automation-Quartz\AutomationQuartz\Documents\TUN - QRZ - IMS Trap Capacity TIC - Setup.doc
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # Engineering Dashboard (\\tu-server-sw\tu-server1\docs\Utilities\Engineer Dashboard)
#                          # TTERM Pro             (\\tu-server-sw\tu-server1\docs\Utilities\TTERM_PRO)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # http://slcmrp2.waters.com/Citrix/AccessPlatform/site/default.aspx
#                          # Doors (WATERS Production): /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-571)                 # Feedback Transmission Control for mobility TIC will be implemented as Feedback Transmission Control for Trap Capacity 
#                          # as per section 11.5 in the Software Requirement document 721005052.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis (other):            # http://typhoon-build.waters.com/job/Build-Typhoon-Documentation/Typhoon_Documentation/typhoon/designs/feedbackaquisition.html#trap-capacity-feedback-dre
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@Ignore
Feature: IMS Trap Capacity (Corrected TIC)
	 In order to check that the 'IMS Trap Capacity' Corrected TIC is calculated and used effectively 
	 I want to be able to check the value from a purpose-made spreadsheet against EPC generated values - and then load a method with a given threshold values set
	 So that it can be determined that the IMS DRE is correctly set for each function
	 


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given that a real instrument is used
		And the following document has been followed to set up the environment for testing
			| Document                                      | Location                                       |
			| IMS Trap Capacity (Corrected TIC) - Setup.doc | \Automation-Quartz\AutomationQuartz\Documents\ |
			# This document contains the following details...
			# - enabling CorrectedTIC, 
			# - enabling diagnostics
			# - generating relevant EPC log details 
			# - generating scan data
			# - details of how to calculate the Corrected TIC with a spreadsheet
			# - running a method from a samplelist
			# - modifying method to set a CorrectedTIC threshold for each function
			

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@ManualOnly
Scenario: TUN-01 - IMS Trap Capacity TIC - Spreadsheet Value Matching ECP Log Output
	When a single function HDMSMS 'Custom Tune' XML method is run from a 'Samplelist'
		And the Function 1 Scan 0 'Corrected TIC Sum' value has been calculated by means of a spreadsheet
		And the Function 1 Scan 0 'Corrected TIC' value has been extracted from the EPC log
	Then the two values will match to the nearest integer.
	# The spreadsheet is embedded within 'IMS Trap Capacity (Combined TIC) - Setup.doc'
	# The EPC log is available through TTERM Pro


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@ManualOnly
Scenario: TUN-02 - IMS Trap Capacity - IMS DRE set to Expected Value with Various Threshold Values
	Given a mutli-function HDMSMS 'Custom Tune' XML method has a 'CorrectedTICThreshold Value' set for each 'Function'
		| Function | CorrectedTICThreshold Value                  |
		| 1        | Set to force a DRE drop to approximately 75% |
		| 2        | Set to force a DRE drop to approximately 50% |
		| 3        | Set to force a DRE drop to approximately 25% |
	When this method is run from a 'Samplelist'
	Then the 'Corrected TIC' value extracted from the EPC log for each 'Function' will be available
		| Function | Corrected TIC            |
		| 1        | Set to approximately 75% |
		| 2        | Set to approximately 50% |
		| 3        | Set to approximately 25% |
		And the Engineering Dashboard parameter 'TWAVE2_TRAP_FILL_TIME_SETTING' will show details as follows
		| Function | Comments                                                                             |
		| 1        | Set to approximately 75% of full scale value (- value at exactly 75% would be 11.72) |
		| 2        | Set to approximately 50% of full scale value (- value at exactly 50% would be  7.81) |
		| 3        | Set to approximately 25% of full scale value (- value at exactly 25% would be  3.91) |
		# TWAVE2_TRAP_FILL_TIME_SETTING full scale (100%) value is normally 15.62
		# This can be determined by setting the beam intensity low (- temporarily set the Tune page ‘Instrument’ tab ‘Detector Voltage’, or the ‘System 1’ tab ‘Entrance’ value to zero) 


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@ManualOnly	
Scenario: TUN-03 - IMS Trap Capacity - Discrete IMS DRE Values
	Given a mutli-function HDMSMS 'Custom Tune' XML method has a 'CorrectedTICThreshold Value' set for each 'Function'
		| Function | CorrectedTICThreshold Value    |
		| 1        | Set to force a DRE drop to 75% |
		| 2        | Set to force a DRE drop to 50% |
		| 3        | Set to force a DRE drop to 25% |
	When this method is run from a 'Samplelist'
		And the IMS 'DRE' value extracted from the EPC log for each function is available
	Then the IMS 'DRE' for each function will be set to one of the 'EventDRETable' values from 'TrapCapacityFeedbackDRE.lua'
	# Check against the actual values in the file '\Typhoon\config\scripts\method\DataProcessors\TrapCapacityFeedbackDRE.lua'
	# Just for reference, as of 23-Jun-15, the values were...
	# EventDRETable = {100,99,94,89,84,79,74,69,64,59,54,49,44,39,35,33,31,29,27,25,23,21,20}	


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@ManualOnly	
Scenario Outline: TUN-04 - IMS Trap Capacity - No Dropped Scans with Varying Functions and Scan Times
	Given the following setup
		| File                                                                     | Details                      |
		| Typhoon\config\scripts\method\method_setup.lua                           | SetupTICCorrection() enabled |
		| Typhoon\config\scripts\method\DataProcessors\TrapCapacityFeedbackDRE.lua | Diagnostics = false          |
		| Typhoon\config\scripts\method\DataProcessors\CorrectedTIC.lua            | Diagnostics = false          | 
	When an HDMSMS 'Custom Tune' XML method with <Number of Functions> each with a specific <Scan Time> is run from a 'Samplelist'
	Then the EPC log will NOT contain messages that there have been 'dropped scans' during the acquisition
		
		Examples:
		| Number of Functions | Scan Time |
		| 1                   | 0.1       |
		| 3                   | 1         |
	

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Defect FW#7234
Scenario: TUN-05 - Only One HD-MSe function Should Use Trap Capacity 
	Given an acquisition is started using the 'mse_fullhd.xml' Custom tune method
	Then the EPC log window will only show ONE instance of the following 'Message'
		| Message                                       |
		| Adding processor: DataProcessors/CorrectedTIC |
		# the 'mse_fullhd.xml' Custom tune method can be found in the folder '\Typhoon\config\methods\Mse\'
		

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Defect FW#6606
Scenario Outline: TUN-06 - Enabling 'pDRE HD Attenuate' should disable Trap Capacity
	Given the Tune page 'System 2' has an <Initial pDRE HD Attenuate Setting>
	When the Tune page 'System 2' has a <New pDRE HD Attenuate Setting>
		And an acquisition is started using the 'hdms.xml' custom tune method
	Then a specific <EPC Log Message> will be shown
		# Stop the method acquisition after scenario completion
		
		Examples:
		| Initial pDRE HD Attenuate Setting | New pDRE HD Attenuate Setting | EPC Log Message                           |
		| Off                               | On                            |  N/A                                      |
		| On                                | Off                           | "Delegating TIC Survey function to: HDMS" |
		# N/A - No "Delegating TIC Survey function..." message is shown
				

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@ManualOnly		
 Scenario Outline: TUN-07 - IMS Trap Capacity - Enabling Based on Method (with ESI Source)
 	Given the following setup
 		| File                                                  | Details            |
 		| Typhoon\config\scripts\method\Support\FeedbackDRE.lua | Diagnostics = true |
		And an 'ESI' source is fitted
 	When a 'Custom Tune' XML with a <Method Type> and a <Number of Functions> is run from a 'Samplelist'
 	Then an 'IMS Trap Capacity' <State> will be set for all functions within the Method
 		# State can be tracked by looking for the 'Adding Trap Capacity Feedback DRE' message in the EPC log (TTERMPRO / Putty);
		# This message should only be output for a method that has a State of 'Enabled'.
		
		Examples: (ESI) Non-HS/HD Methods - Disabled
 		| Method Type | Number of Functions | State    |
 		| MS          | 1                   | Disabled |
 		| MSe         | 2                   | Disabled |
 		| MSMS        | 1                   | Disabled |
 		| MRM         | 1                   | Disabled |
 		| MRM + RADAR | 2                   | Disabled |
		| DDA         | 2                   | Disabled |
				
		Examples: (ESI) HS Methods - Enabled
 		| Method Type | Number of Functions | State    |
 		| HSMSMS      | 1                   | Enabled  |
 		| HSMRM       | 1                   | Enabled  |

		Examples: (ESI) HD Methods - Enabled
 		| Method Type | Number of Functions | State    |
 		| HDMS        | 1                   | Enabled  |
 		| HDMSe       | 1                   | Enabled  |
	
		
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: Outline TUN-08 - IMS Trap Capacity - Enabling Based on Method (with APCI Source)
 	Given the following setup
 		| File                                                  | Details            |
 		| Typhoon\config\scripts\method\Support\FeedbackDRE.lua | Diagnostics = true |
		And an 'APCI' source is fitted
 	When a 'Custom Tune' XML with a <Method Type> and a <Number of Functions> is run from a 'Samplelist'
 	Then an 'IMS Trap Capacity' <State> will be set for all functions within the Method
 		# State can be tracked by looking for the 'Adding Trap Capacity Feedback DRE' message in the EPC log (TTERMPRO / Putty);
		# This message should only be output for a method that has a State of 'Enabled'.
		
		Examples: (APCI) Non-HS/HD Method - Disabled
 		| Method Type | Number of Functions | State    |
 		| MS          | 1                   | Disabled |
 		# Other method types are supported as with ESI
		
		Examples: (APCI) HS Method - Enabled
 		| Method Type | Number of Functions | State    |
 		| HSMSMS      | 1                   | Enabled  |
		# Other sourtce type are supported as with ESI
		
		Examples: (APCI) HS Method - Enabled
 		| Method Type | Number of Functions | State    |
 		| HDMS        | 1                   | Enabled  |
		# Other sourtce type are supported as with ESI
		

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END