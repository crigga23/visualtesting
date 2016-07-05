using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using Applitools;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Microsoft.Win32;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using Quartz.Support.Configuration;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;
using Waters.Control.Client;
using Waters.Control.Client.Interface;
using Waters.Control.Client.InternalInterface;

namespace Quartz.Support.GeneralHelpers
{
    public class ServiceHelper
    {
        public enum WaitType { Wait, NoWait };

        private static bool clearDataStore = true;
        private static TyphoonClientConfiguration typhoonClientConfiguration = null;
        private static bool TyphoonStarted { get; set; }
        private static bool ClearDataStore { get { return clearDataStore; } set { clearDataStore = value; } }
        private static ITestConfiguration TestConfiguration;

        public static BatchInfo Batch { get; set; }
    
        static ServiceHelper()
        {
            TestConfiguration = new TestConfiguration(new AppSettingsConfigurationManager());
        }

        public static void StartTyphoonAndQuartz(bool emptyDataStore = true)
        {
            ClearDataStore = emptyDataStore;
            StartTyphoon();
            StartQuartz();
        }

        public static void RestartTyphoonAndQuartz(bool emptyDataStore = true)
        {
            ClearDataStore = emptyDataStore;
            StopTyphoonAndQuartz();
            StartTyphoonAndQuartz(emptyDataStore);
        }

        public static void StopTyphoonAndQuartz()
        {
            try
            {
                CloseQuartz();
            }
            catch (Exception ex)
            {
                Report.Warn(String.Format("There was an issue closing Quartz: {0}", ex.Message));
            }

            try
            {
                StopTyphoon();
            }
            catch (Exception ex)
            {
                Report.Warn(String.Format("There was an issue stopping Typhoon: {0}", ex.Message));
            }
        }

        #region Typhoon Helpers

        public static string GetTyphoonBinFolder()
        {
            return new SystemManagerLocator().GetTyphoonInstallFolder();
        }

        public static void SetTyphoonBinFolder()
        {
            //Update the bin directory in the registry
            RegistryKey localKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry64);

            RegistryKey binFolder = localKey.OpenSubKey("SOFTWARE\\Waters\\Typhoon", true);
            if (binFolder != null)
            {
                try
                {
                    string currentValue = binFolder.GetValue("TyphoonBinFolder").ToString();

                    string match = @"instruments\\(.*)\\bin";

                    var instrumentBinFolder = Regex.Replace(currentValue, match, "instruments\\" + TestConfiguration.Instrument.ToLower() + "\\bin");

                    binFolder.SetValue("TyphoonBinFolder", instrumentBinFolder, RegistryValueKind.String);
                    binFolder.Close();
                }
                catch (Exception)
                {
                    Report.Fail("Unable to set registry string TyphoonBinFolder");                   
                }
            }
            else
            {
                Report.Fail("Unable to find Typhoon registry key");
            }
        }

        public static void StartTyphoon(bool switchToOperate = true, WaitType waitType = WaitType.Wait)
        {
            SetTyphoonBinFolder();

            Debug.WriteLine("automation: Starting Typhoon...");

            if (WatersProcesses.Count > 0)
                KillWatersProcesses();

            if (ClearDataStore)
                EmptyDataStore();

            if (!TyphoonStarted)
            {
                TyphoonFactory.Create(GetTyphoonClientConfiguration());
                TyphoonFactory.Instance.GetSystemManager().Start();
                TyphoonStarted = true;

                if (waitType == WaitType.Wait)
                {
                    if (switchToOperate)
                        SetInstrumentIntoOperate();
                }
            }
            else
            {
                Report.Action("Typhoon System is already started");
            }
        }

        private static TyphoonClientConfiguration GetTyphoonClientConfiguration()
        {
            if (typhoonClientConfiguration == null)
            {
                typhoonClientConfiguration = new TyphoonClientConfiguration()
                {
                    StartupTyphoon = true,
                    UseSimulatedInstrument = TyphoonHelper.SimulatedInstrument
                };
            }
            return typhoonClientConfiguration;
        }

        public static void StopTyphoon()
        {
            try
            {
                if (TyphoonStarted)
                {
                    TyphoonFactory.Instance.GetSystemManager().Shutdown();
                    TyphoonFactory.Instance.Destroy();
                    TyphoonStarted = false;

                    var systemManager = Process.GetProcessesByName("Waters.Service.SystemManager").FirstOrDefault();

                    if (systemManager != null)
                    {
                        systemManager.WaitForExit(60000);
                    }
                }
            }
            catch (NoTyphoonResponseException e)
            {
                Report.ScreenshotOfDesktop();
                Report.Warn("No Typhoon Response Exception trying to Stop Typhoon...");
                Report.Debug(e.StackTrace);
            }

            Wait.Until(f => WatersProcesses.Count == 0, 10000, "Wating for Typhoon Services to stop...", false);

            if (WatersProcesses.Count > 0)
                KillWatersProcesses();
        }

        private static void SetInstrumentIntoOperate()
        {
            var wait = new AutoResetEvent(false);
            if (!TyphoonFactory.Instance.HardwareControl.IsOnline)
            {
                Debug.WriteLine("automation: Waiting for Hardware Control to come online.");

                Action<bool> onlineEventHandler = o => wait.Set();
                TyphoonFactory.Instance.HardwareControl.OnlineEvent += onlineEventHandler;
                try
                {
                    if (!wait.WaitOne(20000))
                    {
                        Report.Action("Hardware Control failed to come online within 15 seconds.");
                        Debug.WriteLine("automation: Hardware Control failed to come online within 15 seconds.");
                    }
                    else
                    {
                        Report.Action("Hardware Control is online.");
                        Debug.WriteLine("automation: Hardware Control is online.");
                    }
                }
                finally
                {
                    TyphoonFactory.Instance.HardwareControl.OnlineEvent -= onlineEventHandler;
                }
            }

            Report.Action("Putting Hardware Control into Operate.");
            Debug.WriteLine("automation: Putting Hardware Control into Operate.");
            TyphoonFactory.Instance.HardwareControl.Operate();
            TyphoonHelper.WaitForSettle();

            if (TyphoonHelper.SimulatedInstrument)
            {
                Report.Action("Setting Detector Voltage, AverageIonArea, AverageIonAreaCharge, AverageIonAreaMZ for both polarities");
                Debug.WriteLine("automation: Setting Detector Voltage, AverageIonArea, AverageIonAreaCharge, AverageIonAreaMZ for both polarities.");

                //TODO: Change to use SetModeSync
                TyphoonFactory.Instance.HardwareControl.SetMode("Polarity", "Negative");
                TyphoonHelper.WaitForSettle();

                //TODO: Change to use SetSync
                TyphoonFactory.Instance.HardwareControl.Set("TofADC.AverageIonArea.Setting", 8.0);
                TyphoonFactory.Instance.HardwareControl.Set("TofADC.AverageIonAreaCharge.Setting", -1.0);
                TyphoonFactory.Instance.HardwareControl.Set("TofADC.AverageIonAreaMZ.Setting", 554.27);
                TyphoonFactory.Instance.HardwareControl.Set("Detector.MCPDetectorVoltage.Setting", 1700.00);

                TyphoonFactory.Instance.HardwareControl.SetMode("Polarity", "Positive");
                TyphoonHelper.WaitForSettle();

                TyphoonFactory.Instance.HardwareControl.Set("TofADC.AverageIonArea.Setting", 8.0);
                TyphoonFactory.Instance.HardwareControl.Set("TofADC.AverageIonAreaCharge.Setting", 1.0);
                TyphoonFactory.Instance.HardwareControl.Set("TofADC.AverageIonAreaMZ.Setting", 556.27);
                TyphoonFactory.Instance.HardwareControl.Set("Detector.MCPDetectorVoltage.Setting", 1700.00);
            }
            else
            {
                Debug.WriteLine("automation: This is an instrument test run. Importing tune sets...");
                InstrumentHelper.ImportInstrumentTuneSet();
            }

            Report.Action("Finished setting parameter values");
            Debug.WriteLine("automation: Finished setting parameter values");
        }

        public static void EmptyDataStore()
        {
            DirectoryInfo dataStoreInfo = new DirectoryInfo(TyphoonHelper.TyphoonDataStoreLocation);

            if (dataStoreInfo.Exists)
            {
                foreach (FileInfo file in dataStoreInfo.GetFiles())
                {
                    file.Delete();
                }
                foreach (DirectoryInfo dir in dataStoreInfo.GetDirectories())
                {
                    dir.Delete(true);
                }
            }
        }

        #endregion

        #region Quartz Helpers

        public static void StartQuartz()
        {
            if (ChromeProcesses.Count > 0)
            {
                KillChrome();
            }

            InitialiseAutomationDriver();
  
            GoToQuartzLoginPage();

            if (TestConfiguration.UseBootstrapStyling)
            {
                LogIntoQuartzAndGoToFullTuningControls();
                return;
            }

            LoginAsDeveloper();
        }

        public static Eyes Eyes { get; set; }

        public static void CheckPlot()
        {
            ServiceHelper.Eyes.CheckRegion(By.CssSelector(@"#tpPlotContainer > div.panel-body.tune_relayout > div > div"), TimeSpan.FromSeconds(25));
            //ServiceHelper.Eyes.CheckRegion(By.XPath(@"//*[@id='container']/div[1]/ng-view/div[1]"), TimeSpan.FromSeconds(25));
        }

        public static void CheckRegion(By by, TimeSpan amountOfTimeToFindMatch, string tag)
        {
            ServiceHelper.Eyes.CheckRegion(by, amountOfTimeToFindMatch, tag);
        }

        public static void CheckWindow(string tag)
        {
            ServiceHelper.Eyes.CheckWindow(tag);
        }


        private static void InitialiseAutomationDriver()
        {
            Report.Debug("Creating new Automation Driver");
            AutomationDriver.Driver = AutomationDriver.Create();

            Report.Debug("Creating new Eyes object");
            Eyes = new Eyes
            {
                ApiKey = "4CdGxKqBtKsbOdHq2ivjXg1049uDWhQxNpMc5ny5kaS7U110",
                MatchLevel = MatchLevel.Layout
            };

            Report.Debug(string.Format("Setting the batch for the test:{0}", ServiceHelper.Batch.Id));
            Eyes.Batch = ServiceHelper.Batch;

            Report.Debug("Open eyes");
            Eyes.Open(AutomationDriver.Driver, "Quartz", ScenarioContext.Current.ScenarioInfo.Title);
            AutomationDriver.Driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(Wait.ImplicitWaitSeconds));

            InitialiseReportDriver();
        }

        private static void InitialiseReportDriver()
        {
            //The Report needs a reference to the Driver so that it can screenshot.
            Report.Driver = AutomationDriver.Driver;
        }

        public static void CloseQuartz()
        {
            if (AutomationDriver.Driver != null)
            {
                AutomationDriver.Driver.Close();
                AutomationDriver.Driver.Quit();
                Wait.ForMilliseconds(1000);

                Wait.Until(f => ChromeProcesses.Count == 0, 20000, "Waiting for Chrome Browser to close", false);

                if (ChromeProcesses.Count > 0)
                    KillChrome();
            }
        }

        public static void LogIntoQuartzAndGoToFullTuningControls()
        {
            try
            {
                Debug.WriteLine("automation: Login");
                LoginPage.LoginAsAutomationTestUser();
                ServiceHelper.CheckWindow("Successfully Logged in");
                //Debug.WriteLine("automation: Successfully Logged-In");
                ApplicationsPage.GoToQuartzFullTuningControls();
                ServiceHelper.CheckWindow("Entered on Application Page");
                //Debug.WriteLine("automation: Entered on Application Page");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void GoToQuartzLoginPage()
        {
            Report.Action("Navigating to the Quartz Login Page: " + LoginPage.Url);
            AutomationDriver.Driver.Navigate().GoToUrl(LoginPage.Url);
            //Page.CheckUrl(LoginPage.Url);
            ServiceHelper.CheckWindow("Quartz Login Page");
        }


        public static void LoginAsDeveloper()
        {
            Wait.Until(ExpectedConditions.ElementExists(By.Id("developer_login_text")), 120000);
            IWebElement loginButton = AutomationDriver.Driver.FindElement(By.Id("developer_login_text"));
            Thread.Sleep(5000);
            loginButton.Click();

            Wait.Until(ExpectedConditions.ElementExists(By.Id("tpControlsPanel")), 120000);
            Wait.Until(ExpectedConditions.ElementExists(By.Id("tpPlotPanel")), 20000);
            Wait.Until(ExpectedConditions.ElementExists(By.Id("operateStatus.Readback")), 10000);
        }



        #endregion


        private static List<Process> ChromeProcesses
        {
            get
            {
                return Process.GetProcesses()
                    .Where(p => p.ProcessName.StartsWith("chrome"))
                    .ToList();
            }
        }

        private static List<Process> WatersProcesses
        {
            get
            {
                return Process.GetProcesses()
                    .Where(p => p.ProcessName.StartsWith("Waters.") || p.ProcessName.Equals("node"))
                    .ToList();
            }
        }

        /// <summary>
        /// This method kills the windows application error reporting process. This is clean up work before
        ///  starting the next instance of Typhoon.
        /// </summary>
        public static void KillMSErrReportingProcess()
        {
            Debug.WriteLine("automation: Checking for Typhoon crash evidences");

            var processes = Process.GetProcesses()
                   .Where(p => (p.ProcessName.StartsWith("WerFault")) ||
                               (p.ProcessName.StartsWith("WerMgr"))).ToList();

            if (processes.Count > 0)
            {
                Report.Warn("Typhoon is crashed");
                Debug.WriteLine("automation: Cleaning up the Typhoon crash");
                processes.ForEach(p => KillProcess(p));
            }
            else
            {
                Debug.WriteLine("automation: Typhoon was stopped gracefully");
            }
        }

        public static void KillChrome()
        {
            if (TestConfiguration.IsRunningHeadless) return; // Do not bother closing Chrome Processes if running headless

            Report.Warn("Chrome processes are running. Killing all running Chrome Browsers.");
            ChromeProcesses.ForEach(p => KillProcess(p));
            Wait.ForMilliseconds(2000);
        }



        public static void KillWatersProcesses()
        {
            Report.Warn("Waters processes are running. Killing all running 'Waters.' processes");
            WatersProcesses.ForEach(p => KillProcess(p));
            Wait.ForMilliseconds(2000);
        }

        private static void KillProcess(Process p)
        {
            try
            {
                p.Kill();
                p.WaitForExit();
            }
            catch (Exception)
            {
                Report.Warn("Unable to kill process: " + p.ProcessName);
            }
        }

        public static void KillProcessesByName(string processName)
        {
            var processes = Process.GetProcessesByName(processName).ToList();

            if (processes.Count > 0)
            {
                foreach (var process in processes)
                {
                    Debug.WriteLine("Killing process: " + process.ProcessName + " (" + process.Id + ")");
                    process.Kill();
                    Wait.ForMilliseconds(5000);
                }
            }
        }

        public static void KillTestRunnerProcesses()
        {
            var testrunnerProcesses = Process.GetProcessesByName("TestRunner").OrderBy(p => p.StartTime).ToList();

            if (testrunnerProcesses.Count > 0)
            {
                testrunnerProcesses.Remove(testrunnerProcesses.Last());

                foreach (var process in testrunnerProcesses)
                {
                    Debug.WriteLine("Killing process: " + process.ProcessName + " (" + process.Id + ")");
                    process.Kill();
                    Thread.Sleep(5000);
                }
            }
        }

        public static void KillChromeProcesses()
        {
            if (TestConfiguration.IsRunningHeadless) return;  // Do not bother closing Chrome Processes if running headless

            Debug.WriteLine("Cleaning up all running Chrome processes.");
            Process.GetProcesses()
                    .Where(p => p.ProcessName.StartsWith("chrome", StringComparison.OrdinalIgnoreCase))
                    .ToList().ForEach(p => KillProcess(p));
            Wait.ForMilliseconds(2000);
            Debug.WriteLine("Cleaned all Chrome processes.");
        }

    }
}