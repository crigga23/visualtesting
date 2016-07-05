using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class MSProfileTabView
    {

        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {                  
                    { "Quadrupole Options", new ControlGroup (() => MSQuadrupoleOptionsDropdown ) },
                    { "Mass 1", new ControlGroup (() => MSMass1SettingTextBox ) },
                    { "Mass 2", new ControlGroup (() => MSMass2SettingTextBox ) },
                    { "Mass 3", new ControlGroup (() => MSMass3SettingTextBox ) },
                    { "Dwell Time 1", new ControlGroup (() => MSDwellTime1SettingTextBox ) },
                    { "Dwell Time 2", new ControlGroup (() => MSDwellTime2SettingTextBox ) },
                    { "Ramp Time 1", new ControlGroup (() => MSRampTime1SettingTextBox ) },
                    { "MS/MSMS", new ControlGroup (() => MSMSMSDropdown ) },
                    { "Set Mass", new ControlGroup (() => SetMassSettingTextBox ) },
                    { "Select Mode", new ControlGroup (() => SelectModeDropdown ) },
                    { "EDC Mass", new ControlGroup (() => EDCMassSettingTextBox ) },
                    { "Delay Coefficient < 2000", new ControlGroup (() => EDCLowMassDelayCoefficientSettingTextBox ) },
                    { "Delay Coefficient >= 2000", new ControlGroup (() => EDCHighMassDelayCoefficientSettingTextBox ) },
                    { "Delay Offset < 2000", new ControlGroup (() =>  EDCLowMassDelayOffsetSettingTextBox) },
                    { "Delay Offset >= 2000", new ControlGroup (() => EDCHighMassDelayOffsetSettingTextBox ) },  
                };
            }
        }

        #region Controls

        public static Dropdown MSQuadrupoleOptionsDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("Acquisition.MSProfile.Setting")));
            }
        }

        public static TextBox MSMass1SettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.MSMass1.Setting"))) { SettingId = "Quad.MSMass1.Setting", Label = "Mass 1" };
            }
        }

        public static TextBox MSMass2SettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.MSMass2.Setting"))) { SettingId = "Quad.MSMass2.Setting", Label = "Mass 2" };
            }
        }

        public static TextBox MSMass3SettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.MSMass3.Setting"))) { SettingId = "Quad.MSMass3.Setting", Label = "Mass 3" };
            }
        }

        public static TextBox MSDwellTime1SettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.MSDwellTime1.Setting"))) { SettingId = "Quad.MSDwellTime1.Setting", Label = "Dwell Time(%Scan Time) 1" };
            }
        }

        public static TextBox MSDwellTime2SettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.MSDwellTime2.Setting"))) { SettingId = "Quad.MSDwellTime2.Setting", Label = "Dwell Time(%Scan Time) 2" };
            }
        }

        public static TextBox MSRampTime1SettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.MSTime1.Setting"))) { SettingId = "Quad.MSTime1.Setting", Label = "Ramp Time(%Scan Time) 1" };
            }
        }

        public static TextBox MSRampTime2SettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.MSTime2.Setting"))) { SettingId = "Quad.MSTime2.Setting", Label = "Ramp Time(%Scan Time) 1" };
            }
        }

        public static Dropdown MSMSMSDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("AcquisitionMode.MSMSMode"))) { Label = "MS/MSMS" };
            }
        }

        public static TextBox SetMassSettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Acquisition.SetMass.Setting"))) { Label = "Set Mass" };
            }
        }

        public static Dropdown SelectModeDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("AcquisitionMode.EnhanceMode"))) { Label = "Select Mode" };
            }
        }

        public static TextBox EDCMassSettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.EDCMass.Setting"))) { Label = "EDC Mass" };
            }
        }

        public static TextBox EDCLowMassDelayCoefficientSettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.EDCCoefficientLow.Setting"))) { Label = "Delay Coefficient < 2000" };
            }
        }

        public static TextBox EDCHighMassDelayCoefficientSettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.EDCCoefficientHigh.Setting"))) { Label = "Delay Coefficient >= 2000" };
            }
        }
        public static TextBox EDCLowMassDelayOffsetSettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.EDCDelayOffsetLow.Setting"))) { Label = "Delay Offset < 2000" };
            }
        }
        public static TextBox EDCHighMassDelayOffsetSettingTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.EDCDelayOffsetHigh.Setting"))) { Label = "Delay Offset >= 2000" };
            }
        }

        #endregion Controls
    }
}