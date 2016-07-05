using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using Quartz.Support;
using Quartz.Support.Views;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using TechTalk.SpecFlow;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;

namespace Quartz.Support.InstrumentSetup.StepDefinitions
{
    [Binding]
    public class QRZ_InsrumentSetupSteps
    {
        private static string configPath = string.Concat(ServiceHelper.GetTyphoonBinFolder(), ConfigurationManager.AppSettings["TyphoonConfigPath"]);

        XmlFileHelper xmlHelper = new XmlFileHelper(configPath + "CalibrationProcessingCriteria.xml");

        InstrumentSetupPage instrumentSetupPage = new InstrumentSetupPage();
        List<Switch> SwitchesOfInterest = new List<Switch>();

        [AfterScenario("InstrumentSetup")]
        public void AfterScenario()
        {
            SwitchesOfInterest.Clear();

            instrumentSetupPage.StopInstrumentSetup();

            List<string> tags = new List<string>(ScenarioContext.Current.ScenarioInfo.Tags);

            if (tags.Contains("cleanup-06"))
            {
                // Update config file to simulate a failure                  
                var node = xmlHelper.GetNode("AcceptanceCriterion", "name", "MeanPredictionErrorLimit");
                node.SetAttributeValue("max", "1.0");
                xmlHelper.Save();
            }

            // Turn all toggles ensure no conflicts between scenarios 
            instrumentSetupPage.ToggleAllSwitchesOff();
        }

        [Given(@"the Instrument Setup page is accessed")]
        public void GivenTheInstrumentSetupPageIsAccessed()
        {
            NavigationMenu.InstrumentSetupAnchor.Click();
        }

        [When(@"the polarity (.*) switch is set to '(.*)'")]
        public void WhenTheSwitchIsSetTo(string switchName, string switchState)
        {
            var toggleSwitch = instrumentSetupPage.GetPolaritySwitch(switchName);

            if (toggleSwitch != null)
            {
                if (switchState.ToLower() == "on")
                    toggleSwitch.ToggleOn();
                else
                    toggleSwitch.ToggleOff();
            }

            Wait.ForMilliseconds(2000, "Wait for related toggles states to change");
        }

        [Given(@"all toggles are set to OFF")]
        public void GivenAllTogglesAreSetToOFF()
        {
            instrumentSetupPage.ToggleAllSwitchesOff();
        }

        [Then(@"the following (.*) switches are '(.*)'")]
        public void ThenTheFollowingSwitchesAre(string polarity, string switchState, TechTalk.SpecFlow.Table table)
        {
            Report.Action(string.Format("Check the following '{0}' switches are '{1}'", polarity, switchState)); 
            foreach (var row in table.Rows)
            {
                var toggle = row["Switch"];

                var toggleSwitch = instrumentSetupPage.FindSwitch(toggle, polarity);
                SwitchesOfInterest.Add(toggleSwitch);

                Check.AreEqual(switchState, toggleSwitch.ToggleState, string.Format("The '{0}' switch state is as expected", toggle));
            }
        }


        [Then(@"the expected switches are '(.*)'")]
        public void ThenTheSwitchesAre(string switchState)
        {
            Report.Action(string.Format("Check the following switches are '{0}'", switchState)); 

            foreach (var toggle in SwitchesOfInterest)
            {
                Check.AreEqual(switchState, toggle.ToggleState, string.Format("The '{0}' switch is in the expected state", toggle.AutomationId));
            }
        }

        [Given(@"an instrument state of (.*)")]
        public void GivenAnInstrumentStateOfRunning(string instrumentState)
        {
            Report.Action("Initially ensure all slots are OFF");
            instrumentSetupPage.ToggleAllSwitchesOff();

            if (instrumentState == "Completed - 1 Slot Failed") // turn 1 toggle on only
            {
                Report.Action("Set Mass Calibration 600 (Negative Sensitivity) to On");
                instrumentSetupPage.Controls.NegativeSensitivity_600.ToggleOn();
            }
            else // turn two toggles on
            {
                Report.Action("Set Mass Calibration 5000 (Positive Resolution) to On");
                instrumentSetupPage.Controls.PositiveResolution_5000.ToggleOn();
                Report.Action("Set Mass Calibration 600 (Negative Sensitivity) to On");
                instrumentSetupPage.Controls.NegativeSensitivity_600.ToggleOn();
            }

            switch (instrumentState)
            {
                case "Running":
                    instrumentSetupPage.StartInstrumentSetup();
                    break;
                case "Aborted":
                    instrumentSetupPage.StartInstrumentSetup();
                    Wait.ForMilliseconds(2000);
                    instrumentSetupPage.Controls.CancelButton.Click();
                    break;
                case "Completed":
                    instrumentSetupPage.StartInstrumentSetup();
                    instrumentSetupPage.WaitForInstrumentSetupToFinish(180);
                    break;
                case "Completed - 1 Slot Failed":
                    // Update config file to simulate a failure                  
                    ModifyCalibrationAcceptanceCriteriaToSimulateFailure();

                    instrumentSetupPage.StartInstrumentSetup();
                    instrumentSetupPage.WaitForInstrumentSetupToFinish(240);
                    instrumentSetupPage.CheckSlotsFailed();
                    break;
                case "Completed - 2 Slots Failed":
                    // Update config file to simulate a failure                  
                    ModifyCalibrationAcceptanceCriteriaToSimulateFailure();

                    instrumentSetupPage.StartInstrumentSetup();
                    instrumentSetupPage.WaitForInstrumentSetupToFinish(300);
                    instrumentSetupPage.CheckSlotsFailed(2);
                    break;
                default:
                    Report.Fail("Instrument state not implemented.");
                    break;
            }
        }

        [Then(@"the Instrument Setup '(.*)' button should be '(.*)'")]
        public void ThenTheButtonShouldBe(string buttonText, string state)
        {
            Report.Action(string.Format("Check the '{0}' button is '{1}'", buttonText, state));
            Button button = instrumentSetupPage.FindButtonByText(buttonText);

            switch (buttonText)
            {
                case "Run":
                    button = instrumentSetupPage.Controls.RunButton;
                    break;
                case "Cancel":
                    button = instrumentSetupPage.Controls.CancelButton;
                    break;
                default:
                    Report.Fail("Button not implemented.");
                    break;
            }

            button.CheckEnabledState(state, true);
        }

        [Given(@"that the Instrument Setup process has not been run")]
        public void GivenThatTheInstrumentSetupProcessHasNotBeenRun()
        {
            instrumentSetupPage.ResetInstrumentSetup();
        }

        [Given(@"all slots are in a '(.*)' status")]
        public void GivenAllSlotsAreInAStatus(string status)
        {
            // Ensure all slots are in the expected state
            Check.IsTrue(instrumentSetupPage.AllSlotRunStates.TrueForAll( f => f.Equals(status)), string.Format("All slots have a status of {0}", status));
        }

        [Given(@"the Instrument Setup process is not running")]
        public void GivenTheInstrumentSetupProcessIsNotRunning()
        {
            instrumentSetupPage.StopInstrumentSetup();
            Check.IsFalse(instrumentSetupPage.IsRunning, "The instrument setup process is NOT running");
        }

        [Then(@"the progress bar should be (.*)")]
        public void ThenTheProgressBarShouldBe(string state)
        {
            var progressBar = instrumentSetupPage.Controls.ProgressBar;

            switch (state)
            {
                case "Progressing left to right":
                    progressBar.CheckIsIncrementing();
                    break;
                case "Progress frozen at Aborted state":
                    instrumentSetupPage.CheckInstrumentSetupAborted();
                    break;
                case "Full":
                    instrumentSetupPage.CheckProgressBarComplete();
                    break;
                case "Blank":
                    Check.IsTrue(progressBar.Bar.GetCssValue("width") == "0px", "Progress Bar is empty and has never been run");
                    break;
                default:
                    Report.Fail("Progress bar state not implemented.");
                    break;
            }
        }
       

        [Then(@"the progress message should be '(.*)'")]
        public void ThenTheProgressMessageShouldBe(string message)
        {
            Check.AreEqual(message, instrumentSetupPage.Controls.IssueMessage.Text, string.Format("Issue message is '{0}'", message));
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
                        instrumentSetupPage.Controls.RunButton.CheckEnabledState(expectedState, true);
                        break;
                    case "Cancel":
                        instrumentSetupPage.Controls.CancelButton.CheckEnabledState(expectedState, true);
                        break;
                    default:
                        Report.Fail("Button no implemented");
                        break;
                }
            }
        }

        [Then(@"the following polarity switches are in the expected state")]
        public void ThenTheFollowingPolaritySwitchesAreInTheExpectedState(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                var expectedState = row["Expected State"];
                Switch polaritySwitch = instrumentSetupPage.GetPolaritySwitch(row["Polarity Switch"]);

                polaritySwitch.CheckToggleState(expectedState, true);
            }
        }

        [Then(@"the following switches are in the expected state")]
        public void ThenTheFollowingSwitchesAreInTheExpectedState(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                var expectedState = row["Expected State"];

                Switch toggle = instrumentSetupPage.FindSwitch(row["Switch"], row["Switch Polarity"]);

                toggle.CheckToggleState(expectedState, true);
            }
        }


        #region Helper Methods

        private void ModifyCalibrationAcceptanceCriteriaToSimulateFailure()
        {
            Report.Action("Update CalibrationProcessingCriteria.xml, set MeanPredictionErrorLimit to '0.0'");
            var node = xmlHelper.GetNode("AcceptanceCriterion", "name", "MeanPredictionErrorLimit");
            node.SetAttributeValue("max", "0.0");
            xmlHelper.Save();
            Report.Debug("Update to MeanPredictionErrorLimit saved");
        }

        #endregion Helper Methods


    }
}
