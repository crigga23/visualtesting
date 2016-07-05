# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Wrens NoteBook
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Emmy Hoyes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 4-Aug-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:	   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Typoon and Quartz installed for Opsrey instrument
#                          # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis                    # http://typhoon-build.corp.waters.com/job/Build-Typhoon-Documentation/Typhoon_Documentation/ See Wrens Notebook
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
					
@ignore
Feature: Quartz - Wrens Notebook
	In order to control the instrument using lua scripts I want to be able to manage and edit notebook containing scripts

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the Wrens Notebook application is open
		
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: 01 - Create notebook
	When I create a new notebook 
		And I enter a new name
	Then a new notebook is created 
		And is displayed in the browser with one existing blank script

Scenario: 02  - Save notebook
	Given there is a notebook open
	When I have made changes to the notebook
		And the notebook is saved
	Then the notebook changes should be saved

Scenario: 03  - Save notebook with new name
	Given there is a notebook open
	When I select to save the notebook with a new name
		And I have entered the new name
	Then the notebook will be created with the new name
		And will be displayed in the browser

Scenario: 04  - Save notebook with new name but cancel
	Given there is a notebook open
	When I select to save a notebook with a new name
		And enter the new name and select cancel
	Then the notebook will not be created with the new name
		And the original notebook will be displayed in the browser

# ------------------------------------------------------------------------------------------------------------------------------------------
Scenario: 05 - Export notebook
	Given there is a notebook open
	When I select to export the notebook
	Then a file with a .wnb extension is downloaded through the browser


Scenario: 06 - Import notebook .wnb
	When I select to import a notebook
		And select a .wnb file from the file dialog
	Then a notebook is imported 	

Scenario: 07 - Import notebook wrong format
	When I select to import a notebook
		And select a file that has not got a .wnb extension from the file dialog
	Then a message is displayed to point out the incorrect file extension

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: 08 - Delete notebook
	Given there is a notebook open
	When I delete the notebook
	Then the notebook is deleted 
		And no notebook is displayed in the browser

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: 09 - Display notebook
	Given there is more than one notebook present
	When I select a different notebook from what is being displayed 
	Then the new notebook is displayed
		
Scenario: 10 - Notebook changes are saved between changing notebooks
	Given there is more than one notebook present
		And I have made changes to the notebook
		And I select a different notebook 
	When returning to the first notebook
	Then the notebook should have retained the changes made

Scenario: 11 - Notebook changes are saved between quartz sections
	Given there is a notebook open
		And I have made changes to the notebook
		And I navigate to a different section of the application
	When I return to the notebook application
	Then the notebook should have retained the changes made
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: 12 - Buttons shown when notebook selected
	Given a notebook is selected	
	Then the following buttons are displayed
			| Create New		|
			| Save				|
			| Save As New		|
			| Delete Notebook	|
			| Add Script		|
			| Export Notebook	|
			| Import Notebook	|
 

Scenario: 13 - Buttons shown when notebook not selected
	Given that no notebook is selected
	Then the following buttons are displayed
			| Create New		|
			| Import Notebook	|

#for when the application is started from fresh install
Scenario: 14 - New notebook prompted on start up
	Given there are no existing notebooks 
	When I visit the wrens notebook application 
	Then a prompt is displayed to create a new notebook


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
