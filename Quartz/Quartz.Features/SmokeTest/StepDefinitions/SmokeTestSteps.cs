using System;
using System.Collections.Generic;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Modals;
using Quartz.Support.Views.Page;
using Quartz.Support.Views.TabViews;
using TechTalk.SpecFlow;
using Table = TechTalk.SpecFlow.Table;

namespace Quartz.Features.SmokeTest.StepDefinitions
{
    [Binding]
    public class SmokeTestSteps
    {
        private MobilityPopupPage _mobilityPage;
        private readonly TunePage _tunePage;

        public SmokeTestSteps(TunePage tunePage, MobilityPopupPage mobilityPage)
        {
            _mobilityPage = mobilityPage;
            _tunePage = tunePage;
        }

        public SmokeTestSteps(TunePage tunePage)
        {
            _tunePage = tunePage;
        }

        [AfterScenario("smoketest")]
        public void AfterScenario()
        {
            if (Modal.Exists())
            {
                Modal.Close();
            }
        }

        [Then(@"the instrument power indicator should be visible")]
        public void ThenTheInstrumentPowerIndicatorShouldBeVisible()
        {
            //Check.IsTrue(_tunePage.Controls.InstrumentPowerIndicator.Displayed, "The Instrument Power indicator is visible", true);
            ServiceHelper.CheckWindow("The Instrument Power indicator is visible");
        }

        [Then(@"the correct status should be displayed")]
        public void ThenTheCorrectStatusShouldBeDisplayed(Table table)
        {
            Dictionary<string, Action> buttonActions = new Dictionary<string, Action> 
            {
                {"Operate", _tunePage.Controls.OperateButton.Click },
                {"Source", _tunePage.Controls.SourceButton.Click },
                {"Standby", _tunePage.Controls.StandByButton.Click }
            };

            foreach (var row in table.Rows)
            {
                string instrumentPowerButtonType = row["instrument power button"];
                buttonActions[instrumentPowerButtonType]();

                ServiceHelper.CheckWindow(string.Format("instrument power button: {0}", instrumentPowerButtonType));               // REPLACE WITH CHECKREGION!!!!!
                //Check.AreEqual(row["status"], () => _tunePage.GetOperateStatus().ToLower(), "The Operate Status the correct colour", true, 5000);
            }
        }

        [StepDefinition(@"the detector voltage is set to (.*)")]
        public void WhenTheDetectorVoltageIsSetTo(int voltage)
        {
            _tunePage.ControlsWidget.InstrumentTab.Select();
            InstrumentTabView.DetectorVoltageSetting.SetValue(voltage.ToString());
            ServiceHelper.CheckWindow(string.Format("Setting detector voltage to {0}", voltage));
        }

        [StepDefinition(@"Tuning is started")]
        public void WhenTuningIsStarted()
        {
            // TODO: Grab baseline image at this point and display in report!!!!
            //Report.Screenshot();
            TunePage.Tuning.WithScreenShots(numberOfScreenShots: 5, intervalInSeconds: 2).StartTuning();
            ServiceHelper.CheckWindow("Tuning has started");
        }

        [Then(@"Sodium Formate plot is displayed and refreshes correctly")]
        public void ThenSodiumFormatePlotIsDisplayedAndRefreshesCorrectly()
        {
            Report.Action("#Actual - Are the NaF peaks available and do they match the intensity from the above baseline?");
            //Report.Screenshot();
            ServiceHelper.CheckPlot();
        }

        [StepDefinition(@"Tuning is aborted")]
        public void ThenTuningIsAborted()
        {
            TunePage.Tuning.WithScreenShots(numberOfScreenShots: 2, intervalInSeconds: 2).AbortTuning();
            ServiceHelper.CheckWindow("Tuning has been aborted");
        }

        [Then(@"Sodium Formate plot is halted")]
        public void ThenSodiumFormatePlotIsHalted()
        {
            Report.Action("This requires manual verification. Please check that the plot has halted");
            //Report.Screenshot();
            ServiceHelper.CheckPlot();
        }

        [Then(@"the Sodium Formate plot refreshes correctly when tuning and is halted when aborted")]
        public void ThenTheSodiumFormatePlotRefreshesCorrectlyWhenTuningAndIsHaltedWhenAborted()
        {
            // TODO: This step will require manual verification
            //ScenarioContext.Current.Pending();

            Report.Action("This requires manual verification. Please check that the plot is being refreshed when tuning and that the plot is halted when tuning is aborted.");
            //Report.Screenshot();
            ServiceHelper.CheckPlot();
        }

        [StepDefinition(@"Quartz is in Mobility mode")]
        public void GivenQuartzIsInMobilityMode()
        {
            TunePage.MobilityMode.Start();
            //Wait.ForMilliseconds(2000);
            ServiceHelper.CheckPlot();
        }

        [StepDefinition(@"the plot (.*) button is clicked")]
        public void WhenThePlotButtonIsClicked(string buttonType)
        {
            Dictionary<string, Action> buttonActions = new Dictionary<string, Action>() 
            {
                {"MZ", _tunePage.Controls.MZButton.Click },
                {"BPI", _tunePage.Controls.BPIButton.Click },
                {"TIC", _tunePage.Controls.TICButton.Click },
                {"DT", _tunePage.Controls.DTButton.Click }
            };

            buttonActions[buttonType]();

            //Report.Action(string.Format("The {0} button has been clicked", buttonType));
            //Report.Screenshot();
            ServiceHelper.CheckWindow(string.Format("The {0} button has been clicked", buttonType));
        }

        [Then(@"the expected live plot is shown")]
        public void ThenTheExpectedLivePlotIsShown()
        {
            //// TODO: Refactor this - It is copy and pasted from TunePageCommand.TakeScreenShots()
            //Report.Screenshot();
            //const int _numberOfScreenShots = 5;
            //const int _intervalInSeconds = 3;
            //for (int i = 0; i < _numberOfScreenShots; i++)
            //{
            //    Report.Action(string.Format("Wait {0} second(s) - Take Screenshot", _intervalInSeconds));
            //    Report.Screenshot();
            //    Wait.ForMilliseconds(TimeSpan.FromSeconds(_intervalInSeconds).Milliseconds);
            //}
            ServiceHelper.Eyes.Log("The expected live plot is shown");
            ServiceHelper.CheckPlot();
        }

        [Then(@"the expected live drift time pop-out dialog is displayed")]
        public void ThenTheExpectedLiveDriftTimePop_OutDialogIsDisplayed()
        {
            CheckMobilityPopout("BPI");
        }

        private void CheckMobilityPopout(string buttonType)
        {
            //IWebElement mobiligramWidget = _mobilityPage.FindWidget("Mobiligram");

            //Check.IsNotNull(mobiligramWidget, "The Mobiligram widget is present.", true);
            //Check.IsTrue(mobiligramWidget.Displayed, string.Format("The mobility pop out dialog is displayed when the {0} button is clicked.", buttonType), true);
            //_mobilityPage.CloseMobilityPopoutWindow();
            ServiceHelper.CheckWindow(string.Format("The mobility pop out dialog is displayed when the {0} button is clicked.", buttonType));
        }

        [When(@"the '(Chart Readback|Plot Peak Properties)' dialog is displayed")]
        [Then(@"the '(Chart Readback|Plot Peak Properties)' dialog should be displayed")]
        public void ThenTheDialogShouldBeDisplayed(string dialog)
        {
            Dictionary<string, Action> dialogAction = new Dictionary<string, Action> 
            { 
                {"Chart Readback", ChartReadbackModal.CheckExists },
                {"Plot Peak Properties", PlotPeakPropertiesModal.CheckExists }
            };

            dialogAction[dialog]();

            Report.Action(string.Format("Check this screenshot displays the {0} modal dialog", dialog));
            Report.Screenshot();
        }

        [Then(@"all the '(Chart Readback|Plot Peak Properties)' controls should be present")]
        public void ThenAllTheControlsShouldBePresent(string dialog)
        {
            Dictionary<string, Action> dialogDictionary = new Dictionary<string, Action>()
            {
                {"Chart Readback", ChartReadbackModal.CheckChartReadbackModalControls },
                {"Plot Peak Properties", PlotPeakPropertiesModal.CheckPlotPeakPropertiesModalControls }
            };

            dialogDictionary[dialog]();
        }

        [Then(@"items can be added and removed from the Available List to the Currently Plotted List")]
        public void ThenItemsCanBeAddedAndRemovedFromTheAvailableListToTheCurrentlyPlottedList()
        {
            ChartReadbackModal.AddRandomChartReadbackProperty();
            ChartReadbackModal.RemoveRandomChartReadbackProperty();
            ChartReadbackModal.Plot();
        }

        [When(@"there are no items in the currently plotted list")]
        public void WhenThereAreNoItemsInTheCurrentlyPlottedList()
        {
            Check.IsTrue(ChartReadbackModal.CurrentlyPlottedList.IsEmpty, "There are no items in the Currently Plotted List.", continueOnFail: true);
        }

        [Then(@"the ChartReadback Plot button should be disabled")]
        public void ThenTheButtonShouldBeDisabled()
        {
            ChartReadbackModal.PlotButton.CheckDisabled();
        }

        [When(@"Quartz is switched into TOF mode")]
        public void WhenQuartzIsSwitchedIntoTOFMode()
        {
            TunePage.TOFMode.Start();
        }

        [Then(@"the DT button should be disabled")]
        public void ThenTheDTButtonShouldBeDisabled()
        {
            //Check.IsTrue(() => !_tunePage.Controls.DTButton.Enabled, "The DT button is disabled", false, 3000);
            //Report.Screenshot(_tunePage.Controls.DTButton);
            ServiceHelper.CheckWindow("The DT button is disabled");
        }

        [Then(@"the DT plot should stop updating if it is still visible")]
        public void ThenTheDTPlotShouldStopUpdatingIfItIsStillVisible()
        {
            CheckMobilityPopout("DT");
        }

        [When(@"the MS method is selected")]
        public void WhenTheMSMethodIsSelected()
        {
            _tunePage.SelectTuningMethod("MS");
        }

        [When(@"the Fluidics tabs has been selected from the Controls widget")]
        public void WhenTheFluidicsTabsHasBeenSelectedFromTheControlsWidget()
        {
            _tunePage.Controls.ControlsWidget.TabControl.Select("Fluidics");
        }

        [Then(@"a plot should be generated for the following sample")]
        public void WhenAPlotIsGeneratedForTheFollowingSample(Table samples)
        {
            foreach (TableRow row in samples.Rows)
            {
                string sample = row["Sample"];
                if (TyphoonHelper.SimulatedInstrument)
                {
                    Wait.ForMilliseconds(1000, "Waiting for 1 second");
                }
                else
                {
                    Wait.ForMilliseconds(60000, "Waiting for 1 minute");
                }

                FluidicsTabView.SampleFluidicsReservoirSettingDropdown.SelectOptionFromDropDown(sample);
                Report.Screenshot();
            }
        }

        [Given(@"Quartz does not contain any pages that are dependent upon http or https")]
        public void GivenQuartzDoesNotContainAnyPagesThatAreDependentUponHttpOrHttps(Table quartzPages)
        {
            foreach (var page in quartzPages.Rows)
            {
                string pageTitle = page[0];

                Anchor navMenuItem = NavigationMenu.Anchors.Find(x => x.Label.Equals(pageTitle, StringComparison.InvariantCultureIgnoreCase));
                Check.IsNotNull(navMenuItem, string.Format("quartzNavigationMenuItem cannot be null\r\n Quartz Navigation Menu: {0}", pageTitle), true);
                navMenuItem.Click();
                Page.WaitForPageToLoad();

                Page.CheckForHttp();
            }
        }

        [Then(@"click the '(Chart Readback|Plot Peak Properties)' Plot button")]
        public void ThenClickThePlotPeakPropertiesPlotButton(string plotType)
        {
            Dictionary<string, Action> plot = new Dictionary<string, Action>
            {
                { "Chart Readback", ChartReadbackModal.Plot },
                { "Plot Peak Properties", PlotPeakPropertiesModal.Plot }
            };

            plot[plotType]();
        }

        [Then(@"click the '(Chart Readback|Plot Peak Properties)' Cancel button")]
        public void ThenClickTheChartReadbackCancelButton(string plotType)
        {
            Dictionary<string, Action> cancel = new Dictionary<string, Action>
            {
                { "Chart Readback", ChartReadbackModal.Cancel },
                { "Plot Peak Properties", PlotPeakPropertiesModal.Cancel }
            };

            cancel[plotType]();
        }

    }
}
