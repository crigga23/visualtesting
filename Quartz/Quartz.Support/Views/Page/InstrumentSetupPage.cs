using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Automation.Config.Lib.ConfigHelpers;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.Configuration;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.Modals;

namespace Quartz.Support.Views.Page
{
    public class InstrumentSetupPage : Page
    {
        public enum InstrumentSetupState { Running, Aborted, Completed }

        #region Properties

        private InstrumentSetupConfig _instrumentSetupConfig;

        public InstrumentSetupPageControls Controls { get; set; }

        public List<Slot> MassCalibrationSlots
        {
            get
            {
                List<Slot> slots = new List<Slot>();

                foreach (var slot in _instrumentSetupConfig.MassCalibrationSlots)
                {
                    slots.Add(FindSlotById(slot.AutomationId));
                }

                return slots;
            }
        }

        public List<Slot> AdcSlots
        {
            get
            {
                List<Slot> slots = new List<Slot>();

                foreach (var slot in _instrumentSetupConfig.AdcSlots)
                {
                    slots.Add(FindSlotById(slot.AutomationId));
                }

                return slots;
            }
        }

        public List<Slot> DetectorSetupSlots
        {
            get
            {
                List<Slot> slots = new List<Slot>();

                foreach (var slot in _instrumentSetupConfig.DetectorSetupSlots)
                {
                    slots.Add(FindSlotById(slot.AutomationId));
                }

                return slots;
            }
        }

        public List<Slot> ResolutionOptimisationSlots
        {
            get
            {
                List<Slot> slots = new List<Slot>();

                foreach (var slot in _instrumentSetupConfig.ResolutionOptimisationSlots)
                {
                    slots.Add(FindSlotById(slot.AutomationId));
                }

                return slots;
            }
        }

        public List<Slot> CcsCalibrationSlots
        {
            get
            {
                List<Slot> slots = new List<Slot>();

                foreach (var slot in _instrumentSetupConfig.CcsCalibrationSlots)
                {
                    slots.Add(FindSlotById(slot.AutomationId));
                }

                return slots;
            }
        }

        public List<Slot> AllSlots
        {
            get
            {
                List<Slot> slots = new List<Slot>();
                var elements = Driver.FindElements(By.XPath("//input[contains(@ng-click, 'megaToggleChange()')]")).ToList();
                elements.ForEach(e => slots.Add(new Slot(e)));

                return slots;
            }
        }

        public List<Slot> OptimisationAndCalibrationSlots
        {
            get
            {
                List<Slot> slots = new List<Slot>();
                var elements = Controls.OptimisationAndCalibrationPanel.Element.FindElements(By.TagName("input")).ToList();
                elements.ForEach(e => slots.Add(new Slot(e)));

                return slots;
            }
        }

        public List<Slot> AllSelectedSlots
        {
            get
            {
                var elements = AutomationDriver.Driver.FindElements(By.XPath("//input[contains(@ng-click, 'megaToggleChange()') and contains(@checked, 'checked')]")).ToList();

                var slots = new List<Slot>();
                foreach (var element in elements)
                {
                    slots.Add(new Slot(element));
                }

                return slots;
            }
        }

        public List<Slot> VisibleSelectedSlots
        {
            get
            {
                return AllSelectedSlots.Where(element => element.Element.GetAttribute("class").Contains("ng-hide") == false).ToList<Slot>();
            }
        }

        public List<Slot> UnselectedSlots
        {
            get
            {
                List<Slot> slots = new List<Slot>();
                var elements = Driver.FindElements(By.XPath("//input[contains(@ng-click, 'megaToggleChange()') and not(@checked, 'checked')]")).ToList();
                elements.ForEach(e => slots.Add(new Slot(e)));

                return slots;
            }
        }

        public List<string> AllSlotRunStates
        {
            get
            {
                var states = new List<string>();
                AllSlots.ForEach(s => states.Add(s.RunState));
                return states;
            }
        }

        public bool SlotsAlreadyRun
        {
            get
            {
                var runSlots = AllSlotRunStates.Where(s => s != "Not Run").ToList();
                return runSlots.Count > 0 ;
            }
        }

        public List<Slot> FailedSlots
        {
            get
            {
                var failedSlots = AllSelectedSlots.Where(s => s.RunState == "Failed").ToList<Slot>();
                return failedSlots;
            }
        }

        public bool IsRunning
        {
            get
            {
                return !Controls.RunButton.Enabled;
            }
        }

        #endregion Properties

        public InstrumentSetupPage()
        {
            Controls = new InstrumentSetupPageControls(this);
            _instrumentSetupConfig = new InstrumentSetupConfig(new TestConfiguration(new AppSettingsConfigurationManager()).Instrument);
        }


        #region Methods

        public bool RunResolutionOptimisationSlots(bool superSpeed = false)
        {
            Report.Action("Run the Resolution Optimisation slots");
            return RunSlots(ResolutionOptimisationSlots, 1000, superSpeed);
        }

        public bool RunDetectorSetupSlots(bool superSpeed = false)
        {
            Report.Action("Run the Detector Setup slots");
            return RunSlots(DetectorSetupSlots, 1000, superSpeed);
        }

        public bool RunADCSlots(bool superSpeed = false)
        {
            Report.Action("Run the ADC slots");
            return RunSlots(AdcSlots, 600, superSpeed);
        }

        public bool RunSlots(List<Slot> slots, int timeoutInSeconds, bool superSpeed = false)
        {
            int slotsAlreadyRun = 0;

            foreach (var slot in slots)
            {
                var runState = slot.RunState;

                if (runState == "Not Run")
                {
                    Wait.Until(s => !slot.Hidden, 60000, string.Format("Waiting for {0} slot to be rendered on the UI.", slot.AutomationId));
                    slot.Activate();
                }
                else if (runState == "Success")
                {
                    Report.Warn(slot.AutomationId + " already has a SUCCESS state. This slot will not be run.");
                    slotsAlreadyRun++;
                }
                else
                {
                    Report.Warn(slot.AutomationId + " has already been run with a state of ABORTED, FAILED or ERROR. Re-running this slot...");
                    Wait.Until(s => !slot.Hidden, 60000, string.Format("Waiting for {0} slot to be rendered on the UI.", slot.AutomationId));
                    slot.Activate();
                }
            }

            Check.AreEqual(slots.Count - slotsAlreadyRun, () => AllSelectedSlots.Count, string.Format("Expected: {0} slots selected. Actual: {1} slots selected. {2} slots already run", slots.Count, AllSelectedSlots.Count, slotsAlreadyRun), false, 15000);

            if (AllSelectedSlots.Count > 0)
            {
                StartInstrumentSetup(superSpeed);
                WaitForInstrumentSetupToFinish(timeoutInSeconds);

                bool slotFailures = true;

                if (slots.Where(slot => slot.RunState != "Success").Count() > 0)
                    slotFailures = false;

                CheckSlotStates(slots, "Success");

                // Toggle slots off again
                DeselectAllSlots();

                if (superSpeed)
                {
                    TyphoonHelper.DisableSuperSpeed();
                }

                return slotFailures;
            }
            else
            {
                Report.Warn("No slots were selected to run");
                return false;
            }
        }

        public void ResetInstrumentSetup()
        {
            if (SlotsAlreadyRun)
            {
                Controls.ResetButton.Click();
                DialogConfirmationModal.ClickYesAndClose();

                Check.AreEqual("Last update performed : Instrument Setup data reset by command", () => Controls.IssueMessage, "Slots are reset", false, 40000);
                Report.Screenshot();
            }
            else
            {
                Report.Debug("Slots already have status 'Not Run'. No action taken");
            }
        }

        /// <summary>
        /// Find the switch based on a label and the Polarity and Mode 
        /// </summary>
        /// <param name="label">e.g. Mass Calibration 600</param>
        /// <param name="polarityMode">e.g. Positive Resolution</param>
        /// <returns>Switch object</returns>
        public Slot FindSlot(string label, string polarityMode)
        {
            polarityMode = polarityMode.Replace("Detector Setup", "").Trim();
            polarityMode = polarityMode.Replace("CCS Calibration", "").Trim();

            // Instead of a Switch statement to define all the switches, build up the expected automation ID and search for that
            TextInfo textInfo = new CultureInfo("en-US", false).TextInfo;
            string idToLookFor = "";
            if (label.Contains("Mass Calibration"))
            {
                idToLookFor = string.Format("MassCalibration.{0}.{1}", polarityMode.Replace(" ", "."), label.Replace("Mass Calibration", "").Trim());
            }
            else if (label.StartsWith("CCS Calibration"))
            {
                idToLookFor = string.Format("CCSCalibration.{0}.{1}", polarityMode.Replace(" ", "."), label.Replace("CCS Calibration", "").Trim());
            }
            else
            {
                idToLookFor = textInfo.ToTitleCase(label).Replace(" ", "") + "." + polarityMode.Replace(" ", ".");
            }

            try
            {
                idToLookFor = idToLookFor.TrimEnd(new char[] { '.' });
                return new Slot(Driver.FindElement(By.Id(idToLookFor)));
            }
            catch (ElementNotVisibleException)
            {
                return null;
            }
        }

        public void StartInstrumentSetup(bool superSpeed = true)
        {
            if (superSpeed)
                TyphoonHelper.EnableSuperSpeed();

            Controls.RunButton.Click();
            CheckIsRunning();
        }

        public void StopInstrumentSetup()
        {
            Wait.ForMilliseconds(1000); // if start only just clicked then run states may not have refreshed 

            Report.Action("Stop Instrument Setup");

            if (IsRunning)
            { 
                Controls.CancelButton.Click();
                Check.IsFalse(() => IsRunning, "The instrument setup process is NOT running", false, 5000);
            }
            else
            {
                Report.Pass("Instrument Setup is not running. No action taken.");
            }     
        }

        public void SelectAllSlots()
        {
            Report.Action("Select all slots");

            foreach (var slot in AllSlots)
            {
                if (slot.SlotState == "Inactive")
                {
                    // Wait is required due to dependancy between slots. This is why slot.Activate() is not used.
                    Wait.Until(f => !slot.Hidden, 5000, "Waiting for slot to be visible");

                    slot.SelectCheckBox();
                }                    
            }
        }

        public void DeselectAllSlots()
        {
            if (AllSelectedSlots.Count > 0)
            {
                Controls.SelectNoneButton.Click();

                // Wait for all Mass Cal, Res Op and Css slots to be unticked
                if (_instrumentSetupConfig.CcsCalibration)
                    Wait.Until(f => CcsCalibrationSlots.TrueForAll(s => !s.Selected), 20000, "CCS Calibration slots are deselected");

                if (_instrumentSetupConfig.MassCalibration)
                    Wait.Until(f => MassCalibrationSlots.TrueForAll(s => !s.Selected), 20000, "Mass Calibration Slots are deselected");

                if (_instrumentSetupConfig.ResolutionOptimisation)
                    Wait.Until(f => ResolutionOptimisationSlots.TrueForAll(s => !s.Selected), 20000, "Resolution Calibration Slots are deselected");

                if (_instrumentSetupConfig.DetectorSetup)
                    DetectorSetupSlots.ForEach(s => s.Deactivate());           

                if (_instrumentSetupConfig.AdcSetup)
                    AdcSlots.ForEach(s => s.Deactivate());

                Check.AreEqual(0, () => AllSelectedSlots.Count, "All slots are deselected", false, 50000);
            }
            else
            {
                Report.Pass("All slots are OFF");
            }

            Report.DebugScreenshot();
        }

        public void CheckIsRunning()
        {      
            Check.IsTrue(() => IsRunning, "Instrument Setup is running", false, 10000);
            Report.Screenshot();
        }

        public void CheckProgressBarComplete()
        {
            Check.IsTrue(() => Controls.ProgressBar.PercentComplete == 100, "The progress bar is complete", false, 5000);
            Report.Screenshot();
        }

        public void CheckInstrumentSetupAborted()
        {
            CheckProgressBarComplete();
            Check.IsFalse(AllSlotRunStates.Contains("Pending") || AllSlotRunStates.Contains("Running"), "No slots are at status Running or Pending");
            Check.IsTrue(() => AllSlotRunStates.Contains("Aborted"), "1 or more slots have an aborted status", false, 2000);
            Report.Screenshot();
        }

        public void WaitForInstrumentSetupToFinish(int timeoutInSeconds)
        {
            int timeout = timeoutInSeconds * 1000;
            Wait.Until(p => Controls.RunningMessage.Contains("100% complete"), timeout, "Waiting for the instrument setup to complete");
            Report.Pass("Instrument Setup Complete");
            Report.Screenshot();
        }

        public void CheckSlotStates(List<Slot> slots, string runState)
        {
            foreach (var slot in slots)
            {
                Check.AreEqual(runState, slot.RunState, string.Format("Slot '{0}' run state is as expected", slot.AutomationId));
            }

            Report.Screenshot();
        }

        #endregion Methods

        public class InstrumentSetupPageControls
        {

            private Page parent;

            public InstrumentSetupPageControls(Page page)
            {
                parent = page;
            }

            #region Controls

            public Button ResetButton
            {
                get
                {
                    return new Button(parent.Driver.FindElement(By.Id("InstrumentSetup.Reset")));
                }
            }

            public Button SelectAllButton
            {
                get
                {
                    return new Button(parent.Driver.FindElement(By.Id("select_all_button_2")));
                }
            }

            public Button SelectNoneButton
            {
                get
                {
                    return new Button(parent.Driver.FindElement(By.Id("select_none_button_2")));
                }
            }

            public Button RunButton
            {
                get
                {
                    return new Button(parent.Driver.FindElement(By.Id("run_is_controlpanel")));
                }
            }

            public Button CancelButton
            {
                get
                {
                    return new Button(parent.Driver.FindElement(By.Id("cancel_is_controlpanel")));
                }
            }

            public string RunningMessage
            {
                get
                {
                    var div = parent.Driver.FindElement(By.XPath("//div[@ng-show='isRunning']/div"));
                    String script = "return arguments[0].innerText";
                    return (String)((IJavaScriptExecutor)parent.Driver).ExecuteScript(script, div);
                }
            }

            public string IssueMessage
            {
                get
                {

                    var div = parent.Driver.FindElement(By.XPath("//div[@ng-show='!isRunning']/div"));
                    String script = "return arguments[0].innerText";
                    return (String)((IJavaScriptExecutor)parent.Driver).ExecuteScript(script, div);
                }
            }

            public TextArea LogMessages
            {
                get
                {
                    return new TextArea(parent.Driver.FindElement(By.Id("textAreaMessages")));
                }
            }

            public ProgressBar ProgressBar
            {
                get
                {
                    return new ProgressBar(parent.Driver.FindElement(By.Id("Instrument.Setup.ProgressBar")));
                }
            }

            public Panel ProgressPanel
            {
                get
                {
                    return new Panel(parent.Driver.FindElement(By.XPath("//div[contains(@heading, 'Instrument Setup')]")));
                }
            }

            public Panel DetectorSetupQuadCCSLockCalibrationPanel
            {
                get
                {
                    return new Panel(parent.Driver.FindElement(By.XPath("//div[contains(@heading, 'Detector Setup, Quad, Lock CCS Calibration')]")));
                }
            }

            //TODO: Need to implement an automationId
            public Panel OptimisationAndCalibrationPanel
            {
                get
                {
                    return new Panel(parent.Driver.FindElement(By.XPath("//div[contains(@heading, 'Resolution Optimisation and Calibration')]")));
                }
            }

            public Slot ADCSetupPositive
            {
                get { return new Slot(parent.Driver.FindElement(By.Id("ADCSetup.Positive"))); }
            }

            public Slot ADCSetupNegative
            {
                get { return new Slot(parent.Driver.FindElement(By.Id("ADCSetup.Negative"))); }
            }

            public Slot DetectorSetupPositive
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("DetectorSetup.Positive")));
                }
            }

            public Slot DetectorSetupNegative
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("DetectorSetup.Negative")));
                }
            }

            public Slot CCSCalibrationNegativeResolution_1000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Resolution.1000")));
                }
            }

            public Slot CCSCalibrationNegativeSensitivity_1000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Sensitivity.1000")));
                }
            }

            public Slot CCSCalibrationPositiveResolution_1000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Resolution.1000")));
                }
            }

            public Slot CCSCalibrationPositiveSensitivity_1000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Sensitivity.1000")));
                }
            }


            public Slot CCSCalibrationPositiveSensitivity_2000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Sensitivity.2000")));
                }
            }

            public Slot CCSCalibrationPositiveResolution_2000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Resolution.2000")));
                }
            }

            public Slot CCSCalibrationNegativeSensitivity_2000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Sensitivity.2000")));
                }
            }

            public Slot CCSCalibrationNegativeResolution_2000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Reoslution.2000")));
                }
            }

            public Slot CCSCalibrationPositiveSensitivity_5000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Sensitivity.5000")));
                }
            }

            public Slot CCSCalibrationPositiveResolution_5000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Resolution.5000")));
                }
            }

            public Slot CCSCalibrationNegativeSensitivity_5000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Sensitivity.5000")));
                }
            }

            public Slot CCSCalibrationNegativeResolution_5000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Reoslution.5000")));
                }
            }

            public Slot CCSCalibrationPositiveSensitivity_8000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Sensitivity.8000")));
                }
            }

            public Slot CCSCalibrationPositiveResolution_8000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Resolution.8000")));
                }
            }

            public Slot CCSCalibrationNegativeSensitivity_8000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Sensitivity.8000")));
                }
            }

            public Slot CCSCalibrationNegativeResolution_8000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Reoslution.8000")));
                }
            }

            public Slot CCSCalibrationPositiveSensitivity_14000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Sensitivity.14000")));
                }
            }

            public Slot CCSCalibrationPositiveResolution_14000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Resolution.14000")));
                }
            }

            public Slot CCSCalibrationNegativeSensitivity_14000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Sensitivity.14000")));
                }
            }

            public Slot CCSCalibrationNegativeResolution_14000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Reoslution.14000")));

                }
            }

            public Slot CCSCalibrationPositiveSensitivity_32000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Sensitivity.32000")));
                }
            }

            public Slot CCSCalibrationPositiveResolution_32000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Resolution.32000")));
                }
            }

            public Slot CCSCalibrationNegativeSensitivity_32000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Sensitivity.32000")));
                }
            }

            public Slot CCSCalibrationNegativeResolution_32000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Reoslution.32000")));
                }
            }


            public Slot CCSCalibrationPositiveSensitivity_70000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Sensitivity.70000")));
                }
            }

            public Slot CCSCalibrationPositiveResolution_70000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Positive.Resolution.70000")));
                }
            }

            public Slot CCSCalibrationNegativeSensitivity_70000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Sensitivity.70000")));
                }
            }

            public Slot CCSCalibrationNegativeResolution_70000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("CCSCalibration.Negative.Reoslution.70000")));
                }
            }

            public Slot LockCCSCalibrationPositive
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("LockCCSCalibration.Positive")));
                }
            }

            public Slot LockCCSCalibrationNegative
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("LockCCSCalibration.Negative")));
                }
            }

            public Slot ResolutionOptimisation_PositiveResolution
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("ResolutionOptimisation.Positive.Resolution")));
                }
            }

            public Slot ResolutionOptimisation_NegativeResolution
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("ResolutionOptimisation.Negative.Resolution")));
                }
            }

            public Slot ResolutionOptimisation_PositiveSensitivity
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("ResolutionOptimisation.Positive.Sensitivity")));
                }
            }

            public Slot ResolutionOptimisation_NegativeSensitivity
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("ResolutionOptimisation.Negative.Sensitivity")));
                }
            }

            public Slot PositiveResolution_1000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Resolution.1000")));
                }
            }

            public Slot NegativeResolution_1000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Resolution.1000")));
                }
            }

            public Slot PositiveSensitivity_1000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Sensitivity.1000")));
                }
            }

            public Slot NegativeSensitivity_1000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Sensitivity.1000")));
                }
            }

            public Slot PositiveResolution_1200
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Resolution.1200")));
                }
            }

            public Slot NegativeResolution_1200
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Resolution.1200")));
                }
            }

            public Slot PositiveSensitivity_1200
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Sensitivity.1200")));
                }
            }

            public Slot NegativeSensitivity_1200
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Sensitivity.1200")));
                }
            }

            public Slot PositiveResolution_2000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Resolution.2000")));
                }
            }

            public Slot NegativeResolution_2000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Resolution.2000")));
                }
            }

            public Slot PositiveSensitivity_2000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Sensitivity.2000")));
                }
            }

            public Slot NegativeSensitivity_2000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Sensitivity.2000")));
                }
            }

            public Slot PositiveResolution_4000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Resolution.4000")));
                }
            }

            public Slot NegativeResolution_4000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Resolution.4000")));
                }
            }

            public Slot PositiveSensitivity_4000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Sensitivity.4000")));
                }
            }

            public Slot NegativeSensitivity_4000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Sensitivity.4000")));
                }
            }

            public Slot PositiveResolution_8000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Resolution.8000")));
                }
            }

            public Slot NegativeResolution_8000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Resolution.8000")));
                }
            }

            public Slot PositiveSensitivity_8000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Sensitivity.8000")));
                }
            }

            public Slot NegativeSensitivity_8000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Sensitivity.8000")));
                }
            }

            public Slot PositiveResolution_14000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Resolution.14000")));
                }
            }

            public Slot NegativeResolution_14000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Resolution.14000")));
                }
            }

            public Slot PositiveSensitivity_14000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Sensitivity.14000")));
                }
            }

            public Slot NegativeSensitivity_14000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Sensitivity.14000")));
                }
            }

            public Slot PositiveResolution_32000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Resolution.32000")));
                }
            }

            public Slot NegativeResolution_32000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Resolution.32000")));
                }
            }

            public Slot PositiveSensitivity_32000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Sensitivity.32000")));
                }
            }

            public Slot NegativeSensitivity_32000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Sensitivity.32000")));
                }

            }

            public Slot PositiveResolution_70000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Resolution.70000")));
                }
            }

            public Slot NegativeResolution_70000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Resolution.70000")));
                }
            }

            public Slot PositiveSensitivity_70000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Positive.Sensitivity.70000")));
                }
            }

            public Slot NegativeSensitivity_70000
            {
                get
                {
                    return new Slot(parent.Driver.FindElement(By.Id("MassCalibration.Negative.Sensitivity.70000")));
                }
            }

            #endregion Controls

        }

    }
}
