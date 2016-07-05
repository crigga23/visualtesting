using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class FluidicsTabView
    {
        #region Controls

        public static Button SampleStartInfusionButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("SampleFluidics.Infusion")));
            }
        }

        public static Button SampleRefillButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("SampleFluidics.Refill")));
            }
        }

        public static Button SamplePurgeButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("SampleFluidics.Purge")));
            }
        }

        public static Button SampleWashButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("SampleFluidics.Wash")));
            }
        }

        public static Button SampleInjectButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("SampleFluidics.Inject")));
            }
        }

        public static Button SampleResetButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("SampleFluidics.Reset")));
            }
        }

        public static ProgressBar SampleProgressBar
        {
            get
            {
                return new ProgressBar(AutomationDriver.Driver.FindElement(By.Id("Fluidics.PercentLeft.Readback")));
            }
        }

        public static string SampleFluidicLevel
        {
            get
            {
                return SampleProgressBar.Element.FindElement(By.TagName("span")).Text;
            }
        }

        public static Dropdown SampleFluidicsReservoirSettingDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("SampleFluidics.Reservoir.Setting")));
            }
        }

        public static Dropdown SampleFlowPathSettingDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("SampleFluidics.FlowState.Setting")));
            }
        }

        public static Dropdown FillVolumeSettingDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("SampleFluidics.FillVolume.Setting")));
            }
        }

        public static Dropdown WashCycleSettingDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("SampleFluidics.WashCycles.Setting")));
            }
        }

        public static TextBox SampleInfusionFlowRateTextbox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("SampleFluidics.FlowRate.Setting")));
            }
        }

        public static string ReferenceFluidicLevel
        {
            get
            {
                return ReferenceProgressBar.Element.FindElement(By.TagName("span")).Text;
            }
        }

        public static Button ReferenceInfusionButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("ReferenceFluidics.Infusion.Setting")));
            }
        }

        public static Button ReferenceRefillButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("ReferenceFluidics.Refill.Setting")));
            }
        }

        public static Button ReferencePurgeButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("ReferenceFluidics.Purge.Setting")));
            }
        }

        public static Button ReferenceFSCButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("ReferenceFluidics.FlowSensorCalibration.Setting")));
            }
        }

        public static Button ReferenceResetButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("ReferenceFluidics.Reset.Setting")));
            }
        }

        public static ProgressBar ReferenceProgressBar
        {
            get
            {
                return new ProgressBar(AutomationDriver.Driver.FindElement(By.Id("Fluidics.ReferenceFluidicsPercentLeftRb.Readback")));
            }
        }

        public static TextBox ReferenceInfusionFlowRateTextbox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("ReferenceFluidics.FlowRate.Setting")));
            }
        }

        public static Dropdown ReferenceFluidicsReservoirSettingDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("ReferenceFluidics.Reservoir.Setting")));
            }
        }

        public static Dropdown ReferenceFluidicsFlowPathSettingDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("ReferenceFluidics.FlowState.Setting")));
            }
        }

        public static Dropdown ReferenceFluidicsBafflePositionSettingDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("Fluidics.BafflePosition.Setting")));
            }
        }

        public static Dropdown ReferenceFluidicsIlluminationSettingDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("Fluidics.Illumination.Setting")));
            }
        }

        #endregion Controls
    }
}