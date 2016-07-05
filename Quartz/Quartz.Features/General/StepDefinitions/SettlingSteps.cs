using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Timers;
using System.Windows.Automation;
using Quartz.Support.Views;
using TechTalk.SpecFlow;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using Waters.Control.Client;

namespace Quartz.Features.General.StepDefinitions
{
    [Binding]
    public class SettlingSteps
    {
        private static string configPath = TyphoonHelper.ConfigDirectory;

        private string DetectorRunningMode;
        private string DataFile;

        private XmlFileHelper xmlHelper;
        private TunePage tunePage;
        private DetectorSetupPage detectorPage;
        private CalibrationPage calibrationPage;

        private static Timer _settlingTimer;
        private Dictionary<string, string> StartFinishSettleMessages = new Dictionary<string, string>();

        public SettlingSteps(TunePage _tunePage, DetectorSetupPage _detectorPage, CalibrationPage _calibrationPage)
        {
            tunePage = _tunePage;
            detectorPage = _detectorPage;
            calibrationPage = _calibrationPage;
            _settlingTimer = new Timer 
            { 
                Enabled = true
            };

            _settlingTimer.Elapsed += new ElapsedEventHandler(OnTimedEvent);
        }


        private static string InstrumentMonitorText = string.Empty;

        [BeforeFeature("Settling")]
        public static void BeforeFeature()
        {
            // Workaround for Betas: Uncomment Settling 
            InstrumentMonitorText = File.ReadAllText(configPath + "InstrumentMonitor.xml");
            var newInstrumentMonitorText = InstrumentMonitorText.Replace("<!--", "");
            newInstrumentMonitorText = newInstrumentMonitorText.Replace("-->", "");

            File.WriteAllText(configPath + "InstrumentMonitor.xml", newInstrumentMonitorText);
        }

        [AfterFeature("Settling")]
        public static void AfterFeature()
        {
            // Workaround for Betas: Uncomment Settling 
            File.WriteAllText(configPath + "InstrumentMonitor.xml", InstrumentMonitorText);
        }

        [AfterScenario("Settling")]
        public void AfterScenario()
        {
            if (DebugViewHelper.DebugViewProcess != null)
            {
                try
                {
                    //Close the DebugView application
                    Report.Debug("Scenario has finished executing, closing any open DebugView sessions...");
                    DebugViewHelper.SetMessageFilter("*");
                    DebugViewHelper.DebugViewProcess.Kill();
                }
                catch (Exception)
                {
                    // Make sure the process has been killed.
                    Process[] dbgViews = Process.GetProcessesByName("Dbgview");
                    foreach (var process in dbgViews)
                    {
                        process.Kill();
                    }
                }
            }

            if (ScenarioContext.Current.ScenarioInfo.Tags.Length != 0)
            {
                if (ScenarioContext.Current.ScenarioInfo.Tags[0] == "cleanup-SET-03")
                {
                    try
                    {
                        xmlHelper = new XmlFileHelper(configPath + "InstrumentMonitor.xml");
                        xmlHelper.SetAttributeValue("Settle", "Readback", "20", "System1.FlightTube.Readback");
                        xmlHelper.XmlDoc.Save(configPath + "InstrumentMonitor.xml");

                        ServiceHelper.FullReconnect();
                    }
                    catch (Exception) { }
                }

                if (ScenarioContext.Current.ScenarioInfo.Tags[0] == "cleanup-SET-07")
                {
                    try
                    {
                        // Reject the calibration report to close it.
                        PeakPickerPage pp = new PeakPickerPage();
                        pp.Controls.RejectCalibrationButton.Click();
                    }
                    catch (Exception) { }
                }

                if (ScenarioContext.Current.ScenarioInfo.Tags[0] == "cleanup-FullReconnect")
                {
                    Report.Debug("Reconnecting to Typhoon and Quartz...");
                    ServiceHelper.FullReconnect();
                }
            }

            try
            {
                // Ensure Detector Setup is stopped
                NavigationMenu.DetectorSetupAnchor.Click();

                if (detectorPage.Controls.StartStopButton.Text == "Stop")
                    detectorPage.Controls.StartStopButton.Click();

                // Ensure Acquiisition is not running
                NavigationMenu.TuneAnchor.Click();

                if (tunePage.Controls.AbortButton.Enabled == true)
                    tunePage.Controls.AbortButton.Click();

            }
            catch (Exception) { }

            try
            {
                // Set polarity and mode back to default and then wait for it to settle before moving onto the next scenario
                NavigationMenu.TuneAnchor.Click();
                tunePage.SwitchConfiguration("Resolution", "Positive");
                Wait.ForMilliseconds(20000);
            }
            catch (Exception) { }
        }


        [Given(@"that the '(.*)' file is available")]
        public void GivenThatTheFileIsAvailable(string fileName)
        {
            Check.IsTrue(File.Exists(configPath + fileName), fileName + " exists in " + configPath);
        }

        [Given(@"the ""(.*)"" file is modified to prevent the FlightTube voltage from ever being reached")]
        public void GivenTheFileIsModifiedToPreventTheFlightTubeVoltageFromEverBeingReached(string fileName)
        {        
            xmlHelper = new XmlFileHelper(configPath + fileName);
            xmlHelper.SetAttributeValue("Settle", "Readback", "System1.FlightTube.Readback", "20");
            xmlHelper.XmlDoc.Save(configPath + fileName);
        }
        
        [Given(@"the Quartz browser is '(.*)'")]
        public void GivenTheQuartzBrowserIs(string action)
        {
            if (action.ToLower() == "opened")
                ServiceHelper.StartQuartz();
            else
                throw new NotImplementedException(string.Format("Action '{0}' not implemented", action));
        }       

        [Given(@"that for each Polarity and Mode, the Flight Tube \(Tof Voltage\) instrument setting is as follows")]
        public void GivenThatForEachPolarityAndModeTheFlightTubeTofVoltageInstrumentSettingIsAsFollows(Table table)
        {       
            foreach (TableRow row in table.Rows)
            {
                tunePage.SwitchConfiguration(row["Mode"], row["Polarity"]);

                Report.Action(string.Format("Check the Flight Tube (Tof Voltage) for mode/polarity '{0}/{1}'", row["Mode"], row["Polarity"]));

                tunePage.ControlsWidget.System1Tab.Select();
                System1TabView.FlightTubeSettingTextBox.SetText(row["Flight Tube"]);
                Check.AreEqual(row["Flight Tube"], System1TabView.FlightTubeSettingTextBox.Text, string.Format("Flight Tube Voltage is equal to '{0}'", row["Flight Tube"]), true);
                Report.Screenshot(System1TabView.FlightTubeSettingTextBox);
            }
        }


        [When(@"the contents of the '(.*)' file are inspected")]
        public void WhenTheContentsOfTheFileAreInspected(string fileName)
        {
            xmlHelper = new XmlFileHelper(configPath + fileName);
        }
        
        [Given(@"all Typhoon Services are '(.*)'")]
        [When(@"all Typhoon Services are '(.*)'")]
        public void WhenAllTyphoonServicesAre(string action)
        {
            if (action.ToLower() == "stopped")
            {
                Report.Action("Close Chrome and stop all waters processes");
                ServiceHelper.KillChrome();
                ServiceHelper.KillWatersProcesses();
                ServiceHelper.EmptyDataStore();
            }
            else if (action.ToLower() == "started")
            {
                Report.Action("Start the Typhoon services");
                TyphoonFactory.Reset();
                ServiceHelper.StartTyphoon();
            }
            else if (action.ToLower() == "restarted")
            {
                Report.Action("Close Chrome and restart all typhoon services");
                ServiceHelper.KillChrome();
                ServiceHelper.StopTyphoon();
                ServiceHelper.KillWatersProcesses();
                ServiceHelper.EmptyDataStore();
                TyphoonFactory.Reset();
                ServiceHelper.StartTyphoon();
            }
            else
            {
                throw new NotImplementedException(string.Format("Action '{0}' not implemented", action));
            }
        }

        [When(@"the Quartz browser is '(.*)'")]
        public void WhenTheQuartzBrowserIs(string action)
        {
            if (action.ToLower() == "opened")
                ServiceHelper.StartQuartz();
            else if (action.ToLower() == "closed")
                ServiceHelper.CloseQuartz();
            else if (action.ToLower() == "re-opened")
                ServiceHelper.StartQuartz();
            else
                throw new NotImplementedException(string.Format("Action '{0}' has not been defined", action));
        }                 
        
        [When(@"the Detector Setup process is run in '(.*)' mode \(using LeuEnk Vial\)")]
        public void WhenTheDetectorSetupProcessIsRunInModeUsingLeuEnkVial(string detectorMode)
        {
            // Set Sample Fluidics Reservoir to B (using LeuEnk Vial)
            tunePage.ControlsWidget.FluidicsTab.Select();
            FluidicsTabView.SampleFluidicsReservoirSettingDropdown.SelectOptionFromDropDown("B");

            NavigationMenu.DetectorSetupAnchor.Click();
            Wait.ForMilliseconds(1500); // wait for page to load 
            detectorPage.RunDetectorSetup(detectorMode, false); // don't wait for it to complete

            DetectorRunningMode = detectorMode;
        }

        [When(@"the Detector Setup process is run in '(.*)' mode and positive has completed")]
        public void WhenTheDetectorSetupProcessIsRunInMode(string detectorMode)
        {
            // Set Sample Fluidics Reservoir to B (using LeuEnk Vial)
            tunePage.ControlsWidget.FluidicsTab.Select();
            FluidicsTabView.SampleFluidicsReservoirSettingDropdown.SelectOptionFromDropDown("B");

            NavigationMenu.DetectorSetupAnchor.Click();
            Wait.ForMilliseconds(1500); // wait for page to load 
            detectorPage.RunDetectorSetup(detectorMode, false);

            // Wait for positive to complete
            detectorPage.WaitForDetectorSetupToComplete("Positive");

            DetectorRunningMode = detectorMode;
        }
        
        [When(@"the Positive mode Detector Setup process has completed")]
        public void WhenThePositiveModeDetectorSetupProcessHasCompleted()
        {
            detectorPage.WaitForDetectorSetupToComplete("Positive");
        }

        [When(@"an attempt is made to initiate the Acquisition process with '(.*)' and '(.*)'")]
        public void WhenAnAttemptIsMadeToInitiateTheAcquisitionProcessWithAnd(string polarity, string mode)
        {
            tunePage.SwitchConfiguration(mode, polarity);

            // Try to run an Acquisition           
            NavigationMenu.TuneAnchor.Click();
            tunePage.SelectTuningMethod("MS");
        }
        
        [Then(@"the file will contain tag details for the following")]
        public void ThenTheFileWillContainTagDetailsForTheFollowing(Table table)
        {
            foreach (var settle in table.Rows)
            {
                Report.Action(string.Format("Check the file contains a node for '{0}'", settle["Settle Name"]));

                var settleNode = xmlHelper.GetNode("Settle", "Name", settle["Settle Name"]);
                Check.IsNotNull(settleNode, string.Format("Settle node found for '{0}'", settle["Settle Name"]));
            }
        }

        [When(@"I wait '(.*)' seconds")]
        [Given(@"I wait '(.*)' seconds")]
        public void GivenIWaitSeconds(int seconds)
        {
            Wait.ForMilliseconds(seconds * 1000);
        }

        [Given(@"a few seconds of data is Acquired")]
        public void GivenAFewSecondsOfDataIsAcquired()
        {
            // Set Sample Fluidics Reservoir to C
            tunePage.ControlsWidget.FluidicsTab.Select();
            FluidicsTabView.SampleFluidicsReservoirSettingDropdown.SelectOptionFromDropDown("C");

            // Load MS.xml and record for a few seconds.
            tunePage.SelectTuningMethod("MS");

		    // Record data
            DataFile = "Settling" + DateTime.Now.ToString("ddmmyyHmmss");
            tunePage.RecordAcquisition(2000, DataFile);

            // Stop the tuning
            tunePage.Controls.AbortButton.Click();
        }

        [When(@"a Manual Calibration is Created using the Acquired data")]
        public void WhenAManualCalibrationIsCreatedUsingTheAcquiredData()
        {
            NavigationMenu.ManualCalibrationAnchor.Click();
            calibrationPage.CreateCalibration(DataFile);

            PeakPickerPage pp = new PeakPickerPage();
            pp.Controls.RejectCalibrationButton.Click();
        }

        [Given(@"the DebugView tool is opened")]
        [When(@"the DebugView tool is opened")]
        public void GivenTheDebugViewToolIsOpened()
        {
            DebugViewHelper.OpenDebugView();
            
            // Set filter to look at settle message only
            DebugViewHelper.SetMessageFilter("*Settle*");
            Wait.ForMilliseconds(500);
            DebugViewHelper.ClearDebugViewDisplay();
            DebugViewHelper.MinimizeDebugWindow();
        }

        [Given(@"the DebugView tool is opened listening for Settle and Method Runner messages")]
        public void GivenTheDebugViewToolIsOpenedListeningForSettleAndMethodRunnerMessages()
        {
            DebugViewHelper.OpenDebugView();
            DebugViewHelper.MinimizeDebugWindow();
        }

        [Then(@"after some time DebugView Messages related to InstrumentMonitor will be shown")]
        public void ThenAfterSomeTimeDebugViewMessagesRelatedToInstrumentMonitorWillBeShown(Table table)
        {
            int maxAttempts = 0;
            foreach (var row in table.Rows)
            {
                Report.Action(string.Format("Find message containing '{0}'", row["DebugView Messages"]));

                AutomationElement messageFound = null;

                while (messageFound == null && maxAttempts < 25)
                {
                    messageFound = DebugViewHelper.FindMessageContaining(row["DebugView Messages"], false);

                    if (messageFound == null)
                    {
                        Wait.ForMilliseconds(1000);
                        maxAttempts++;
                    }
                }

                Check.IsNotNull(messageFound, string.Format("Found settling message: {0}", row["DebugView Messages"]));
            }
        }

        [Then(@"after '(.*)' seconds a DebugView Tof Voltage timeout message is shown")]
        public void ThenAfterADebugViewTofVoltageTimeoutMessageIsShown(string time)
        {
            _settlingTimer.Interval = Convert.ToInt32(time) * 1000;
            _settlingTimer.Start();

            Report.Action(string.Format("Waiting {0} seconds", time));
            Report.Debug("Time now: " + DateTime.Now);
            while (_settlingTimer.Enabled)
            {
                // Do nothing
            }

            var messages = DebugViewHelper.GetAllSettleMessages();
            Report.Debug(string.Format("Got all settle messages from the last {0} seconds", time));
            Report.Debug("Time now: " + DateTime.Now);

            var message = DebugViewHelper.FindMessageContaining(messages, "Settle timeout on: Tof Voltage", true);
        }

        [Then(@"DebugView (.*) and (.*) are shown")]
        [Then(@"DebugView '(.*)' and '(.*)' are shown")]
        public void ThenDebugViewAndAreShown(string startMessage, string finishMessage)
        {
            if (startMessage == "N/A" && finishMessage == "N/A")
            {
                Report.Action("Check no settle messages were received");
                var messages = DebugViewHelper.GetAllSettleMessages();
                Report.Debug(messages.Count + " messages were received");
                Check.IsTrue(messages.Count == 0, "No settle messages were received");
            }
            else
            {
                _settlingTimer.Elapsed += new ElapsedEventHandler(OnTimedEvent);
                _settlingTimer.Interval = 20000;
                _settlingTimer.Start();

                Report.Action(string.Format("Waiting {0}", "18 seconds"));
                Report.Debug("Time now: " + DateTime.Now);
                while (_settlingTimer.Enabled)
                {
                    // Do nothing
                }

                var messages = DebugViewHelper.GetAllSettleMessages();
                Report.Debug(string.Format("Got all settle messages from the last {0}", "18 seconds"));
                Report.Debug(string.Format("{0} settle messages found", messages.Count.ToString()));
                Report.Debug("Time now: " + DateTime.Now);

                var start = DebugViewHelper.FindMessageContaining(startMessage, true);
                var finish = DebugViewHelper.FindMessageContaining(finishMessage, true);

                StartFinishSettleMessages.Add(start.Current.Name, finish.Current.Name);
            }
        }

        [Then(@"there will be a (.*) between the settle messages")]
        public void ThenThereWillBeABetweenTheSettleMessages(string delay)
        {
            if (delay == @"N/A (No Delay)" || delay == "N/A")
            {
                Report.Debug("No settle messages expected");
            }
            else
            {
                Report.Action("Check the delay between messages is approximately " + delay);

                foreach (var pair in StartFinishSettleMessages)
                {
                    var duration = DebugViewHelper.GetDurationBetweenMessages(pair.Key, pair.Value);

                    if (delay == "18 seconds")
                    {     
                        // Tolerance added
                        Report.Debug(string.Format("Time between start settle and finish settle messages was exactly: {0}", duration.ToString()));
                        Check.IsTrue(duration >= new TimeSpan(0, 0, 14) && duration <= new TimeSpan(0, 0, 20), "Time between start settle and finish settle messages is within tolerance of 14 seconds and 20 seconds");

                    }
                    else if (delay == "3 seconds")
                    {
                        // Tolerance added
                        Report.Debug(string.Format("Time between start settle and finish settle messages was exactly: {0}", duration.ToString()));
                        Check.IsTrue(duration >= new TimeSpan(0, 0, 3) && duration <= new TimeSpan(0, 0, 12), "Time between start settle and finish settle messages is within tolerance of 3 seconds and 5 seconds");
                    }
                    else
                    {
                        throw new NotImplementedException("Time delay not implemented");
                    }  
                }
            }                  
        }

        [Then(@"there will be a (.*) seconds between the first and last settle messages")]
        public void ThenThereWillBeASecondsBetweenTheFirstAndLastSettleMessages(int seconds)
        {
            if (seconds == 18)
            {
                Report.Action("Check the delay between messages is approximately 18 seconds");

                // find the first received message and the last received message
                List<DateTime> start = new List<DateTime>();
                List<DateTime> finish = new List<DateTime>();

                foreach (var startMessage in StartFinishSettleMessages.Keys)
                    start.Add(DebugViewHelper.GetMessageTimeStamp(startMessage));

                var startTimeStamp = start.Min();

                foreach (var finishMessage in StartFinishSettleMessages.Values)
                    finish.Add(DebugViewHelper.GetMessageTimeStamp(finishMessage));

                var finishTimeStamp = finish.Max();

                // Check duration between start and finish messages
                var duration = DateTime.Parse(finishTimeStamp.ToString()).Subtract(DateTime.Parse(startTimeStamp.ToString()));

                // Tolerance added
                Report.Debug(string.Format("Time between start settle and finish settle messages was exactly: {0}", duration.ToString()));
                Check.IsTrue(duration >= new TimeSpan(0, 0, 14) && duration <= new TimeSpan(0, 0, 22), "Time between start settle and finish settle messages is within tolerance of 14 seconds and 20 seconds");
            }
            else
            {
                throw new NotImplementedException("Time delay not implemented");
            }
        }

        [Then(@"it is not possible to start the following processes")]
        public void ThenItIsNotPossibleToStartTheFollowingProcesses(Table table)
        {
            // Change the DebugView filter
            DebugViewHelper.ClearDebugViewDisplay();
            DebugViewHelper.SetMessageFilter("*MethodRunner*");

            foreach (var row in table.Rows)
            {
                if (row["Process"] == "Acquisition")
                {
                    TryToRunAcquisition();

                    var message = DebugViewHelper.FindMessageContaining("MethodRunner System getting ready timeout, aborting method.", true);
                }
                else if (row["Process"] == "Detector Setup")
                {
                    TryToRunDetectorSetup();
                }
                else
                {
                    throw new NotImplementedException("Process requested not implemented.");
                }
            }
        }

        [Then(@"the Detector Setup process will not start, until both Pre-Run DebugView '(.*)' and '(.*)' are shown \(if appropriate\)")]
        public void ThenTheDetectorSetupProcessWillNotStartUntilBothPre_RunDebugViewAndAreShownIfAppropriate(string startMessage, string finishMessage)
        {
            if (startMessage == @"N/A (No Message)" && finishMessage == @"N/A (No Message)")
            {
                Report.Action("Check the detector setup starts straight away");
                Wait.ForMilliseconds(1000);

                Check.IsTrue(detectorPage.Controls.PositiveResultsPanelStatus.Text == "Running" || detectorPage.Controls.NegativeResultsPanelStatus.Text == "Running", "The Detector Setup status is 'Running'");

                // Check no messages were received
                var messagesReceived = DebugViewHelper.GetAllSettleMessages();
                Check.IsTrue(messagesReceived.Count == 0, "No settle messages were received");

            }
            else if (startMessage == "Settle started on: Polarity")
            {
                Report.Action(string.Format("Check the detector setup does not start until the settle messages: '{0}' and '{1}' have been received.", startMessage, finishMessage));

                // Wait for the Detector Setup to start
                var startedRunning = detectorPage.WaitForDetectorSetupToStart(30000);
                        
                Report.Action(string.Format("Wait for the start message: '{0}'; and finish message: {1}", startMessage, finishMessage));  
                StartFinishSettleMessages = new Dictionary<string, string>();

                // Specify a timeout to find the start and finish messages so that we don't have an infinite loop if something goes wrong
                _settlingTimer.Interval = 20000;
                _settlingTimer.Start();

                AutomationElement sMessage = null;
                AutomationElement fMessage = null;
                while ((sMessage == null || fMessage ==null) && _settlingTimer.Enabled)
                {
                    // Keep looking
                    if (sMessage == null)
                        sMessage = DebugViewHelper.FindMessageContaining(startMessage, false);

                    if (fMessage == null)
                        fMessage = DebugViewHelper.FindMessageContaining(finishMessage, false);
                }

                _settlingTimer.Stop();
  
                // Store the message to check the time delay between them later
                if (sMessage != null && fMessage != null)
                {
                    StartFinishSettleMessages.Add(sMessage.Current.Name, fMessage.Current.Name);
                }
                else
                {
                    Report.Fail("Did not receive start and finish messages with in 20 seconds");
                }

                // Get the time the finished message was received
                var receivedFinishMessage = DebugViewHelper.GetMessageTimeStamp(fMessage.Current.Name);
                Report.Debug(string.Format("Message '{0}' was received at '{1}'...", fMessage.Current.Name, receivedFinishMessage.ToString()));

                // Check the finish message was received before the detector setup ran
                var utc = TimeZoneInfo.ConvertTimeToUtc(startedRunning);
                Check.IsTrue(receivedFinishMessage < TimeZoneInfo.ConvertTimeToUtc(startedRunning), string.Format("The message '{0}' was received before the detector setup started at '{1}'", finishMessage, startedRunning.ToString()));                               
            }

            // Stop the detector setup
            detectorPage.Controls.StartStopButton.Click();
        }

        [Then(@"the Negative Detector Setup process will not start, until both Mid-Run DebugView '(.*)' and '(.*)' are shown")]
        public void ThenTheNegativeDetectorSetupProcessWillNotStartUntilBothMid_RunDebugViewAndAreShown(string startMessage, string finishMessage)
        {
            StartFinishSettleMessages = new Dictionary<string, string>();

            Report.Action(string.Format("Check the Negative Detector Setup process does not start until the settle messages: '{0}' and '{1}' have been received.", startMessage, finishMessage));
            var startedRunning = WaitForNegativeDetectorSetupToStart();

            // Get the last received start message as there will be multiple after switiching polarities
            Wait.ForMilliseconds(8000);
            var sMessage = DebugViewHelper.GetMessagesContaining(startMessage).LastOrDefault();
            var fMessage = DebugViewHelper.GetMessagesContaining(finishMessage).LastOrDefault();
  
            // Store the message to check the time delay between them later
            if (sMessage != null && fMessage != null)
            {
                StartFinishSettleMessages.Add(sMessage.Current.Name, fMessage.Current.Name);
            }
            else
            {
                Report.Fail("Did not receive start and finish messages");
            }

            // Get the time the finished message was received
            var receivedFinishMessage = DebugViewHelper.GetMessageTimeStamp(fMessage.Current.Name);
            Report.Debug(string.Format("Message '{0}' was received at '{1}'...", fMessage.Current.Name, receivedFinishMessage.ToString()));

            // Check the finish message was received before the detector setup ran
            var utc = TimeZoneInfo.ConvertTimeToUtc(startedRunning);
            Check.IsTrue(receivedFinishMessage <= TimeZoneInfo.ConvertTimeToUtc(startedRunning), string.Format("The message '{0}' was received before the negative detector setup started at '{1}'", finishMessage, startedRunning.ToString()));                
        }  

        [Then(@"there will be no DebugView Settle messages shown")]
        public void ThenThereWillBeNoDebugViewSettleMessagesShown()
        {
            var allMessagees = DebugViewHelper.GetAllSettleMessages();
            Check.IsTrue(allMessagees.Count == 0, "No Settle messages were displayed");
        }
        
        [Then(@"the time between DebugView Tof Voltage Settle started and finished messages, is at least '(.*)' seconds")]
        public void ThenTheTimeBetweenDebugViewTofVoltageSettleStartedAndFinishedMessagesIsAtLeastSeconds(int seconds)
        {
            // Wait a reasonable amount of time for the finish message to be received i.e. double expected time
            Wait.ForMilliseconds((seconds * 1000)*2);

            var startMessage = DebugViewHelper.FindMessageContaining("Settle started on: Tof Voltage", true);
            var finishMessage = DebugViewHelper.FindMessageContaining("Settle finished on: Tof Voltage", true);

            var duration = DebugViewHelper.GetDurationBetweenMessages(startMessage.Current.Name, finishMessage.Current.Name);

            // Tolerance added
            Report.Debug(string.Format("Time between start settle and finish settle messages was exactly: {0}", duration.ToString()));
            Check.IsTrue(duration >= new TimeSpan(0, 0, seconds), string.Format("Time between start settle and finish settle messages is greater than '{0}' seconds", seconds));
        }

        [Then(@"the Acquisition is not started, until DebugView '(.*)' and '(.*)' are shown")]
        public void ThenTheAcquisitionIsNotStartedUntilDebugViewAndAreShown(string startMessage, string finishMessage)
        {
            Report.Action(string.Format("Check the acquisition does not start until the settle messages: '{0}' and '{1}' have been received.", startMessage, finishMessage));
            
            var startedRunning = StartAcquisition();

            if (startMessage == "Tof Voltage and Polarity")
            {
                var messages = DebugViewHelper.FindMessagesContaining("Settle started on: Tof Voltage", "Settle finished on: Tof Voltage", "Settle started on: Polarity", "Settle finished on: Polarity");

                DebugViewHelper.CheckFinishMessageReceivedBeforeAcquisitionRan(messages[1], startedRunning);
                DebugViewHelper.CheckFinishMessageReceivedBeforeAcquisitionRan(messages[3], startedRunning);

                StartFinishSettleMessages = new Dictionary<string, string>();

                // Add these message to the dictionary to check the time delays later
                StartFinishSettleMessages.Add(messages[0].Current.Name, messages[1].Current.Name);
                StartFinishSettleMessages.Add(messages[2].Current.Name, messages[3].Current.Name);
            }

            // Stop the acquisition
            tunePage.Controls.AbortButton.Click();
        }

        [Then(@"the Acquisition is not started, until both DebugView '(.*)' and '(.*)' are shown \(if appropriate\)")]
        public void ThenTheAcquisitionIsNotStartedUntilBothDebugViewAndAreShownIfAppropriate(string startMessage, string finishMessage)
        {
            if (startMessage == @"N/A (No Message)" && finishMessage == @"N/A (No Message)")
            {
                Report.Action("Check the acquisition starts straight away");
                Wait.ForMilliseconds(1500); // give it enough time to toggle the Abort button if it has started

                // Test the Acquisition runs stright away by checking Abort is disabled and a message was displayed
                tunePage.Controls.AbortButton.CheckEnabled();

                Report.Action("Check no settle messages were received");
                var settleMessages = DebugViewHelper.GetMessagesContaining("Settle");
                Report.Debug(settleMessages.Count + " settle messages received ");
                Check.IsTrue(settleMessages.Count == 0, "No settle messages were received");
            }
            else
            {
                Report.Action(string.Format("Check the acquisition does not start until the settle messages: '{0}' and '{1}' have been received.", startMessage, finishMessage));

                var startedRunning = StartAcquisition();

                Report.Action(string.Format("Wait for the start message: '{0}'; and finish message: {1}", startMessage, finishMessage));
                // Wait until the finished message is received
                StartFinishSettleMessages = new Dictionary<string, string>();

                int maxAttempts = 0;
                AutomationElement sMessage = null;
                AutomationElement fMessage = null;
                while ((sMessage == null || fMessage == null) && maxAttempts < 50)
                {
                    Wait.ForMilliseconds(500);
                    // Keep looking
                    if (sMessage == null)
                        sMessage = DebugViewHelper.FindMessageContaining(startMessage, false);

                    if (fMessage == null)
                        fMessage = DebugViewHelper.FindMessageContaining(finishMessage, false);

                    maxAttempts++;
                }

                // Store the message to check the time delay between them later
                if (sMessage != null && fMessage != null)
                {
                    StartFinishSettleMessages.Add(sMessage.Current.Name, fMessage.Current.Name);
                }
                else
                {
                    Report.Fail("Did not receive start and finish messages with in 20 seconds");
                }

                DebugViewHelper.CheckFinishMessageReceivedBeforeAcquisitionRan(fMessage, startedRunning);
            }

            // Stop the acquisition
            tunePage.Controls.AbortButton.Click();
        }

        [When(@"the Flight Tube voltage is set to (.*)")]
        [Given(@"the Flight Tube voltage is set to (.*)")]
        public void GivenTheFlightTubeVoltageIsSetTo(string value)
        {
            NavigationMenu.TuneAnchor.Click();
            tunePage.ControlsWidget.System1Tab.Select();
            System1TabView.FlightTubeSettingTextBox.SetText(value);
        }


        /// <summary>
        /// Starts Acquisition
        /// </summary>
        /// <returns>DateTime the acquisition started</returns>
        public DateTime StartAcquisition()
        {
            // Look for message that acquisition is starting... Note: Checking for visual change in Quartz UI was not reliable
            Report.Action(string.Format("Wait for the start acquisition message: '{0}'", "Sequencer Starting Schedule"));

            // Wait approximately 25 seconds
            int maxAttempts = 0;
            AutomationElement sMessage = null;
            while (sMessage == null && maxAttempts < 50)
            {                
                if (sMessage == null)
                {
                    sMessage = DebugViewHelper.FindMessageContaining("Sequencer Starting schedule", false);
                }
                Wait.ForMilliseconds(500);
                maxAttempts++;
            }

            Check.IsNotNull(sMessage, "Acquisition start message found");

            return DebugViewHelper.GetMessageTimeStamp(sMessage.Current.Name);
        }

        /// <summary>
        /// Wait for the negative detector setup to start
        /// </summary>
        /// <returns>The time it started</returns>
        private DateTime WaitForNegativeDetectorSetupToStart()
        {
            Wait.ForMilliseconds(500);
            // Count number of lines in the progress log, following the postive mode completing
            var textlength = detectorPage.Controls.ProgressLogTextArea.Text.Length;

            // It should not increase until the start and finish messages have been receieved.
            while (detectorPage.Controls.ProgressLogTextArea.Text.Length == textlength)
            {
                // Do nothing
                Wait.ForMilliseconds(1000);

                if (detectorPage.Controls.NegativeResultsPanelStatus.Text == "Aborted")
                    Report.Fail("Negative detector setup unexpectedly Aborted.");
                    Report.Screenshot();
            }
            var startedRunning = DateTime.Now;

            Report.Debug(string.Format("Negative Detector Setup started running at: {0}", startedRunning.ToString()));
            Report.Screenshot();

            return startedRunning;
        }

        /// <summary>
        /// Attempt to start the detector setup and look for an Aborted status
        /// </summary>
        private void TryToRunDetectorSetup()
        {
            // Try to run a Detector Setup
            NavigationMenu.DetectorSetupAnchor.Click();
            detectorPage.RunDetectorSetup("Positive", false);
            Wait.ForMilliseconds(200);
            Check.IsTrue(detectorPage.Controls.PositiveResultsPanelStatus.Text == "Aborted", "Detector Setup status is 'Aborted'");
            Report.DebugScreenshot(detectorPage.Controls.PositiveResultsPanelStatus);
        }

        /// <summary>
        /// Attempt to run an acquisition but expect it to fail
        /// </summary>
        private void TryToRunAcquisition()
        {
            // Try to run an Acquisition
            NavigationMenu.TuneAnchor.Click();
            tunePage.SelectTuningMethod("MS");

            Wait.ForMilliseconds(3000);

            // Test the Acquisition did not run by checking Abort is disabled and a message was displayed
            tunePage.Controls.AbortButton.CheckDisabled();
        }

        /// <summary>
        /// Fired when a timeout occurs
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        public static void OnTimedEvent(object source, ElapsedEventArgs e)
        {
            _settlingTimer.Enabled = false;
        }
    }
}
