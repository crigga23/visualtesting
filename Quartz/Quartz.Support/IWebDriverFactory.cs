using OpenQA.Selenium;

namespace Quartz.Support
{
    public interface IWebDriverFactory
    {
        IWebDriver CreateDriver(IWebDriverConfiguration localWebDriverConfiguration);
    }
}