
# -----------------------------------------------------------------------------------------------------------------
# Revision:   01
# Author:     CDH, Date: 04-June-14
# Revised by: CDH (06-June-14), ILU (23-Aug-2015)
# -----------------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
  #Prerequisites:
  #Given a 'Quartz environment' is available
  #And a 'valid username and password' is available for successful login to the Quartz Environment
  #And the Quartz enviroment is connected to an instrument (physical or simulated)'
# -------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------
# Fluidics tab values shall not be included within this test, as they are currently stored in the Target Registry 
# --------

@ManualTune
Feature: TUN - QRZ - Saving And Loading Sets
  In order to check that the Save Set and Load Set functionality works as expected
  As a User
  I want to be able to Save and Load Sets successfully within and across browser / Typhoon sessions

  Background: 
	Given factory defaults have been reset

# -----------------------------------------------------------------------------------------------------------------------------------------
  Scenario: SLS - 01 - Attempting to Save with No Changes 
    Given that the browser is freshly opened on the Tune page		
		And the Control Parameters have not been modified within the current browser session
	Then the option to save the Control Parameters is disabled

  Scenario: SLS - 02 - Attempting to Load with no Previous Saves
    Given that the browser is opened on the Tune page
	  And no tune sets have been previously saved
    When an attempt is made to Load Set 
	Then there are no tune sets available for selection

  Scenario: SLS - 03 - Attempting to Save with no Previous Saves
    Given that the browser is opened on the Tune page
      And some of the Control Parameters have been modified within the current browser session
	  And no tune sets have been previously saved
    When an attempt is made to Save Set
    Then it is possible to Save the Control Parameters set without any warnings or errors

  Scenario: SLS - 04 - Attempting to Save with Previous Saves
    Given that the browser is opened on the Tune page
	  And some of the Control Parameters have been modified within the current browser session
	  And there are tune sets available to load
    When an attempt is made to Save Set
    Then it is possible to Save the Control Parameters set without any warnings or errors

@SmokeTest
  Scenario: SLS - 05 - Attempting to Load with Previous Saves
    Given that the browser is opened on the Tune page
      And at least one Control Parameter set has been previously saved
    When an attempt is made to Load Set 
	 And one of the available Sets is selected
    Then it is possible to Load the Control Parameter set without any warnings or errors

  Scenario: SLS - 06 - Loading a Parameter Control Set Saved Within the Same Browser Session
    Given that the browser is opened on the Tune page
      And all the Control Parameter values are changed from their initial values
      And Save Set is selected with a unique name specified for the save
      And all the Control Parameter values are changed from their Saved values
    When an attempt is made to Load Set
	  And the current changes are then not saved
	  And the previously Saved set is selected
	Then all non factory default Control Parameters are returned to their previously saved values
	And the option to save the Control Parameters is disabled

  Scenario: SLS - 07 - Loading a Parameter Control Set Saved in a Previous Browser Session
    Given that the browser is opened on the Tune page
      And all the Control Parameter values are changed from their initial values
      And Save Set is selected with a unique name specified for the save
      And the Browser is closed and re-opened
      And all the Control Parameter values are changed from their current values
    When an attempt is made to Load Set
	 And the current changes are then not saved
	 And the previously Saved set is selected
	Then all non factory default Control Parameters are returned to their previously saved values

  Scenario: SLS - 08 - Loading a Parameter Control Set Saved in a Previous Typhoon Session
    Given that the browser is opened on the Tune page
      And all the Control Parameter values are changed from their initial values
      And Save Set is selected with a unique name specified for the save
      And the Browser is closed
      And Typhoon is restarted without setting any parameter values
      And the Browser is re-opened
    When an attempt is made to Load Set
	 And the previously Saved set is selected
	Then all non factory default Control Parameters are returned to their previously saved values

  Scenario: SLS - 09 - Loading an Overwritten Parameter Control Set
    Given that the browser is opened on the Tune page
      And all the Control Parameter values are changed from their initial values
      And Save Set is selected with a unique name specified for the save
      And all the Control Parameter values are changed from their Saved values
      And Save Set is selected with the SAME name (overwritting the existing set)
      And all the Control Parameter values are changed from their overwritten values
    When an attempt is made to Load Set
	 And the current changes are then not saved
	 And the previously Saved set is selected	
	Then all non factory default Control Parameters are returned to their previously saved values 

 Scenario Outline: SLS - 10 - Attempting to Save with different names
    Given that the browser is opened on the Tune page
	  And no tune sets have been previously saved
      And some of the Control Parameters have been modified within the current browser session
    When an attempt is made to Save Set
    Then I should be able to specify a user defined <Save Set Name> having as result <Accepted / Rejected>
		Examples: Strings
		| Save Set Name                   | Accepted / Rejected |
		| Alpha                           | Accepted            |
		| Numeric                         | Accepted            |
		| Alpha-Numeric                   | Accepted            |
		| Approved Special Characters     | Accepted            |
		| Special Characters              | Rejected            |
		| Alpha-Numeric-SpecialCharacters | Rejected            |

		Examples: Long string
		| Save Set Name  | Accepted / Rejected |
		| 150 characters | Accepted            |
		| 151 characters | Rejected            |
# -----------------------------------------------------------------------------------------------------------------------------------------
# END