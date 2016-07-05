# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Readbacks
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# Date:                    # 08-OCT-2015
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # This should be run on real instrument as some of the readbacks do not work with the simulator
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # - That '​factory_​settings.gpb'​ file does not exist in the '\Typhoon\config' folder
#                          # - An 'ESI LockSpray' source has been fitted
#                          # - The Instrument is in 'Operate'
#                          # - Tuning has been started then aborted
#                          #   NOTE: the reason for starting the tuning is that some readbacks do not give the expected results after an instrumnet hardware reboot
#                          #		 when the instrument is in operate unless tuning has been started at least once
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # 08-OCT-15 - Major rewrite to address readback dependanciy issues - now readback values are just tested against known set values
#                          #             which should be the same from instrument to instrument 
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Everest/3_Analysis Areas/Application Specific/Instruments/Mass Spectrometer Projects/Osprey/
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# (SS-971)                 # The user will be able to switch the instrument polarity
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# (SS-972)                 # The user will be able to switch the instrument analyser resolution mode
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------
# (SS-973)                 # The user will be able set all of the instrument parameters related to the current instrument source configuration and current instrument modes                     
# -------------------------#-----------------------------------------------------------------------------------------------------------------------------------------


@Ignore
Feature: In order to check the instrument is in good working state
         I want to be able to set specific tune page parameter values
		 So that any associated readbacks are within the expected range 
		 # The purpose of this test is to ensure that for a specific setting, that the readbacks are approprite.
	     # If the default settings are not as expected, make a note and log it as a seperate defect against the current Osprey defaults document 

# -------------------------------------------------------------------------------------------------------------------------------------------------------------------
@RealInstrumentOnly
Scenario Outline: TUN-01 Expected Default Readbacks and Expected Readbacks after Modifying Set Values
	Given the Instrument <Polarity> and <Mode> has been set
	When the <Tune Page tab> is been selected
	Then the <Control> set value matches the <Default>  
		And each <Control> will have an associated readback within the expected <Default Readback Range>
	When the <Control> set value is changed to a <Modified Default>
		And the instrument has completed any active Polarity settle tasks
		And the instrument has completed any active Temperature settling
		# When changing the Source Temperature, ensure that enough time has elapsed to allow the readback to change (approximately 1 minute per degree)
	Then each <Control> will have an associated readback within the <Modified Readback Range>
	
	# Baseline readbacks have been taken from Beta-003 (Quartz build 1171)
	# Where the Readback Range was too narrow (i.e. 0.2 to 0.2) it has been increased to allow for a slight readback change (i.e. 0.1 to 0.3)
	# Although the information below is listed in examples tables, in practice, each group of readbacks can be tested together for each tab
	Examples: Tolerance 5%
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Positive | Sensitivity | ESI LockSpray | Capillary (kV)               | 3.00            | 2.85 to 3.15           | 3.30             | 3.14 to 3.47            |
	| Positive | Sensitivity | ESI LockSpray | Source Offset (V)            | 80              |   40 to 44             | 88               |   48 to 54              |
	| Positive | Sensitivity | ESI LockSpray | Source Temperature (°C)      | 100             |   95 to 105            | 105              |  100 to 110             |
	| Positive | Sensitivity | ESI LockSpray | Desolvation Temperature (°C) | 250             |  238 to 263            | 275              |  261 to 289             |
	| Positive | Sensitivity | ESI LockSpray | Cone Gas (L/hour)            | 50              |   48 to 53             | 55               |   52 to 58              |
	| Positive | Sensitivity | ESI LockSpray | Desolvation Gas (L/hour)     | 600             |  570 to 630            | 660              |  627 to 693             |
	| Positive | Sensitivity | ESI LockSpray | Reference Capillary (kV)     | 3.00            | 2.85 to 3.15           | 3.30             | 3.14 to 3.47            |
	
	Examples: Tolerance 5%
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Negative | Resolution  | ESI LockSpray | Capillary (kV)               | 2.50            | 2.38 to 2.64           | 2.25             | 2.14 to 2.36            |
	| Negative | Resolution  | ESI LockSpray | Source Offset (V)            | 80              |  -46 to -50            | 72               |  -38 to -42             |
	| Negative | Resolution  | ESI LockSpray | Source Temperature (°C)      | 100             |   95 to 105            | 95               |   90 to 100             |
	| Negative | Resolution  | ESI LockSpray | Desolvation Temperature (°C) | 250             |  238 to 263            | 225              |  214 to 236             |
	| Negative | Resolution  | ESI LockSpray | Cone Gas (L/hour)            | 50              |   48 to 53             | 45               |   43 to 47              |
	| Negative | Resolution  | ESI LockSpray | Desolvation Gas (L/hour)     | 600             |  570 to 630            | 540              |  512 to 566             |
	| Negative | Resolution  | ESI LockSpray | Reference Capillary (kV)     | 2.50            | 2.38 to 2.64           | 2.25             | 2.14 to 2.36            |
	
	Examples: Tolerance 5%
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Positive | Resolution  | Instrument    | Ion Guide Gradient (V)       | 0.5             | -156.0 to -172.4       | 0.7              | -155.3 to -171.7        |
	| Positive | Resolution  | Instrument    | Aperture 2 (V)               | 0.0             | -156.3 to -172.7       | 0.2              | -156.3 to -172.7        |
	| Positive | Resolution  | Instrument    | Pre-filter (V)               | 10.0            | -165.9 to -183.3       | 15.5             | -171.3 to -189.3        |
	| Positive | Resolution  | Instrument    | Detector Voltage(V)          | 1700            |   1615 to 1785         | 2400             |   2280 to 2520          |
																					          
	Examples: Tolerance 5%															          
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Negative | Sensitivity | Instrument    | Ion Guide Gradient (V)       | 0.5             | 155.7 to 172.1         | 0.3              | 155.3 to 171.7          |
	| Negative | Sensitivity | Instrument    | Aperture 2 (V)               | 0.0             | 156.0 to 172.4         | 0.3              | 156.3 to 172.7          |
	| Negative | Sensitivity | Instrument    | Pre-filter (V)               | 10.0            | 165.6 to 183.0         | 5.5              | 161.4 to 178.4          |
	| Negative | Sensitivity | Instrument    | Detector Voltage(V)          | 1700            |  1615 to 1785          | 550              |   523 to 578            |
																					          
	Examples: Tolerance 5%													          
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Positive | Sensitivity | Cell1         | Entrance (V)                 | 2               |   -161 to -177         | 1                |   -162 to -179          |
	| Positive | Sensitivity | Cell1         | Exit (V)                     | 5.0             | -168.9 to -186.7       | 0.2              | -163.5 to -180.7        |
	| Positive | Sensitivity | Cell1         | Pulse Height (V)             | 0.2             |    0.1 to 0.3          | 15.5             |   14.7 to 16.3          |
																					          
	Examples: Tolerance 5%															          
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Negative | Resolution  | Cell1         | Entrance (V)                 | -2              |   -160 to -176         | 1                |   162 to 180            |
	| Negative | Resolution  | Cell1         | Exit (V)                     | 5.0             | -169.2 to -187.0       | 0.2              | 163.5 to 180.7          |
	| Negative | Resolution  | Cell1         | Pulse Height (V)             | 0.2             |    0.1 to 0.3          | 15.5             |  14.7 to 16.3           |
	
	Examples: Tolerance 5%
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Positive | Resolution  | Cell2         | Entrance (V)                 | -10.0           | -159.6 to -176.4       | 0.7              | -160.4 to -177.2        |
	| Positive | Resolution  | Cell2         | Exit (V)                     | 5.0             | -169.2 to -187.0       | 0.2              | -168.3 to -186.1        |
																					          
	Examples: Tolerance 5%															          
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Negative | Sensitivity | Cell2         | Entrance (V)                 | -2.0            | 160.2 to 177.0         | 0.7              | 159.9 to 176.7          |
	| Negative | Sensitivity | Cell2         | Exit (V)                     | 15.0            | 168.0 to 185.6         | 0.2              | 168.6 to 186.4          |
	
	Examples: Tolerance 5%
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Positive | Sensitivity | System1       | Acceleration 1 (V)           | 30              |    -199 to -219        | 10               |    -180 to -198         |
	| Positive | Sensitivity | System1       | Acceleration 2 (V)           | 120             |    -284 to -314        | 10               |    -180 to -200         |
	| Positive | Sensitivity | System1       | Aperture 3 (V)               | 30              |    -199 to -221        | 10               |    -180 to -200         |
	| Positive | Sensitivity | System1       | Transport 1 (V)              | 30              |    -199 to -219        | 10               |    -180 to -198         |
	| Positive | Sensitivity | System1       | Transport 2 (V)              | 30              |    -199 to -219        | 10               |    -176 to -194         |
	| Positive | Sensitivity | System1       | Steering (V)                 | 0.00            | -198.98 to -219.92     | 4.50             | -184.54 to -203.96      |
	| Positive | Sensitivity | System1       | Tube Lens (V)                | 25              |    -195 to -215        | 10               |    -180 to -200         |
	| Positive | Sensitivity | System1       | Entrance (V)                 | 20              |    -189 to -209        | 10               |    -180 to -200         |
	| Positive | Sensitivity | System1       | Pusher (V)                   | 1900            |    1805 to 1995        | 1000             |     950 to 1050         |
	| Positive | Sensitivity | System1       | Pusher Offset (V)            | 0.00            | -189.66 to -209.62     | 3.50             | -183.63 to -202.97      |
	| Positive | Sensitivity | System1       | Puller (V)                   | 1400            |    1330 to 1470        | 1800             |    1710 to 1890         |
	| Positive | Sensitivity | System1       | Puller Offset (V)            | 0.00            | -189.66 to -209.62     | 3.00             | -183.04 to -202.30      |
		
	Examples: Tolerance 2%
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Positive | Sensitivity | System1       | Strike Plate (kV)            | 8.00            |  7.84 to 8.16          | 5.00             | 4.90 to 5.10            |
	| Positive | Sensitivity | System1       | Flight Tube (kV)             | 7.00            |  6.86 to 7.14          | 6.00             | 5.88 to 6.12            |
	| Positive | Sensitivity | System1       | Reflectron(kV)               | 2.036           | 1.995 to 2.077         | 2.000            | 1.96 to 2.04            |
	| Positive | Sensitivity | System1       | Reflectron Grid(kV)          | 1.020           | 1.000 to 1.040         | 1.000            | 0.98 to 1.02            |
	
	Examples: Tolerance 5%
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Negative | Resolution  | System1       | Acceleration 1 (V)           | 30              |    199 to 219          | 10               |    180 to 198           |
	| Negative | Resolution  | System1       | Acceleration 2 (V)           | 0               |    169 to 187          | 60               |    226 to 250           |
	| Negative | Resolution  | System1       | Aperture 3 (V)               | 10              |    179 to 197          | 20               |    188 to 208           |
	| Negative | Resolution  | System1       | Transport 1 (V)              | 20              |    188 to 208          | 30               |    198 to 218           |
	| Negative | Resolution  | System1       | Transport 2 (V)              | 10              |    179 to 197          | 20               |    190 to 210           |
	| Negative | Resolution  | System1       | Steering (V)                 | 0.00            | 178.83 to 197.65       | 2.00             | 186.65 to 206.29        |
	| Negative | Resolution  | System1       | Tube Lens (V)                | 30              |    198 to 218          | 25               |    193 to 213           |
	| Negative | Resolution  | System1       | Entrance (V)                 | 20              |    188 to 208          | 30               |    198 to 218           |
	| Negative | Resolution  | System1       | Pusher (V)                   | 1900            |   1805 to 1995         | 1200             |   1140 to 1260          |
	| Negative | Resolution  | System1       | Pusher Offset (V)            | 0.00            | 188.45 to 208.29       | 3.00             | 200.78 to 221.92        |
	| Negative | Resolution  | System1       | Puller (V)                   | 1400            |   1330 to 1470         | 1500             |   1425 to 1575          |
	| Negative | Resolution  | System1       | Puller Offset (V)            | 0.00            | 188.45 to 208.29       | 3.00             | 200.78 to 221.92        |
	
	Examples: Tolerance 2%
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Negative | Resolution  | System1       | Strike Plate (kV)            | 8.00            |  7.84 to 8.16          | 2.00             | 1.96 to 2.04            |
	| Negative | Resolution  | System1       | Flight Tube (kV)             | 7.00            |  6.86 to 7.14          | 2.00             | 1.96 to 2.04            |
	| Negative | Resolution  | System1       | Reflectron(kV)               | 2.036           | 1.995 to 2.077         | 2.500            | 2.45 to 2.55            |
	| Negative | Resolution  | System1       | Reflectron Grid(kV)          | 1.020           | 1.000 to 1.040         | 0.500            | 0.49 to 0.51            |
	
	Examples: Tolerance 5%
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Positive | Resolution  | System2       | Collector (V)                | 60              | -215 to -237           | 15               | -172 to -190            |
	| Positive | Resolution  | System2       | Stopper (V)                  | 10              | -167 to -185           | 30               | -186 to -206            |
	
	Examples: Tolerance 5%
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Negative | Sensitivity | System2       | Collector (V)                | 60              | 215 to 237             | 30               | 185 to 205              |
	| Negative | Sensitivity | System2       | Stopper (V)                  | 10              | 167 to 185             | 40               | 195 to 215              |
	
	Examples: Tolerance 5%
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Positive | Sensitivity | RF            | StepWave RF (V)              | 300             | 285 to 315             | 150              | 142 to 158              |
	| Positive | Sensitivity | RF            | Trap/IMS RF (V)              | 300             | 285 to 315             | 150              | 142 to 158              |
	| Positive | Sensitivity | RF            | Ion Guide RF Offset (V)      | 200             | 250 to 276             | 100              | 155 to 171              |
	| Positive | Sensitivity | RF            | Cell1 RF (V)                 | 500             | 475 to 525             | 250              | 237 to 263              |
	| Positive | Sensitivity | RF            | Cell2 RF Offset (V)          | 100             | 156 to 172             | 50               | 107 to 119              |
																					          
	Examples: Tolerance 5%															          
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Negative | Resolution  | RF            | StepWave RF (V)              | 300             | 285 to 315             | 100              |  95 to 105              |
	| Negative | Resolution  | RF            | Trap/IMS RF (V)              | 300             | 285 to 315             | 100              |  95 to 105              |
	| Negative | Resolution  | RF            | Ion Guide RF Offset (V)      | 200             | 250 to 276             | 100              | 359 to 397              |
	| Negative | Resolution  | RF            | Cell1 RF Offset (V)          | 500             | 475 to 525             | 100              |  95 to 105              |
	| Negative | Resolution  | RF            | Cell2 RF Offset (V)          | 100             | 156 to 172             | 75               | 132 to 146              |          
																					          
	Examples: Tolerance 5%															          
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Positive | Sensitivity | Gases         | Trap Gas (L/min)             | 1.6             |  1.5 to 1.7            | 0.7              |   0.6 to 0.8            |
	| Positive | Sensitivity | Gases         | IMS Gas (mL/min)             | 25              |   24 to 26             | 10               |     9 to 11             |
	| Positive | Sensitivity | Gases         | CC1 Gas (mL/min)             | 0.50            | 0.47 to 0.53           | 15.50            | 14.72 to 16.28          |
	| Positive | Sensitivity | Gases         | CC2 Gas (mL/min)             | 0.30            | 0.28 to 0.32           | 12.34            | 11.72 to 12.96          |	
	
	Examples: Tolerance 5%										                        
	| Polarity | Mode        | Tune Page tab | Control                      | Default Setting | Default Readback Range | Modified Default | Modified Readback Range |
	| Negative | Resolution  | Gases         | Trap Gas (L/min)             | 1.6             |  1.5 to 1.7            | 0.7              |   0.6 to 0.8            |
	| Negative | Resolution  | Gases         | IMS Gas (mL/min)             | 25              |   24 to 26             | 20               |     9 to 11             |
	| Negative | Resolution  | Gases         | CC1 Gas (mL/min)             | 0.50            | 0.47 to 0.53           | 15.5             | 14.72 to 16.28          |
	| Negative | Resolution  | Gases         | CC2 Gas (mL/min)             | 0.30            | 0.28 to 0.32           | 12.34            | 11.72 to 12.96          |
	
		
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------
# END