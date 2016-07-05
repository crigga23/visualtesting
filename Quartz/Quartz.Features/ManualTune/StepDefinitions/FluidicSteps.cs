using System;
using System.Text.RegularExpressions;
using Automation.Reporting.Lib;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using Quartz.Support.Views.TabViews;
using TechTalk.SpecFlow;

namespace Quartz.Features.ManualTune.StepDefinitions
{
    [Binding]
    public class FluidicSteps
    {
        private readonly TunePage _tunePage;
        private readonly InstrumentControlWidget _instrumentControl;

        public FluidicSteps(TunePage tunePage, InstrumentControlWidget instrumentControl)
        {
            _tunePage = tunePage;
            _instrumentControl = instrumentControl;
        }

        [StepDefinition(@"reference fluidics are set to")]
        public void GivenReferenceFluidicsAreSetTo(Table table)
        {
            TunePage.FluidicsSetup.SelectFluidicsTab();

            foreach (var row in table.Rows)
            {
                var bafflePos = row["Baffle Position"];
                var reservoir = row["Reservoir"];
                var flowPath = row["Flow Path"];
                var flowRate = row["Flow Rate"];

                TunePage.FluidicsSetup.SetBafflePosition(bafflePos);
                TunePage.FluidicsSetup.SetReferenceReservoir(reservoir);
                TunePage.FluidicsSetup.SetReferenceFlowPath(flowPath);
                TunePage.FluidicsSetup.SetReferenceFlowRate(flowRate);
            }
        }

        [StepDefinition(@"sample fluidics are set to")]
        public void GivenSampleFluidicsAreSetTo(Table table)
        {
            TunePage.FluidicsSetup.SelectFluidicsTab();

            foreach (var row in table.Rows)
            {
                var bafflePos = row["Baffle Position"];
                var reservoir = row["Reservoir"];
                var flowPath = row["Flow Path"];
                var flowRate = row["Flow Rate"];

                TunePage.FluidicsSetup.SetBafflePosition(bafflePos);
                TunePage.FluidicsSetup.SetSampleReservoir(reservoir);
                TunePage.FluidicsSetup.SetSampleFlowPath(flowPath);
                TunePage.FluidicsSetup.SetSampleFlowRate(flowRate);
            }
        }

        [StepDefinition(@"Sodium Formate is selected via the Fluidics Sample vial")]
        public void GivenSodiumFormateIsSelectedViaTheFluidicsSampleVial()
        {
            TunePage.FluidicsSetup.SelectFluidicsTab();
            TunePage.FluidicsSetup.SetSampleReservoir(FluidicsSetupCommand.SolutionType.SodiumFormate);
        }

        [StepDefinition(@"Leucine Enkephalin is selected via the Fluidics Reference vial")]
        [StepDefinition(@"Reference Fluidics Reservoir B is selected")]
        public void GivenLeucineEnkephalinIsSelectedViaTheFluidicsReferenceVial()
        {
            TunePage.FluidicsSetup.SelectFluidicsTab();
            TunePage.FluidicsSetup.SetReferenceReservoir(FluidicsSetupCommand.SolutionType.LeucineEnkephalin);
        }

        [StepDefinition(@"Sample Vial (.*) is selected")]
        public void GivenSampleVialIsSelected(string vialLetter)
        {
            _instrumentControl.TabControl.Select("Fluidics");
            FluidicsTabView.SampleFluidicsReservoirSettingDropdown.SelectOptionFromDropDown(vialLetter);
        }

        [StepDefinition(@"you start reference infusing")]
        [StepDefinition(@"you start infusion on the Reference")]
        public void GivenYouStartInfusionOnTheReference()
        {
            TunePage.FluidicsSetup.StartReferenceInfusion();
        }

        [StepDefinition(@"you start sample infusing")]
        [StepDefinition(@"you start infusion on the Sample")]
        public void GivenYouStartInfusionOnTheSample()
        {
            TunePage.FluidicsSetup.StartSampleInfusion();
        }

        [Given(@"the reference fluidic level is not less than '(.*)' minutes")]
        public void GivenTheReferenceFluidicLevelIsNotLessThanMinutes(Decimal time)
        {
            if (!TyphoonHelper.SimulatedInstrument)
            {
                string pattern = @"([\d.]+)";
                var timeRemaining = Regex.Match(TunePage.FluidicsSetup.ReferenceFluidicLevel, pattern).Value;

                if (Convert.ToDecimal(timeRemaining) < time)
                    TunePage.FluidicsSetup.RefillReferenceFluidics();
                else
                    Report.Pass("Reference fluidic level is greater than " + time + " minutes");

                Report.Screenshot(_tunePage.ControlsWidget.FluidicsTab.Element);
            }
            else
            {
                Report.Action("This is a simulated instrument test run. Refilling fluidics is not necessary");
            }
        }

    }
}
