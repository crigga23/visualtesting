namespace Quartz.Support.Configuration
{
    public interface ITestConfiguration
    {
        string ApplicationUrl { get; set; }
        string ApplicationPort { get; set; }
        string Browser { get; set; }
        string ConfigDirectory { get; set; }
        string DefaultWait { get; set; }
        bool EnableTrace { get; set; }
        string Instrument { get; set; }
        string InstrumentName { get; set; }
        bool IsRunningHeadless { get; set; }
        string QuartzAutomationUserName { get; set; }
        string QuartzAutomationPassword { get; set; }
        string QuartzReportDirectory { get; set; }
        bool SuperSpeed { get; set; }
        bool TakeScreenshots { get; set; }
        string TyphoonConfigDirectory { get; set; }
        string TyphoonDataStoreDirectory { get; set; }
        string TyphoonInstallerName { get; set; }
        string TyphoonMSIInstallerLocation { get; set; }
        bool UseBootstrapStyling { get; set; }
        bool UseSimulatedInstrument { get; set; }
        string InstrumentMethodDirectory { get; set; }
    }
}