using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class Cell1TabView
    {

        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {                  
                    { "Cell1 Entrance (V)", new ControlGroup (() => EntranceTextBox, () => EntranceReadBackTextBox ) },
                    { "CE2 (V)", new ControlGroup (() => CE2TextBox ) },
                    { "Cell1 Exit (V)", new ControlGroup (() => ExitTextBox, ()=> ExitReadBackTextBox) },
                    { "Hex DC (V)", new ControlGroup (() => HexDCTextBox ) },
                    { "Wave Velocity (m/s)", new ControlGroup (() => WaveVelocityTextBox ) },
                    { "Pulse Height (V)", new ControlGroup (() => PulseHeightTextBox, () => PulseHeightReadBackTextBox) }
                };
            }
        }

        #region Controls
        public static TextBox EntranceTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.EntranceOffset.Setting"))); }
        }
        public static TextBox EntranceReadBackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.Entrance.Readback"))); }
        }
        public static TextBox CE2TextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.Bias.Setting"))); }
        }
        public static TextBox ExitTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.ExitOffset.Setting"))); }
        }
        public static TextBox ExitReadBackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.Exit.Readback"))); }
        }
        public static TextBox HexDCTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.TrapDCOffset.Setting"))); }
        }
        public static TextBox WaveVelocityTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.WaveVelocity.Setting"))); }
        }
        public static TextBox PulseHeightTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.PulseHeight.Setting"))); }
        }
        public static TextBox PulseHeightReadBackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.TwavePulseHeight.Readback"))); }
        }
        #endregion Controls
    }
}