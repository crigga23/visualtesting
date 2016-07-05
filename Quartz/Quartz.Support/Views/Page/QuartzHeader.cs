using System;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Page
{
    public class QuartzHeader
    {
        public static Button ToggleLanguage
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("toggleLanguageButton"))); }
        }

        public static Button AboutButton
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("aboutBoxButton"))); }
        }

        public static Button Help
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("helpButton"))); }
        }

        public static Button Logout
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("logOutButton"))); }
        }

        public static Button Applications
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("applicationSelectButton"))); }
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

        public static void WaitForToastContainerToClose()
        {
            Report.Debug("Waiting for Toast container to close");

            while (ToastContainerExists)
            {
                //do nothing
            }
            Report.Debug("Toast closed");
        }

        public static bool QuartzUserLoggedIn
        {
            get
            {
                bool logOutButtonExists = AutomationDriver.Driver.FindElements(By.Id("logOutButton")).Count != 0;
                return logOutButtonExists;
            }
        }
    }
}
