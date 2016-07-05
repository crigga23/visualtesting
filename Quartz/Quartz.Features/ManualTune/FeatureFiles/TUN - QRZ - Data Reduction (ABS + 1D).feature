
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Data Reduction (ABS + 1D)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 19-APR-15
#                          # 08-DEC-15 (Minor Updates)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Data Reduction options are set within the method above the function settings, as follows...
#                          #
#                          #   For 'ABS (off), 1D (off) - Bypass', add the following to the method:
#                          #     <Setting Name="DataReductionMode" Value="0.0"/>
#                          #
#                          #   For 'ABS (on) , 1D (off)', add the following to the method:
#                          #     <Setting Name="DataReductionMode" Value="1.0"/>
#                          #			
#                          #   For 'ABS (on) , 1D (on, threshold 'n')', add the following to the method:
#                          #     <Setting Name="DataReductionMode" Value="3.0"/>
#                          #     <Setting Name="DataReductionThreshold" Value="n"/>	
#                          #        [Where 'n' is the Threshold value]
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # As above for 'Automation Test Notes'.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # The following 'Original Data' is available and copied locally to 'C:\ReplayData\'
#	                       # \\tu-server-sw01\Data3\Automation\Feature File PreReq Files\UrineVal1_dilution5_rep1.raw
#                          # NOTE: Original data acquisition length = 12.5 minutes
#                          # NOTE: This is non-mobility data created in Positive Sensitivity mode
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # The 'Waters Compression and Archival Tool v1.00' from the following location...
#                          # \\tu-server-sw01\Data3\Utilities\Waters Compression and Archival Tool v1.00
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # 10-AUG-15 - Added Tolerances to account for varying results due to Calibration Resolution
#                          # 10-AUG-15 - Added TUN-03 to compare Tune page compression results with the 'Waters Compression and Archival Tool v1.00'
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-592)                 # The data processing pipeline will be able to apply an adaptive background subtraction algorithm on the acquired data. 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-593)                 # The data processing pipeline will be able to apply a 1D Data Sweep algorithm on the acquired data.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-595)                 # The data processing pipeline will be able to apply an adaptive background subtraction algorithm on the acquired data followed by a 1D Data Sweep algorithm.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
Feature: Data Reduction (ABS + 1D)
	 In order to check that Data Reduction is working as expected
	 I want to be able to acquire data with various Data Reduction options enabled
	 So that the final data is acquired with an expected level of compression and subsequent data size reduction
	 

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the whole Instrument Setup status is cleared so that no slots have been run
		And Typhoon is started
		And a Quartz Development Console is open
		And the 'Instrument section' is selected
			
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@ignore
@Updated
Scenario Outline: TUN-01 - Simulation - Data Reduction (ABS / ABS + 1D)
	Given the Instrument Setup 'Detector Setup' process is run in 'Positive' mode
		And the Instrument Setup 'Mass Calibration' is successfully run for Mass Range 1200 in 'Positive Sensitivity' mode
		And Typhoon is stopped
		And the simulator is then set up to replay the 'Original Data'
		# By modifying 'C:\Waters Corporation\Typhoon\config\simulator_config.xml' to include the following uncommented lines...
		#
		# <Functions>
		#	<Function no="1">
		# 		<DataGenerator type="Replay">
		#			<RawFile path="C:\ReplayData\UrineVal1_dilution5_rep1.raw" function="0" />
		#		</DataGenerator>
		#	</Function>
		# </Functions>
		And Typhoon is started
		And the instrument is set to 'Positive Sensitivity' mode
		And the Tune Page is loaded with a Method using <Data Reduction Options> and the following 'Settings' and 'Values'
			| Settings       | Values |
			| Type           | MS     |
			| TimeStart      | 0      |
			| TimeEnd        | 750.0  |
			| StartMass      | 50     |
			| EndMass        | 1200   |
			| ScanTime       | 0.15   |
			| InterscanDelay | 0.014  |
	When a Tune page acquisition is 'Started'
		And the Tune page acquisition is then 'Stopped' when tuning stops (after 750.0 seconds)
				# ...therefore all the data points will be recorded at least once, as the simulator replays external data in a loop. 
	Then the acquisition data size will be of the <Expected Data Compression Rate> within a <Tolerance> when compared to the 'ABS (off), 1D (off) - Bypass' data size
		
		Examples: 
		| Data Reduction Options           | Expected Data Compression Rate | Tolerance |
		| ABS (off), 1D (off) - Bypass     | N/A                            | N/A       |
		| ABS (on) , 1D (off)              | Approx.  99 %                  | +/- 3%    |
		| ABS (on) , 1D (on, threshold  2) | Approx.  42 %                  | +/- 6%    |
		| ABS (on) , 1D (on, threshold  5) | Approx.  16 %                  | +/- 3%    |
		| ABS (on) , 1D (on, threshold 10) | Approx.   9 %                  | +/- 2%    |
		| ABS (on) , 1D (on, threshold 50) | Approx.   2 %                  | +/- 1%    |
		# NOTE: Expected data compression rates determined from the 'Waters Compression and Archival Tool v1.00.
		# Compression rates are determined by comparing the Bypass (ABS (off), 1D (off)) data _FUNC001.DAT file with the newly created one in the datastore raw subfolder.


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
@ignore
@Updated
Scenario Outline: TUN-02 - Normal Prerequisites Not Run - Default Values Written out to Log
	Given that initial Instrument Setup <Detector Setup Status> is set
		And initial Instrument Setup <Mass Calibration Status> is set
		And Typhoon is stopped
		And the simulator is set up to replay the 'Original Data'
		# By modifying 'C:\Waters Corporation\Typhoon\config\simulator_config.xml' to include the following uncommented lines...
		#
		# <Functions>
		#	<Function no="1">
		# 		<DataGenerator type="Replay">
		#			<RawFile path="C:\ReplayData\UrineVal1_dilution5_rep1.raw" function="0" />
		#		</DataGenerator>
		#	</Function>
		# </Functions>
		And Typhoon is started
		And the instrument is set to 'Positive Sensitivity' mode
		And the Tune Page is loaded with a Method using the following 'Settings' and 'Values'
			| Settings       | Values |
			| Type           | MS     |
			| TimeStart      | 0      |
			| TimeEnd        | 750.0  |
			| StartMass      | 50     |
			| EndMass        | 1200   |
			| ScanTime       | 0.15   |
			| InterscanDelay | 0.014  |
			#----- Data Reduction -----
			| ABS            | On     |
			| 1D             | On     |
			| 1D Threshold   | 5      |
	When a Tune page acquisition is 'Started'
		And the Tune page acquisition is then 'Stopped' when tuning stops (after 750.0 seconds)
		# ...therefore all the data points will be recorded at least once, as the simulator replays external data in a loop. 
	Then there will be an <Expected Log Output>
		And the <Approximate Acquisition Data Size> can be measured when compared to the 'Original Data' size within a <Tolerance>
			
			Examples: 
			| Detector Setup Status | Mass Calibration Status | Expected Log Output                                         | Approximate Acquisition Data Size | Tolerance |
			| Not Run               | Not Run                 | Default 'singleIonResponse' parameter written out to log    | 12%                               | +/- 2.5 % |
			|                       |                         | Default 'singleIonMz' parameter written out to log          |                                   |           |
			|                       |                         | Default 'peak_width_offset' parameter written out to log    |                                   |           |
			|                       |                         | Default 'high mass resolution' parameter written out to log |                                   |           |
			#----------------------------------------------------------------------------------------------------------------------------------------------------------------
			| Run (positive mode)   | Not Run                 | New 'singleIonResponse' parameter written out to log        | 12%                               | +/- 2.5 % |
			|                       |                         | New 'singleIonMz' parameter written out to log              |                                   |           |
			|                       |                         | Default 'peak_width_offset' parameter written out to log    |                                   |           |
			|                       |                         | Default 'peak_width_gradient' parameter written out to log  |                                   |           |
			|                       |                         | Default 'high mass resolution' parameter written out to log |                                   |           |
			# Default values written out to DebugView [typhoon] log
			# Default 'singleIonResponse' (Average Single Ion Intensity) = 33 (taken from the ReplayData RAW _extern.inf file)
			# Default 'singleIonMz' (Measured m/z) = 556.27 (to 2dp)
			# Default 'peak_width_offset' = 1.0
			# Default 'peak_width_offset' = 0.000017
			# Default 'high mass resolution' = 30000
	

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------	
Scenario: TUN-03 - Simulation - Comparing Tune Page Compression with the 'Waters Compression and Archival Tool v1.00'
	Given the Instrument Setup 'Detector Setup' process is run in 'Positive' mode
		And the Instrument Setup 'Mass Calibration' is successfully run for Mass Range 1200 in 'Positive Sensitivity' mode
		And Typhoon is stopped
		And the simulator is then set up to replay the 'Original Data'
		# By modifying 'C:\Waters Corporation\Typhoon\config\simulator_config.xml' to include the following uncommented lines...
		#
		# <Functions>
		#	<Function no="1">
		# 		<DataGenerator type="Replay">
		#			<RawFile path="C:\ReplayData\UrineVal1_dilution5_rep1.raw" function="0" />
		#		</DataGenerator>
		#	</Function>
		# </Functions>
		And Typhoon is started
		And the instrument is set to 'Positive Sensitivity' mode
		
		# Bypass Data
		And the Tune Page is loaded with a Method using the following general 'Settings' and 'Values'
			| Settings               | Values |
			| DataReductionMode      | 0.0    |
		And the following 'MS' function 'Settings' and 'Values'
			| Settings       | Values |
			| TimeStart      | 0      |
			| TimeEnd        | 750.0  |
			| StartMass      | 50     |
			| EndMass        | 1200   |
			| ScanTime       | 0.15   |
			| InterscanDelay | 0.014  |
		And a Tune page acquisition is 'Started'
		And when tuning stops (after 750.0 seconds) the Tune page acquisition is 'Stopped' and saved as 'BypassData' 

		# ABS + 1D Threshold 2 Data
		And the Tune Page is loaded with a Method using the following general 'Settings' and 'Values'
			| Settings               | Values |
			| DataReductionMode      | 3.0    |
			| DataReductionThreshold | 2      |	
		And the following 'MS' function 'Settings' and 'Values'
			| Settings       | Values |
			| TimeStart      | 0      |
			| TimeEnd        | 750.0  |
			| StartMass      | 50     |
			| EndMass        | 1200   |
			| ScanTime       | 0.15   |
			| InterscanDelay | 0.014  |
		And a Tune page acquisition is 'Started'
		And when tuning stops (after 750.0 seconds) the Tune page acquisition is 'Stopped' and Saved as 'ABS1DThreshold2' 
		And the DebugView log 'high mass resolution' parameter for the acquisition is recorded for later use
		
		# Waters Compression Tool Data
		And the 'Waters Compression and Archival Tool v1.00' is run with the following 'Basic Settings' and Values'
			| Basic Setting | Value                                                   |
			| Folder        | C:\Waters Corporation\Typhoon\data_store\BypassData.raw |
		And the following 'Process Option Parameters' and Values'
			| Process Option Parameters  | Values               |
			| Threshold (ion conouts)    | 2                    |
			| MS Resolution              | high mass resolution |
			| Low Drift                  | 2                    |
			| High Drift                 | 10                   |
			| Chromatrographc Peak Width | 0.02                 |
			| Output Folder              | C:\Output            |
			# The high mass resolution value will be taken from previoulsy recorded DebugView log
	When the size of the 'Waters Compression and Archival Tool v1.00' output folder data and the 'ABS1DThreshold2' data_store data are compared
	Then the data file sizes will be within 1% of one another
	# Data sizes are determined the size of the _FUNC001.DAT file within each data folder

		
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END