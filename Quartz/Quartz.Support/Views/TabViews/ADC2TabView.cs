using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class ADCTab2View
    {
        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {                  
                    { "DC Bias A", new ControlGroup (() => DCBiasA ) },
                    { "Amplitude Threshold A", new ControlGroup (() => AmplitudeThresholdA ) },
                    { "Area Threshold A", new ControlGroup (() => AreaThresholdA ) },
                    { "Baseline Mean A", new ControlGroup (() => BaselineMeanA ) },
                    { "DC Bias B", new ControlGroup (() => DCBiasB ) },
                    { "Amplitude Threshold B", new ControlGroup (() => AmplitudeThresholdB ) },
                    { "Area Threshold B", new ControlGroup (() => AreaThresholdB ) },
                    { "Baseline Mean B", new ControlGroup (() => BaselineMeanB ) },
                    { "Time Delay B", new ControlGroup (() => TimeDelayB ) },
                    { "Channel B Multiplier", new ControlGroup (() => ChannelBMultiplier ) },
                    { "Trigger Threshold", new ControlGroup (() => TriggerThreshold ) },
                    { "Input Channel", new ControlGroup (() => InputChannel ) },
                    { "Signal Source", new ControlGroup (() => SignalSource ) },
                    { "Pulse Shaping", new ControlGroup (() => PulseShaping ) },
                    { "Output Scaling Factor", new ControlGroup (() => OutputScalingFactor ) },
                    { "Average Single Ion Intensity", new ControlGroup (() => AverageIonIntensitySettingTextBox ) },
                    { "Measured m/z", new ControlGroup (() => AverageIonAreaMZSettingTextBox ) },
                    { "Measured charge", new ControlGroup (() => AverageIonAreaChargeSettingTextBox ) },
                    { "T0 (ns)", new ControlGroup (() => T0 ) },
                    { "Veff (V)", new ControlGroup (() => VeffSettingTextBox ) },
                    { "ADC Algorithm", new ControlGroup (() => ADCAlgorithm ) }
                    
                };
            }
        }

        #region Controls
        public static TextBox DCBiasA
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.MasterDCThreshold.Setting"))); }
        }
        public static TextBox AmplitudeThresholdA
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.AmplitudeThresholdMaster.Setting"))); }
        }
        public static TextBox AreaThresholdA
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.IonAreaThresholdMaster.Setting"))); }
        }
        public static TextBox BaselineMeanA
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.BaseSubstractMaster.Setting"))); }
        }
        public static TextBox DCBiasB
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.SlaveDCThreshold.Setting"))); }
        }
        public static TextBox AmplitudeThresholdB
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.AmplitudeThresholdSlave.Setting"))); }
        }
        public static TextBox AreaThresholdB
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.IonAreaThresholdSlave.Setting"))); }
        }
        public static TextBox BaselineMeanB
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.BaseSubstractSlave.Setting"))); }
        }
        public static TextBox TimeDelayB
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.TimeDelaySlave.Setting"))); }
        }
        public static TextBox ChannelBMultiplier
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.GainScallingSlave.Setting"))); }
        }
        public static TextBox TriggerThreshold
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.TriggerVoltage.Setting"))); }
        }
        public static Dropdown InputChannel
        {
            get { return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("TofADC.InputSignal.Setting"))); }
        }
        public static Dropdown SignalSource
        {
            get { return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("TofADC.SignalSource.Setting"))); }
        }
        public static Dropdown PulseShaping
        {
            get { return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("TofADC.EchoMaster.Setting"))); }
        }
        public static TextBox OutputScalingFactor
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.GainFinalDivide.Setting"))); }
        }
        public static TextBox AverageIonIntensitySettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.AverageIonArea.Setting"))); }
        }
        public static TextBox AverageIonAreaMZSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.AverageIonAreaMZ.Setting"))); }
        }
        public static TextBox AverageIonAreaChargeSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("TofADC.AverageIonAreaCharge.Setting"))); }
        }
        public static TextBox T0
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Acquisition.T0.Setting"))); }
        }
        public static TextBox VeffSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Acquisition.Veff.Setting"))); }
        }
        public static Button VeffCalculatorButton
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("veffCalcBtn"))); }
        }
        public static Dropdown ADCAlgorithm
        {
            get { return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("TofADC.OperateAlgorithm.Setting"))); }
        }
        #endregion Controls
    }
}