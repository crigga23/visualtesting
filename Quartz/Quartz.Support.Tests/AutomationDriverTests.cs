using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Tests
{
    [TestClass]
    public class AutomationDriverTests
    {
        public IWebDriver driver;

        [TestCleanup]
        public void Quit()
        {
            if (driver != null)
            {
                driver.Quit();
            }
        }

        [TestMethod]
        public void AutomationDriver_Create_Returns_IWebDriver()
        {
            driver = AutomationDriver.Create();
            Assert.IsInstanceOfType(driver, typeof(IWebDriver));
        }
    }
}