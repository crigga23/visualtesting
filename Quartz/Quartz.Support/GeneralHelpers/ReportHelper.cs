using System.Configuration;
using System.IO;
using System.Reflection;

namespace Quartz.Support.GeneralHelpers
{
    public class ReportHelper
    {
        public static void SetupQuartzReport()
        {
            string quartzAssemblyLocation = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            SetupQuartzReportDirectory(quartzAssemblyLocation);
            SetupQuartzReportScreenshotDirectory(quartzAssemblyLocation);
        }

        private static void SetupQuartzReportDirectory(string quartzAssemblyLocation)
        {
            string reportsDirectory = string.Concat(quartzAssemblyLocation,
                ConfigurationManager.AppSettings["QuartzReportLocation"]);
            if (!Directory.Exists(reportsDirectory))
            {
                Directory.CreateDirectory(reportsDirectory);
            }
        }

        private static void SetupQuartzReportScreenshotDirectory(string quartzAssemblyLocation)
        {
            string screenshotDirectory = string.Concat(quartzAssemblyLocation,
                ConfigurationManager.AppSettings["QuartzReportLocation"] + "Screenshots\\");
            if (!Directory.Exists(screenshotDirectory))
            {
                Directory.CreateDirectory(screenshotDirectory);
            }
        }
    }
}
