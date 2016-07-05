using System;
using System.Linq;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using QuartzAutomationSupport.GeneralHelpers;
using QuartzAutomationSupport.Views.Modals;
using Waters.Automation.Reporting;
using WebAutomationFramework.Controls;

namespace QuartzAutomationSupport.Views.Page
{
    public class AboutModal : Modal
    {
        public static Button CancelButton
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("aboutBoxCancelButton"))); }
        }

        public static Button OKButton
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("aboutBoxCloseButton"))); }
        }

        public static Label QuartzLabel
        {
            get { return new Label(AutomationDriver.Driver.FindElement(By.Id("quartzLabel"))); }
        }

        public static Label TyphoonLabel
        {
            get { return new Label(AutomationDriver.Driver.FindElement(By.Id("typhoonLabel"))); }
        }
        
        public static Label DevConsoleLabel
        {
            get { return new Label(AutomationDriver.Driver.FindElement(By.Id("devConsoleLabel"))); }
        }

        public static Label WrensLabel
        {
            get { return new Label(AutomationDriver.Driver.FindElement(By.Id("wrensLabel"))); }
        }

        public static Label AMITSLabel
        {
            get { return new Label(AutomationDriver.Driver.FindElement(By.Id("amitsLabel"))); }
        }

        public static Label WEATLabel
        {
            get { return new Label(AutomationDriver.Driver.FindElementById("weatLabel")); }
        }

        public static Label ManTestLabel
        {
            get { return new Label(AutomationDriver.Driver.FindElementById("manTestLabel")); }
        }

        public static Label CopyRightsLabel
        {
            get { return new Label(AutomationDriver.Driver.FindElementById("copyright")); }
        }

        public static Label AboutBoxDialogHeader
        {
            get { return new Label(AutomationDriver.Driver.FindElementByXPath("/html/body/header/div[1]/form/input[2]")); }
        }

        public static bool ToastContainerExists
        {
            get
            {
                try
                {
                    const int timeToWaitInMilliseconds = 5000;
                    IWebElement toast = AutomationDriver.Driver.FindElement(By.Id("toast-container"),
                        timeToWaitInMilliseconds);
                    return toast != null;
                }
                catch (Exception)
                {
                    return false;
                }
            }
        }

        // TODO: Can this be moved into the framework somewhere so it can be used elsewhere?
        public void PressEscapeKeyOnKeyBoard()
        {
            Actions action = new Actions(AutomationDriver.Driver);
            action.SendKeys(Keys.Escape).Perform();
        }

        public void CheckFormat(string format, Label label, string labelText)
        {
            label.CheckDisplayed();

            string[] labelContents = label.Text.Split(':');

            if (string.IsNullOrEmpty(format))
            {
                Check.IsTrue(string.IsNullOrEmpty(labelContents[1]),
                    string.Format("The format of the '{0}' label is in the correct format: '{1}'", label, format), true);
            }
            else
            {
                string[] expectedContents = Array.ConvertAll(format.Split(','), s => s.TrimStart());

                Check.IsTrue(expectedContents.All(s => labelContents[1].Contains(s)),
                    string.Format("The format of the '{0}' label is in the correct format: '{1}'", label, format), true);
            }
            Report.Screenshot(label.Element);
        }

        public static void CloseModalIfOpen()
        {
            if (Exists)
            {
                OKButton.Click();
            }

        }
    }
}
