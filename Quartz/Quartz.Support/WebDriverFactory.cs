using System;
using System.IO;
using System.Windows.Forms;
using Applitools;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.PhantomJS;
using OpenQA.Selenium.Remote;

namespace Quartz.Support
{
    public class WebDriverFactory : IWebDriverFactory
    {
        private DesiredCapabilities caps;
        private IWebDriver webDriver;
        private string driverPath;

        private PhantomJSOptions PhantomJSOptions
        {
            get
            {
                PhantomJSOptions PhantomOptions = new PhantomJSOptions();
                caps = DesiredCapabilities.Chrome();
                caps.IsJavaScriptEnabled = true;

                caps.SetCapability(ChromeOptions.Capability, ChromeOptions);
                caps.SetCapability(CapabilityType.TakesScreenshot, true);
                PhantomOptions.AddAdditionalCapability(CapabilityType.BrowserName, caps);
                return PhantomOptions;
            }
        }

        private static ChromeOptions ChromeOptions
        {
            get
            {
                ChromeOptions chromeOptions = new ChromeOptions();
                chromeOptions.AddArgument("start-maximized");
                chromeOptions.AddArgument("--verbose");
                chromeOptions.AddArgument("--disable-extensions");
                return chromeOptions;
            }
        }

        public IWebDriver CreateDriver(IWebDriverConfiguration localWebDriverConfiguration)
        {
            if (localWebDriverConfiguration == null)
            {
                throw new ArgumentNullException("localWebDriverConfiguration", "The local web driver configuration must not be null");
            }
            
            switch (localWebDriverConfiguration.Browser)
            {
                case "visual":
                    GetChromeDriver();


                    //var eyes = new Eyes
                    //{
                    //    ApiKey = "4CdGxKqBtKsbOdHq2ivjXg1049uDWhQxNpMc5ny5kaS7U110",
                    //    MatchLevel = MatchLevel.Layout
                    //};
                    //eyes.Open(webDriver, "Quartz", "Visual Testing - InfoHack");

                    break;
                case "chrome":
                    GetChromeDriver();
                    break;
                case "headless":
                case "phantomjs":
                    Report.Debug("Initializing PhantomJS...");

                    webDriver = new PhantomJSDriver(PhantomJSOptions);
                    break;
                default:
                    GetChromeDriver();
                    break;
            }

            webDriver.Manage().Window.Maximize();
            return webDriver;
        }

        private void GetChromeDriver()
        {
            Report.Debug("Initializing ChromeDriver...");
            driverPath = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            webDriver = new ChromeDriver(driverPath, ChromeOptions, TimeSpan.FromMinutes(3));
        }
    }
}