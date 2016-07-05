
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - BPI Mass
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
# (HDD-383)                # The Plot Panel will display the mass in the centre of the BPI plot and will have a precision of 4 points .
# -------------------------#-------------------------------------------------------------------------------------------------------------------------



@ignore
Feature: BPI Mass
	In order to monitor the mass of the most intense peak within an MZ mass range
	I want to be able to select the BPI plot during tuning
	so that a constantly updating BPI Mass is clearly displayed


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the Veff has been adjusted correctly for Positive and Negative modes using Leucine Enkephalin
	And there is a good Sodium Formate beam available in Positive and Negative modes (within the mass range 50-1200)

	# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-01 - BPI Plot Mass (Single Peak)
	When a Method with <Polarity> and <Mass Range> is loaded
		Then the <BPI Most Intense Mass> value should be shown top-centre of the BPI 'Plot Type'
		| Plot Type |
		| Tune Page |
		| Pop-out   |
		And the value will be shown to four decimal places

		Examples: Positive Polarity - Single Peak
		| Polarity | Mass Range | BPI Most Intense Mass |
		| Positive | 89-92      | 90                    |
		| Positive | 157-160    | 158                   |
		| Positive | 633-636    | 634                   |
		| Positive | 1245-1248  | 1246                  |
		| Positive | 1993-1996  | 1994                  |
		
		Examples: Negative Polarity - Single Peak
		| Polarity | Mass Range | BPI Most Intense Mass |
		| Negative | 111-114    | 112                   |
		| Negative | 179-182    | 180                   |
		| Negative | 655-658    | 656                   |
		| Negative | 1267-1270  | 1268                  |
		| Negative | 1947-1950  | 1948                  |
     	# Although the BPI mass will be shown to 4dp, only the integer part needs to be checked
		# Values based on Sodium Formate reference XML (C:\Waters Corporation\Typhoon\config\referenceCompounds)


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-02 - BPI Plot Mass (Multiple Peaks - Most Intense Independently Determined)
	When a Method with <Polarity> and <Mass Range> is loaded
		And the most intense MZ plot peak has been independently determined
	Then the most intense MZ peak value will be shown top-centre of the BPI 'Plot Type'
		| Plot Type |
		| Tune Page |
		| Pop-out   |

		Examples: Positive Polarity - Multiple Peaks
		| Polarity | Mass Range |
		| Positive | 50-600     |
		| Positive | 600-1200   |
		| Positive | 50-1200    |
		
		Examples: Negative Polarity - Multiple Peaks
		| Polarity | Mass Range |
		| Negative | 50-600     |
		| Negative | 600-1200   |
		| Negative | 50-1200    |
		# Although the BPI mass will be shown to 4dp, only the integer part needs to be checked
		# Most intense peak independently determined 


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-03 - BPI Plot Mass - Update Interval
	When a Method with <Polarity> and <Scan Time> and <Mass Range> is loaded
	Then the BPI Most Intense Mass at top-centre of the BPI 'Plot Type' will update every <Interval> seconds
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
		# Update interval can be checked by monitoring the changing decimal part of BPI Mass


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-04 - BPI Plot Mass - Vial Selection
	Given Leucine Enkephalin is infused with a good beam
	When Fluidics <Vial> is selected
	Then the <BPI Mass Value> will be shown on the BPI 'Plot Type'
		| Plot Type |
		| Tune Page |
		| Pop-out   |

		Examples:
		| Vial               | BPI Mass Value |
		| Sodium Formate     | 159 / 227      |
		| Leucine Enkephalin | 556            |
		# the BPI Mass value updates according to vial / solution
		# Although the BPI mass will be shown to 4dp, only the integer part needs to be checked
		# For the Sodium Formate vial, the BPI Most Intense Mass will vary between 159 and 227


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-05 - BPI Plot Mass - MZ Zooming
	When a Method with 'Mass Range' is loaded
		| Mass Range |
		| 200-1200    |
		And an MZ plot <Zoom Range> is selected
	Then the <BPI Most Intense Mass> value should be shown top-centre of the BPI 'Plot Type'
		| Plot Type |
		| Tune Page |
		| Pop-out   |
	
		Examples: Positive Polarity
		| Zoom Range | BPI Most Intense Mass |
		| 50-200     | 227 / 295             |
		| 200-600    | 227 / 295             |
		| 600-1200   | 227 / 295             |
		| 1100-1200  | 227 / 295             |
		# Assumption: The most intense peak from the entire MZ range is shown regardless of MZ Zooming
		# Although the BPI mass will be shown to 4dp, only the integer part needs to be checked
		# BPI Most Intense Mass will vary between 227 and 295


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-06 - BPI Plot Mass - Normalise Mode (y-Axis Scale Adjust)
	When an unmodified 'ms.xml' Custom Tune method is loaded
		And the BPI <Plot Type> is selected
	Then if the 'Normalise Mode' is toggled the <BPI Most Intense Mass> value is still shown top-centre of the BPI plot 
		| Normalise Mode |
		| OFF            |
		| ON             |
		| OFF            |

		Examples:
		| Plot Type | BPI Most Intense Mass |
		| Tune Page | 159 / 227             |
		| Pop-out   | 159 / 227             |
		# The most intense peak from the entire MZ range is shown regardless of MZ Zooming
		# Although the BPI mass will be shown to 4dp, only the integer part needs to be checked
		# Unmodified 'ms.xml' Custom Tune method Mass Range assumed to be 100-1100
		# BPI Most Intense Mass will vary between 227 and 295


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: TUN-07 - BPI Plot Mass - Multiple Function Selection
	Given Leucine Enkephalin is infusing with a good beam
	When a modified 'ms_lockmass.xml' Custom Tune method is loaded...
		"""
		<?xml version="1.0"?>
		<MsMethod InstrumentType="QTof" InstrumentModel="Osprey" Version="1.0">
			<Settings>
				<Setting Name="SourceTemperature" Value="130.0" Mapping="Source.SourceTemperature.Setting"/>
			</Settings>
			<Setup Type="LockMass">
				<Settings>
					<Setting Name="LockMass" Value="499.5"/>
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
	Then <BPI Most Intense Mass> value is updated every <Interval> seconds
		Examples:
		| Plot Type | Function | BPI Most Intense Mass | Interval |
		| Tune Page | 1:MS     | 159 / 227             | 1.0      |
		| Tune Page | 2:MS     | 556                   | 10.0     |
		| Pop-out   | 1:MS     | 159 / 227             | 1.0      |
		| Pop-out   | 2:MS     | 556                   | 10.0     |
		# Function '1:MS' BPI Most Intense Mass will vary between 159 and 227
		# Update interval can be checked by monitoring the changing decimal part of BPI Mass


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
