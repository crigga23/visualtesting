
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Health Checks
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 16-JUN-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #  See below (Manual Test Notes)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Detailed Descriptions were taken from...
#                          #   C:\Waters Corporation\Typhoon\webserver\i18n\modules\instrument\healthMonitor\en.json
#                          #
#                          # Failure parameters were taken from...
#                          #   C:\Waters Corporation\Typhoon\config\InstrumentMonitor.xml
#                          #
#                          # The following failures can be triggered within the Simulator by running these commands from the Typhoon\bin folder...
#                          #   KeyValueStoreClient.exe "Simulator" "Simulation.SourceDoor" "Open"
#                          #   KeyValueStoreClient.exe "Simulator" "Simulation.FusesState" "Removed"
#                          #   KeyValueStoreClient.exe "Simulator" "Simulation.SourcePressure" "Failed"

#                          # NOTE: At present (16/06/2015) the following should cause a failaure but don't...
#                          #   KeyValueStoreClient.exe "Simulator" "Simulation.SourceHeater" "Disconnected"
#                          #   KeyValueStoreClient.exe "Simulator" "Simulation.FluidicsLeakDetector" "Disconnected"
#                          #   KeyValueStoreClient.exe "Simulator" "Simulation.FluidicsLeak" "Leaking"
#                          #
#                          # Issue the command 'Ok' to clear the errors i.e....
#                          #   KeyValueStoreClient.exe "Simulator" "Simulation.FluidicsLeak" "Ok"
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Quartz Dashboard msi is installed
#                          # Chrome browser installed
#                          # Typhoon is started
#                          # Quartz Dashboard is running within the Chrome Browser
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Quartz EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-134)                 # The health page will provide the ability to view the health status of the instrument There will be an overall status along
#                          # with individual status of each health check. Each status will show a brief description of the problem.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-311                   # The software will display the overall health status to the user.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# SS-312                   # The overall health status being visible at all times within the main application.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-581)                 # Typhoon will provide mechanism to inform about current instrument health state.
#                          # Each health check will be configurable through the xml configuration file.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------



@Ignore
Feature: Health Checks
	In order to check that the Health Check monitoring system is functioning correctly
	I want to be able to change the status of various aspects of the instrument
	So that it triggers a Health Check failure and this failure can be cleared


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the Health Checks page is accessed


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: HEA-01 - Health Checks GUI - Columns
	When an ESI source is fitted
	Then the rows contain the following 'Columns'
		| Colums  |
		| Name    |
		| State   |
		| Details |
		And none of the row data can be edited
		
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: HEA-02 - Health Checks GUI - Basic Rows Available for all Supported Source Types
	When a <Source Type> is fitted
	Then the following health check rows should be available
		| Name                                          | State | Details                                                      |
		| Main Status                                   | Error | Detector setup positive polarity required                    |
		| EPC Connection status                         | Ok    | Connected                                                    |
		| Detector setup positive polarity required     | Error | The detector setup has to be performed for positive polarity |
		| Detector setup negative polarity required     | Error | The detector setup has to be performed for negative polarity |
		| Nitrogen gas failure                          | Ok    | Nitrogen gas ok                                              |
		| Source turbo speed                            | Ok    | Source turbo speed ok                                        |
		| TOF turbo speed                               | Ok    | TOF turbo speed ok                                           |
		| Probe heater fuse blown                       | Ok    | Probe heater fuse ok                                         |
		| Source door                                   | Ok    | The source door is closed                                    |
		| Source heater fuse blown                      | Ok    | Source heater fuse ok                                        |
		| Source pressure test API gas pressure warning | Ok    | Source pressure test API ok                                  |
		| High exhaust pressure warning                 | Ok    | High exhaust pressure ok                                     |
		| Exhaust problem warning                       | Ok    | Exhaust ok                                                   |
		| Source pressure test leak warning             | Ok    | Source pressure test leak ok                                 |
		| Source pressure test API gas trip             | Ok    | Source pressure test API gas ok                              |
		| Source pressure test exhaust trip             | Ok    | Source pressure test exhaust trip ok                         |
		| Source pressure test failed                   | Ok    | Source pressure test ok                                      |
		| Fluidics system error                         | Ok    | Fluidics system ok                                           |
		| Reference fluidics system error               | Ok    | Reference fluidics system ok                                 |
		| Source Standby                                | Ok    | Instrument standby or operate                                |
		| Fluidics Operation Stopped                    | Ok    | Fluidics ok                                                  |
		| Pump override enabled                         | Ok    | Pump override not active                                     |
		| Leak Sensor                                   | Ok    | Leak Sensor status ok                                        |
		| Instrument Standby                            | Ok    | Instrument in operate or source standby                      |
		| Source temperature settling failure           | Ok    | Source temperature settled ok                                |
		| Desolvation temperature settling failure      | Ok    | Desolvation temperature settled ok                           |
		| IMS Pressure Setup Failure.                   | Ok    | IMS Pressure run ok.                                         |
		| IMS Pressure Lock Failure.                    | Ok    | IMS Pressure Lock ok.                                        |

		Examples: Supported
		| Source Type    |
		| ESI            |
		| ESI Lockspray  |
		| Nano           |
		| Nano Lockspray |
		| APGC           |
		
	  # Examples: Future Release
	  # | APPI           |
	  # | APCI           |
	  # | APCI Lockspray |
	

Scenario Outline: HEA-03 - Health Checks GUI - Additional Rows Available for Specific Source Types (ESI, ESI Lockspray)
	When a <Source Type> is fitted
	Then the following health check rows with 'Name' 'State' and 'Details' information should be available
		| Name                            | State | Details                      |
		| Desolvation gas flow            | Ok    | Desolvation gas flow ok      |
		| Source heater disconnected      | Ok    | Source heater connected      |
		| Desolvation heater disconnected | Ok    | Desolvation heater connected |
		# Additional rows specific to ESI and ESI Lockspray sources
		And no additional rows specific to other source types should be shown
			Examples: Supported
			| Source Type    |
			| ESI            |
			| ESI Lockspray  |
			
Scenario Outline: HEA-04 - Health Checks GUI - Additional Rows Available for Specific Source Types (Nano, Nano Lockspray)
	When a <Source Type> is fitted
	Then the following health check rows with 'Name' 'State' and 'Details' information should be available
		| Name            | State | Details         |
		| Probe Withdrawn | Ok    | Probe connected |
		# Additional row specific to Nano and Nano Lockspray sources
		And no additional rows specific to other source types should be shown
			Examples: Supported
			| Source Type    |
			| Nano           |
			| Nano Lockspray |

Scenario: HEA-05 - Health Checks GUI - Additional Rows Available for Specific Source Types (APGC)
	When an APGC Source is fitted
	Then no additional rows specific to other source types should be shown

# Future Release
#Scenario HEA-xx - Health Checks GUI - Additional Rows Available for Specific Source Types (APPI)
#	When an APPI Source is fitted
#	Then the following health check rows with 'Name' 'State' and 'Details' information should be available
#		| Names                           | State | Details                      |
#		| APPI Fuse Blown                 | Ok    | APPI fuse ok                 |
#		| APPI lamp overheat              | Ok    | APPI lamp ok                 |
#		# Additional rows specific to the APPI source
#		And no additional rows specific to other source types should be shown

# Future Release			
#Scenario Outline HEA-xx - Health Checks GUI - Additional Rows Available for Specific Source Types (APCI, APCI Lockspray)
#	When a <Source Type> is fitted
#	Then the following health check rows with 'Name' 'State' and 'Details' information should be available
#		| Name                | State | Details       |
#		| APCI probe overheat | Ok    | APCI probe ok |
#		# Additional row specific to APCI and APCI Lockspray sources
#		And no additional rows specific to other source types should be shown
#		Examples: Supported
#		| Source Type    |
#		| APCI           |
#		| APCI Lockspray |


#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: HEA-06 - Health Checks - OK States
	When a <Source Type> is fitted
		And a specific <Instrument Status / Action> is present
	Then the Health Check <Name> will have an 'OK' (green) State and associated <Details>
		Examples: Any Source Type
		| Source Type    | Instrument Status / Action                      | Name                                          | Details                                  |
		| Any            | Instrument is placed into Operate               | Source Standby                                | Instrument standby or operate.           |
		| Any            | Instrument is placed into Operate               | Instrument Standby                            | Instrument in operate or source standby. |
		| Any            | Instrument is placed into Standby               | Source Standby                                | Instrument standby or operate.           |
		| Any            | Instrument Pumped (Source Turbo Speed >95%)     | Source Turbo Speed                            | Source turbo speed ok.                   |
		| Any            | Instrument Pumped (TOF Turbo Speed >95%)        | TOF Turbo Speed                               | TOF turbo speed ok.                      |
		| Any            | EPC Connected                                   | EPC Connection Status                         | EPC connected.                           |
		| Any            | Detector Setup run successfully (positive)      | Detector setup positive polarity required     | Detector setup positive ok.              |
		| Any            | Detector Setup run successfully (negative)      | Detector setup negative polarity required     | Detector setup negative ok.              |
		| Any            | Probe heater fuse not blown                     | Probe heater fuse blown                       | Probe heater fuse ok                     |
		| Any            | Source door closed                              | Source door                                   | The source door is closed                |
		| Any            | Source heater fuse not blown                    | Source heater fuse blown                      | Source heater fuse ok                    |
		| Any            | API source pressure OK                          | Source pressure test API gas pressure warning | Source pressure test API ok              |
		| Any            | Exhaust pressure OK                             | High exhaust pressure warning                 | High exhaust pressure ok                 |
		| Any            | Exhaust OK                                      | Exhaust problem warning                       | Exhaust ok                               |
		| Any            | Run Source pressure test (no leaks)             | Source pressure test leak warning             | Source pressure test leak ok             |
		| Any            | Run Source pressure test (API gas pressure OK)  | Source pressure test API gas trip             | Source pressure test API gas ok          |
		| Any            | Run Source pressure test (exhaust pressure OK)  | Source pressure test exhaust trip             | Source pressure test exhaust trip ok     |
		| Any            | Run Source pressure test (no leak)              | Source pressure test failed                   | Source pressure test ok                  |
		| Any            | No Sample fluidics system error                 | Fluidics system error                         | Fluidics system ok                       |
		| Any            | No Reference fluidics system error              | Reference fluidics system error               | Reference fluidics system ok             |
		| Any            | Instrument in standby or operate                | Source Standby                                | Instrument standby or operate            |
		| Any            | Fluidics not in a Stopped state                 | Fluidics Operation Stopped                    | Fluidics ok                              |
		| Any            | Pump override not active                        | Pump override enabled                         | Pump override not active                 |
		| Any            | Leak not detected (MS fluidics)                 | Leak Sensor                                   | Leak Sensor status ok                    |
		| Any            | Source temperature settled                      | Source temperature settling failure           | Source temperature settled ok            |
		| Any            | Desolvation temperature settled                 | Desolvation temperature settling failure      | Desolvation temperature settled ok       |
		| Any            | IMS Pressure Setup passed                       | IMS Pressure Setup Failure                    | IMS Pressure run ok.                     |
		| Any            | IMS Pressure Setup passed and locked            | IMS Pressure Lock Failure                     | IMS Pressure Lock ok.                    |
		
        Examples: ESI Source Type (Supported)
		| Source Type    | Instrument Status / Action                      | Name                                          | Details                                  |
		| ESI            | Desolvation Gas (readback 50 or greater)        | Desolvation gas flow                          | Desolvation gas flow ok                  |
		| ESI            | Source heater connected                         | Source heater disconnected                    | Source heater connected                  |
		| ESI            | Desolvation heater connected                    | Desolvation heater disconnected               | Desolvation heater connected             |

		Examples: ESI Lockspray Source Type (Supported)
		| Source Type    | Instrument Status / Action                      | Name                                          | Details                                  |
		| ESI Lockspray  | Desolvation Gas (readback 50 or greater)        | Desolvation gas flow                          | Desolvation gas flow ok                  |
		| ESI Lockspray  | Source heater connected                         | Source heater disconnected                    | Source heater connected                  |
		| ESI Lockspray  | Desolvation heater connected                    | Desolvation heater disconnected               | Desolvation heater connected             |

		Examples: Nano Source Type (Supported)
		| Source Type    | Instrument Status / Action                      | Name                                          | Details                                  |
		| Nano           | XYZ plate fitted and inserted                   | Probe Withdrawn                               | Probe connected                          |

		Examples: Nano Source Type (Supported)
		| Source Type    | Instrument Status / Action                      | Name                                          | Details                                  |
		| Nano Lockspray | XYZ plate fitted and inserted                   | Probe Withdrawn                               | Probe connected                          |
		
		Examples: APGC Source Type (Supported)
		| Source Type    | Instrument Status / Action                      | Name                                          | Details                                  |
		| APGC           | N/A                                             | N/A                                           | N/A                                      |
		
	  # Examples: Specific Source Type (Future Release)
	  # | Source Type    | Instrument Status / Action                      | Name                                          | Details                                  |
	  # | APPI           | APPI lamp temperature OK                        | APPI lamp overheat                            | APPI lamp ok                             |
	  # | APPI           | APPI Fuse not blown                             | APPI Fuse Blown                               | APPI fuse ok                             |
	  # | APCI           | APCI probe temperature OK                       | APCI probe overheat                           | APCI probe ok                            |
	  # | APCI Lockspray | APCI probe temperature OK                       | APCI probe overheat                           | APCI probe ok                            |  


Scenario Outline: HEA-07 - Health Checks - Error States (and Clearing Errors)
	When a <Source Type> is fitted
		And a specific <Instrument Status / Action> is initiated
	Then the Health Check <Name> will have an 'Error' (red) state and associated <Details>
		And when the <Instrument Status / Action> causing the 'Error' is clear or resolved, then the Health Check <Name> will have an 'OK' (green) State
		Examples: Error
		| Source Type    | Instrument Status / Action                                     | Name                                          | Details                                                                                                                                                 |
		| Any            | Instrument Vented - Source turbo speed (95% or less)           | Source Turbo Speed                            | Source turbo speed must be greater than 95% for the detector to operate.                                                                                |
		| Any            | Instrument Vented - TOF turbo speed (95% or less)              | TOF Turbo Speed                               | TOF turbo speed must be greater than 95% for the detector to operate.                                                                                   |
		| Any            | Detector Setup not run (positive)                              | Detector setup positive polarity required     | The detector setup has to be performed for positive polarity.                                                                                           |
		| Any            | Detector Setup not run (negative)                              | Detector setup negative polarity required     | The detector setup has to be performed for negative polarity.                                                                                           |
		| Any            | Probe heater fuse blown                                        | Probe heater fuse blown                       | A blown probe heater fuse has been detected.Please contact Waters technical service for assistance.                                                     |
		| Any            | Source door open                                               | Source door                                   | The source door is open.Close the source door to enable the detector to operate.                                                                        |
		| Any            | Source heater fuse blown                                       | Source heater fuse blown                      | A blown source heater fuse has been detected.Please contact Waters technical service for assistance.                                                    |
		| Any            | Sample fluidics system error                                   | Fluidics system error                         | The instrument fluidics system encountered an error.                                                                                                    |
		| Any            | Reference fluidics system error                                | Reference fluidics system error               | The instrument reference fluidics system encountered an error.                                                                                          |
		| Any            | Instrument is placed into Source Standby                       | Source Standby                                | The instrument must be in Operate mode to acquire data. The instrument might have been put in Source Standby manually, or an error could have occurred. |
		| Any            | Fluidics in a Stopped state (failed source pressure test)      | Fluidics Operation Stopped                    | A fluidics operation has been stopped. The fluidics are not in a useable state.                                                                         |
		| Any            | Pump override active / enabled                                 | Pump override enabled                         | Pump override enabled.                                                                                                                                  |
		| Any            | Leak detected (MS fluidics)                                    | Leak Sensor                                   | A leak has been detected in the MS fluidics system. Check all fluidic connections.                                                                      |
		| Any            | Instrument is placed into Source Standby                       | Source Standby                                | The instrument must be in Operate mode to acquire data. The instrument might have been put in Source Standby manually, or an error could have occurred. |
		| Any            | Instrument is placed into Source Standby                       | Instrument Standby                            | The instrument must be in Operate mode to acquire data. The instrument might have been put in Standby manually, or an error could have occurred.        |
		| Any            | Instrument is placed into Standby                              | Instrument Standby                            | The instrument must be in Operate mode to acquire data. The instrument might have been put in Standby manually, or an error could have occurred.        |
		| Any            | API source pressure test failed (pressure too low)             | Source pressure test API gas pressure warning | The source pressure test is indicating a low API gas pressure warning.Please wait for the test to complete.                                             |
		| Any            | Exhaust pressure too high                                      | High exhaust pressure warning                 | High source exhaust pressure has been observed.Refer to online help.                                                                                    |
		| Any            | Exhaust blocked                                                | Exhaust problem warning                       | Source pressure monitoring is indicating a possible exhaust problem.Refer to online help.                                                               |
		| Any            | Run Source pressure test (leak detected)                       | Source pressure test leak warning             | The source pressure test is indicating a possible source leak.Please wait for the test to complete.                                                     |
		| Any            | Run Source pressure test (API gas too low)                     | Source pressure test API gas trip             | The source pressure test failed to complete due to low API gas pressure.Refer to online help.                                                           |
		| Any            | Run Source pressure test (exhaust pressure too high)           | Source pressure test exhaust trip             | The source pressure test failed to complete due to high exhaust pressure.Refer to online help.                                                          |
		| Any            | Run Source pressure test (failed)                              | Source pressure test failed                   | The source pressure test failed. Possible source leak.Refer to online help.                                                                             |
		| Any            | IMS Pressure Setup failed                                      | IMS Pressure Setup Failure                    | IMS Pressure Setup has failed.                                                                                                                          |
		| Any            | IMS Pressure Lock failed                                       | IMS Pressure Lock Failure                     | IMS Pressure Lock has failed.                                                                                                                           |
				
		Examples: ESI Source Types (Supported)
		| Source Type    | Instrument Status / Action                                     | Name                                          | Details                                                                                                                                                 |
		| ESI            | Desolvation Gas (readback less than 50)                        | Desolvation gas flow                          | The desolvation gas flow is too low. The flow rate set must exceed the minimum desolvation gas flow rate. If the flow rate setting is appropriate...    |
		| ESI            | Source heater disconnected                                     | Source heater disconnected                    | The source heater is disconnected.Reconnect the source heater before continuing.                                                                        |
		| ESI            | Desolvation heater disconnected                                | Desolvation heater disconnected               | The desolvation heater is disconnected.Reconnect the desolvation heater before continuing.                                                              |
		
		Examples: ESI Lockspray Source Types (Supported)
		| Source Type    | Instrument Status / Action                                     | Name                                          | Details                                                                                                                                                 |
		| ESI Lockspray  | Desolvation Gas (readback less than 50)                        | Desolvation gas flow                          | The desolvation gas flow is too low. The flow rate set must exceed the minimum desolvation gas flow rate. If the flow rate setting is appropriate...    |
		| ESI Lockspray  | Source heater disconnected                                     | Source heater disconnected                    | The source heater is disconnected.Reconnect the source heater before continuing.                                                                        |
		| ESI Lockspray  | Desolvation heater disconnected                                | Desolvation heater disconnected               | The desolvation heater is disconnected.Reconnect the desolvation heater before continuing.                                                              |
		
		Examples: Nano Source Types (Supported)
		| Source Type    | Instrument Status / Action                                     | Name                                          | Details                                                                                                                                                 |
		| Nano           | XYZ plate extracted                                            | Probe Withdrawn                               | No probe is connected. A suitable probe must be connected to enable the detector to operate.                                                            |
		
		Examples: Nano Lockspray Source Types (Supported)
		| Source Type    | Instrument Status / Action                                     | Name                                          | Details                                                                                                                                                 |
		| Nano Lockspray | XYZ plate extracted                                            | Probe Withdrawn                               | No probe is connected. A suitable probe must be connected to enable the detector to operate.                                                            |
		
		Examples: APGC Source Type (Supported)
		| Source Type    | Instrument Status / Action                                     | Name                                          | Details                                                                                                                                                 |
		| APGC           | N/A                                                            | N/A                                           | N/A                                                                                                                                                     |
		# NOTE: Some of the above failures can be triggered and cleared within the Simulator - see header 'Manual Test Notes' above.
		# NOTE: Some of the Details have been shorted (...) to aid readability - for the full Details see '\Typhoon\webserver\i18n\modules\instrument\healthMonitor\en.json'
      
		# Examples: Specific Source Types (Future Release)
		# | Source Type    | Instrument Status / Action                                     | Name                                          | Details                                                                                                                                                                                                                                                |
		# | APPI           | APPI lamp overheated                                           | APPI lamp overheat                            | The RF coil associated with the APPI lamp has overheated. Wait for the lamp to cool...                                                                  |
		# | APPI           | APPI Fuse blown                                                | APPI Fuse Blown                               | A blown APPI fuse has been detected.Please contact Waters technical service for assistance.                                                             |
		# | APCI           | APCI probe temperature overheated                              | APCI probe overheat                           | The APCI probe has overheated, probably because the nebulizing gas flow is restricted...                                                                |
        # | APCI Lockspray | APCI probe temperature overheated                              | APCI probe overheat                           | The APCI probe has overheated, probably because the nebulizing gas flow is restricted...                                                                |

Scenario Outline: HEA-08 - Health Checks - Warning States (and Clearing Warnings)
	When a specific <Instrument Status / Action> is initiated
	Then the Health Check <Name> will have a 'Warning' (orange) state and associated <Details>
		And when the <Instrument Status / Action> causing the 'Warning' is clear or resolved, then the Health Check <Name> will have an 'OK' (green) State
		| Instrument Status / Action                                     | Name                                          | Details                                                                               |
		| Source temperature settling took longer than 1800 seconds      | Source temperature settling failure           | The source temperature has failed to settle, possibly due to a hardware problem.      |
		| Desolvation temperature settling took longer than 1800 seconds | Desolvation temperature settling failure      | The desolvation temperature has failed to settle, possibly due to a hardware problem. |


#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: HEA-09 - Application - Overall Health Status Indicator
	When an <Instrument Page> is selected
	Then the 'Overall Health Status Indicator' will be visible within the main application
		Examples:
		| Instrument Page      |
		| Tune                 |
		| Calibration          |
		| Instrument Setup     |
		| Vacuum               |
		| Quad Setup           |
		| Detector Setup       |
		| Scope Mode           |
		| Source Pressure Test |
		| IMS Pressure Test    |
		# The 'Overall Health Status Indicator' will show information such as "Health Status: Instrument OK", "...Instrument in Error", "...Instrument Warning" etc.
		# The Health Status page is checked in the next Scenario
		

Scenario Outline: HEA-10 - Main Status State and Details + Overall Indicator
	When an 'ESI' source is fitted
		And there are a <Number of Rows in Error State> within the Health Status page below the Main Status
		And there are a <Number of Rows in Warning State> within the Health Status page below the Main Status
	Then the <Health Status Page - Main Status State> will be shown
		And the <Health Status Page - Main Status Details> will be shown
		And the <Application - Overall Health Status Indicator> details will be shown
		Examples: Errors only
		| Number of Rows in Error State | Number of Rows in Warning State | Health Status Page - Main Status State | Health Status Page - Main Status Details                 | Application - Overall Health Status Indicator |
		| 0                             | 0                               | Ok                                     | Ok                                                       | Instrument OK                                 |
		| 1                             | 0                               | Error                                  | Name of 'Error' status row                               | Instrument in Error                           |
		| 2 (or more)                   | 0                               | Error                                  | Name of 'Error' status row that is highest in the list   | Instrument in Error                           |

		Examples: Warnings only
		| Number of Rows in Error State | Number of Rows in Warning State | Health Status Page - Main Status State | Health Status Page - Main Status Details                 | Application - Overall Health Status Indicator |
		| 0                             | 0                               | Ok                                     | Ok                                                       | Instrument OK                                 |
		| 0                             | 1                               | Warning                                | Name of 'Warning' status row                             | Instrument Warning                            |
		| 0                             | 2 (or more)                     | Warning                                | Name of 'Warning' status row that is highest in the list | Instrument Warning                            |

		Examples: Errors and Warnings
		| Number of Rows in Error State | Number of Rows in Warning State | Health Status Page - Main Status State | Health  Status Page - Main Status Details                | Application - Overall Health Status Indicator |
		| 1                             | 1                               | Error                                  | Name of 'Error' status row                               | Instrument in Error                           |
		| 2 (or more)                   | 1                               | Error                                  | Name of 'Error' status row that is highest in the list   | Instrument in Error                           |
		| 1                             | 2 (or more)                     | Error                                  | Name of 'Error' status row                               | Instrument in Error                           |
			
		# NOTE: Some failures can be triggered within the Simulator - see header 'Manual Test Notes' above.
		# NOTE: Assumption - Rows are in priority order - the most important are at the top, the least important at the bottom

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END