

@Installation
Feature: KIT- ConfigureBeam
	In order to avoid silly mistakes
	As a math idiot
	I want to be told the sum of two numbers

Scenario: ConfigureBeam
	Given Quartz is installed
		And the factory defaults and tune set is copied to the instrument
		And I restart Quartz and Typhoon
		And the browser is opened on the Tune page
		And the instrument is in 'Operate' mode
	    And instrument factory defaults are loaded	
		And Tuning is started
		And reference fluidics are Idle
		And reference fluidics are set to 
			| Baffle Position | Reservoir | Flow Path | Flow Rate |
			| Reference       | B         | Infusion  | 40.00     | 
		And the reference fluidic level is not less than '5.00' minutes		
	When a Reference Fluidics 'Purge' is initiated
		And you start infusion on the Reference
	Then after some time the plot will show a beam

		
		
