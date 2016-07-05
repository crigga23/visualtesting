using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.PhantomJS;
using Quartz.Support.Configuration;

namespace Quartz.Support.Tests
{
    [TestClass]
    public class WebDriverFactoryTests
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
        public void WebDriverFactory_Constructor_Throws_ArgumentNullException_When_No_LocalConfiguration_Is_Passed_In()
        {
            try
            {
                driver = new WebDriverFactory().CreateDriver(null);
                Assert.Fail("Failed to throw exception when null local configuration files is passed into constructor");
            }
            catch (ArgumentNullException ex)
            {
                Assert.AreEqual("The local web driver configuration must not be null\r\nParameter name: localWebDriverConfiguration", ex.Message);
            }
        }

        [TestMethod]
        public void WebDriverFactory_Returns_ChromeDriver_For_ChromeLocalWebDriverConfiguration()
        {
            Mock<ITestConfiguration> mock = new Mock<ITestConfiguration>();
            mock.SetupProperty(x => x.Browser, "chrome");

            driver = new WebDriverFactory().CreateDriver(new LocalWebDriverConfiguration(mock.Object.Browser));

            mock.VerifyGet(x => x.Browser, Times.Exactly(1));
            Assert.IsInstanceOfType(driver, typeof(ChromeDriver));
        }
        [TestMethod]
        public void WebDriverFactory_Returns_PhantomJSDriver_For_PhantomJSLocalWebDriverConfiguration()
        {
            Mock<ITestConfiguration> mock = new Mock<ITestConfiguration>();
            mock.SetupProperty(x => x.Browser, "phantomjs");

            driver = new WebDriverFactory().CreateDriver(new LocalWebDriverConfiguration(mock.Object.Browser));

            mock.VerifyGet(x => x.Browser, Times.Exactly(1));
            Assert.IsInstanceOfType(driver, typeof(PhantomJSDriver));
        }

        [TestMethod]
        public void WebDriverFactory_Returns_PhantomJSDriver_For_HeadlessLocalWebDriverConfiguration()
        {
            Mock<ITestConfiguration> mock = new Mock<ITestConfiguration>();
            mock.SetupProperty(x => x.Browser, "headless");

            driver = new WebDriverFactory().CreateDriver(new LocalWebDriverConfiguration(mock.Object.Browser));

            mock.VerifyGet(x => x.Browser, Times.Exactly(1));
            Assert.IsInstanceOfType(driver, typeof(PhantomJSDriver));
        }

        [TestMethod]
        public void WebDriverFactory_Returns_ChromeDriver_When_LocalWebDriverConfiguration_IsEmpty()
        {
            Mock<ITestConfiguration> mock = new Mock<ITestConfiguration>();
            mock.SetupProperty(x => x.Browser, string.Empty);

            driver = new WebDriverFactory().CreateDriver(new LocalWebDriverConfiguration(mock.Object.Browser));

            mock.VerifyGet(x => x.Browser, Times.Exactly(1));
            Assert.IsInstanceOfType(driver, typeof(ChromeDriver));
        }
    }
}