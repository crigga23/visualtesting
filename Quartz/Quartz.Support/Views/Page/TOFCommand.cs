using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Page
{
    public class TOFCommand
    {
        private readonly TunePage _tunePage;

        public TOFCommand(TunePage tunePage)
        {
            _tunePage = tunePage;
        }

        public void Start()
        {
            // This should switch windows so that the TOF button can be clicked
            var windows = AutomationDriver.Driver.WindowHandles;

            foreach (string window in windows)
            {
                AutomationDriver.Driver.SwitchTo().Window(window);
                if (AutomationDriver.Driver.CurrentWindowHandle.Contains(window))
                {
                    break;
                }
            }

            IWebElement tofButton = AutomationDriver.Driver.FindElement(By.Id("TOFMode.TOF.Mode"));
            if (tofButton != null)
            {
                tofButton.Click();
            }
        }
    }
}