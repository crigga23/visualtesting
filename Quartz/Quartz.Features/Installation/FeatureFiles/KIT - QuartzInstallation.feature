# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # KIT - Quartz Installation
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CM
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 22-DEC-14
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
# Basis:                   # \\tu-server-sw\tu-server1\docs\Quartz\Quartz Smoke Test.xlsx
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@Installation
Feature: KIT - Quartz Installation
	In order to perform a Quartz Installation
	I want to be able to install the WEAP from disk and check it has installed correctly

@InstallQuartz
Scenario: KIT - Install Quartz on simulated instrument
	Given the installer is present
	Then I install the latest version of the installer

Scenario: KIT - Install Quartz on real instrument
	Given the installer is present
	Then I install the latest version of the installer
		And perform a soft reboot the instrument
		#And wait for 5 minutes for EPC to synchronise with the latest VxWorks
		#And ensure there is communication between ADC and EPC
		#And I start Typhoon
		#And wait for 30 seconds to connect to the legacy service
		#And I start Quartz
		#And that the Quartz Tune page is open
		#And purge the reference fluidics

Scenario: KIT - Uninstall Quartz
	Given Quartz is installed
	When Quartz is uninstalled
	Then the program is not present in add remove programs
