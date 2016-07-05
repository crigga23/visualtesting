using Microsoft.VisualStudio.TestTools.UnitTesting;
using Quartz.Support.Exceptions;
using Quartz.Support.Views.Page;

namespace Quartz.Support.Tests.Views.Page
{
    [TestClass]
    public class TunePageTests
    {
        [TestMethod]
        public void SwitchConfiguration_Throws_NoSuchInstrumentModeException()
        {
            // arrange
            var expected = "No such instrument mode exists for 'test' mode";
            var actual = string.Empty;

            // act
            try
            {
                new TunePage().SwitchConfiguration("test", string.Empty);
                Assert.Fail("No such instrument mode exception should have been thrown");
            }
            catch (NoSuchInstrumentModeException ex)
            {
                actual = ex.Message;
                Assert.AreEqual(expected, actual);
            }
        }

        [TestMethod]
        public void SwitchConfiguration_Throws_NoSuchInstrumentPolarityException()
        {
            // arrange
            var expected = "No such instrument polarity exists for 'test' polarity";
            var actual = string.Empty;

            // act
            try
            {
                new TunePage().SwitchConfiguration(string.Empty, "test");
                Assert.Fail("No such instrument polarity exception should have been thrown");
            }
            catch (NoSuchInstrumentPolarityException ex)
            {
                actual = ex.Message;
                Assert.AreEqual(expected, actual);
            }
        }
    }
}