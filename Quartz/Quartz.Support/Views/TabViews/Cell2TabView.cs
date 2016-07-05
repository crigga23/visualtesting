using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class Cell2TabView
    {

        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {                  
                    { "Cell2 Entrance (V)", new ControlGroup (() => EntranceTextBox, () => EntranceReadBackTextBox ) },
                    { "Gradient (V)", new ControlGroup (() => GradientTextBox ) },
                    { "Static Offset (V)", new ControlGroup (() => StaticOffsetTextBox ) },
                    { "Offset B (V)", new ControlGroup (() => OffsetBTextBox ) },
                    { "Offset C (V)", new ControlGroup (() => OffsetCTextBox ) },
                    { "Cell2 Exit (V)", new ControlGroup (() => ExitTextBox, () => ExitReadBackTextBox ) },
                    { "Exit Trap (V)", new ControlGroup (() => ExitTrapTextBox ) },
                    { "Exit Extract (V)", new ControlGroup (() => ExitExtractTextBox ) }
                   
                };
            }
        }

        #region Controls
        public static TextBox EntranceTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.EntranceOutputOffset.Setting"))); }
        }
        public static TextBox EntranceReadBackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.Entrance.Readback"))); }
        }
        public static TextBox GradientTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("VoltageBias.Bias5.Setting"))); }
        }
        public static TextBox StaticOffsetTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("VoltageBias.collisionStaticOffset.Setting"))); }
        }
        public static TextBox OffsetBTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell2.OffsetB.Setting"))); }
        }
        public static TextBox OffsetCTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell2.OffsetC.Setting"))); }
        }
        public static TextBox ExitTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.ExitOutputOffset.Setting"))); }
        }
        public static TextBox ExitReadBackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Cell1.Exit.Readback"))); }
        }
        public static TextBox ExitTrapTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.TrappingVoltage.Setting"))); }
        }
        public static TextBox ExitExtractTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.ExtractionVoltage.Setting"))); }
        }
        #endregion Controls
    }
}