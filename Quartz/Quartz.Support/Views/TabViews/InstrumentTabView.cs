using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class InstrumentTabView
    {
        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {   
                    { "Collision Energy(V)", new ControlGroup (() => CollisionEnergySetting) },
                    { "Ion Guide Gradient (V)", new ControlGroup (() => IonGuideGradientSetting, () => IonGuideGradientReadback  ) },
                    { "Aperture 2 (V)", new ControlGroup (() => Aperture2Setting, () => Aperture2Readback) },
                    { "LM Resolution (low)", new ControlGroup (() => LMResolutionSetting) },
                    { "HM Resolution (high)", new ControlGroup (() => HMResolutionSetting) },
                    { "Pre-filter (V)", new ControlGroup (() => PrefilterSetting, () => PrefilterReadback ) },
                    { "Ion Energy (V)", new ControlGroup (() => IonEnergySetting) },
                    { "Detector Voltage(V)", new ControlGroup (() => DetectorVoltageSetting, () =>  DetectorVoltageReadback) }
                };
            }
        }

        #region Controls

        public static TextBox CollisionEnergySetting
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Instrument.CollisionEnergy.Setting")));
            }
        }

        public static TextBox IonGuideGradientSetting
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.ConeVoltage.Setting")));
            }
        }

        public static TextBox IonGuideGradientReadback
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.ConeVoltage.Readback")));
            }
        }

        public static TextBox Aperture2Setting
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.Aperture2.Setting")));
            }
        }

        public static TextBox Aperture2Readback
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.Aperture2.Readback")));
            }
        }

        public static TextBox LMResolutionSetting
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.LMResolution.Setting")));
            }
        }

        public static TextBox HMResolutionSetting
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.HMResolution.Setting")));
            }
        }

        public static TextBox PrefilterSetting
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.Prefilter.Setting")));
            }
        }

        public static TextBox PrefilterReadback
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.Prefilter.Readback")));
            }
        }

        public static TextBox IonEnergySetting
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Quad.IonEnergy.Setting")));
            }
        }

        public static TextBox DetectorVoltageSetting
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Detector.MCPDetectorVoltage.Setting")));
            }
        }

        public static TextBox DetectorVoltageReadback
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Detector.MCPDetectorVoltage.Readback")));
            }
        }

        #endregion Controls
    }
}