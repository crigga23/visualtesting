using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Xml.Linq;
using Automation.Config.Lib.ConfigHelpers;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.Typhoon.Lib;
using Automation.WebFramework.Lib;
using Quartz.Support;
using Quartz.Support.Configuration;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Modals;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.InstrumentSetup.StepDefinitions
{
    [Binding]
    public class QRZ_InstrumentSetupSteps
    {
        private static string configPath = TyphoonHelper.ConfigDirectory;

        private int expectedSlotCompletionTimeInSeconds = 150;

        private XmlManager xmlHelper = new XmlManager(configPath + "CalibrationProcessingCriteria.xml");
        private TyphoonConfigurationHelper typhoonConfigurationHelper = new TyphoonConfigurationHelper();

        private Dictionary<string, string> polynomials = new Dictionary<string, string>();

        private InstrumentSetupConfig _instrumentSetupConfig;
        private InstrumentSetupPage _instrumentSetupPage;
        private IAcquisitionData _acquisitionData = AcquistionFactory.Instance.AcquisitionData;
        TunePage tunePage = new TunePage();  

        public TechTalk.SpecFlow.Table CalibratedSlots { get; private set; }

        public QRZ_InstrumentSetupSteps(InstrumentSetupPage instrumentSetupPage)
        {
            _instrumentSetupConfig = new InstrumentSetupConfig(new TestConfiguration(new AppSettingsConfigurationManager()).Instrument);
            _instrumentSetupPage = instrumentSetupPage;

            if (!FeatureContext.Current.ContainsKey("InstrumentSetupCalibrationComplete"))
                FeatureContext.Current.Add("InstrumentSetupCalibrationComplete", false);

            if (!FeatureContext.Current.ContainsKey("DetectorSetupAndResOpComplete"))
                FeatureContext.Current.Add("DetectorSetupAndResOpComplete", false);

            if (!FeatureContext.Current.ContainsKey("SkipInstrumentSetup"))
                FeatureContext.Current.Add("SkipInstrumentSetup", false);

            if (!FeatureContext.Current.ContainsKey("ConfigureBeamComplete"))
                FeatureContext.Current.Add("ConfigureBeamComplete", false);
        }

        [BeforeFeature("InstrumentSetupAcquisition", "InstrumentSetup")]
        public static void BeforeFeature()
        {
            // Update the InstrumentSetupConfiguration.xml and enable the Positive.Sensitivity.4000 to use vial A 
            XmlManager xmlInstConfigHelper = new XmlManager(configPath + "InstrumentSetupConfiguration.xml");
            var highMassNode = xmlInstConfigHelper.GetNode("OverrideGroup", "Name", "HighMassMode");
            highMassNode.Add(new XElement("Parameter", new XAttribute("Name", "Reservoir"), new XAttribute("Value", "0.0")));
            xmlInstConfigHelper.Save();
        }

        [AfterFeature("InstrumentSetupAcquisition", "InstrumentSetup")]
        public static void AfterFeature()
        {
            try
            {
                // Update the InstrumentSetupConfiguration.xml and undo changes for Positive.Sensitivity.4000 to use vial A 
                XmlManager xmlInstConfigHelper = new XmlManager(configPath + "InstrumentSetupConfiguration.xml");
                var highMassNode = xmlInstConfigHelper.GetNode("OverrideGroup", "Name", "HighMassMode");
                var reservoirNode = xmlInstConfigHelper.GetNode(highMassNode.Descendants(), "Parameter", "Name", "Reservoir");
                reservoirNode.Remove();
                xmlInstConfigHelper.Save();
            }
            catch (Exception)
            {
                Report.Warn("Unable to revert changes to InstrumentSetupConfiguration.xml");
            }
        }


        [BeforeScenario("InstrumentSetup")]
        public void BeforeScenario()
        {
            if (FeatureContext.Current.Get<bool>("SkipInstrumentSetup") == true)
                Report.Fail("SKIPPING TEST - Instrument Setup is failing in other scenarios in this feature.");
        }

        [AfterScenario("InstrumentSetup")]
        public void AfterScenario()
        {
            Report.Action("Start of feature After Scenario");

            if (!AutomationDriver.Driver.Url.Contains("instrumentSetup"))
            {
                NavigationMenu.InstrumentSetupAnchor.Click();
            }
           
            _instrumentSetupPage.StopInstrumentSetup();

            List<string> tags = new List<string>(ScenarioContext.Current.ScenarioInfo.Tags);

            if (tags.Contains("@cleanup-xml"))
            {
                // Revert change to typhoon calibration configuration
                typhoonConfigurationHelper.SetCalibrationAcceptanceCriteria("1.0");
            }

            // Deselect all slots to ensure no conflicts between scenarios 
            _instrumentSetupPage.DeselectAllSlots();

            //TODO : Reset should not set values using the KVS directly.
            Report.Action("Reset the Mass Calibration slot results");
            TyphoonHelper.ResetSlotRunStates(_instrumentSetupPage.MassCalibrationSlots);

            if (ScenarioContext.Current.TestError != null)
            {
                ServiceHelper.RestartTyphoonAndQuartz(false);
            }

            Report.Action("End of feature After Scenario");
        }


        [Given(@"the instrument has a beam")]
        public void GivenTheInstrumentHasABeam()
        {
            if (!TyphoonHelper.SimulatedInstrument)
            {
                // Only need to configure a beam once per feature
                if (FeatureContext.Current.Get<bool>("ConfigureBeamComplete") == false)
                {
                    NavigationMenu.TuneAnchor.Click();
                    tunePage.Controls.MZButton.Click();

                    TunePage.Tuning.WithScreenShots(numberOfScreenShots: 5, intervalInSeconds: 5).StartTuning();

                    TunePage.FluidicsSetup.SelectFluidicsTab();
                    TunePage.FluidicsSetup.StartReferenceInfusion();

                    // Take 12 screenshot at interval of 5 secs
                    for (int i = 0; i < 12; i++)
                    {
                        Wait.ForMilliseconds(5000);
                        Report.Screenshot();
                    }

                    tunePage.Controls.BPIButton.Click();
                    
                    // Take 6 screenshot at interval of 5 secs
                    for (int i = 0; i < 6; i++)
                    {
                        Wait.ForMilliseconds(5000);
                        Report.Screenshot();
                    }

                    TunePage.FluidicsSetup.StopReferenceInfusion();
                    TunePage.Tuning.AbortTuning();

                    FeatureContext.Current["ConfigureBeamComplete"] = true;
                }
            }
        }


        [Given(@"the Instrument Setup page is accessed")]
        public void GivenTheInstrumentSetupPageIsAccessed()
        {
            NavigationMenu.InstrumentSetupAnchor.Click();
        }

        [Given(@"Instrument Setup Calibration has been run successfully for the following '(.*)' slots")]
        public void GivenInstrumentSetupCalibrationHasBeenRunSuccessfullyForTheFollowingSlots(string slotToRun, TechTalk.SpecFlow.Table table)
        {
            if (FeatureContext.Current.Get<bool>("InstrumentSetupCalibrationComplete"))
            {
                return;
            }
                
            Report.Action("Initially ensure all slots are OFF");
            _instrumentSetupPage.DeselectAllSlots();

            CalibratedSlots = table;

            NavigationMenu.InstrumentSetupAnchor.Click();

            List<Slot> calibrationSlotsToRun = new List<Slot>();

            foreach (var row in table.Rows)
            {
                var mass = row["Mass"];
                var posRes = row["POS RES"];
                var negRes = row["NEG RES"];
                var posSens = row["POS SENS"];
                var negSens = row["NEG SENS"];

                if (posRes == slotToRun)
                    calibrationSlotsToRun.Add(_instrumentSetupPage.FindSlot(mass, "Positive Resolution"));

                if (negRes == slotToRun)
                    calibrationSlotsToRun.Add(_instrumentSetupPage.FindSlot(mass, "Negative Resolution"));

                if (posSens == slotToRun)
                    calibrationSlotsToRun.Add(_instrumentSetupPage.FindSlot(mass, "Positive Sensitivity"));

                if (negSens == slotToRun)
                    calibrationSlotsToRun.Add(_instrumentSetupPage.FindSlot(mass, "Negative Sensitivity"));                       
            }

            _instrumentSetupPage.RunSlots(calibrationSlotsToRun, 4000, true);
            
            FeatureContext.Current["InstrumentSetupCalibrationComplete"] = true;
   
        }

        [Given(@"a baseline MS Method acquisition has been run to determine / record the calibration polynomials for each '(.*)' slot")]
        public void GivenAMSMethodAcquisitionHasBeenRunToDetermineRecordTheCalibrationPolynomialsForEachSlot(string slot)
        {           
            // Copy xml file to the method directory
            string methodPath =  TyphoonHelper.MethodsDirectory + "\\ms_InstrumentSetupTest.xml";
            string xmlDataPath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), @"Data\ms_InstrumentSetupTest.xml");
            File.Copy(xmlDataPath, methodPath, true);

            XmlManager xmlHelper = new XmlManager(methodPath);

            NavigationMenu.TuneAnchor.Click();

            foreach (var row in CalibratedSlots.Rows)
            {
                string mass = row["Mass"];

                foreach (var columnValue in row.Keys)
                {
                    string fileNamePrefix = "";
                    string endMass = mass.Replace("Mass Calibration", "").Trim();

                    if (row[columnValue] == "X")
                    {
                        if (columnValue == "POS RES")
                        {
                            tunePage.SwitchConfiguration("Resolution", "Positive");
                            fileNamePrefix = "PosRes";
                        }
                        else if (columnValue == "NEG RES")
                        {
                            tunePage.SwitchConfiguration("Resolution", "Negative");
                            fileNamePrefix = "NegRes";
                        }
                        else if (columnValue == "POS SENS")
                        {
                            tunePage.SwitchConfiguration("Sensitivity", "Positive");
                            fileNamePrefix = "PosSens";
                        }
                        else if (columnValue == "NEG SENS")
                        {
                            tunePage.SwitchConfiguration("Sensitivity", "Negative");
                            fileNamePrefix = "NegSens";
                        }

                        string fileName = fileNamePrefix + endMass + "_" + DateTime.Now.ToString("dd_MMM_HHmmss");

                        // update end mass in xml file
                        var endMassNode = xmlHelper.GetNode("Setting", "Name", "EndMass");
                        endMassNode.SetAttributeValue("Value", endMass);
                        xmlHelper.Save();

                        // run xml file and record acquisition
                        tunePage.SelectTuningMethod("ms_InstrumentSetupTest.xml");

                        // record acquisition
                        Wait.ForMilliseconds(2000);
                        TunePage.Tuning.RecordAndSaveAcquisition(5000, fileName);

                        TunePage.Tuning.AbortTuning();

                        // Examine the RAW file to find polynomials            
                        polynomials.Add(fileNamePrefix + endMass, TunePage.Tuning.GetPolynomials(fileName));
                    }
                }
            }
        }

        [Then(@"the acquisition has had the calibration applied for mass (.*), polarity (.*) and mode (.*)")]
        public void ThenTheAcquisitionHasHadTheCalibrationAppliedForMassPolarityAndMode(string mass, string polarity, string opticMode)
        {
            ValidateAcquiredData.CheckCalibrationApplied(_acquisitionData.CurrentAcquiredData.Scans, mass, polarity, opticMode);

        }

        [Then(@"the acquisition has had the calibration applied to all '(.*)' functions of mass '(.*)', polarity '(.*)' and mode '(.*)'")]
        public void ThenTheAcquisitionHasHadTheCalibrationAppliedToAllFunctionsOfMassPolarityAndMode(int functions, string mass, string polarity, string opticMode)
        {
            ValidateAcquiredData.CheckCalibrationAppliedToEachFunction(_acquisitionData.CurrentAcquiredData.Scans, functions, mass, polarity, opticMode);
        }

        [Then(@"no calibration has been applied to all '(.*)' functions")]
        public void ThenNoCalibrationHasBeenAppliedToAllFunctions(int functions)
        {
            ValidateAcquiredData.CheckNoCalibrationAppliedToEachFunction(_acquisitionData.CurrentAcquiredData.Scans, functions);
        }

        [When(@"the instrument setup '(.*)' button is clicked")]
        public void WhenTheInstrumentSetupButtonIsClicked(string button)
        {
            switch (button)
            {
                case "Select All":
                    _instrumentSetupPage.Controls.SelectAllButton.Click();
                    break;
                case "Select None":
                    _instrumentSetupPage.Controls.SelectNoneButton.Click();
                    break;
                case "Reset":
                    _instrumentSetupPage.Controls.ResetButton.Click();
                    DialogConfirmationModal.ClickYesAndClose();
                    break;
                default:
                    throw new NotImplementedException("Button not implemented");
            }
        }


        [Then(@"all Resolution Optimisation and Calibration slots are not selected")]
        public void ThenAllResolutionOptimisationAndCalibrationSlotsAreNotSelected()
        {
            foreach (var slot in _instrumentSetupPage.OptimisationAndCalibrationSlots)
            {
                slot.CheckSelectedState(false, true, 10000);
            }
        }

        [Given(@"all slots are selected")]
        public void GivenAllSlotsAreSelected()
        {
            _instrumentSetupPage.SelectAllSlots();
        }


        [Given(@"all slots are OFF")]
        public void GivenAllSlotsAreOFF()
        {
            _instrumentSetupPage.DeselectAllSlots();
        }

        [Given(@"calibration acceptance criteria has been modified to simulate a failure")]
        public void GivenCalibrationAcceptanceCriteriaHasBeenModifiedToSimulateAFailure()
        {
            typhoonConfigurationHelper.ForceCalibrationToFail();
        }

        [Given(@"'(.*)' mass calibration slots are selected and run")]
        public void GivenMassCalibrationSlotsAreSelectedAndRun(int numberOfSlots)
        {
            _instrumentSetupPage.DeselectAllSlots();

            List<Slot> activatedSlots = new List<Slot>();

            for (int i = 0; i < numberOfSlots; i++)
            {
                activatedSlots.Add(_instrumentSetupPage.FindSlotById(_instrumentSetupConfig.MassCalibrationSlots[0].AutomationId));
            }

            activatedSlots.ForEach(s => s.Activate());

            _instrumentSetupPage.StartInstrumentSetup();
            _instrumentSetupPage.WaitForInstrumentSetupToFinish(expectedSlotCompletionTimeInSeconds * numberOfSlots);  
        }

        [Given(@"'(.*)' mass calibration slots are selected")]
        public void GivenMassCalibrationSlotsAreSelected(int numberOfSlots)
        {
            _instrumentSetupPage.DeselectAllSlots();

            List<Slot> activatedSlots = new List<Slot>();

            for (int i = 0; i < numberOfSlots; i++)
            {
                activatedSlots.Add(_instrumentSetupPage.FindSlotById(_instrumentSetupConfig.MassCalibrationSlots[0].AutomationId));
            }

            activatedSlots.ForEach(s => s.Activate());
        }

        [When(@"instrument setup process is '(.*)'")]
        public void WhenInstrumentSetupProcessIs(string state)
        {
            switch (state.ToLower())
            {
                case "started":
                    _instrumentSetupPage.StartInstrumentSetup();
                    break;
                case "stopped":
                    _instrumentSetupPage.StopInstrumentSetup();
                    break;
                default:
                    throw new NotImplementedException("Instrument setup state not implemented: " + state);
            }  
        }

        [Then(@"the activated mass calibration slots have a run state of '(.*)'")]
        public void ThenTheActivatedMassCalibrationSlotsHaveARunStateOf(string expectedState)
        {
            var activatedSlots = _instrumentSetupPage.MassCalibrationSlots.Where(s => s.SlotState.Equals("Active")).ToList();
            activatedSlots.ForEach(s => s.CheckSlotRunStatus(expectedState));
        }

        [Given(@"'(.*)' ADC setup slots are selected and run")]
        public void GivenAdcSetupSlotsAreSelectedAndRun(int slots)
        {
            _instrumentSetupPage.DeselectAllSlots();
            
            if (_instrumentSetupConfig.AdcSetup)
            {
                if (slots > _instrumentSetupConfig.AdcSlots.Count)
                    Report.Fail(string.Format("ADC Setup does not support '{0}' number of slots", slots));

                for (int i = 0; i < slots; i++)
                {
                    _instrumentSetupPage.AdcSlots[i].Activate();
                }
            }
            else
            {
                Report.Fail("Instrument does not support ADC slots");
            }
        }

        [Given(@"an instrument state of (.*)")]
        public void GivenAnInstrumentStateOfRunning(string instrumentState)
        {
            if (instrumentState == InstrumentSetupPage.InstrumentSetupState.Running.ToString())
            {
                _instrumentSetupPage.StartInstrumentSetup();
            }
            else if (instrumentState == InstrumentSetupPage.InstrumentSetupState.Aborted.ToString())
            {
                _instrumentSetupPage.StartInstrumentSetup();
                _instrumentSetupPage.StopInstrumentSetup();
            }
            else if (instrumentState == InstrumentSetupPage.InstrumentSetupState.Completed.ToString())
            {
                _instrumentSetupPage.StartInstrumentSetup();
                _instrumentSetupPage.WaitForInstrumentSetupToFinish(expectedSlotCompletionTimeInSeconds * _instrumentSetupPage.AllSelectedSlots.Count);
            }
            else
            {
                Report.Fail("Instrument state not implemented.");
            }
        }

        [Then(@"the Instrument Setup '(.*)' button should be '(.*)'")]
        public void ThenTheButtonShouldBe(string buttonText, string state)
        {
            Report.Action(string.Format("Check the '{0}' button is '{1}'", buttonText, state));
            Button button = _instrumentSetupPage.FindButtonByText(buttonText);

            switch (buttonText)
            {
                case "Run":
                    button = _instrumentSetupPage.Controls.RunButton;
                    break;
                case "Cancel":
                    button = _instrumentSetupPage.Controls.CancelButton;
                    break;
                default:
                    Report.Fail("Button not implemented.");
                    break;
            }

            button.CheckEnabledState(state, true, 1000);
        }

        [Given(@"that the Instrument Setup process has not been run")]
        public void GivenThatTheInstrumentSetupProcessHasNotBeenRun()
        {
            ServiceHelper.RestartTyphoonAndQuartz(true);
            NavigationMenu.InstrumentSetupAnchor.Click();
        }

        [Given(@"ADC Setup, Instrument Setup Detector Setup and Resolution Optimisation has been run for all modes")]
        public void GivenInstrumentSetupDetectorSetupAndResolutionOptimisationHasBeenRunForAllModes()
        {
            if (ScenarioContext.Current.ScenarioInfo.Tags.Contains("SkipDetectorSetup"))
                return;

            if (FeatureContext.Current.Get<bool>("DetectorSetupAndResOpComplete"))
                return;

            _instrumentSetupPage.DeselectAllSlots();

            bool adcSlotsSuccessful = false;
            bool detectorSetupSlotsSuccessful = false;
            bool resOptSlotsSuccessful = false;

            adcSlotsSuccessful = _instrumentSetupPage.RunADCSlots(false);

            if (adcSlotsSuccessful)
            {
                detectorSetupSlotsSuccessful = _instrumentSetupPage.RunDetectorSetupSlots(true);

                if (detectorSetupSlotsSuccessful)
                {
                    resOptSlotsSuccessful = _instrumentSetupPage.RunResolutionOptimisationSlots(true);
                }
            }

            if (!adcSlotsSuccessful || !detectorSetupSlotsSuccessful || !resOptSlotsSuccessful)
            {
                Report.Note("One or more slots failed");
                _instrumentSetupPage.Controls.LogMessages.Text.Split('\r').ToList().ForEach(line => Report.Note(line));

                FeatureContext.Current["SkipInstrumentSetup"] = true;
            }

            FeatureContext.Current["DetectorSetupAndResOpComplete"] = true;
        }

        [Given(@"all slots are in a '(.*)' status")]
        public void GivenAllSlotsAreInAStatus(string status)
        {
            switch (status)
            {
                case "Not Run":
                    _instrumentSetupPage.ResetInstrumentSetup();
                    break;
                default:
                    Report.Fail("Status not implemented: " + status);
                    break;
            }
        }

        [Given(@"the Instrument Setup process is not running")]
        public void GivenTheInstrumentSetupProcessIsNotRunning()
        {
            _instrumentSetupPage.StopInstrumentSetup();
        }

        [Then(@"the progress bar should be (.*)")]
        public void ThenTheProgressBarShouldBe(string state)
        {
            var progressBar = _instrumentSetupPage.Controls.ProgressBar;

            switch (state)
            {
                case "Progressing left to right":
                    progressBar.CheckIsIncrementing();
                    break;
                case "Progress frozen at Aborted state":
                    _instrumentSetupPage.CheckInstrumentSetupAborted();
                    break;
                case "Full":
                    _instrumentSetupPage.CheckProgressBarComplete();
                    break;
                case "Blank":
                    Check.IsTrue(() => progressBar.Element.GetCssValue("width") == "0px", "Progress Bar is empty and has never been run", false, 2000);
                    break;
                default:
                    Report.Fail("Progress bar state not implemented.");
                    break;
            }
        }

        [Then(@"the progress message will be (.*)")]
        public void ThenTheProgressMessageWillBe(string message)
        {
            var runningMessage = _instrumentSetupPage.Controls.RunningMessage;

            if (message == "Running selected tests, x% complete")
            {
                Check.IsTrue(runningMessage.Contains("Running selected tests") && runningMessage.Contains("% complete"), "Progress message is as expected: " + message);
            }
            else
            {
                Check.AreEqual(message, runningMessage, "Progress Message is as expected");
            }                
        }

        [Then(@"the issue message will be (.*)")]
        public void ThenTheIssueMessageWillBe(string message)
        {
            var issueMessage = _instrumentSetupPage.Controls.IssueMessage;

            if (message != "na")
            {
                var timeStamp = DateTime.Today.ToString("ddd-MMM-dd-yyyy");
                timeStamp = timeStamp.Replace("-", " ");
                var expectedMessage = message.Replace("ddd-MMM-dd-yyyy", timeStamp);

                Check.AreEqual(expectedMessage, issueMessage, "Progress Message is as expected: " + expectedMessage);
            }    
        }

        [Then(@"the progress message should be '(.*)'")]
        public void ThenTheProgressMessageShouldBe(string message)
        {
            Check.AreEqual(message, () => _instrumentSetupPage.Controls.IssueMessage, string.Format("Issue message is '{0}'", message), false, 40000);
        }

        [Then(@"the following Instrument Setup buttons are in the expected state")]
        public void ThenTheFollowingInstrumentSetupButtonsAreInTheExpectedState(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                var expectedState = row["Expected State"];

                switch (row["Button"])
                {
                    case "Run":
                        _instrumentSetupPage.Controls.RunButton.CheckEnabledState(expectedState, true);
                        break;
                    case "Cancel":
                        _instrumentSetupPage.Controls.CancelButton.CheckEnabledState(expectedState, true);
                        break;
                    case "Select All":
                        _instrumentSetupPage.Controls.SelectAllButton.CheckEnabledState(expectedState, true);
                        break;
                    case "Select None":
                        _instrumentSetupPage.Controls.SelectNoneButton.CheckEnabledState(expectedState, true);
                        break;
                    default:
                        Report.Fail("Button no implemented");
                        break;
                }
            }
        }

        [Then(@"all slots are in the correct selected state")]
        public void ThenAllSlotsAreInTheCorrectSelectedState()
        {
            foreach (var configSlot in _instrumentSetupConfig.AllSlots)
            {
                var slot = _instrumentSetupPage.FindSlotById(configSlot.AutomationId);
                slot.CheckSelectedState(configSlot.Selected,timeAllowanceForConditionInMilliseconds: 10000);
            }
        }

    }
}
