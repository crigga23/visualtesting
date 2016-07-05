
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - BPI Intensity
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 12-JAN-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Simulated - data for Sodium Formate / Leucine Enkephalin can be accessed by selecting Vial 'A' and 'B' respectively.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Real instrument - Sodium Formate / Leucine Enkephalin are normally available in Vial 'C' and 'B' respectively.
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
# (SS-453)                 # The software will provide the display of BPI plot with peak of maximum intensity per scan and intensity as well.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-366)                 # The software will allow the user to display M/Z, TIC and BPI traces
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/Dev Console/Designs/Dev Console High Level Design
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (HDD-382)                # The Plot Panel will display the base peak intensity on BPI plot.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


@ignore
Feature: BPI Intensity
	In order to monitor the intensity of the largest peak within an MZ mass range
	I want to be able to select the BPI plot during tuning
	so that a constantly updating BPI intensity is clearly displayed


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the Veff has been adjusted correctly for Positive and Negative modes using Leucine Enkephalin
	And there is a good Sodium Formate beam available in Positive and Negative modes (within the mass range 50-1200)
	

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-01 - BPI Intensity (Single Peak)
	When a Method with <Polarity> and <Mass Range> is loaded
		And the MZ y-axis 'ADC response Intensity' of the most intense peak has been roughly determined
		Then the 'BPI Intensity' value will be shown top-right of the BPI 'Plot Type'
		| Plot Type |
		| Tune Page |
		| Pop-out   |
		And the 'BPI Intensity' value will be shown in exponent format
		And the 'BPI Intensity' value will be consistent with the MZ y-axis 'ADC response Intensity' previously determined
		And the 'BPI Intensity' value will be consistent with the current BPI y-axis 'ADC response Intensity' points being plotted

		Examples: Positive Polarity - Single Peak
		| Polarity | Mass Range | 
		| Positive | 89-92      | 
		| Positive | 157-160    | 
		| Positive | 633-636    |
		| Positive | 1245-1248  | 
		| Positive | 1993-1996  | 
		
		Examples: Negative Polarity - Single Peak
		| Polarity | Mass Range | 
		| Negative | 111-114    | 
		| Negative | 179-182    | 
		| Negative | 655-658    | 
		| Negative | 1267-1270  | 
		| Negative | 1947-1950  | 
		# Mass range peak selected from Sodium Formate reference XML (C:\Waters Corporation\Typhoon\config\referenceCompounds)
		# Exponent format examples '5e01', '1.2e05', '1.23e3', '1.234e5'
		# NOTE: There may be two or more interchangeable most intense peaks - just roughly determine the average MZ intensity of these peaks 


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-02 - BPI Intensity (Multiple Peaks - Most Intense Independently Determined)
	When a Method with <Polarity> and <Mass Range> is loaded
		And the MZ y-axis 'ADC response Intensity' of the most intense peak has been roughly determined
	Then the 'BPI Intensity' value will be shown top-right of the BPI 'Plot Type'
		| Plot Type |
		| Tune Page |
		| Pop-out   |
		And the 'BPI Intensity' value will be consistent with the MZ y-axis 'ADC response Intensity' previously determined
		
		Examples: Positive Polarity - Mutiple Peaks
		| Polarity | Mass Range |
		| Positive | 50-600     |
		| Positive | 600-1200   |
		| Positive | 50-1200    |
		
		Examples: Negative Polarity - Mutiple Peaks
		| Polarity | Mass Range |
		| Negative | 50-600     |
		| Negative | 600-1200   |
		| Negative | 50-1200    |
		# NOTE: There may be two or more interchangeable most intense peaks - just roughly determine the average MZ intensity of these peaks 



# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-03 - BPI Intensity - Update Interval
	When a Method with <Polarity> and <Scan Time> and <Mass Range> is loaded
	Then the 'BPI Intensity' value at the top-right of the BPI 'Plot Type' will update every <Interval> seconds
		| Plot Type |
		| Tune Page |
		| Pop-out   |

		Examples: Positive Polarity
		| Polarity | Scan Time | Mass Range | Interval   |
		| Positive | 0.1       | 600-1200   | 0.25       |
		| Positive | 1.0       | 600-1200   | 1          |
		| Positive | 5.0       | 600-1200   | 5          |

		Examples: Positive Polarity
		| Polarity | Scan Time | Mass Range | Interval   |
		| Negative | 0.1       | 1200-2000  | 0.25       |
		| Negative | 1.0       | 1200-2000  | 1          |
		| Negative | 5.0       | 1200-2000  | 5          |
		# Update frequency for scan time of 0.1 is limited to 4 per second


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-04 - BPI Intensity - Vial Selection
	Given Leucine Enkephalin is infusing with a good beam
	When Fluidics <Vial> is selected
		And the MZ y-axis 'ADC response Intensity' of the most intense peak has been roughly determined
	Then the 'BPI Intensity' value will be shown top-right of the BPI 'Plot Type'
		| Plot Type |
		| Tune Page |
		| Pop-out   |
		And the 'BPI Intensity' value will be consistent with the MZ y-axis 'ADC response Intensity' previously determined for <Vial> solution

		Examples:
		| Vial               |
		| Sodium Formate     |
		| Leucine Enkephalin |
		# The BPI Intensity value updates according to Vial / Solution
		# NOTE: There may be two or more interchangeable most intense peaks - just roughly determine the average MZ intensity of these peaks 
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-05 - BPI Intensity - MZ Zooming
	When a Method with 'Mass Range' is loaded
		| Mass Range |
		| 100-1200    |
		And the MZ y-axis 'ADC response Intensity' of the most intense peak has been roughly determined
		And an MZ plot <Zoom Range> is selected
	Then the 'BPI Intensity' value will be shown top-right of the BPI 'Plot Type'
		| Plot Type |
		| Tune Page |
		| Pop-out   |
		And the 'BPI Intensity' value will be consistent with the MZ y-axis 'ADC response Intensity' previously determined
	
		Examples: Positive Polarity
		| Zoom Range |
		| 100-200    |
		| 175-200    |
		| 200-1000   |
		# Assumption: The intensity for most intense peak(s) from the entire MZ range is shown regardless of MZ Zooming
		# NOTE: There may be two or more interchangeable most intense peaks - just roughly determine the average MZ intensity of these peaks 


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-06 - BPI Intensity - Normalise Mode (y-Axis Scale Adjust)
	When an unmodified 'ms.xml' Custom Tune method is loaded
		And the MZ y-axis 'ADC response Intensity' of the most intense peak has been roughly determined
		And the BPI <Plot Type> is selected
	Then if the 'Normalise Mode' is toggled the 'BPI Intensity' value is still shown top-right of the BPI plot 
		| Normalise Mode |
		| OFF            |
		| ON             |
		| OFF            |
		And the 'BPI Intensity' value will be shown in exponent format
		And the 'BPI Intensity' value will be consistent with the MZ y-axis 'ADC response Intensity' previously determined

		Examples:
		| Plot Type | 
		| Tune Page | 
		| Pop-out   | 
		# NOTE: There may be two or more interchangeable most intense peaks - just roughly determine the average MZ intensity of these peaks 


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-07 - BPI Intensity - Multiple Function Selection
	Given Leucine Enkephalin is infusing with a good beam
	When Fluidics 'Vial' is selected and the MZ y-axis 'ADC response Intensity' of the most intense peak has been roughly determined for each vial
		| Vial               |
		| Sodium Formate     |
		| Leucine Enkephalin |
	And the following modified 'ms_lockmass.xml' Custom Tune method is loaded
		"""
		<?xml version="1.0"?>
		<MsMethod InstrumentType="QTof" InstrumentModel="Osprey" Version="1.0">
			<Settings>
				<Setting Name="SourceTemperature" Value="130.0" Mapping="Source.SourceTemperature.Setting"/>
			</Settings>
			<Setup Type="LockMass">
				<Settings>
					<Setting Name="LockMass" Value="566.28"/>
					<Setting Name="Interval" Value="10.0"/>
				</Settings>
			</Setup>

			<Function Type="MS" TimeStart="0.0" TimeEnd="300.0">
				<Instance>
					<Settings>
						<Setting Name="StartMass" Value="100.0"/>
						<Setting Name="EndMass" Value="1200.0"/>
						<Setting Name="ScanTime" Value="1.0"/>
						<Setting Name="InterscanDelay" Value="0.005"/>
					</Settings>
				</Instance>
			</Function>
		</MsMethod>
		"""
		And BPI <Plot Type> is selected
		And BPI <Function> drop-down is selected
	Then 'BPI Intensity' value is updated every <Interval> seconds
		And the 'BPI Intensity' value will be consistent with the MZ y-axis 'ADC response Intensity' previously determined for each vial
		
		Examples:
		| Plot Type | Function | Interval |
		| Tune Page | 1:MS     | 1.0      |
		| Tune Page | 2:MS     | 10.0     |
		| Pop-out   | 1:MS     | 1.0      |
		| Pop-out   | 2:MS     | 10.0     |
		# In Simulated mode, ensure that the Sample vial is set to 'A' and the Reference vial is set to 'B' before running the method
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
