# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - IMS Drift Plot
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 09-SEP-14
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # When in Mobility mode, right-click drag an m/z plot range to add a key item to the Drift Time plot
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # As above for Automation Test Notes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # N/A (Initial Version)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-225)                 # The software will provide a real time display of the acquired data (intensity/drift time)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-227)                 # The drift time display will be available only when the instrument is optimizing in high definition mode.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-228)                 # The user will be able to zoom into the spectral display in both drift time (drift time) and intensity
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-230)                 # The user will be able to undo zoom in on the spectral display  in both drift time and intensity
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-229)                 # The user will be able to return the display to the full acquisition drift time and intensity range.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-226)                 # The user will be able to configure the drift time display to show calibrated drift time or non calibrated drift time.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------



# ---------------------------------------------------------------------------------------------------------------------------------------------------
@ManualTune
@ManualOnly
@ignore
Feature: Drift Time Display
	In order to examine IMS Drift Time data in real time
	I want to be able to show various IMS Drift Time plots and examine each peak
# ---------------------------------------------------------------------------------------------------------------------------------------------------


Background:
	Given that a Quartz Development Console is available
	And the 'Instrument' section is selected
		And the 'Tune' option is selected


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-227)                 # The drift time display will be available only when the instrument is optimizing in high definition mode.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-01 - Drift Time Plot Availability
  	Given that the instrument is in '<Instrument Mode>'
  	When an attempt is made to view the Drift Time Plot
  	Then the Drift Time Plot '<Availability>' will be as shown below:
  		Examples:
		| Instrument Mode | Availability |
		| TOF             | Unavailable  |
		| Mobility        | Available    |


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-225)                 # The software will provide a real time display of the acquired data (intensity/drift time)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-02 - Drift Time Plot Axes
	Given that the instrument has a beam
		And the instrument is in '<Polarity>' and '<Analyser Mode>'
		And the instrument is in Mobility mode
		And the instrument is Tuning
	When a single m/z range is selected for inclusion in the Drift Time plot
		And the Drift Time Plot is selected for view
	Then the plot Drift Time Plot data will be shown in real time
  		And the plot will have a 'Drift Time' x-axis
  		And the plot will have an 'ADC Intensity' y-axis
			Examples:
			| Polarity | Analyser Mode |
			| Positive | Resolution    |
			| Positive | Sensitiviity  |
			| Negative | Resolution    |
			| Negative | Sensitiviity  |
			# single m/z range is selected by a right mouse click and drag on the normal Tof plot


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-228)                 # The user will be able to zoom into the spectral display in both drift time (drift time) and intensity
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-03 - Zoom-In Results to Drift Time and Intensity Scale
	Given the instrument is in Mobility mode
		And a single m/z range is selected for inclusion in the Drift Time plot
  	And the Drift Time Plot is selected for view
  	And there is an '<Initial Zoom State>'
  	When a specific '<Zoom-In Action>' is performed
  	Then results will be '<Drift Time Scale Changes>' and '<Intensity Scale Changes>'
  		Examples:
		| Initial Zoom State                    | Zoom-In Action           | Drift Time Scale Changes     | Intensity Scale Changes     |
		| None                                  | Drift Time only          | Drift Time scale zoomed      | No Change                   |
		| None                                  | Intensity only           | No Change                    | Intensity scale zoomed      |
		| None                                  | Drift Time and Intensity | Drift Time scale zoomed      | Intensity scale zoomed      |
		| Drift Time scale zoomed               | Drift Time only          | Drift Time scale zoomed more | No Change                   |
		| Drift Time scale zoomed               | Intensity only           | No Change                    | Intensity scale zoomed      |
		| Intensity scale zoomed                | Intensity only           | No Change                    | Intensity Scale zoomed more |
		| Intensity scale zoomed                | Drift Time only          | Drift Time scale zoomed      | No Change                   |
		| Drift Time and Intensity scale zoomed | Drift Time only          | Drift Time scale zoomed more | No Change                   |
		| Drift Time and Intensity scale zoomed | Intensity only           | No Change                    | Intensity Scale zoomed more |
		| Drift Time and Intensity scale zoomed | Drift Time and Intensity | Drift Time scale zoomed more | Intensity Scale zoomed more |


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-230)                 # The user will be able to undo zoom in on the spectral display in both drift time and intensity
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-229)                 # The user will be able to return the display to the full acquisition drift time and intensity range.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-04 - Zoom-Out Results to Zoom State (Already Zoomed-In)
  Given the instrument is in Mobility mode
  And a single m/z range is selected for inclusion in the Drift Time plot
  And the Drift Time Plot is selected for view
  And I perform a specific '<Zoom Type>' with an '<Initial Zoom State>'
	When a 'Zoom-Out' action is performed
  Then the results will be a 'Fully Zoomed-out' state
		Examples: Drift Time
		| Zoom Type  | Initial Zoom State    |
		| Drift Time | Zoomed-in once        |
		| Drift Time | Zoomed-in twice       |
		| Drift Time | Zoomed-in three times |
		| Drift Time | Zoomed-in four times  |

		Examples: Intensity
		| Zoom Type | Initial Zoom State    |
		| Intensity | Zoomed-in once        |
		| Intensity | Zoomed-in twice       |
		| Intensity | Zoomed-in three times |
		| Intensity | Zoomed-in four times  |

		Examples: Drift Time and Intensity
		| Zoom Type                | Initial Zoom State    |
		| Drift Time and Intensity | Zoomed-in once        |
		| Drift Time and Intensity | Zoomed-in twice       |
		| Drift Time and Intensity | Zoomed-in three times |
		| Drift Time and Intensity | Zoomed-in four times  |
        # Assumed behaviour same as current m/z plot
        # Drift Time = x-axis only zoom
		# Intensity = y-axis only zoom
		# Drift Time and Intensity = x-axis and y-axis zoom
	
Scenario: QRZ-05 - Zoom-Out Results to Zoom State (Already Fully Zoomed-Out)
	Given the instrument is in Mobility Mode
		And a single m/z range is selected for inclusion in the Drift Time plot
		And the Drift Time Plot is selected for view
		And the Initial Zoom State is 'Fully zoomed-out'
	When a 'Zoom-Out Action' is performed
	Then the Final Zoom State will remain 'Fully zoomed-out'
	# Assumed behaviour same as current m/z plot


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-226)                 # The user will be able to configure the drift time display to show calibrated drift time or non calibrated drift time.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
@FunctionalityIncomplete
@ignore
Scenario Outline: QRZ-06 - Showing Un-calibrated and Calibrated Data (Calibrated in Current Mode)
	Given that the instrument has a good beam
		And the instrument is Tuning
		And the instrument is in Mobility mode
		And a single m/z range is selected for inclusion in the Drift Time plot
		And the instrument is in '<Polarity>' and '<Analyser Mode>'
		And the instrument is Calibrated in Drift-Time for the current polarity and mode
	When the Drift Time Plot is selected for view
	Then it can show Non-calibrated Drift Time data
  		And it can also show Calibrated Drift Time Data
			Examples:
			| Polarity | Analyser Mode |
			| Positive | Resolution    |
			| Positive | Sensitiviity  |
			| Negative | Resolution    |
			| Negative | Sensitiviity  |

@FunctionalityIncomplete
@ignore
Scenario Outline: QRZ-07 - Showing Un-calibrated and Calibrated Data (Not Calibrated in Current Mode)
	Given that the instrument has a good beam
		And the instrument is Tuning
		And the instrument is in Mobility mode
		And a single m/z range is selected for inclusion in the Drift Time plot
		And the instrument is in '<Polarity>' and '<Analyser Mode>'
		And the instrument is NOT Calibrated in Drift-Time for the current polarity and mode
	When the Drift Time Plot is selected for view
	Then it can show Non-calibrated Drift Time data
		But it can NOT show Calibrated Drift Time Data
			Examples:
			| Polarity | Analyser Mode |
			| Positive | Resolution    |
			| Positive | Sensitiviity  |
			| Negative | Resolution    |
			| Negative | Sensitiviity  |


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-N/A)                 # Additional scenarios
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-08 - Adding Various Numbers of Overlapping and Non-Overlapping Ranges
	Given the instrument is in Mobility mode
		And the m/z plot is selected for view
  	When a '<Number>' of '<Specific m/z Range Types>' are selected for inclusion in the Drift Time plot
  		And the Drift Time plot is selected for view
  	Then each selected m/z range will be present as an individual item in the Drift Time plot key
	  	Examples: Overlapping
	    | Number | Specific m/z Range Types |
	    | 0      | N/A                      |
	    | 1      | Overlapping              |
	    | 5      | Overlapping              |
	    | 9      | Overlapping              |
	    | 10     | Overlapping              |

		Examples: Non-Overlapping
	    | Number | Specific m/z Range Types |
	    | 0      | N/A                      |
	    | 1      | Non-overlapping          |
	    | 5      | Non-overlapping          |
	    | 9      | Non-overlapping          |
	    | 10     | Non-overlapping          |
	    # Non-Overlapping example = 100-200, 200-300, 400-1000
	    # Overlapping example = 100-200, 150-300, 150-1000

Scenario Outline: QRZ-09 - Adding Over the Maximum Number of Ranges
	Given the instrument is in Mobility mode
		And the m/z plot is selected for view
  	When a '<Number>' of m/z ranges are selected for inclusion in the Drift Time plot
  		And the Drift Time plot is selected for view
  	Then the first ten m/z ranges (1-10) will be present in the Drift Time plot key
  	But any additional ranges will be discarded ( - they will not be present in the Drift Time plot key)
		Examples:
		| Number |
		| 11     |
		| 12     |

Scenario Outline: QRZ-10 - Adding, Deleting and Re-adding Various Numbers of Ranges
	Given the instrument is in Mobility mode
		And the m/z plot is selected for view
  	When a number of '<m/z Ranges>' are selected for inclusion in the Drift Time plot key
  	And the Drift Time plot is selected for view
  	And a number of '<Drift Time Key Items are Deleted>'
		And a number of '<m/z Ranges are Re-added>' to the Drift Time plot key
  	Then there will be a number of '<Drift Time Key Items Remaining>'
		Examples:
		| m/z Ranges | Drift Time Key Items are Deleted | m/z Ranges are Re-added | Drift Time Key Items Remaining |
		| 9          | 1                                | 1                       | 10                             |
		| 9          | 1                                | 3                       | 10                             |
		| 10         | 1                                | 1                       | 10                             |
		| 10         | 2                                | 3                       | 10                             |
		| 11         | 1                                | 1                       | 10                             |
		| 11         | 2                                | 4                       | 10                             |

Scenario Outline: QRZ-011 - Enabling Various Numbers of Plots from the Key
	Given that the instrument has a good beam
		And the instrument is Tuning
		And the instrument is in Mobility mode
		And the m/z plot is selected for view
  	When a number of '<m/z Ranges>' are selected for inclusion in the Drift Time plot key
  		And the Drift Time plot is selected for view
  	And a number of '<Drift Time Key Items are Enabled>'
  	Then for each enabled key item, there will be a corresponding Drift Time plot
  		And each key item will be shown in a different colour, which corresponds to a Drift Time plot of the same colour
		Examples: Zero Number of Ranges
		| m/z Ranges | Drift Time Key Items are Enabled |
		| 0          | 0                                |

		Examples: Minimum Number of Ranges
		| m/z Ranges | Drift Time Key Items are Enabled |
		| 1          | 0                                |
		| 1          | 1                                |

		Examples: Other Number of Ranges
		| m/z Ranges | Drift Time Key Items are Enabled |
		| 2          | 0                                |
		| 2          | 1                                |
		| 2          | 2                                |
		| 9          | 1                                |
		| 9          | 9                                |

		Examples: Maximum Number of Ranges
		| m/z Ranges | Drift Time Key Items are Enabled |
		| 10         | 0                                |
		| 10         | 1                                |
		| 10         | 5                                |
		| 10         | 9                                |
		| 10         | 10                               |

Scenario Outline: QRZ-012 - Deleting Various Numbers of Plots from the Key
	Given that the instrument has a good beam
		And the instrument is Tuning
		And the instrument is in Mobility mode
		And the m/z plot is selected for view
  	When a number of '<m/z Ranges>' are selected for inclusion in the Drift Time plot key
  		And the Drift Time plot is selected for view
  		And a number of '<Drift Time Key Items are Deleted>'
  	Then there will be a number of '<Drift Time Key Items Remaining>'
		Examples: Low Number of Ranges
		| m/z Ranges | Drift Time Key Items are Deleted | Drift Time Key Items Remaining |
		| 1          | 1                                | 0                              |
		| 2          | 1                                | 1                              |
		| 2          | 2                                | 0                              |
		
		Examples: Medium Number of Ranges
		| m/z Ranges | Drift Time Key Items are Deleted | Drift Time Key Items Remaining |
		| 5          | 3                                | 2                              |
		| 5          | 4                                | 1                              |
		| 5          | 5                                | 0                              |
		
		Examples: Maximum Number of Ranges
		| m/z Ranges | Drift Time Key Items are Deleted | Drift Time Key Items Remaining |
		| 10         | 1                                | 9                              |
		| 10         | 5                                | 5                              |
		| 10         | 9                                | 1                              |
		| 10         | 10                               | 0                              |

Scenario Outline: QRZ-013 - Pausing / Resuming Various Numbers of Enabled Ranges
	Given that the instrument has a good beam
		And the instrument is Tuning
		And the instrument is in Mobility mode
		And the m/z plot is selected for view
  	When a number of '<m/z Ranges>' are selected for inclusion in the Drift Time plot key
  		And the Drift Time plot is selected for view
  		And a number of Drift Time key items are '<Enabled>'
  		And an '<Action>' is performed on the instrument mode
  	Then there will be a corresponding '<Result>' for all enabled plots
	  	Examples:
	  	| m/z Ranges | Enabled | Action                    | Result              |
	  	| 1          | 1       | Switched to TOF mode      | Plot displays will freeze               |
	  	| 1          | 1       | Switched to Mobility mode | Plot displays will resume live updating |
		| 5          | 4       | Switched to TOF mode      | Plot displays will freeze               |
	  	| 5          | 4       | Switched to Mobility mode | Plot displays will resume live updating |
		| 10         | 10      | Switched to TOF mode      | Plot displays will freeze               |
	  	| 10         | 10      | Switched to Mobility mode | Plot displays will resume live updating |
	 	

# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END