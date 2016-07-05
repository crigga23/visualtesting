using Automation.SystemSupport.Lib;
using Automation.Typhoon.Lib;
using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;

namespace Quartz.Features
{
    /// <summary>
    /// This class is designed to be used by TestRunner 
    /// to display in the console or in the reports relevant information for this project.
    /// The methods are invoked using reflection.
    /// </summary>
    public static class VersionsHelper
    {
        private static string Instrument
        {
            get
            {
                //not using ConfigurationManager.AppSettings to load the value from app.config as this is not working when the method is invoked via reflection
                return AppConfigReader.GetAppConfigValue(Assembly.GetExecutingAssembly().Location, "Instrument");
            }
        }


        /// <summary>
        /// This method is designed to be used by TestRunner to display the tested builds at the start and the end of an execution.
        /// The method is invoked using reflection.
        /// </summary>
        public static string GetTestedBuilds()
        {
            string testedBuilds = string.Empty;
            try
            {
                string typhoonBuild = TyphoonInfo.GetTyphoonBuild();

                if (!string.IsNullOrEmpty(typhoonBuild))
                    testedBuilds = string.Format("Typhoon {0}, {1}", typhoonBuild, Instrument);
            }
            catch
            {
                //ignore any exception at this level
            }

            return testedBuilds;
        }


        /// <summary>
        /// This method is designed to be used by TestRunner to customize the report header with project specific information.
        /// The method is invoked using reflection.
        /// </summary>
        public static List<string> GetReportHeaderInformation()
        {
            return new List<string>()
            {
                "Instrument: " + Instrument,
                "Typhoon build: " + TyphoonInfo.GetTyphoonBuild(),
                "Browser: Chrome",
                "Browser version: " + GetChromeBrowserVersion()
            };
        }

        internal static string GetChromeBrowserVersion()
        {
            try
            {
                var path = Registry.GetValue(@"HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe", "", null);
                if (path != null)
                    return FileVersionInfo.GetVersionInfo(path.ToString()).FileVersion;
                else
                    return string.Empty;
            }
            catch (Exception) 
            { 
                return string.Empty; 
            }
        }
    }
}