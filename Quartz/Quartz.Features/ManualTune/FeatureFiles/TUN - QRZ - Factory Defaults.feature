# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # TUN - QRZ - Factory Defaults
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 04-June-14
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Latest version of Osprey Default Document 721006299
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
#
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   #
# -------------------------------------------------------------------------------------------------
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-175)                 # The user will be able to save factory defaults from the Manual Tuning screen
# (SS-176)				   # The user will be able to load factory defaults from the Manual Tuning screen
# (SS-185)				   # The user shall be able to switch the instrument into positive polarity
# (SS-182)				   # The user shall be able to switch the instrument into negative polarity
# (SS-186)				   # The user shall be able to switch the instrument into Resoution mode
# (SS-188)				   # The user shall be able to switch the instrument into Sensitivity mode
# -------------------------#-------------------------------------------------------------------------------------------------------------------------


  #Prerequisites:
  #Given a 'Quartz environment' is available
  #And a 'valid username and password' is available for successful login to the Quartz Environment
  #And the Quartz enviroment is connected to an instrument (physical or simulated)'
# -------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------------------------------------------------------------
# Fluidics tab values shall not be included within this test, as they are currently stored in the Target Registry and not the 'factory_settings.gpb' file
# --------------------------------------------------------------------------------------------------------------------------------------------------------

@ManualTune
@FactoryDefaults
Feature: TUN - QRZ - Factory Defaults
   
	Background:
	Given that the Quartz Tune page is open
	And I have field values for Control Parameters	
 
 
 Scenario: DEF - 01 - Load when 'factory_settings.gpb' file does not exist - Positive
	And factory defaults have been reset
    When all the Control Parameter values are 'set' to 'Value1' for 'Positive' mode combination
	 And 'Load' factory Defaults for 'Positive' mode combination
    Then the Control Parameter defaults match the instrument specification for 'Positive' mode combination
	 And the Dwell Time and Ramp Time parameter defaults match the instrument specification for 'Positive' mode combination
 
 
 Scenario: DEF - 02 - Load when 'factory_settings.gpb' file does not exist - Negative
	And factory defaults have been reset
    When all the Control Parameter values are 'set' to 'Value1' for 'Negative' mode combination
	 And 'Load' factory Defaults for 'Negative' mode combination
    Then the Control Parameter defaults match the instrument specification for 'Negative' mode combination
	 And the Dwell Time and Ramp Time parameter defaults match the instrument specification for 'Negative' mode combination
  
  @SimulatorOnly
  Scenario: DEF - 03 - Save when 'factory_settings.gpb' file does not exist 
    Given that 'factory_settings.gpb' file does not exist in the Config folder
    When the browser is opened on the Tune page
      And 'Save' factory Defaults
    Then a 'factory_settings.gpb' file is created in the Config folder

  
  Scenario: DEF - 04 - Updated after 'factory_settings.gpb' file newly created - PositivePolarity
	And factory defaults have been reset
	When 'Save' factory Defaults
	  And all the Control Parameter values are 'set' to 'Value1' for 'Positive' mode combination
      And 'Load' factory Defaults
    Then the Control Parameter defaults match the instrument specification for 'Positive' mode combination
	

  Scenario: DEF - 05 - Updated after 'factory_settings.gpb' file newly created - NegativePolarity
	And factory defaults have been reset
	When 'Save' factory Defaults
	  And all the Control Parameter values are 'set' to 'Value1' for 'Negative' mode combination
      And 'Load' factory Defaults
    Then the Control Parameter defaults match the instrument specification for 'Negative' mode combination
  
  @Defect
  @CR_US1#206403
  Scenario: DEF - 06 - Updated when 'factory_settings.gpb' file already exists - PositivePolarity
  And factory defaults have been reset
	And 'Save' factory Defaults    
  When all the Control Parameter values are 'set' to 'Value1' for 'Positive' mode combination
    And 'Save' factory Defaults
	And all the Control Parameter values are 'set' to 'Value2' for 'Positive' mode combination
    And 'Load' factory Defaults
  Then all the Control Parameter values are 'equal' to 'Value1' for 'Positive' mode combination

  @Defect
  @CR_US1#206403
  Scenario: DEF - 07 - Updated when 'factory_settings.gpb' file already exists - NegativePolarity
  And factory defaults have been reset
	And 'Save' factory Defaults    
  When all the Control Parameter values are 'set' to 'Value1' for 'Negative' mode combination
    And 'Save' factory Defaults
	And all the Control Parameter values are 'set' to 'Value2' for 'Negative' mode combination
    And 'Load' factory Defaults
  Then all the Control Parameter values are 'equal' to 'Value1' for 'Negative' mode combination  


# -----------------------------------------------------------------------------------------------------------------------------------------
# END

