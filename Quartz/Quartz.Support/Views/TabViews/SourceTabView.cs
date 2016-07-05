using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class SourceTabView
    {

        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {                  
                    { "Capillary (kV)", new ControlGroup (() => CapillaryVoltageSetting, () => CapillaryVoltageReadback ) },
                    { "Reference Capillary (kV)", new ControlGroup (() => ReferenceCapillarySetting, () => ReferenceCapillaryReadback ) },
                    { "Corona mode", new ControlGroup (() => CoronaModeDropdown) },
                    { "Corona Current (µA)", new ControlGroup (() => CoronaCurrentSetting, () => CoronaCurrentReadback ) },
                    { "Corona Voltage (kV)", new ControlGroup (() => CoronaVoltageSetting, () => CoronaVoltageReadback ) },
                    { "Sampling Cone (V)", new ControlGroup (() => SampleConeVoltageSetting) },
                    { "Source Temperature (°C)", new ControlGroup (() => SourceTemperatureSetting, () => SourceTemperatureReadback ) },
                    { "Probe Temperature (°C)", new ControlGroup (() => ProbeTemperatureSetting, () => ProbeTemperatureReadback ) },
                    { "Cone Gas (L/hour)", new ControlGroup (() => ConeGasFlowSetting, () => ConeGasFlowReadback ) },
                    { "Desolvation Gas (L/hour)", new ControlGroup (() => DesolvationGasFlowSetting, () => DesolvationGasFlowReadback ) },
                    { "Purge Gas (L/hour)", new ControlGroup (() => PurgeGasSetting, () => PurgeGasReadback ) },
                    { "Source Offset (V)", new ControlGroup (() => SourceOffsetSetting, () => SourceOffsetReadback ) },
                    { "Desolvation Temperature (°C)", new ControlGroup (() => DesolvationTemperatureSetting, () => DesolvationTemperatureReadback ) },
                    { "NanoFlow Gas (Bar)", new ControlGroup (() => NanoflowGasSetting, () => NanoflowGasReadback ) }
                };
            }
        }


        #region Controls
        public static TextBox CapillaryVoltageSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.CapillaryVoltage.Setting"))); }
        }
        public static TextBox CapillaryVoltageReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.CapillaryVoltage.Readback"))); }
        }
        public static TextBox SampleConeVoltageSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Twave2Bias.Setting"))); }
        }
        public static TextBox SampleConeIMSSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.Twave2Bias.Setting"))); }
        }
        public static TextBox SampleConeVoltageReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.SampleConeVoltage.Readback"))); }
        }
        public static TextBox SourceOffsetSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.SourceOffset.Setting"))); }
        }
        public static TextBox SourceOffsetReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.SourceOffset.Readback"))); }
        }
        public static TextBox SourceTemperatureSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.SourceTemperature.Setting"))); }
        }
        public static TextBox SourceTemperatureReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.SourceTemperature.Readback"))); }
        }
        public static TextBox DesolvationTemperatureSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.DesolvationTemperature.Setting"))); }
        }
        public static TextBox DesolvationTemperatureReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.DesolvationTemperature.Readback"))); }
        }
        public static TextBox ConeGasFlowSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.ConeGasFlow.Setting"))); }
        }
        public static TextBox ConeGasFlowReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.ConeGasFlow.Readback"))); }
        }
        public static TextBox DesolvationGasFlowSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.DesolvationGasFlow.Setting"))); }
        }
        public static TextBox DesolvationGasFlowReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.DesolvationGasFlow.Readback"))); }
        }
        public static TextBox ReferenceCapillarySetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.ReferenceCapillary.Setting"))); }
        }
        public static TextBox ReferenceCapillaryReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.ReferenceCapillary.Readback"))); }
        }

        public static Dropdown CoronaModeDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("Source.CoronaMode.Setting")));
            }
        }

        public static TextBox CoronaVoltageSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.CoronaVoltage.Setting"))); }
        }

        public static TextBox CoronaVoltageReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.CoronaVoltage.Readback"))); }
        }

        public static TextBox CoronaCurrentSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.CoronaCurrent.Setting"))); }
        }

        public static TextBox CoronaCurrentReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.CoronaCurrent.Readback"))); }
        }

        public static TextBox ProbeTemperatureSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.ProbeTemperature.Setting"))); }
        }

        public static TextBox ProbeTemperatureReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.ProbeTemperature.Readback"))); }
        }

        public static TextBox PurgeGasSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.DesolvationGasFlow.Setting"))); }
        }

        public static TextBox PurgeGasReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.DesolvationGasFlow.Readback"))); }
        }

        public static TextBox NanoflowGasSetting
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.NanoflowGasFlow.Setting"))); }
        }

        public static TextBox NanoflowGasReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Source.NanoflowGasFlow.Readback"))); }
        }

        public static Dropdown LampDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("Source.APPILampOverheatStatus.Setting")));
            }
        }



        #endregion Controls

    }
}