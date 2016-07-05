
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Plots
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 09-JUN-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # N/A
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Typhoon EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-209)                 # "It will be possible to see real time plots of the follow:
#                          # - Mass Spectrum
#                          # - Drift Time
#                          # - Chromatogram (BPI and TIC)
#                          # - Extracted Mass Chromatograms (XIC)
#                          # - Arbitrary readbacks
#                          # - Peak properties such as resolution and peak asymetry."
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-311)                 # Plots shall be updated per scan, up to 10 times per second.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-314)                 # It shall be possible to set the vertical gain to Normalise.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-210)                 # It will be possible to see multiple real-time plots simulatenously
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-316)                 # The Y-axis will display the Intensity and the X-axis would display the m/z.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-319)                 # The Resolution and Intensity in ions per push of the largest peak in the current view shall be displayed.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-318)                 # It shall be possible to sum spectra over a specified Elapsed Time or Scan Number range.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-312)                 # It shall be possible to zoom the x-axis display to muliple levels. It shall be possible to unzoom to a full view.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-313)                 # It shall be possible to adjust the vertical gain.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Software Specifications/Dev Console Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-219)                 # The software will provide a real time display of the acquired data (intensity/retention time)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-223)                 # The user will be able to zoom into the spectral display in both retention time and intensity
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-222)                 # The user will be able to undo zoom in of the spectral display  in both retention time and intensity
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-221)                 # The user will be able to return the display to the full acquisition retention time and intensity range.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-220)                 # The user will be able to reset the retention time display.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-236)                 # The user will be able to select read backs to plot against retention time.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-240)                 # The user will be able to reset the display.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-235)                 # The user will be able to select peak properties to plot against retention time.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-246)                 # The user will be able to reset the display.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-432)                 # The user will be able to generate an extracted mass chromatogram from the real time display on the manual optimization page
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-433)                 # The user will be able to zoom into the spectral display in both retention time and intensity.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-434)                 # The user will be able to undo zoom in of the spectral display in both retention time and intensity.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-435)                 # The user will be able to reset the retention time display.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Everest/3_Analysis Areas/Application Specific/Instruments/Mass Spectrometer Projects/Osprey/Osprey UNIFI ICS Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-957)                 # The software will provide a real time display of the acquired data (intensity/retention time)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-958)                 # The user will be able to zoom into the spectral display in both retention time (RT) and intensity
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-960)                 # The user will be able to return the display to the full acquisition RT and intensity range.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-942)                 # The software will provide a real time display of the acquired data (intensity/mass charge)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-943)                 # The user will be able to zoom into the spectral display in both m/z and intensity
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-944)                 # The user will be able to undo zoom in of the spectral display  in both m/z and intensity
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-947)                 # The user will be able to return the display to the full acquisition m/z and intensity range.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# CR ID: FW#8573           # PFD17725 DT plot, after a mass trace is added to the plot, the delete button is not present (Scenario TUN - 11)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@Ignore
Feature: Plots
	In order to check that the Tune page integrated and pop-out Plots are functioning correctly
	I want to be able to open and change associate plot settings
	So that the plot contents update accordingly


#----------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given that the Quartz Tune page is open
		And Detector Setup has been run successfully in both polarities
		And Instrument Setup 'Mass Calibration' has been run successfully in all default modes


#----------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: TUN - 01 - M/z Plot - Presence and Updating at various Mass Ranges and Scan Times
	When the 'Sodium Formate' Sample Fluidics Vial is selected
		And the Baffle is set to 'Sample'
		And the Tune page 'MZ' plot type is selected
		And Tuning is started with <Mass Range> and <Scan Time>
	Then all expected 'Sodium Formate' peaks are displayed across the full <Mass Range>
		And all peaks are updated at a frequency consistent with the selected <Scan Time>
		And the plotting can be Aborted and Tuning restarted more than once and the peaks are still present and updating
		And the plot Normalisation can be toggled more than once with a corresponding change in the Y-Axis peak scaling
		And the Y-axis will display the Intensity and the X-axis would display the m/z.
			Examples:
			| Mass Range | Scan Time |
			| 50-1000    | 0.1       |
			| 50-1000    | 1.0       |
			| 50-2000    | 0.5       |
			| 50-2000    | 1.0       |
			| 50-4000    | 5.0       |
			| 50-8000    | 5.0       |
			| 50-16000   | 5.0       |
			#-------------------------
			| 50-32000   | 5.0       |
			| 50-64000   | 5.0       |

Scenario: TUN - 02 - M/z Plot - Display Parameters
	When the 'Sodium Formate' Sample Fluidics Vial is selected
		And the Baffle is set to 'Sample'
		And the Tune page 'MZ' plot type is selected
	Then there should be 'Parameters' displayed in a set 'Position' outside the m/z plot grid
		| Parameter  | Position   |
		| IPP        | Top-Left   |
		| Resolution | Top-Middle |
		| Intensity  | Top-Right  |

Scenario: TUN - 03 - M/z Plot - Reference Beam within Acceptable Tolerance at Various Mass Ranges
	When the 'Leucine Enkephalin' Reference Fluidics Vial is selected
		And the Baffle is set to 'Reference'
		And the Tune page 'MZ' plot type is selected
		And the Veff has been set so the main 'Leucine Enkephalin' peak is at an m/z of '556.28' when at a High Mass range of 1000 
		And Tune page Tuning is started with <Mass Range> and Scan Time of 1.0 second
		And the main 'Leucine Enkephalin' peak is zoomed into
	Then the main 'Leucine Enkephalin' peak will still be displayed at an m/z of '556.28' within a tolerance of '+/- 0.05Da'
		Examples:
		| Mass Range | 
		| 50-1000    | 
		| 50-2000    |
		| 50-4000    |
		| 50-8000    |
		| 50-16000   | 
		| 50-32000   |
		| 50-64000   |


#----------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: TUN - 04 - BPI/TIC Trace - Presence and Updating at various Mass Ranges and Scan Times
	When the 'Sodium Formate' Sample Fluidics Vial is selected
		And the Baffle is set to 'Sample'
		And the Tune page <Plot Type> is selected
		And Tuning is started with <Mass Range> and <Scan Time>
		And the plot is Cleared
	Then a trace is present and updated at a frequency consistent with the selected <Scan Time>
		And the plotting can be Aborted and Tuning restarted more than once and the trace is still present and updating
		And the plot Normalisation can be toggled more than once with a corresponding change in the Y-Axis peak scaling
			Examples:
			| Plot Type | Mass Range | Scan Time |
			| BPI       | 50-1000    | 0.1       |
			| TIC       | 50-1000    | 1.0       |
			| BPI       | 50-2000    | 0.5       |
			| TIC       | 50-2000    | 1.0       |
			| BPI       | 50-4000    | 5.0       |
			| TIC       | 50-8000    | 5.0       |
			| BPI       | 50-16000   | 5.0       |
			#-------------------------------------
			| BPI       | 50-32000   | 5.0       |
			| TIC       | 50-64000   | 5.0       |

Scenario: TUN - 05 - XIC Trace - Presence and Updating at various Mass Ranges and Scan Times
	When the 'Sodium Formate' Sample Fluidics Vial is selected
		And the Baffle is set to 'Sample'
		And the Tune page MZ plot type is selected
		And Tuning is started with <Tuning Mass Range> and <Scan Time>
		And a 'Shift Right Click Drag' m/z <Mass Range Selection> is made
	Then a new pop-out XIC trace is shown with relevant 'Details'
		| Details                      |
		| Title                        |
		| Correct Mass Range Selection |
		| Non-zero Intensity           |
		| Correct X-Axis Label         |
		And the XIC plot is updated at a frequency consistent with the selected <Scan Time>
		And the plotting can be Aborted and Tuning restarted more than once and the trace is still present and updating
		And the plot Normalisation can be toggled more than once with a corresponding change in the Y-Axis peak scaling
			Examples:
			| Tuning Mass Range | Scan Time | Mass Range Selection |
			| 50-1000           | 0.1       | 100-200              |
			| 50-1000           | 1.0       | 50-55                |
			| 50-2000           | 0.5       | 200-800              |
			| 50-2000           | 1.0       | 500-550              |
			| 50-2000           | 5.0       | 75-1950              |
			| 50-4000           | 5.0       | 3000-4000            |
			| 50-8000           | 5.0       | 400-7000             |
			| 50-16000          | 5.0       | 12000-12500          |


Scenario: TUN - 06 - X and Y Axis Zooming (XIC Trace)
	When a new pop-out XIC trace is shown 
		And the XIC plot <Axis> is zoomed a <Number of Times>
	Then the XIC plot <Axis> is zoomed into the expected level each time
	When a single zoom-out is then performed
	Then the <Axis> is zoomed out to the original XIC plot Scan time range / Intensity
		Examples:
		| Axis    | Number of Times           |
		| X       | 1                         |
		| Y       | 2                         |
		| X and Y | Until Axes stops updating |
		
#----------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: TUN - 07 - Multiple Real Time plots
	When the 'Sodium Formate' Sample Fluidics Vial is selected
		And the Baffle is set to 'Sample'
		And the <Instrument Mode> is set
		And the <Tune Page Plot Type> is selected
		And Tuning is started with <Tuning Mass Range> and <Scan Time>
		And <Additional Pop-out Plots> are added
	Then all (Tune page and additional) plots are updated at a frequency consistent with the selected <Scan Time>
		And plotting can be Aborted and Tuning restarted more than once and all plots are still present and updating
		And individual plot Normalisation can be toggled more than once with a corresponding change in the individual Y-Axis peak scaling
			Examples:
			| Instrument Mode                | Tune Page Plot Type | Tuning Mass Range | Scan Time | Additional Pop-out Plots   |
			| TOF, Positive Sensitivity      | MZ                  | 50-1000           | 0.1       | MZ, BPI, TIC               |
			| TOF, Negative Resolution       | BPI                 | 50-2000           | 0.5       | MZ, MZ, BPI, BPI, TIC, TIC |
			| Mobility, Positive Sensitivity | TIC                 | 50-2000           | 1.0       | DT, DT, MZ, BPI, TIC       |
			
#----------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: TUN - 08 - X and Y Axis Zooming (MZ / BPI / TIC)
	When the 'Sodium Formate' Sample Fluidics Vial is selected
		And the Baffle is set to 'Sample'
		And the Tune page <Plot Type> is selected
		And Tuning is started at <Mass Range>
		And the <Axis> is zoomed a <Number of Times>
	Then the <Axis> is zoomed into the expected level each time
		And peaks are shown where appropriate
	When a single zoom-out is performed
	Then the <Axis> is zoomed out to the original Tuning mass range / Intensity
		Examples:
		| Plot Type     | Axis    | Mass Range | Number of Times           |
		| MZ            | X       | 50-1000    | 1                         |
		| MZ            | Y       | 50-4000    | 2                         |
		| MZ (Pop out)  | X and Y | 50-1000    | Until Axes stops updating |
		#-------------------------------------------------------------------
		| BPI           | X and Y | 50-1000    | 3                         |
		| BPI (Pop out) | X       | 50-1000    | 4                         |
		| BPI           | Y       | 50-1000    | Until Axis stops updating |
		#-------------------------------------------------------------------
		| TIC (Pop out) | Y       | 50-2000    | 5                         |
		| TIC           | X and Y | 50-2000    | 6                         |
		| TIC           | X       | 50-2000    | Until Axis stops updating |
		
#----------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: TUN - 09 - RB plots
	When the Tune page 'RB' plot type is selected
		And the Chart Readback <Filter> is applied
	Then the list of 'Available' items is filters so that only items containing the <Filter> keyword are present in the list
	When all existing entries in the 'Currently Plotted' group are removed
		And the <Selection> is moved to the 'Currently Plotted' group and then plotted
		And the <Tune Page Setting> is repeatedly toggled from <Value 1> to <Value 2>
	Then the plot will correspondingly show a triangular trace as the Y-axis value is plotted over time
		And the Y-axis will show the expected static range (starting from zero)
		And the Z-axis will show the time updating every second
		And the plot will only show values specific to the current <Selection>
		And the 'Clear' button will reset the X-axis so that the values are plotted from time zero
		And the ability to Normalise the Y-axis values will be unavailable
			Examples:
			| Filter       | Selection                          | Tune Page Setting                   | Value 1 | Value 2 |
			| transmission | DRE.transmission.Setting           | 'System 2' pDRE Attentuate          | 99.8    | 0.1     |
			| System1      | System1.Acceleration1.Setting      | 'System 1' Acceleration 1           | 100     | 0       |
			| Capillary    | Source.ReferenceCapillary.Readback | 'ESI LockSpray' Reference Capillary | 0.0     | 5.0     |

Scenario: TUN - 10 - PP plots
	When the instrument is set to 'Positive Sensitivity' mode
		And the <Fluidics Compound> Sample Vial is selected
		And the Baffle is set to 'Sample'
		And the Tune page 'PP' plot type is selected
		And the <Tracker Ion> and <Property> are selected and plotted
	Then the plot will correspondingly show a trace as the Y-axis <Property> is plotted over time
		And the Y-axis will show the expected static range (starting from zero)
		And the Z-axis will show the time updating every second
		And the plot will only show values specific to the current selection
		And the 'Clear' button will reset the X-axis so that the <Property> values are plotted from time zero
		And the ability to Normalise the Y-axis values will be unavailable
			Examples:
			| Fluidics Compound  | Tracker Ion                               | Property   |
			| Sodium Formate     | Sodium Formate (CHO2Na)11Na+ (CHO2Na)11Na | Intensity  |
			| Leucine Enkephalin | Leu Enk (M+H)+ C28H37N5O7H                | Resolution |
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
@ignore
@Updated
Scenario Outline: TUN - 11 - Mass trace in DT plots
When Tuning is started          
	And the <Instrument Mode> is set 
	And nine Right Click Drags are made on the Plot Data creating the following traces with their 'Mass Range Selection'
	| Mass Range Selection |
	| 50-100               |
	| 100-150              |
	| 200-250              |
	| 300-450              |
	| 500-600              |
	| 600-650              |
	| 700-800              |
	| 800-850              |
	| 900-1000             |
	And the DT plot type is selected                                    
Then the Mobility pop-out plot is displayed showing relevant 'Details' 
| Details                      |
| Title                        |
| Correct Drift Time Selection |
| Non-zero Intensity           | 
| Correct X-Axis Label         |                    
	And colored peaks pertaining to the Mass Range Selection are present in the Mobility plot
	# Zoom in might be needed to visualize the colored peaks
	And the Mass Range of the selected traces are displayed under the Key section 
	And the related Key has a waste bin on the right side and a ticked checkbox on the left side
	And no extra trace can be added on the Mobility plot
When the mass trace checkboxes are unticked 
Then the peaks on the plot are not visible
	And if all the mass traces checkboxes are unticked, the TIC trace is grayed out
When the Waste Bin is selected 
Then the peaks and Key entries are deleted
	And if all the mass traces are deleted, the TIC trace is grayed out 
	Examples: 
	| Instrument Mode                |
	| Mobility, Positive Sensitivity |
	| Mobility, Positive Resolution  |
	| Mobility, Negative Sensitivity |
	| Mobility, Negative Resolution  |
	
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
#END
