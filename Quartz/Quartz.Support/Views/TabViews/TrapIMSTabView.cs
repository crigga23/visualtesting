using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class TrapIMSTabView
    {

        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {   
                    { "Trap Entrance (V)", new ControlGroup (() => TrapEntranceTextBox) },
                    { "Trap Stopper (V)", new ControlGroup (() => TrapStopperTextBox) },
                    { "Stopper Height (V)", new ControlGroup (() => StopperHeightTextBox) },
                    { "Trap Bias (V)", new ControlGroup (() => TrapBiasTextBox) },
                    { "Gate Offset (V)", new ControlGroup (() => GateOffsetTextBox) },
                    { "Gate Height (V)", new ControlGroup (() => GateHeightTextBox) },
                    { "Aperture 1 (V)", new ControlGroup (() => Aperture1TextBox) },
                    { "Trap Wave Velocity (m/s)", new ControlGroup (() => TrapWaveVelocityTextBox) },
                    { "Trap Pulse Height 'A' (V)", new ControlGroup (() => TrapPulseHeightATextBox) },
                    { "Trap Pulse Height 'B' (V)", new ControlGroup (() => TrapPulseHeightBTextBox) },
                    { "IMS Wave Velocity (m/s)", new ControlGroup (() => IMSWaveVelocityTextBox) },
                    { "IMS Pulse Height (V)", new ControlGroup (() => IMSPulseHeightTextBox) },
                    { "Gate Release (ms)", new ControlGroup (() => GateReleaseTextBox) },
                    { "Gate Delay (ms)", new ControlGroup (() => GateDelayTextBox) },
                    { "Wave Delay (# pushes)", new ControlGroup (() => WaveDelayTextBox) }
                };
            }
        }


        #region Controls
        public static TextBox TrapEntranceTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.transfer1_exit_offset.Setting"))); }
        }
        public static TextBox TrapStopperTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.transfer1_entrance_offset.Setting"))); }
        }
        public static TextBox StopperHeightTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.tw2_op0_height.Setting"))); }
        }
        public static TextBox TrapBiasTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Twave2OffsetFromBia.Setting"))); }
        }
        public static TextBox GateOffsetTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Aperture1.Setting"))); }
        }
        public static TextBox GateHeightTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.GateTrapHeight.Setting"))); }
        }
        public static TextBox Aperture1TextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Aperture2.Setting"))); }
        }
        public static TextBox TrapWaveVelocityTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Twave2Velocity.Setting"))); }
        }
        public static TextBox TrapPulseHeightATextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Twave2Height.Setting"))); }
        }
        public static TextBox TrapPulseHeightBTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Twave2HeightB.Setting"))); }
        }
        public static TextBox IMSWaveVelocityTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.IMSVelocity.Setting"))); }
        }
        public static TextBox IMSPulseHeightTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.IMSHeight.Setting"))); }
        }
        public static TextBox GateReleaseTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.TrapReleaseTime.Setting"))); }
        }
        public static TextBox GateDelayTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.TrapGateDelay.Setting"))); }
        }
        public static TextBox WaveDelayTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.IMSWaveDelay.Setting"))); }
        }
        #endregion Controls
    }
}