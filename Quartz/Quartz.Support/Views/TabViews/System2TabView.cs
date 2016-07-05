using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class System2TabView
    {
        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {                  
                    { "Collector (V)", new ControlGroup (() => CollectorSettingTextBox, () => CollectorReadbackTextBox ) },
                    { "Collector Pulse (V)", new ControlGroup (() => CollectorPulseSettingTextBox ) },
                    { "Stopper (V)", new ControlGroup (() => StopperSettingTextBox, () =>  StoppperReadbackTextBox) },
                    { "Stopper Pulse (V)", new ControlGroup (() => StopperPulseSettingTextBox ) },
                    { "pDRE Attenuate", new ControlGroup (() => pDREAttenuateDropdown ) },
                    { "pDRE Transmission (%)", new ControlGroup (() => TransmissionSettingTextBox ) },
                    { "pDRE HD Attenuate", new ControlGroup (() => pDREHDAttenuateDropdown ) },
                    { "pDRE HD Transmission (%)", new ControlGroup (() => HDTransmissionSettingTextBox ) },
                };
            }
        }

        #region Controls
        public static TextBox CollectorSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("DRE.CollectorBias.Setting"))); }
        }
        public static TextBox CollectorReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("DRE.CollectorBias.Readback"))); }
        }
        public static Dropdown pDREAttenuateDropdown
        {
            get { return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("DRE.AttenuateOn.Setting"))); }
        }
        public static Dropdown pDREHDAttenuateDropdown
        {
            get { return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("HDDRE.AttenuateOn.Setting"))); }
        }
        public static TextBox CollectorPulseSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("DRE.CollectorPulse.Setting"))); }
        }
        public static TextBox TransmissionSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("DRE.transmission.Setting"))); }
        }
        public static TextBox HDTransmissionSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("HDDRE.transmission.Setting"))); }
        }
        public static TextBox StopperSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("DRE.StopperBias.Setting"))); }
        }
        public static TextBox StoppperReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("DRE.StopperBias.Readback"))); }
        }
        public static TextBox StopperPulseSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("DRE.StopperPulse.Setting"))); }
        }
        #endregion Controls
    }
}