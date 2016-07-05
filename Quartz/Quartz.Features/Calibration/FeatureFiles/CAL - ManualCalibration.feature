# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # CAL - Manual Calibration
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Chris Stephens
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 24-April-2014
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # 17-June-2015 Added standard header details
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------------------------------------------------------
# Basis: /Typhoon/Platform/Dev Console/Software Specifications/ Dev Console Software Specification (Version 0.8)
# --------------------------------------------------------------------------------------------------------------------------------------------------
# Coverage:
#
# SS-248	The user will be able to manually calibrate the MS in all the supported modes of the instrument over different mass ranges using the Dev Console. **TODO**
# SS-255	The software will show sample data, reference data and the current calibration curve.
# SS-256	The software will allow the user to match peaks between sample data and reference data.
# SS-257	The software will allow the user to un-match peaks between sample data and reference data.
# SS-258	The software will display an initial set of automatically matched peaks.
# SS-259	The software will have the ability to return to the initial set of automatically patched peaks. **TODO**
# SS-260	The software will show calibrated residuals. **TODO**
# SS-261	The software will show linear residuals. **TODO**
# SS-263	The software will indicate matched peaks to the user.
# SS-264	The software will have the ability to accept a calibration.
# SS-265	The software will have the ability to reject a calibration.
# SS-262	The software will have the ability to display a calibration report.
# SS-266	The software will allow the user to change automatic peak matching parameters. **TODO**
# SS-269	The software will show summary information for the peak matching process.
# SS-267	The software will automatically update the summary information when changes occur. **TODO**

# SS-270	4.3.8.3 Calibration Report
# SS-271	The software will allow the user to display a calibration report. **TODO**
# SS-272	The software will allow the user to print the calibration report. **TODO**
# SS-273	The software will allow the user to generated a PDF of the calibration report. **TODO**

# SS-486	4.3.8.3.1 Calibration Report Content
# SS-487	The calibration report will contain a list or graph of the actual vs expected results, Mass residuals and statistical representations of the data. **TODO**
# ---------------------------------------------------------------------------------------------------------------------------------------------------

@Obsolete
@ignore
@Calibration
Feature: CAL - ManualCalibration
	In order to calibrate an instrument
	I want to be able to run calibration using Quartz

Background: Calibration - Manual Calibration - Record Tune Page
Given I have set positive and negative ADC values
	And a recording has been created of
| Compound         | Reservoir | Polarity |
| SodiumFormatePos | C         | Positive |
| SodiumFormateNeg | C         | Negative |
| SodiumIodidePos  | A         | Positive |

Scenario: CAL-01 - Manual Calibration - Check Recording List
Given the calibration tab is selected
Then the list of recordings is populated correctly

Scenario Outline: CAL-02 - Manual Calibration - Accept Default Calibration
Given the calibration tab is selected
And reference compound <reference> is selected
And sample recording <recording> is selected
And a calibration has been created
When I accept the calibration
Then the new calibration is applied
And the report is displayed
Examples:
| reference                 | recording        |
| Sodium Formate : Positive | SodiumFormatePos |
| Sodium Formate : Negative | SodiumFormateNeg |
| Sodium Iodide : Positive  | SodiumIodidePos  |


Scenario Outline: CAL-03 - Manual Calibration - Reject Default Calibration
Given the calibration tab is selected
And reference compound <reference> is selected
And sample recording <recording> is selected
And a calibration has been created
When I reject the calibration
Then the original calibration is intact
Examples:
| reference                 | recording        |
| Sodium Formate : Positive | SodiumFormatePos |
| Sodium Formate : Negative | SodiumFormateNeg |
| Sodium Iodide : Positive  | SodiumIodidePos  |

Scenario Outline: CAL-04 - Manual Calibration - Accept Random Calibration
Given the calibration tab is selected
And reference compound <reference> is selected
And sample recording <recording> is selected
And a calibration has been created
When I create a random calibration 
And I accept the calibration
Then the new calibration is applied
And the report is displayed
Examples:
| reference                 | recording        |
| Sodium Formate : Positive | SodiumFormatePos |
| Sodium Formate : Negative | SodiumFormateNeg |
| Sodium Iodide : Positive  | SodiumIodidePos  |

Scenario Outline: CAL-05 - Manual Calibration - Reject Random Calibration
Given the calibration tab is selected
And reference compound <reference> is selected
And sample recording <recording> is selected
And a calibration has been created
When I create a random calibration 
And I reject the calibration
Then the original calibration is intact
Examples:
| reference                 | recording        |
| Sodium Formate : Positive | SodiumFormatePos |
| Sodium Formate : Negative | SodiumFormateNeg |
| Sodium Iodide : Positive  | SodiumIodidePos  |

Scenario Outline: CAL-06 - Manual Calibration - Accept Empty Calibration
Given the calibration tab is selected
And reference compound <reference> is selected
And sample recording <recording> is selected
And a calibration has been created
When I create an empty calibration 
And I accept the calibration
Then the new calibration is applied
And the report is displayed
Examples:
| reference                 | recording        |
| Sodium Formate : Positive | SodiumFormatePos |
| Sodium Formate : Negative | SodiumFormateNeg |
| Sodium Iodide : Positive  | SodiumIodidePos  |

Scenario Outline: CAL-07 - Manual Calibration - Reject Empty Calibration
Given the calibration tab is selected
And reference compound <reference> is selected
And sample recording <recording> is selected
And a calibration has been created
When I create an empty calibration 
And I reject the calibration
Then the original calibration is intact
Examples:
| reference                 | recording        |
| Sodium Formate : Positive | SodiumFormatePos |
| Sodium Formate : Negative | SodiumFormateNeg |
| Sodium Iodide : Positive  | SodiumIodidePos  |

Scenario Outline: CAL-08 - Manual Calibration - Peak Picker Zoom In and Out
Given the calibration tab is selected
And a calibration has been created
When I zoom in and out of the peak picker '10' times 
Then the peak picker is updated correctly
And appropriate zooming messages are received
Examples:
| reference                 | recording        |
| Sodium Formate : Positive | SodiumFormatePos |
| Sodium Formate : Negative | SodiumFormateNeg |
| Sodium Iodide : Positive  | SodiumIodidePos  |

Scenario Outline: CAL-09 - Manual Calibration - Default Report Creation
Given the calibration tab is selected
And reference compound <reference> is selected
And sample recording <recording> is selected
And a calibration has been created
When I create a report
Then the report is displayed
And the charts match the peak picker
Examples:
| reference                 | recording        |
| Sodium Formate : Positive | SodiumFormatePos |
| Sodium Formate : Negative | SodiumFormateNeg |
| Sodium Iodide : Positive  | SodiumIodidePos  |

Scenario Outline: CAL-10 - Manual Calibration - Random Report Creation
Given the calibration tab is selected
And reference compound <reference> is selected
And sample recording <recording> is selected
And a calibration has been created
When I create a random calibration 
And I create a report
Then the report is displayed
And the charts match the peak picker
Examples:
| reference                 | recording        |
| Sodium Formate : Positive | SodiumFormatePos |
| Sodium Formate : Negative | SodiumFormateNeg |
| Sodium Iodide : Positive  | SodiumIodidePos  |
