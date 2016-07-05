using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Modals
{
    public class RecordAcquisitionModal
    {

        public static string AutomationId = null;

        public static bool Exists { get { return Modal.Exists(AutomationId); } }

        public static void WaitForClose()
        {
            Modal.WaitForClose(AutomationId);
        }

        public static void WaitForOpen()
        {
            Modal.WaitForOpen(AutomationId);
        }

        public static Dropdown RunMethodList
        {
            get 
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("tpRunMethodList"))) 
                { 
                    Label = "RunMethodList"
                }; 
            }
        }

        public static TextBox AcquisitionDataName 
        { 
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpRunInputName"))); } 
        }

        public static Button Start
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("tpRunBtnAcquisition"))); }
        }

        public static Button Cancel
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("tpRunCancelBtnAcquisition"))); }
        }

        public static void StartRecordingAcquisition()
        {
            if (Start.Enabled)
            {
                Start.Click();
            }
        }

        public static void CancelRecordingAcquistion()
        {
            Cancel.Click();
        }
    }
}
