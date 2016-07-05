# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # SET - Settling 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------	
# Date:                    # 29-JUL-14      
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # InstrumentMonitor.xml file is modified to prevent the FlightTube voltage from ever being reached by changing...
#                          # Readback="System1.FlightTube.Readback" to Readback="20.0"
#                          # 
#                          # On a real instrument where a Polarity settle is involved, the Minimum Delay may be less than 18 seconds (e.g. 14 seconds)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # As above for Automation Test Notes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------	
# Tools Required:	       # DebugView (http://technet.microsoft.com/en-gb/sysinternals/bb896647.aspx)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # N/A (Initial Version)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-125)                 # The software will support reading settle processes configuration from xml file.
#                          # The software will run each settle process independently and monitor parameters status defined in configuration.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-126)                 # Acquisition system will monitor Instrument Monitor settle status and act accordingly.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------
# Manual Pre-Automation Smoke Test: 13-AUG-14
#--------------------------------------------------------------------------------------------------------
# QRZ-01:  PASSED
# QRZ-02:  PASSED
# QRZ-03:  PASSED
# QRZ-04:  FAILED (Comment 1)
# QRZ-05:  FAILED (Comment 1)
# QRZ-06:  FAILED (Comment 1)
# QRZ-07:  PASSED
# QRZ-08:  PASSED
# QRZ-09:  PASSED
# QRZ-10a: FAILED (Comment 1)
# QRZ-10b: FAILED (Comment 1)
#--------------------------------------------------------------------------------------------------------
# Comment 1: Using the simulator, the Polarity delay is 3 seconds and not the expected 18 seconds.
#--------------------------------------------------------------------------------------------------------

#Prerequisites:
	#Given a Typhoon / Quartz environment is available
	#And a valid username and password is available for successful login to the Quartz Environment
	#And DebugView is available for monitoring port messages


# ---------------------------------------------------------------------------------------------------------------------------------------------------

@Obsolete
@ignore
@General
@Settling
Feature: Settling
	In order to check that Typhoon Settling works as expected
	I want to be able to run various processes and show that the relevant settling tasks are run
	and that where appropriate processes are halted until the settling tasks have completed
# ---------------------------------------------------------------------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: SET-01 - XML Tag Settle Details
	Given that the 'InstrumentMonitor.xml' file is available
	When the contents of the 'InstrumentMonitor.xml' file are inspected
	Then the file will contain tag details for the following
		| Settle Name             |
		| Polarity                |
		| Tof Voltage             |
		| Reflectron Voltage      |
		| Reflectron Grid Voltage |
		| Quad Turbo Speed        |
		| Source Turbo Speed      |
		| Tof Turbo Speed         |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: SET-02 - Typhoon Start - Settle 'Started' and 'Finished' Messages
	Given all Typhoon Services are 'Stopped'
		And the DebugView tool is opened
	When all Typhoon Services are 'Started'
		And the Quartz browser is 'Opened'
		And the instrument is put into 'Operate' mode
	Then after some time DebugView Messages related to InstrumentMonitor will be shown
		| DebugView Messages                          |
		| Settle started on: Polarity                 |
		| Settle started on: Tof Voltage              |
		| Settle started on: Reflectron Grid Voltage  |
		| Settle started on: Reflectron Voltage       |
		| Settle started on: Quad Turbo Speed         |
		| Settle started on: Source Turbo Speed       |
		| Settle started on: Tof Turbo Speed          |
		| Settle finished on: Polarity                |
		| Settle finished on: Tof Voltage             |
		| Settle finished on: Reflectron Grid Voltage |
		| Settle finished on: Reflectron Voltage      |
		| Settle finished on: Quad Turbo Speed        |
		| Settle finished on: Source Turbo Speed      |
		| Settle finished on: Tof Turbo Speed         |

@cleanup-SET-03
Scenario: SET-03 - 'Timeout' Prevents Processes
	Given the "InstrumentMonitor.xml" file is modified to prevent the FlightTube voltage from ever being reached
		And the DebugView tool is opened
		And all Typhoon Services are 'Restarted'
		And the Quartz browser is 'Opened'
		And the browser is opened on the Tune page
 		And the instrument is in 'Operate' mode
	Then after '20' seconds a DebugView Tof Voltage timeout message is shown
		And it is not possible to start the following processes
			| Process        |
			| Acquisition    |
			| Detector Setup |
		# Current timeout is set to 20 seconds within InstrumentMonitor.xml

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: SET-04 - Switching Polarity
	Given the browser is opened on the Tune page
		And the instrument is in 'Operate' mode
		And the polarity is <Initial Polarity>
		# need to wait for the polarity change to have finished otherwise the DebugView could pick up the wrong messages.
		And I wait '20' seconds
		And the DebugView tool is opened
	When the polarity is switched to <New Polarity>
	Then DebugView <Started Settle Message> and <Finished Settle Message> are shown
		And there will be a <Minimum Delay> between the settle messages
			Examples:
			| Initial Polarity | New Polarity | Started Settle Message      | Finished Settle Message      | Minimum Delay |
			| Positive         | Negative     | Settle started on: Polarity | Settle finished on: Polarity | 18 seconds    |
			| Negative         | Positive     | Settle started on: Polarity | Settle finished on: Polarity | 18 seconds    |
			# Polarity switching normally takes approximately 18 seconds (1 second per kv for Tof Voltage to move from -9kv to +9kV)


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@cleanup-FullReconnect
Scenario Outline: SET-05 - Detector Setup (Pre-Run Settling Delay)
	Given the browser is opened on the Tune page
		And the instrument is in 'Operate' mode		
		And the polarity is <Initial Polarity>
		# need to wait for the polarity change to have finished otherwise the DebugView could pick up the wrong messages.
		And I wait '20' seconds
		And the DebugView tool is opened
	When the Detector Setup process is run in '<Run In Mode>' mode (using LeuEnk Vial) 
	Then the Detector Setup process will not start, until both Pre-Run DebugView '<Started Settle Message>' and '<Finished Settle Message>' are shown (if appropriate)
		And there will be a <Minimum Delay> between the settle messages
			Examples: Initial Positive Polarity
			| Initial Polarity | Run In Mode           | Started Settle Message      | Finished Settle Message      | Minimum Delay  |
			| Positive         | Positive only         | N/A (No Message)            | N/A (No Message)             | N/A (No Delay) |
			| Positive         | Negative only         | Settle started on: Polarity | Settle finished on: Polarity | 18 seconds     |
			| Positive         | Positive and Negative | N/A (No Message)            | N/A (No Message)             | N/A (No Delay) |
			
			Examples: Initial Negative Polarity
			| Initial Polarity | Run In Mode           | Started Settle Message      | Finished Settle Message      | Minimum Delay  |
			| Negative         | Negative only         | N/A (No Message)            | N/A (No Message)             | N/A (No Delay) |
			| Negative         | Positive only         | Settle started on: Polarity | Settle finished on: Polarity | 18 seconds     |
			| Negative         | Positive and Negative | Settle started on: Polarity | Settle finished on: Polarity | 18 seconds     |
			# Assumption - Detector Setup will always run Positive mode first, then Negative mode


@cleanup-FullReconnect
Scenario Outline: SET-06 - Detector Setup (Mid-Run Settling Delay)
	Given the browser is opened on the Tune page
		And the instrument is in 'Operate' mode 
		And the polarity is <Initial Polarity>
		And I wait '20' seconds
		And the DebugView tool is opened	
	When the Detector Setup process is run in 'Positive and Negative' mode and positive has completed
	Then the Negative Detector Setup process will not start, until both Mid-Run DebugView '<Started Settle Message>' and '<Finished Settle Message>' are shown
		And there will be a <Minimum Delay> between the settle messages
			Examples:
			| Initial Polarity | Started Settle Message      | Finished Settle Message      | Minimum Delay |
			| Positive         | Settle started on: Polarity | Settle finished on: Polarity | 18 seconds    |
			| Negative         | Settle started on: Polarity | Settle finished on: Polarity | 18 seconds    |
			# Assumption - Detector Setup will always run Positive mode first, then Negative mode


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@cleanup-SET-07
Scenario Outline: SET-07 - Manual Calibration
	Given the browser is opened on the Tune page
		And the instrument is in 'Operate' mode
		And the mode is <Initial Mode> and the polarity is <Initial Polarity>
		And a few seconds of data is Acquired
	When the mode is <Initial Mode> and the polarity is <Initial Polarity> 
		And I wait '20' seconds
		And the DebugView tool is opened
		And a Manual Calibration is Created using the Acquired data
	Then there will be no DebugView Settle messages shown
		Examples: No Change
		| Calibration Polarity | Calibration Mode | Initial Polarity | Initial Mode |
		| Positive             | Resolution       | Positive         | Resolution   |
		| Negative             | Sensitivity      | Negative         | Sensitivity  |

		Examples: Change in Polarity
		| Calibration Polarity | Calibration Mode | Initial Polarity | Initial Mode |
		| Positive             | Resolution       | Negative         | Resolution   |
		| Negative             | Sensitivity      | Positive         | Sensitivity  |

        Examples: Change in Mode
		| Calibration Polarity | Calibration Mode | Initial Polarity | Initial Mode |
		| Positive             | Sensitivity      | Positive         | Resolution   |
		| Negative             | Resolution       | Negative         | Sensitivity  |
		# Assumption - Create Calibration will use the data Polarity / Analyser Mode (i.e. not the current Polarity / Analyser Mode of the current instrument).


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: SET-08 - Minimum Settle Time - Switching Modes
	Given the browser is opened on the Tune page
		And that for each Polarity and Mode, the Flight Tube (Tof Voltage) instrument setting is as follows
			| Polarity | Mode        | Flight Tube  |
			| Positive | Resolution  | 7.00         |
			| Positive | Sensitivity | 9.00         |
			| Negative | Resolution  | 7.00         |
			| Negative | Sensitivity | 9.00         |
		And the instrument is in 'Operate' mode
		And the mode is <Initial Mode> and the polarity is <Initial Polarity>
		And I wait '20' seconds
		And the DebugView tool is opened
	When the mode is switched to <Switched to Mode>
	Then the time between DebugView Tof Voltage Settle started and finished messages, is at least '3' seconds
		Examples:
		| Initial Polarity | Initial Mode | Switched to Mode |
		| Positive         | Resolution   | Sensitivity      |
		| Positive         | Sensitivity  | Resolution       |
		| Negative         | Resolution   | Sensitivity      |
		| Negative         | Sensitivity  | Resolution       |
		# This Minimum Settle Time is imposed to allow correct updating of readbacks
		# The 'Flight Tube' settings are changed to force a 'Tof Voltage' settle message when changing mode
		# Ensure that the 'Flight Tube' settings are returned to their defaults after the test, to ensure other scenarios are not affected


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: SET-09 - No Settling Closing / Re-opening Quartz Browser
	Given the browser is opened on the Tune page
		And the instrument is in '<Status>' mode 
		And the polarity is <Initial Polarity>
		And I wait '20' seconds
		And the DebugView tool is opened
	When the Quartz browser is 'Closed'		
		And the Quartz browser is 'Re-opened'
	Then there will be no DebugView Settle messages shown
		Examples: Operate
		| Status  | Initial Polarity |
		| Operate | Positive         |
		| Operate | Negative         |

		Examples: Source Standby
		| Status         | Initial Polarity |
		| Source Standby | Positive         |
		| Source Standby | Negative         |

		Examples: Standby
		| Status  | Initial Polarity |
		| Standby | Positive         |
		| Standby | Negative         |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
@cleanup-FullReconnect
Scenario Outline: SET-10a - Acquisition Start Prevented (Part 1)
	Given the browser is opened on the Tune page
		And that for each Polarity and Mode, the Flight Tube (Tof Voltage) instrument setting is as follows
			| Polarity | Mode        | Flight Tube |
			| Positive | Resolution  | 7.00        |
			| Positive | Sensitivity | 9.00        |
			| Negative | Resolution  | 7.00        |
			| Negative | Sensitivity | 9.00        |
		And the instrument is in 'Operate' mode
		And the mode is <Initial Mode> and the polarity is <Initial Polarity>
		And I wait '20' seconds
		And the DebugView tool is opened listening for Settle and Method Runner messages
	When an attempt is made to initiate the Acquisition process with '<Method Polarity>' and '<Method Mode>'
	Then the Acquisition is not started, until both DebugView '<Started Settle Message>' and '<Finished Settle Message>' are shown (if appropriate)
		And there will be a <Minimum Delay> between the settle messages
			Examples: No Change
			| Initial Polarity | Initial Mode | Method Polarity | Method Mode | Started Settle Message         | Finished Settle Message         | Minimum Delay  |
			| Positive         | Resolution   | Positive        | Resolution  | N/A (No Message)               | N/A (No Message)                | N/A (No Delay) |
			| Negative         | Resolution   | Negative        | Resolution  | N/A (No Message)               | N/A (No Message)                | N/A (No Delay) |

			Examples: Change in Polarity
			| Initial Polarity | Initial Mode | Method Polarity | Method Mode | Started Settle Message         | Finished Settle Message         | Minimum Delay  |
			| Positive         | Resolution   | Negative        | Resolution  | Settle started on: Polarity    | Settle finished on: Polarity    | 18 seconds     |
			| Negative         | Sensitivity  | Positive        | Sensitivity | Settle started on: Polarity    | Settle finished on: Polarity    | 18 seconds     |

			Examples: Change in Mode
			| Initial Polarity | Initial Mode | Method Polarity | Method Mode | Started Settle Message         | Finished Settle Message         | Minimum Delay  |
			| Positive         | Resolution   | Positive        | Sensitivity | Settle started on: Tof Voltage | Settle finished on: Tof Voltage | 3 seconds      |
			| Negative         | Sensitivity  | Negative        | Resolution  | Settle started on: Tof Voltage | Settle finished on: Tof Voltage | 3 seconds      |
			# The 'Flight Tube' settings are changed to force a 'Tof Voltage' settle message when changing mode
			# Ensure that the 'Flight Tube' settings are returned to their defaults after the test, to ensure other scenarios are not affected

@cleanup-FullReconnect
Scenario Outline: SET-10b - Acquisition Start Prevented (Part 2)
	Given the browser is opened on the Tune page
		And that for each Polarity and Mode, the Flight Tube (Tof Voltage) instrument setting is as follows
			| Polarity | Mode        | Flight Tube |
			| Positive | Resolution  | 7.00        |
			| Positive | Sensitivity | 9.00        |
			| Negative | Resolution  | 7.00        |
			| Negative | Sensitivity | 9.00        |
		And the instrument is in 'Operate' mode
		And the mode is <Initial Mode> and the polarity is <Initial Polarity>
		And I wait '20' seconds
		And the DebugView tool is opened listening for Settle and Method Runner messages
	When an attempt is made to initiate the Acquisition process with '<Method Polarity>' and '<Method Mode>'
	Then the Acquisition is not started, until DebugView '<Settle Started on Messages>' and '<Settle Finished on Messages>' are shown
		And there will be a <Minimum Delay> between the first and last settle messages
			Examples: Both Polarity and Mode Change
			| Initial Polarity | Initial Mode | Method Polarity | Method Mode | Settle Started on Messages | Settle Finished on Messages | Minimum Delay |
			| Positive         | Sensitivity  | Negative        | Resolution  | Tof Voltage and Polarity   | Tof Voltage and Polarity    | 18 seconds    |
			| Negative         | Resolution   | Positive        | Sensitivity | Tof Voltage and Polarity   | Tof Voltage and Polarity    | 18 seconds    |
			# The 'Flight Tube' settings are changed to force a 'Tof Voltage' settle message when changing mode
			# Ensure that the 'Flight Tube' settings are returned to their defaults after the test, to ensure other scenarios are not affected


Scenario Outline: SET-11 - Manually Changing Flight Tube Voltages
	Given the browser is opened on the Tune page
		And the instrument is in 'Operate' mode
		And the Flight Tube voltage is set to <Initial Value>
		And I wait '25' seconds
		And the DebugView tool is opened
	When the Flight Tube voltage is set to <New Value>
	Then DebugView <Settle Started Message> and <Settle Finished Message> are shown
		And there will be a <Minimum Delay> between the settle messages
			Examples:
			| Initial Value | New Value | Settle Started Message         | Settle Finished Message         | Minimum Delay |
			| 5.00          | 4.50      | N/A                            | N/A                             | N/A            |
			| 5.00          | 5.50      | N/A                            | N/A                             | N/A            |
			| 5.00          | 4.40      | Settle started on: Tof Voltage | Settle finished on: Tof Voltage | 3 seconds      |
			| 5.00          | 5.60      | Settle started on: Tof Voltage | Settle finished on: Tof Voltage | 3 seconds      |
			| 1.00          | 10.00     | Settle started on: Tof Voltage | Settle finished on: Tof Voltage | 3 seconds      |
			| 10.00         | 1.00      | Settle started on: Tof Voltage | Settle finished on: Tof Voltage | 3 seconds      |
			# The Tof Voltage settle messages will only be shown when the value is outside the tolerance specified in '\Config\InstrumentMonitor.xml'
#END
