using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class RFTabView
    {
        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {                  
                    { "StepWave RF (V)", new ControlGroup (() => RFOffsetSettingTextBox, () => RFOffsetReadback ) },
                    { "Trap/IMS RF (V)", new ControlGroup (() => Trap_IMSRFTextBox, () => Trap_IMSRFReadback ) },
                    { "Ion Guide RF Offset (V)", new ControlGroup (() => IonGuideRFOffsetTextBox, () => IonGuideRFOffsetReadback ) },
                    { "Ion Guide RF Gain", new ControlGroup (() => IonGuideRFGainTextBox ) },
                    { "Cell1 RF (V)", new ControlGroup (() => Cell1RFOffsetTextBox, () => Cell1RFOffsetReadback) },
                    { "Cell2 RF Offset (V)", new ControlGroup (() => Cell2RFOffsetTextBox, () => Cell2RFOffsetReadback ) },
                    { "Cell2 RF Gain", new ControlGroup (() => Cell2RFGainTextBox ) },
                    { "MS/MS Ramp Mode", new ControlGroup (() => MSMSRampModeDropdown ) },
                    { "MS/MS Ramp Initial", new ControlGroup (() => MSMSRampInitialTextBox ) },
                    { "MS/MS Ramp Final", new ControlGroup (() => MSMSRampFinalTextBox ) },
                };
            }
        }

        #region Controls
        public static TextBox RFOffsetSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.RFOffset.Setting"))); }
        }
        public static TextBox RFOffsetReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.RFOffset.Readback"))); }
        }
        public static TextBox Trap_IMSRFTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.IonGuideRF.Setting"))); }
        }
        public static TextBox Trap_IMSRFReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Stepwave.IonGuideRF.Readback"))); }
        }
        public static TextBox IonGuideRFOffsetTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.RFProgram.Setting"))); }
        }
        public static TextBox IonGuideRFOffsetReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.RFProgram.Readback"))); }
        }
        public static TextBox IonGuideRFGainTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.RFAmplitude.Setting"))); }
        }
        public static TextBox Cell1RFOffsetTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.RFOffset.Setting"))); }
        }
        public static TextBox Cell1RFOffsetReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.RFOffset.Readback"))); }
        }
        public static TextBox Cell2RFOffsetTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.TwigRFOffset.Setting"))); }
        }
        public static TextBox Cell2RFOffsetReadback
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.TwigRFOffset.Readback"))); }
        }
        public static TextBox Cell2RFGainTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.TwigRFGain.Setting"))); }
        }
        public static Dropdown MSMSRampModeDropdown
        {
            get { return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("Cell2RF.ManualMode.Setting"))); }
        }
        public static TextBox MSMSRampInitialTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.TwigRFRampInitial.Setting"))); }
        }
        public static TextBox MSMSRampFinalTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.TwigRFRampFinal.Setting"))); }
        }
        #endregion Controls
    }
}