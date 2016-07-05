using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class StepWaveTabView
    {

        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {   
                    { "SW 1 Offset (V)", new ControlGroup (() => SW1OffsetSettingTextBox) },
                    { "SW 2 Offset (V)", new ControlGroup (() => SW2OffsetSettingTextBox) },
                    { "SW 1 Velocity (m/s)", new ControlGroup (() => SW1VelocitySettingTextBox) },
                    { "SW 1 Pulse Height (V)", new ControlGroup (() => SW1PulseHeightSettingTextBox) },
                    { "SW 2 Velocity (m/s)", new ControlGroup (() => SW2VelocitySettingTextBox) },
                    { "SW 2 Pulse Height (V)", new ControlGroup (() => SW2PulseHeightSettingTextBox) }
                };
            }
        }

        #region Controls
        public static TextBox SW1OffsetSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.SW1Offset.Setting"))); }
        }
        public static TextBox SW2OffsetSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.SampleConeVoltage.Setting"))); }
        }
        public static TextBox SW1VelocitySettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Twave1InVelocity.Setting"))); }
        }
        public static TextBox SW1PulseHeightSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Twave1InPulseHeight.Setting"))); }
        }
        public static TextBox SW2VelocitySettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Twave1OutVelocity.Setting"))); }
        }
        public static TextBox SW2PulseHeightSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Twave1OutPulseHeight.Setting"))); }
        }
        public static TextBox RFOffsetReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.RFOffset.Setting"))); }
        }
        public static TextBox IonGuideRFReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.IonGuideRF.Setting"))); }
        }
        #endregion Controls
    }
}