using System;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.Installation.StepDefinitions
{
    [Binding]
    public class KIT_ConfigureBeamSteps
    {

        TunePage tunePage = new TunePage();

        [Given(@"the factory defaults and tune set is copied to the instrument")]
        public void GivenTheFactoryDefaultsAndTuneSetIsCopiedToTheInstrument()
        {
            InstrumentHelper.ImportInstrumentFactoryDefaults();
        }

        [Given(@"instrument factory defaults are loaded")]
        public void GivenInstrumentFactoryDefaultsAreLoaded()
        {
            Report.Action("Loading Factory Defaults");
            tunePage.LoadFactoryDefaults();
        }

        [Given(@"reference fluidics are Idle")]
        public void GivenReferenceFluidicsAreIdle()
        {
            TunePage.FluidicsSetup.SelectFluidicsTab();

            // check initial state of fluidics
            if (TunePage.FluidicsSetup.ReferenceFluidicLevel == "Stopped - Select purge to recover")
            {
                Report.Action("Reference Fluidics is stopped. Attempting to Purge...");

                TunePage.FluidicsSetup.PurgeReferenceFluidics();
                Wait.ForMilliseconds(4000);

                if (TunePage.FluidicsSetup.ReferenceFluidicLevel == "Stopped - Select purge to recover")
                {
                    Report.Action("Purge did not work. Overriding Source Pressure test...");

                    NavigationMenu.SourcePressureTestAnchor.Click();
                    var button = AutomationDriver.Driver.FindElement(By.Id("Source.OverrideSourcePressureTest.Setting"));
                    button.Click();

                    NavigationMenu.TuneAnchor.Click();
                    tunePage.ControlsWidget.FluidicsTab.Select();

                    Check.IsTrue(TunePage.FluidicsSetup.ReferenceFluidicLevel == "Purging", "Reference fluidics is purging");
                }

                Wait.Until(f => TunePage.FluidicsSetup.ReferenceFluidicLevel != "Purging", 12000, "Waiting for reference fluidics to stop purging...");

                Report.Action("Purge completed");
            }

            if (TunePage.FluidicsSetup.ReferenceFluidicLevel.StartsWith("Idle") == false)
            {
                Report.Fail("Reference Fluidics is not Idle. Unable to start infusion");
                return;
            }
        }

        [Given(@"sample fluidics are Idle")]
        public void GivenSampleFluidicsAreIdle()
        {
            // check initial state of fluidics
            if (TunePage.FluidicsSetup.SampleFluidicLevel == "Stopped - Select purge to recover")
            {
                Report.Action("Sample Fluidics is stopped. Attempting to Purge...");

                TunePage.FluidicsSetup.PurgeSampleFluidics();
                Wait.ForMilliseconds(4000);

                if (TunePage.FluidicsSetup.SampleFluidicLevel == "Stopped - Select purge to recover")
                {
                    Report.Action("Purge did not work. Overriding Source Pressure test...");

                    NavigationMenu.SourcePressureTestAnchor.Click();
                    var button = AutomationDriver.Driver.FindElement(By.Id("Source.OverrideSourcePressureTest.Setting"));
                    button.Click();

                    NavigationMenu.TuneAnchor.Click();
                    tunePage.ControlsWidget.FluidicsTab.Select();

                    Check.IsTrue(TunePage.FluidicsSetup.SampleFluidicLevel == "Purging", "Sample fluidics is purging");
                }

                Wait.Until(f => TunePage.FluidicsSetup.SampleFluidicLevel != "Purging", 12000, "Waiting for sample fluidics to stop purging...");

                Report.Action("Purge completed");
            }

            if (TunePage.FluidicsSetup.SampleFluidicLevel.StartsWith("Idle") == false)
            {
                Report.Fail("Sample Fluidics is not Idle. Unable to start infusion");
                return;
            }
        }

        [When(@"a Reference Fluidics '(.*)' is initiated")]
        public void WhenAReferenceFluidicsIsInitiated(string action)
        {
            switch (action)
            {
                case "purge":
                case "Purge":
                    TunePage.FluidicsSetup.PurgeReferenceFluidics();
                    Report.Screenshot();
                    break;
                default:
                    throw new NotImplementedException("Fluidics action not implemented");
            }
        }

        [When(@"you start sample infusion")]
        public void WhenYouStartSampleInfusion()
        {
            ScenarioContext.Current.Pending();
        }

        [Then(@"after some time the plot will show a beam")]
        public void ThenAfterSomeTimeThePlotWillShowABeam()
        {
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
        }
    }
}
