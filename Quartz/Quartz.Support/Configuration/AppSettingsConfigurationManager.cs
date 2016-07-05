using System.Configuration;

namespace Quartz.Support.Configuration
{
    public class AppSettingsConfigurationManager : IAppSettingsConfigurationManager
    {
        public virtual string GetAppSetting(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }
    }
}