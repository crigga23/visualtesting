namespace Quartz.Support
{
    public class LocalWebDriverConfiguration : IWebDriverConfiguration
    {
        public string Browser { get; set; }

        public LocalWebDriverConfiguration(string browser)
        {
            Browser = browser;
        }
    }
}