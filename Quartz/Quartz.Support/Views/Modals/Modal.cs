using System;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Modals
{
    public class Modal
    {
        private const int modalLoadTimeInMilliseconds = 2000;

        public static bool Exists(string automationId = null)
        {
                IWebElement modal;
                if (!string.IsNullOrEmpty(automationId))
                {
                    modal = AutomationDriver.Driver.FindElement(By.Id(automationId), modalLoadTimeInMilliseconds);
                }
                else
                {
                    modal = AutomationDriver.Driver.FindElement(By.ClassName("modal"), modalLoadTimeInMilliseconds);
                }

                if (modal != null)
                    return true;
                else
                    return false;
        }

        public static IWebElement Element
        {
            get
            {
                try
                {
                    return AutomationDriver.Driver.FindElement(By.ClassName("modal"), modalLoadTimeInMilliseconds);
                }
                catch (Exception)
                {
                    return null;
                }
            }
        }

        public static void WaitForOpen(string modalAutomationId = null)
        {
            Wait.Until(f => Exists(modalAutomationId), 15000, "Waiting for modal to be displayed...");
            
            // Allow a little extra time for the modal to fade in.
            Wait.ForMilliseconds(1000); 
        }

        public static void WaitForClose(string modalAutomationId = null)
        {
            Wait.Until(f => !Exists(modalAutomationId), 15000, "Waiting for modal to close...");
        }

        public static void CloseModalIfOpen(string modalAutomationId = null)
        {
            if (Exists(modalAutomationId))
            {
                Close();
            }
        }

        public static void Close()
        {
            Button closeButton = new Button(AutomationDriver.Driver.FindElement(By.CssSelector("button.close")));
            closeButton.Click();

            WaitForClose();
        }
    }
}