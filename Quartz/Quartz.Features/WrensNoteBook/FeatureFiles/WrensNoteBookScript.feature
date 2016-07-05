# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # Wrens NoteBook Scripts
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Emmy Hoyes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    # 4-Aug-15
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:	   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Typoon and Quartz installed for Osprey instrument
#                          # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # This a script that can be used for testing the script editor:
#						   #		require('BaseFramework')
#						   #		local i=0;
#						   #		while (i<100) do 
#						   #		local report=SLB.Report()
#						   #		report:title("Test")
#						   #		report:section("Section Test"):text("My text "..i)
#						   #		print("This is for the log "..1)
#						   #		local sender=SLB.Sender()
#						   #
#						   #			sender:send(report)
# 						   #		sleep(1)
# 						   #		i=i+1
# 						   #		end
#						   #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    #
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis                    #  http://typhoon-build.corp.waters.com/job/Build-Typhoon-Documentation/Typhoon_Documentation/ See Wrens Notebook
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

@ignore
Feature: Quartz - Wrens Notebook Scripts
	In order to control the instruments using lua scripts I want to be able to manage and edit scripts.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given the Wrens Notebook application is open
		
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: 01 - Add new script
	Given there is a notebook open
	When I add a new script 
	Then a new script is added to the notebook

Scenario: 02 - Run script
	Given there is a notebook open with a script displayed
	When I run a script
	Then that script is run 

Scenario: 03 - Stop script
	Given there is a notebook open with a script displayed
	And the script is running
	When I stop the script
	Then that script is stopped

Scenario: 04 - Delete script
	Given there is a notebook open with a script displayed
	When I delete the script
	Then that script is deleted

Scenario: 05 - Clear results
	Given there is a notebook open with a script displayed
		And there are results present in the result window
	When I clear the results
	Then the result window is cleared

Scenario: 06 - Edit script title
	Given there is a notebook open with a script displayed
	When I click on the title
	Then the title can be edited
# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: 07 - Move script up
	Given there is a notebook open
		And there is more than one script present
	When I click on the up arrow for a script that isn't the top script
	Then that script and its results are moved one position up swapping positions with the script above

Scenario: 08 - Move script down
	Given there is a notebook open
		And there is more than one script present
	When I click on the down arrow
	Then that script and its results are moved one position down

Scenario: 09 - Navigate to script from short cut menu
	Given there is a notebook open
		And there is more than one script present
	When I click on the title displayed in shortcut menu
	Then that script is displayed at the top of the browser window

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: 10 - Saves script on run
	Given there is a notebook open with a script displayed
		And I have made a change to the script
		And I run the script
		And a different notebook has been selected
	When returning to the first notebook
	Then the script should have retained the changes made

Scenario: 11 - Display reports
	Given there is a notebook open with a script displayed
		And the script creates a report
	When I run the script			
	Then the report should be displayed in the report window

Scenario: 12 - Display prints
	Given there is a notebook open with a script displayed
		And the script uses a print statement
	When I run the script			
	Then the text printed should be displayed in the log window

# ---------------------------------------------------------------------------------------------------------------------------------------------------

#End
