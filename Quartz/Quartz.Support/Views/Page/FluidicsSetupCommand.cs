using System;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using Quartz.Support.Views.TabViews;
using TechTalk.SpecFlow;

namespace Quartz.Support.Views.Page
{
    public class FluidicsSetupCommand
    {
        public enum SolutionType
        {
            SodiumFormate,
            LeucineEnkephalin
        }

        public enum BafflePosition
        {
            Sample,
            Reference
        }

        public enum InfusionState
        {
            Idle
        }

        public string SampleFluidicLevel { get { return FluidicsTabView.SampleFluidicLevel; } }

        public string ReferenceFluidicLevel { get { return FluidicsTabView.ReferenceFluidicLevel; } }

        private readonly TunePage _tunePage;

        private const string reservoirA = "A";
        private const string reservoirB = "B";
        private const string reservoirC = "C"; 
        

        public FluidicsSetupCommand(TunePage tunePage)
        {
            _tunePage = tunePage;
        }

        public void SetSampleReservoir(string solutionType)
        {
            Report.Action(string.Format("Set Sample Reservoir to '{0}'", solutionType));
            FluidicsTabView.SampleFluidicsReservoirSettingDropdown.SelectOptionFromDropDown(solutionType, continueOnFail: true);
        }

        public void SetSampleReservoir(SolutionType solutionType)
        {
            Report.Action(string.Format("Set Sample Reservoir to '{0}'", solutionType));

            switch (solutionType)
            { 
                case SolutionType.SodiumFormate:
                    FluidicsTabView.SampleFluidicsReservoirSettingDropdown.SelectOptionFromDropDown(reservoirC, continueOnFail: true);
                    break;
                case SolutionType.LeucineEnkephalin:
                    FluidicsTabView.SampleFluidicsReservoirSettingDropdown.SelectOptionFromDropDown(reservoirB, continueOnFail: true);
                    break;
            }
        }

        public void SetSampleFlowPath(string flowPath)
        {
            Report.Action(string.Format("Set Sample Flow Path to '{0}'", flowPath));
            FluidicsTabView.SampleFlowPathSettingDropdown.SelectOptionFromDropDown(flowPath);
        }

        public void SetSampleFlowRate(string flowRate)
        {
            Report.Action(string.Format("Set Sample Flow Rate to '{0}'", flowRate));
            FluidicsTabView.SampleInfusionFlowRateTextbox.SetText(flowRate);
        }

        public void SetReferenceReservoir(SolutionType solutionType)
        {
            Report.Action(string.Format("Set Reference Reservoir to '{0}'", solutionType));

            switch (solutionType)
            {
                case SolutionType.SodiumFormate:
                    FluidicsTabView.ReferenceFluidicsReservoirSettingDropdown.SelectOptionFromDropDown(reservoirC, continueOnFail: true);
                    break;
                case SolutionType.LeucineEnkephalin:
                    FluidicsTabView.ReferenceFluidicsReservoirSettingDropdown.SelectOptionFromDropDown(reservoirB, continueOnFail: true);
                    break;
            }
        }

        public void SetReferenceReservoir(string solutionType)
        {
            Report.Action(string.Format("Set Reference Reservoir to '{0}'", solutionType));
            FluidicsTabView.ReferenceFluidicsReservoirSettingDropdown.SelectOptionFromDropDown(solutionType, continueOnFail: true);
        }

        public void SetReferenceFlowPath(string flowPath)
        {
            Report.Action(string.Format("Set Reference Flow Path to '{0}'", flowPath));
            FluidicsTabView.ReferenceFluidicsFlowPathSettingDropdown.SelectOptionFromDropDown(flowPath);
        }

        public void SetReferenceFlowRate(string flowRate)
        {
            Report.Action(string.Format("Set Reference Flow Rate to '{0}'", flowRate));
            FluidicsTabView.ReferenceInfusionFlowRateTextbox.SetText(flowRate);
        }
         
        public void SelectFluidicsTab()
        {
            var tab = _tunePage.Controls.ControlsWidget.FluidicsTab;

            if (!tab.Selected)
            {
                tab.Select();
            }
        }

        public void RefillSampleFluidics()
        {
            RefillFluidics(BafflePosition.Sample);
        }

        public void RefillReferenceFluidics()
        {
            RefillFluidics(BafflePosition.Reference);

            // Infuse at a high rate for 30 seconds following a refill
            Report.Action("Reference Fluidics was refilled. Infusing to establish a beam...");

            TunePage.FluidicsSetup.SetBafflePosition(BafflePosition.Reference);
            TunePage.FluidicsSetup.SetReferenceReservoir(reservoirB);
            TunePage.FluidicsSetup.SetReferenceFlowPath("Infusion");
            TunePage.FluidicsSetup.SetReferenceFlowRate("60.00");

            StartReferenceInfusion();

            Wait.ForMilliseconds(30000);

            StopReferenceInfusion();
        }

        private void RefillFluidics(BafflePosition baffle)
        {
            Button infuseBtn;
            Button refillBtn;
            switch (baffle)
            {
                case BafflePosition.Sample:
                    infuseBtn = FluidicsTabView.SampleStartInfusionButton;
                    refillBtn = FluidicsTabView.SampleRefillButton;
                    break;
                case BafflePosition.Reference:
                    infuseBtn = FluidicsTabView.ReferenceInfusionButton;
                    refillBtn = FluidicsTabView.ReferenceRefillButton;
                    break;
                default:
                    throw new NotImplementedException("Unknown baffle position");
            }

            Report.Action(string.Format("Refill the {0} Fluidics", baffle.ToString()));

            InstrumentControlWidget instrumentControl = new InstrumentControlWidget();

            if (infuseBtn.Text == "Stop Infusion")
            {
                Wait.Until(b => infuseBtn.Text == "Start Infusion", 35000, "Waiting for fluidics to stop infusion...");
            }

            refillBtn.Click();

            switch (baffle)
            {
                case BafflePosition.Sample:
                    Wait.Until(t => FluidicsTabView.SampleProgressBar.PercentComplete == 100, 35000, "Waiting for Sample Fluidics to refill...");
                    break;
                case BafflePosition.Reference:
                    Wait.Until(t => FluidicsTabView.ReferenceProgressBar.PercentComplete == 100, 35000, "Waiting for Reference Fluidics to refill...");
                    break;
                default:
                    throw new NotImplementedException("Unknown baffle position");
            }            
        }


        public void PurgeSampleFluidics()
        {
            Report.Action("Purge the Sample Fluidics");
           
            // We don't always need to click Purge because changing the reservior causes it to Purge automatically on an instrument
            var purgeButton = FluidicsTabView.SamplePurgeButton; 
            if (purgeButton.Enabled)
                purgeButton.Click();

            Wait.Until(b => FluidicsTabView.SampleStartInfusionButton.Enabled, 180000, "Waiting for purge to finish...");
        }

        private void StartInfusion(BafflePosition baffle)
        {
            Button infuseBtn;
            switch (baffle)
            {
                case BafflePosition.Sample:
                    infuseBtn = FluidicsTabView.SampleStartInfusionButton;
                    break;
                case BafflePosition.Reference:
                    infuseBtn = FluidicsTabView.ReferenceInfusionButton;
                    break;
                default:
                    throw new NotImplementedException("Unknown baffle position");
            }

            Report.Action(string.Format("Start {0} Infusion", baffle.ToString()));

            if (infuseBtn.Text == "Stop Infusion")
            {
                Report.Debug(string.Format("{0} Infusion already started", baffle.ToString()));
            }
            else
            {
                if (!infuseBtn.Enabled)
                {
                    Wait.Until(b => infuseBtn.Enabled, 120000, "Waiting for Start Infusion button to be enabled...");
                }

                infuseBtn.Click();
                infuseBtn.CheckCaption("Stop Infusion", 5000);
            }

            FeatureContext.Current["FluidicsRequired"] = true;
        }

        public void StartSampleInfusion()
        {
            StartInfusion(BafflePosition.Sample);
        }

        public void StartReferenceInfusion()
        {
            StartInfusion(BafflePosition.Reference);
        }

        private void StopInfusion(BafflePosition baffle)
        {
            Button infuseBtn;
            switch (baffle)
            {
                case BafflePosition.Sample:
                    infuseBtn = FluidicsTabView.SampleStartInfusionButton;
                    break;
                case BafflePosition.Reference:
                    infuseBtn = FluidicsTabView.ReferenceInfusionButton;
                    break;
                default:
                    throw new NotImplementedException("Unknown baffle position");
            }

            Report.Action(string.Format("Stop {0} Infusion", baffle.ToString()));

            if (infuseBtn.Text == "Start Infusion")
            {
                Report.Debug(string.Format("{0} Infusion already stopped", baffle.ToString()));
            }
            else
            {
                if (!infuseBtn.Enabled)
                {
                    Wait.Until(b => infuseBtn.Enabled, 120000, "Waiting for Stop Infusion button to be enabled...");
                }

                infuseBtn.Click();
                infuseBtn.CheckCaption("Start Infusion", 10000);
            }

        }

        public void StopSampleInfusion()
        {
            StopInfusion(BafflePosition.Sample);
        }

        public void StopReferenceInfusion()
        {
            StopInfusion(BafflePosition.Reference);
        }

        public void EnsureSampleAndReferenceNotInfusing()
        {           
            NavigationMenu.TuneAnchor.Click();
            Page.WaitForPageToLoad();
            SelectFluidicsTab();
            StopSampleInfusion();
            StopReferenceInfusion();
        }

        public void SetBafflePosition(string bafflePosition)
        {
            FluidicsTabView.ReferenceFluidicsBafflePositionSettingDropdown.SelectOptionFromDropDown(bafflePosition, continueOnFail: true);
        }

        public void SetBafflePosition(BafflePosition bafflePosition)
        {
            switch (bafflePosition)
            {
                case BafflePosition.Sample:
                    FluidicsTabView.ReferenceFluidicsBafflePositionSettingDropdown.SelectOptionFromDropDown("Sample", continueOnFail: true);
                    break;
                case BafflePosition.Reference:
                    FluidicsTabView.ReferenceFluidicsBafflePositionSettingDropdown.SelectOptionFromDropDown("Reference", continueOnFail: true);
                    break;
            }
        }

        public void PurgeReferenceFluidics()
        {
            Report.Action("Purge the Reference Fluidics");

            // We don't always need to click Purge because changing the reservior causes it to Purge automatically on an instrument
            var purgeBtn = FluidicsTabView.ReferencePurgeButton;
            if (purgeBtn.Enabled)
            {
                purgeBtn.Click();
            }

            Wait.Until(b => FluidicsTabView.ReferenceInfusionButton.Enabled, 180000, "Waiting for reference fluidic to finish purging...");
        }

        public void SetSampleInfusionState(InfusionState state)
        {
            switch (state)
            {
                case InfusionState.Idle:

                    if (FluidicsTabView.SampleFluidicLevel.StartsWith("Infusing"))
                        StopSampleInfusion();

                    break;
            }
        }
    }
}