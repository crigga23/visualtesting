using Applitools;
using OpenQA.Selenium;
using Quartz.Support.Configuration;

namespace Quartz.Support.GeneralHelpers
{
    public class AutomationDriver
    {
        public static IWebDriver Driver { get; set; }

        //public static Eyes Eyes { get; set; }

        public static IWebDriver Create()
        {
            return new WebDriverFactory().CreateDriver(new LocalWebDriverConfiguration(new TestConfiguration(new AppSettingsConfigurationManager()).Browser));
        }
    }
}
