using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Modals
{
    public class RecordDataModal
    {
        public static string AutomationId = "Dialog.TuneRecord";

        public static bool Exists { get { return Modal.Exists(AutomationId); } }

        public static void WaitForClose()
        {
            Modal.WaitForClose(AutomationId);
        }

        public static void WaitForOpen()
        {
            Modal.WaitForOpen(AutomationId);
        }

        public static TextBox FileName
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("rdFileName")))
                {
                    Label = "Filename"
                };
            }
        }

        public static Button SaveButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("rdOkBtn")));
            }
        }

        public static Button DiscardButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("rdDiscardBtn")));
            }
        }

        public static void Save()
        {
            if (SaveButton.Enabled)
            {
                SaveButton.Click();
            }
        }

        public static void Discard()
        {
            DiscardButton.Click();
        }

    }
}
