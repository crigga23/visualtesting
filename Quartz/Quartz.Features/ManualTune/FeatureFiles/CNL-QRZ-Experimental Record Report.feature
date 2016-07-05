# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # CNL-QRZ-Experimental Record Report
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Andrea Barti
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 30-JUL-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #  n/a
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # n/a
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Quartz Dashboard msi is installed
#                          # Chrome browser installed
#                          # Typhoon is started
#                          # Quartz Dashboard is running within the Chrome Browser
#                          # MassLynx installed
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # n/a
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # n/a
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Quartz EAP Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-610)                 # The .raw data experimental record is populated with parameter settings.
#                            Parameters for inclusion are selected by means of a configuration file. 
#                            For each function in the acquisition, all instrument modes are reported.
#                            The stat of CCS calibration is reported for each function
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@Ignore
@ManualOnly
Feature: CNL-QRZ-Experimental Record Report

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: CNL-01 - Experimental Record Report
	Given that the Tune page is accessed 
		And the '<Polarity>', '<Mode>', '<Status>', '<API gas>' and '<Collision gas>' have been set  	
		And on the 'ESI LockSpray' tab the ESI 'Parameters' are set to the following 'Values' having the specific 'Units of measure'
		| Parameters              | Values | Units of Measure |
		| Capillary               | 3.15   | kV               |
		| Sampling Cone           | 24     | V                |
		| Source Offset           | 87     | V                |
		| Source Temperature      | 120    | °C               |
		| Desolvation Temperature | 342    | °C               |
		| Cone Gas                | 154    | L/h              |
		| Desolvation Gas         | 758    | L/h              |
		| Reference Capillary     | 2.14   | kV               |
		And on the 'Instrument' tab the 'Parameters' are set to the following 'Values' having the specific 'Units of measure'
		| Parameters         | Values | Units of Measure |
		| Collision Energy   | 15.5   | V                |
		| Ion Guide Gradient | 0.4    | V                |
		| Aperture           | 2.3    | V                |
		| LM Resolution      | 5.4    | n/a              |
		| HM Resolution      | 17.5   | n/a              |
		| Pre-filter         | 11.3   | V                |
		| Ion Energy         | 4.1    | V                |
		| Detector Voltage   | 1678   | V                |
		And on the 'Fluidics' tab the Sample Fluidics 'Parameters' are set to the following 'Values' having the specific 'Units of measure'
		| Parameters         | Values | Units of measure |
		| Reservoir          | B      | n/a              |
		| Flow Path          | Waste  | n/a              |
		| Infusion Flow Rate | 4.3    | µl/min           |
		| Fill Volume        | 150    | µl               |
		| Wash Cycle         | 2      | n/a              |
		And on the 'Fluidics' tab the Reference Fluidics 'Parameters' are set to the following 'Values' having the specific 'Units of measure'
		| Parameters         | Values    | Units of measure |
		| Reservoir          | C         | n/a              |
		| Flow Path          | Infusion  | n/a              |
		| Infusion Flow Rate | 4.3       | µl/min           |
		| Baffle Position    | Reference | n/a              |
		| Illumination       | Off       | n/a              |
		And on the 'System 1' tab the 'Parameters' are set to the following 'Values' having the specific 'Units of measure'
		| Parameters      | Values | Units of measure |
		| Acceleration 1  | 20     | V                |
		| Acceleration 2  | 10     | V                |
		| Aperture 2      | 3      | V                |
		| Transport 1     | 41     | V                |
		| Transport 2     | 35     | V                |
		| Steering        | 2.14   | V                |
		| Tube Lens       | 51     | V                |
		| Entrance        | 14     | V                |
		| Pusher          | 1957   | V                |
		| Pusher Offset   | -1.36  | V                |
		| Puller          | 1247   | V                |
		| Puller Offset   | -0.28  | V                |
		| Strike Plate    | 1.25   | kV               |
		| Flight Tube     | 0.25   | kV               |
		| Reflectron      | 0.214  | kV               |
		| Reflectron Grid | 0.412  | kV               |
		And on the 'System 2' tab the 'Parameters' are set to the following 'Values' having the specific 'Units of measure'
		| Parameters           | Values | Units of measure |
		| Collector            | 65     | V                |
		| Collector Pulse      | 10.2   | V                |
		| Stopper              | 15     | V                |
		| Stopper Pulse        | 14.2   | V                |
		| pDRE Attenuate       | On     | n/a              |
		| pDRE Transmission    | 95.14  | %                |
		| pDRE HD Attenuate    | On     | n/a              |
		| pDRE HD Transmission | 94.2   | %                |
		And on the 'RF' tab the 'Parameters' are set to the following 'Values' having the specific 'Units of measure'
		| Parameters          | Values    | Units of measure |
		| StepWave RF         | 315       | V                |
		| Trap/IMS RF         | 412       | V                |
		| Ion Guide RF Offset | 214       | V                |
		| Ion Guide RF Gain   | 6         | n/a              |
		| Cell1 RF Offset     | 514       | V                |
		| Cell2 RF Offset     | 247       | V                |
		| Cell2 RF Gain       | 7         | n/a              |
		| MS/MS Ramp Mode     | Automatic | n/a              |
		| MS/MS Ramp Initial  | 43        | n/a              |
		| MS/MS Ramp Final    | 127       | n/a              |
		And on the 'ADC2' tab the 'Parameters' are set to the following 'Values' having the specific 'Units of measure'
		| Parameters                   | Values      | Units of measure |
		| DC Bias A                    | -1.524      | n/a              |
		| Amplitude Threshold A        | 6           | n/a              |
		| Area Threshold A             | 7           | n/a              |
		| Baseline Mean A              | 3           | n/a              |
		| Time Delay A                 | 4127        | n/a              |
		| DC Bias B                    | -1.896      | n/a              |
		| Amplitude Threshold B        | 6           | n/a              |
		| Baseline Mean B              | 4           | n/a              |
		| Time Delay B                 | 4123        | n/a              |
		| Channel B Multiplier         | 1.32        | n/a              |
		| Trigger Threshold            | 1.2         | n/a              |
		| Saturation bins/stitch       | 2           | n/a              |
		| Input Channel                | Dual        | n/a              |
		| Signal Source                | Test signal | n/a              |
		| Pulse Shaping                | ON          | n/a              |
		| Stitching Window +/-         | 5.1         | n/a              |
		| Edge Enhance                 | 4           | n/a              |
		| Output Scaling Factor        | 11          | n/a              |	
		| Avarage Single Ion Intensity | 23          | n/a              |
		| Measured m/z                 | 556.2478    | n/a              |
		| Meassured charge             | 4           | n/a              |
		| T0                           | -24         | ns               |
		| Veff                         | 5230.21     | V                |
		| ADC Algorithm                | Avg         | n/a              |
		And on the 'MS Profile' tab the 'Parameters' are set to the following 'Values' having the specific 'Units of measure'
		| Parameters         | Values         | Units of measure |
		| Quadrupole Options | Manual Profile | n/a              |
		| m/z                | 125            | n/a              |
		| m/z                | 254            | n/a              |
		| m/z                | 536            | n/a              |
		| Dwell Time         | 34             | % Scan Time      |
		| Dwell Time         | 42             | % Scan Time      |
		| Ramp Time          | 23             | % Scan Time      |
		| MS/MSMS            | MSMS           | n/a              |
		| Set Mass           | 556.4125       | n/a              |
		| Select Mode        | EDC            | n/a              |
		| EDC Mass           | 0.1234         | n/a              |
		And on the 'StepWave' tab the 'Parameters' are set to the following 'Values' having the specific 'Units of measure'
		| Parameters        | Values | Units of measure |
		| SW 1 Offset       | 24.3   | V                |
		| SW 2 Offset       | 41.9   | V                |
		| SW 1 Velocity     | 294    | m/s              |
		| SW 1 Pulse Height | 14.6   | V                |
		| SW 2 Velocity     | 314    | m/s              |
		| SW 2 Pulse Height | 16.7   | V                |
		And 'Tune' button is pressed and 'Start' button is pressed and 'Stop' button is pressed
		And the record data is saved
	When MassLynx is started and  Spectrum Data Browser is opened
		And the raw file is imported and selected and the Experiment option is selected
		# The location of the file is c:\Program Files\Waters\UNIFI\Instruments\Osprey\1.0.0\Typhoon\data_store\
	Then the tune parameters displayed in the Experiment Record are the same with the tune parameteres set in the Quartz
	When Unifi is started and Import other data option is selected from My Work page
		And the raw file is imported 
		# The location of the file is c:\Program Files\Waters\UNIFI\Instruments\Osprey\1.0.0\Typhoon\data_store\
		And Explorer page is accessed
		And the Sample is opened
		And from Tools, Show acquisition information option is selected
		Then the tune parameters displayed in the Experiment Record are the same with the tune parameteres set in the Quartz
		Examples:
		| Polarity | Mode        | Status   | API gas | Collision gas |
		| Positive | Sensitivity | TOF      | On      | Off           |
		| Negative | Resolution  | Mobility | Off     | On            | 

# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END