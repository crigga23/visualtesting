
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # GEN - QRZ - Localisation
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 09-JUL-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # See 'Manual Test Notes' below.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Uninstall any existing instances of the Chrome browser.
#                          # Re-install the Chrome Browser from an official Google source (https://www.google.co.uk/chrome/browser/desktop/).
#                          # Language settings should be added / used from the Chrome Browser (Settings-->Advanced Settings-->Language and Input Settings)
#                          # WARNING: Be sure you know where you are clicking to set this option, as once the language has been changed, 
#                          #          the menus will be shown in the selected language and may be very difficult to find to change back!
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Quartz EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-167)	               # The software will localize the Quartz dashboard.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-168)	               # The software will localize all Quartz applications.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-169)	               # The software will perform the localization in the browser. 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-171)	               # The software will set the active locale from the browsers current setting.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-172)                 # The software will store localization resources for all supported languages.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-172)                 # The software will have a fallback local when the requested one is not supported.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specification/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-482)	               # Localisation for Chinese will be supported.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-483)	               # Localisation for Japanese will be supported.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
Feature: Localisation
	In order to check that the Quartz application GUI responds to a change in browser locale
	I want to be able to change the browser locale from English to a non-English language
	So that all the Quartz application GUI elements are displayed in the expected language


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-01 - Localisation
	Given the browser locale has been changed to <Selected Language>
		And the browser has been restarted
	When the following 'Quartz Application Areas' are inspected
		 | Quartz Application Areas                                  |
		 | Login Page                                                |
		 | Instrument tab pages (Tune, Calibration, etc..)           |
		 | Tools Tab pages (Property Viewer, Wrens Notebook, etc..)  |
		 | Buttons, Dropdown lists, Menus, Sub menus                 |
		 | All accessible forms, Dialogues, Windows, pop-out windows |
		 | Text, Text field defaults, Labels, Lists, Axes, Titles    |
		 | Reports and printed variants                              |
	Then all the GUI elements are shown in the <Expected Language>
		Examples:
		| Selected Language | Expected Language  |
		| Japanese (ja)     | Japanese (ja)      |
		| Chinese (zh)      | Chinese (zh)       |
		| Welsh - Cymraeg   | English (en)       |
		| English (en)      | English (en)       |
		# 'Welsh - Cymraeg' is unsupported so will show the default language 'English'.
			
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
