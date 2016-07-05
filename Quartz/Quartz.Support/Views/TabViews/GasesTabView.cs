using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class GasesTabView
    {
        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {                  
                    { "Trap Gas (L/min)", new ControlGroup (() => TrapGasTextBox, () => TrapGasReadBackTextBox ) },
                    { "IMS Gas (mL/min)", new ControlGroup (() => IMSGasTextBox, () => IMSGasReadBackTextBox ) },
                    { "CC1 Gas (mL/min)", new ControlGroup (() => CC1GasTextBox, () => CC1GasReadBackTextBox) },
                    { "CC2 Gas (mL/min)", new ControlGroup (() => CC2GasTextBox, () =>  CC2GasReadBackTextBox) }
                };
            }
        }


        #region Controls
        public static TextBox TrapGasTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Trap.MFC.SP.Setting"))); }
        }
        public static TextBox TrapGasReadBackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Trap.MFC.Flowrate.Readback"))); }
        }
        public static TextBox IMSGasTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("IMS.MFC.SP.Setting"))); }
        }
        public static TextBox IMSGasReadBackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("IMS.MFC.Flowrate.Readback"))); }
        }
        public static TextBox CC1GasTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("MFC1.SP.Setting"))); }
        }
        public static TextBox CC1GasReadBackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("MFC1.Flowrate.Readback"))); }
        }
        public static TextBox CC2GasTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("MFC2.SP.Setting"))); }
        }
        public static TextBox CC2GasReadBackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("MFC2.Flowrate.Readback"))); }
        }
        #endregion Controls
    }
}