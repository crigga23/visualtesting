@ignore
Feature: QuadSetupPeakDisplay

# -----------------------------------------------------------------------------------------------------------------
# Revision:		01
# Author:     	MH, Date: 22-APR-14
# Revised by: 	EH, date revised 30-APR-14
# Basis:      	'Xevo G2 Tof Software Spec' current 1.2 (v2.1.0), SS-7986
# -----------------------------------------------------------------------------------------------------------------------------------------

Background: 
	Given the Quad Setup Page is Open

# -----------------------------------------------------------------------------------------------------------------------------------------

	@QuadSetupMode
	Scenario: Quad Setup Peak Display - Main Peak Display	
		Then the following quad setup peak display windows should be available
				| Controls                 | Unit | Default |
				| Peak Displays for Mass 1 | m/z  | 172.88  |
				| Peak Displays for Mass 2 | m/z  | 472.62  |
				| Peak Displays for Mass 3 | m/z  | 772.45  |
				| Peak Displays for Mass 4 | m/z  | 922.35  |
			
  	@QuadSetupMode
	Scenario: Quad Setup Peak Display - Peak Controls
		Then the following quad setup mass textboxes should be available
				| Controls      | Checked | Default |
				| Mass1 textbox | True    | 172.88  |
				| Mass2 textbox | True    | 472.62  |
				| Mass3 textbox | True    | 772.45  |
				| Mass4 textbox | True    | 922.35  |
				

  	@QuadSetupMode
	Scenario: Quad Setup Peak Display - Peak Display can be removed
		When A mass checkbox is deselected
		Then the corresponding peak display should not be present
	
   	@QuadSetupMode
	Scenario: Quad Setup Peak Display - Peak Display can be reinstated
		When A mass checkbox is reselected
		Then the corresponding peak display should be present
	
# -----------------------------------------------------------------------------------------------------------------------------------------
	@QuadSetupMode
	Scenario: Quad Setup Display - Additional parameter defaults and ranges
		Then it should have the following quad setup parameters present			
				| Parameters      | Default | 
				| Span            | 10      | 
				| Number of steps | 10      | 
				| Time Per Step   | 0.1	| 
				| Detector Window | 4		| 
	
	@QuadSetupMode	
	Scenario: Quad Setup Peak Display - Parameter predefined values
	   Then the parameters should have the following predefined values present
				| Parameters      | Predefined             |
				| Span            | 1,2,4,10,20,50         |
				| Number of steps | 10,20,30,50            |
				| Time Per Step   | 0.023,0.04,0.06,0.1    |
				| Detector Window | 1,2,4,10,100           |
		
# -----------------------------------------------------------------------------------------------------------------------------------------
# END
