using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using OpenQA.Selenium;
using Quartz.Support.Configuration;

namespace Quartz.Support.Tests
{
    [TestClass]
    public class TestConfigurationTests
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
        public void TestConfiguration_Browser_Should_Get_Set()
        {
            Mock<ITestConfiguration> mock = new Mock<ITestConfiguration>();
            mock.SetupProperty(x => x.Browser, It.IsAny<string>());

            driver = new WebDriverFactory().CreateDriver(new LocalWebDriverConfiguration(mock.Object.Browser));

            mock.VerifyGet(x => x.Browser, Times.Exactly(1));
            Assert.AreEqual(It.IsAny<string>(), mock.Object.Browser);
        }

        [Ignore]
        [TestMethod]
        public void TestConfiguration_Instrument_Should_Get_Set()
        {
            Mock<ITestConfiguration> mock = new Mock<ITestConfiguration>();
            mock.SetupProperty(x => x.Instrument, It.IsAny<string>());

            Mock<IAppSettingsConfigurationManager> mockAppSettingsConfigurationManager = new Mock<IAppSettingsConfigurationManager>();
            mockAppSettingsConfigurationManager.Setup(x => x.GetAppSetting(It.IsAny<string>())).Returns(It.IsAny<string>());
        }

        [TestMethod]
        public void TestConfiguration_Throws_ArgumentNullException_When_No_AppSettingsConfigurationManager_Is_Passed_In()
        {
            try
            {
                new Quartz.Support.Configuration.TestConfiguration(null);
                Assert.Fail("Failed to throw exception when null appSettingsConfigurationManager is passed into constructor");
            }
            catch (ArgumentNullException ex)
            {
                Assert.AreEqual("The AppSettingsConfigurationManager must not be null\r\nParameter name: appSettingsConfigurationManager", ex.Message);
            }
        }

        [TestMethod]
        public void TestConfiguration_Constructor_When_AppSettingsConfigurationManager_Is_Provided_Returns_TestConfiguration()
        {
            Mock<IAppSettingsConfigurationManager> mockAppSettingsConfigurationManager = new Mock<IAppSettingsConfigurationManager>();
            mockAppSettingsConfigurationManager.Setup(x => x.GetAppSetting(It.IsAny<string>())).Returns(It.IsAny<string>());

            var testConfiguration = new Quartz.Support.Configuration.TestConfiguration(mockAppSettingsConfigurationManager.Object);

            mockAppSettingsConfigurationManager.Verify();
            Assert.IsInstanceOfType(testConfiguration, typeof(Quartz.Support.Configuration.TestConfiguration));

        }
    }
}