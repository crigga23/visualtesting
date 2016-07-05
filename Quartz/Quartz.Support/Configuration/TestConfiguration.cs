using System;
using System.IO;
using System.Reflection;

namespace Quartz.Support.Configuration
{
    public class TestConfiguration : ITestConfiguration
    {
        private string applicationUrl;
        private string applicationPort;
        private string browser;
        private string configDirectory;
        private string defaultWait;
        private bool enableTrace;
        private string instrument;
        private string instrumentName;
        private bool isRunningHeadless;
        private string quartzAutomationUserName;
        private string quartzAutomationPassword;
        private string quartzReportDirectory;
        private bool superSpeed;
        private bool takeScreenshots;
        private string typhoonConfigDirectory;
        private string typhoonDataStoreDirectory;
        private string typhoonInstallerName;
        private string typhoonMsiInstallerLocation;
        private bool useBootstrapStyling;
        private bool useSimulatedInstrument;
        private string methodDirectory;

        public string ApplicationUrl
        {
            get { applicationUrl = AppSettingsConfigurationManager.GetAppSetting("ApplicationUrl"); return applicationUrl; }
            set { applicationUrl = value; }
        }

        public string ApplicationPort
        {
            get { applicationPort = AppSettingsConfigurationManager.GetAppSetting("ApplicationPort"); return applicationPort; }
            set { applicationPort = value; }
        }

        public string Browser
        {
            get { browser = AppSettingsConfigurationManager.GetAppSetting("Browser"); return browser; }
            set { browser = value; }
        }

        public string ConfigDirectory
        {
            get
            {
                var directory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
                configDirectory = directory + "\\Instruments\\" + Instrument + "\\Config\\";
                return configDirectory;
            }
            set { configDirectory = value; }
        }

        public string DefaultWait
        {
            get { defaultWait = AppSettingsConfigurationManager.GetAppSetting("DefaultWait"); return defaultWait; }
            set { defaultWait = value; }
        }

        public bool EnableTrace
        {
            get { enableTrace = Convert.ToBoolean(AppSettingsConfigurationManager.GetAppSetting("EnableTrace")); return enableTrace; }
            set { enableTrace = value; }
        }

        public string Instrument
        {
            get { instrument = AppSettingsConfigurationManager.GetAppSetting("Instrument"); return instrument; }
            set { instrument = value; }
        }

        public string InstrumentName
        {
            get { instrumentName = AppSettingsConfigurationManager.GetAppSetting("InstrumentName"); return instrumentName; }
            set { instrumentName = value; }
        }

        public bool IsRunningHeadless
        {
            get { isRunningHeadless = Browser.Equals("headless") || Browser.Equals("phantomjs"); return isRunningHeadless; }
            set { isRunningHeadless = value; }
        }

        public string QuartzAutomationUserName
        {
            get { quartzAutomationUserName = AppSettingsConfigurationManager.GetAppSetting("QuartzAutomationUserName"); return quartzAutomationUserName; }
            set { quartzAutomationUserName = value; }
        }

        public string QuartzAutomationPassword
        {
            get { quartzAutomationPassword = AppSettingsConfigurationManager.GetAppSetting("QuartzAutomationPassword"); return quartzAutomationPassword; }
            set { quartzAutomationPassword = value; }
        }

        public string QuartzReportDirectory
        {
            get { quartzReportDirectory = AppSettingsConfigurationManager.GetAppSetting("QuartzReportDirectory"); return quartzReportDirectory; }
            set { quartzReportDirectory = value; }
        }

        public bool SuperSpeed
        {
            get { superSpeed = Convert.ToBoolean(AppSettingsConfigurationManager.GetAppSetting("SuperSpeed")); return superSpeed; }
            set { superSpeed = value; }
        }

        public bool TakeScreenshots
        {
            get { takeScreenshots = Convert.ToBoolean(AppSettingsConfigurationManager.GetAppSetting("TakeScreenshots"));  return takeScreenshots; }
            set { takeScreenshots = value; }
        }

        public string TyphoonConfigDirectory
        {
            get { typhoonConfigDirectory = AppSettingsConfigurationManager.GetAppSetting("TyphoonConfigDirectory"); return typhoonConfigDirectory; }
            set { typhoonConfigDirectory = value; }
        }

        public string TyphoonDataStoreDirectory
        {
            get { typhoonDataStoreDirectory = AppSettingsConfigurationManager.GetAppSetting("TyphoonDataStoreDirectory"); return typhoonDataStoreDirectory; }
            set { typhoonDataStoreDirectory = value; }
        }

        public string TyphoonInstallerName
        {
            get { typhoonInstallerName = AppSettingsConfigurationManager.GetAppSetting("TyphoonInstallerName"); return typhoonInstallerName; }
            set { typhoonInstallerName = value; }
        }

        public string TyphoonMSIInstallerLocation
        {
            get { typhoonMsiInstallerLocation = AppSettingsConfigurationManager.GetAppSetting("TyphoonMSIInstallerLocation"); return typhoonMsiInstallerLocation; }
            set { typhoonMsiInstallerLocation = value; }
        }

        public bool UseBootstrapStyling
        {
            get { useBootstrapStyling = Convert.ToBoolean(AppSettingsConfigurationManager.GetAppSetting("UseBootstrapStyling")); return useBootstrapStyling; }
            set { useBootstrapStyling = value; }
        }

        public bool UseSimulatedInstrument
        {
            get { useSimulatedInstrument = Convert.ToBoolean(AppSettingsConfigurationManager.GetAppSetting("UseSimulatedInstrument")); return useSimulatedInstrument; }
            set { useSimulatedInstrument = value; }
        }

        public string InstrumentMethodDirectory
        {
            get
            {
                var directory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
                methodDirectory = directory + "\\Data\\TestData\\Instruments\\" + Instrument + "\\Methods\\";
                return methodDirectory;
            }
            set { methodDirectory = value; }
        }

        

        public virtual IAppSettingsConfigurationManager AppSettingsConfigurationManager { get; set; }

        public TestConfiguration(IAppSettingsConfigurationManager appSettingsConfigurationManager)
        {
            if (appSettingsConfigurationManager == null)
            {
                throw new ArgumentNullException("appSettingsConfigurationManager", "The AppSettingsConfigurationManager must not be null");
            }

            AppSettingsConfigurationManager = appSettingsConfigurationManager;
        }
    }
}
