# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # MET - QRZ - Triggering
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # CDH
# -------------------------#-------------------------------------------------------------------------------------------------------------------------	
# Date:                    # 19-AUG-14      
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # Currently, it is not practical to automate this feature, 
#                          # until additional development work has been scheduled to facilitate it.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # Add the following lines to XML method to enable external triggering:-
#                          # To specify 'Network' triggering add...   <Setting Name="Network" Value="0.0" Mapping="Inlet.Event1In.Setting"/>
#                          # To specify 'Hardware' triggering add...  <Setting Name="Event1" Value="1.0" Mapping="Inlet.Event1In.Setting"/>
#                          #                                          <Setting Name="Event2" Value="1.0" Mapping="Inlet.Event1In.Setting"/>
#                          #                                          <Setting Name="Event3" Value="1.0" Mapping="Inlet.Event1In.Setting"/>
#                          #                                          <Setting Name="Event4" Value="1.0" Mapping="Inlet.Event1In.Setting"/>
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # An external trigger box is required to be connected to the rear panel of the instrument, to be triggered manually.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------	
# Tools Required:	       # 'MultiAcquityTrigger' application from A.Grzyb (\\tu-server-sw\tu-server1\docs\Test_Applications\Network Triggering)
#                          #  Settings...
#                          #             IP:     192.168.0.2 (or other 'epc' IP Address)
#                          #             Cookie: Trigger
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # N/A (Initial Version)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # Osprey UNIFI ICS Software Specification
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-155)                 # The software will enable the user to specify the triggering mechanism for the method.
#                          # The triggering mechanism defines how the instruments within a system communicate
#                          # in order to align the start of data collection with the introduction of the sample.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-156)                 # The software will enable the user to specify the triggering mechanism for the method.
#                          # The triggering mechanism defines how the instruments within a system communicate
#                          # in order to align the start of data collection with the introduction of the sample.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-155)                 # The software will offer three modes of acquisition method triggering  - No Triggering, Network, Hardware
#                          # * No Triggering define the method to execute data acquisition without any triggering from other instruments within the system.
#                          # * Network - The method will be triggered via the waters instrument communication Multicast system.
#                          # * Hardware - The method will be triggered via a physical connection into the instrument rear panel connection panel.
#                          # * Probe Insertion (ASAP only)
#                          # When Hardware is selected the user will be able to select between triggering via the instrument rear panel 
#                          # event input 1, event input 2 or both event inputs 1 and 2.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# NOTE: The following SS is not covered in this feature file - it will be covered in later iterations when the ASAP Probe type is supported.
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# (SS-155)                 # * Probe Insertion (ASAP only)
# -------------------------#-------------------------------------------------------------------------------------------------------------------------



# ---------------------------------------------------------------------------------------------------------------------------------------------------
Feature: Triggering
	In order to check that Triggering works as expected
	I want to be able to run an Acquisition and show that it can be triggered appropriately according to the selected triggering option
# ---------------------------------------------------------------------------------------------------------------------------------------------------


Background:
	Given that a Method is available

# ---------------------------------------------------------------------------------------------------------------------------------------------------
@ManualOnly
Scenario: QRZ-01 - Acquisition Triggering (None)
	Given that 'no trigger type' has been specified within the method
	When an attempt is made to 'Start' an acquisition using this method
	Then the method acquisition 'will start' without the need for any external triggering

@ManualOnly
Scenario: QRZ-02 - Acquisition Triggering (Network)
	Given the trigger type 'Network' has been specified within the method
	When an attempt is made to 'Start' an acquisition using this method
	Then the method acquisition 'will not start' until it has been 'triggered' correctly via the 'Network'

@ManualOnly
Scenario Outline: QRZ-03 - Acquisition Triggering (Hardware - Contact Closure)
	Given the trigger type 'Hardware' has been specified within the method for '<Selected Event Input(s)>'
	When an attempt is made to 'Start' an acquisition using this method
	Then the method acquisition 'will not start' until it has received at least one external pulse from all selected '<Event Input(s)>'
		Examples:
		| Event Input(s)                                                      |
		| Event Input 1                                                       |
		| Event Input 2                                                       |
		| Event Input 3                                                       |
		| Event Input 4                                                       |	
		| Event Input 1 AND Event Input 2                                     |
		| Event Input 1 AND Event Input 2 AND Event Input 3 AND Event Input 4 |	

# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END
