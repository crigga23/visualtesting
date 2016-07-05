using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Quartz.Support.Configuration;
using Waters.Control.Client;
using Waters.Control.Message.InstrumentSetup;

namespace Quartz.Support.GeneralHelpers
{
    public static class TyphoonHelper
    {

        private static ITestConfiguration TestConfiguration;
        static TyphoonHelper()
        {
            TestConfiguration = new TestConfiguration(new AppSettingsConfigurationManager());
        }

        public static string TyphoonVersion { get; set; }
        public static KeyValueStore KeyValueStore { get { return TyphoonFactory.Instance.KeyValueStore; } }
        public static bool SimulatedInstrument { get { return Convert.ToBoolean(ConfigurationManager.AppSettings["UseSimulatedInstrument"]); } }
        public static string IpAddress { get { return ConfigurationManager.AppSettings["IpAddress"]; } }
        public static bool EnableTrace { get { return Convert.ToBoolean(ConfigurationManager.AppSettings["EnableTrace"]); } }
        public static string TuneSetDirectory { get { return string.Concat(BinDirectory, "\\tune_sets"); } }
        public static string BinDirectory { get { return ServiceHelper.GetTyphoonBinFolder(); } }
        public static string MethodsDirectory { get { return string.Concat(ServiceHelper.GetTyphoonBinFolder(), ConfigurationManager.AppSettings["TyphoonConfigPath"], "methods"); } }
        public static string ConfigDirectory { get { return string.Concat(ServiceHelper.GetTyphoonBinFolder(), ConfigurationManager.AppSettings["TyphoonConfigPath"]); } }
        public static string TyphoonDataStoreLocation
        {
            get { return string.Concat(ServiceHelper.GetTyphoonBinFolder(), ConfigurationManager.AppSettings["TyphoonDataStoreLocation"]); }
        }
        public static bool UseBootstrapStyling { get { return TestConfiguration.UseBootstrapStyling; } }

        public static bool SuperSpeed { get { return Convert.ToBoolean(ConfigurationManager.AppSettings["SuperSpeed"]); } }

        public static void EnableSuperSpeed()
        {
            if (SimulatedInstrument && SuperSpeed)
                SetKeyValueStoreParameterValue("Simulator", "Simulation.EnableSuperSpeed", "1");
        }

        public static void DisableSuperSpeed()
        {
            if (SimulatedInstrument && SuperSpeed)
                SetKeyValueStoreParameterValue("Simulator", "Simulation.EnableSuperSpeed", "0");
        }

        /// <summary>
        /// Switches the source on the simulator
        /// </summary>
        /// <param name="sourceType">source e.g. ESI, APCI, ESI LOCKSPRAY, APCI LOCKSPRAY, NANO LOCKSPRAY, NANOFLOW</param>
        public static void SetSourceTypeOnSimulator(string sourceType)
        {
            SetKeyValueStoreParameterValue("Simulator", "Simulation.SourceType", sourceType);
            Check.IsTrue(GetSourceType().Equals(sourceType), string.Concat("Typhoon source type is ", sourceType));
        }

        public static string GetSourceType()
        {
            return GetKeyValueStoreParameterValue("Simulator", "Simulation.SourceType");
        }

        /// <summary>
        /// Set the value of a parameter in the KeyValueStore
        /// </summary>
        /// <param name="room">the room e.g. "Simulator"</param>
        /// <param name="parameter">the key e.g. Simulation.SourceType</param>
        /// <param name="value">The value you want to set it to</param>
        public static void SetKeyValueStoreParameterValue(string room, string parameter, string value)
        {
            Report.Debug(string.Format("Setting KeyValueStore parameter: Room: {0}; Parameter: {1}; Value: {2}", room, parameter, value));
            var wait = new AutoResetEvent(false);

            var storeRoom = KeyValueStore.Open(room);

            Action<string> waitSet = (s) => wait.Set();

            try
            {
                storeRoom.Subscribe<string>(parameter, waitSet);
                storeRoom.Put(parameter, value);

                wait.WaitOne(1000);
            }
            finally
            {
                // Unsubscribe
            }
        }

        public static void ResetSlotRunStates(List<Slot> slots)
        {
            var instrumentResultsRoom = KeyValueStore.Open("InstrumentSetupClient");
            Report.Debug("Resetting slot statuses...");

            foreach (var slot in slots)
            {
                SlotUI slotUI = instrumentResultsRoom.Get<SlotUI>(slot.AutomationId);
                slotUI.status = ApplicationStatus.APPLICATION_NOT_RUN;
                instrumentResultsRoom.Put(slot.AutomationId, slotUI);
            }

            Wait.Until(f => slots.TrueForAll(s => s.RunState == "Not Run"), 30000);
            Report.Screenshot();
        }

        /// <summary>
        /// Get the value of a parameter in KeyValueStore
        /// </summary>
        /// <param name="room">the room e.g. "Simulator"</param>
        /// <param name="parameter">the key e.g. Simulation.SourceType</param>
        /// <returns>string</returns>
        public static string GetKeyValueStoreParameterValue(string room, string parameter)
        {
            var storeRoom = KeyValueStore.Open(room);
            return storeRoom.Get<string>(parameter);
        }

        public static double GetHardwareControlParameterValue(string id)
        {
            return TyphoonFactory.Instance.HardwareControl.Get(id);
        }

        public static string GetHardwareControlMode(string mode)
        {
            return TyphoonFactory.Instance.HardwareControl.GetMode(mode);
        }

        public static string GetLatestQuartzInstallerPath()
        {
            IEnumerable<string> typhoonMsiInstallerList = GetTyphoonMsiInstallerList();
            string latestQuartzInstallerPath = GetLatestQuartzMsiInstaller(typhoonMsiInstallerList);
            GetQuartzMsiInstallerVersionString(latestQuartzInstallerPath);

            Report.Action(string.Format("The path for the latest version of Waters Embedded Analyser Platform is: {0}", latestQuartzInstallerPath));

            return latestQuartzInstallerPath;
        }

        private static string GetLatestQuartzMsiInstaller(IEnumerable<string> typhoonMsiInstallerList)
        {
            string typhoonInstallerFilenamePart = "Waters";
            string latestQuartzInstallerPath = string.Empty;
            latestQuartzInstallerPath = typhoonMsiInstallerList.Where(x => x.Contains(typhoonInstallerFilenamePart)).OrderByDescending(f => new FileInfo(f).CreationTimeUtc)
                                                 .Take(1).ElementAt(0);
            Report.Action("Retrieved the path for latest version of the Waters Embedded Analyser Platform MSI installer");
            return latestQuartzInstallerPath;
        }

        private static void GetQuartzMsiInstallerVersionString(string latestQuartzInstallerPath)
        {
           if (latestQuartzInstallerPath.Contains("Waters"))
            {
                string installerName = latestQuartzInstallerPath.Substring(latestQuartzInstallerPath.IndexOf("Waters"));
                TyphoonVersion = installerName.Split(new string[] { ".msi" }, StringSplitOptions.None)[0].Substring(installerName.LastIndexOfAny(new char[]{'v', 'V'}));
                if (!string.IsNullOrWhiteSpace(TyphoonVersion))
                {
                    TyphoonVersion = TyphoonVersion.ToUpperInvariant().Trim().Replace("V", string.Empty).Trim();
                }
                
            }
            Report.Action(string.Format("The latest version of Waters Embedded Analyser Platform is: {0} ", TyphoonVersion));
        }

        private static IEnumerable<string> GetTyphoonMsiInstallerList()
        {
            string typhoonMsiInstallerLocation = ConfigurationManager.AppSettings["TyphoonMsiInstallerLocation"];
            IEnumerable<string> typhoonMsiInstallerList = Directory.GetFiles(typhoonMsiInstallerLocation,
                    string.Concat(ConfigurationManager.AppSettings["TyphoonInstallerName"], " *.msi"), SearchOption.TopDirectoryOnly).ToList();
            
            Report.Action("Retrieved List of Waters Embedded Analyser Platform MSI installers");

            return typhoonMsiInstallerList;
        }
      
        public static void WaitForSettle()
        {
            Wait.ForMilliseconds(1000);
            Report.Action("Waiting for instrument conditions to settle.");

            if (TyphoonFactory.Instance.InstrumentMonitor.ReadyState.readyStatus ==
                Waters.Control.Message.InstrumentMonitor.InstrumentReadyStatus._IM_Ready)
            {
                Report.Pass("Instrument is already settled.");
                return;
            }

            var waitForReady = new AutoResetEvent(false);

            Action<Waters.Control.Message.InstrumentMonitor.ReadyState> readyStateHandler = e =>
            {
                if (e.readyStatus == Waters.Control.Message.InstrumentMonitor.InstrumentReadyStatus._IM_Ready ||
                    e.readyStatus == Waters.Control.Message.InstrumentMonitor.InstrumentReadyStatus._IM_Timeout)
                {
                    waitForReady.Set();
                }
            };

            TyphoonFactory.Instance.InstrumentMonitor.ReadyStateChange += readyStateHandler;

            try
            {
                var stopwatch = Stopwatch.StartNew();

                if (waitForReady.WaitOne(60000))
                {
                    Report.Action(string.Format("Instrument settled in {0} ms.", stopwatch.ElapsedMilliseconds));
                }
                else
                {
                    Report.Fail(string.Format(
                        "Instrument has not settled in 60 seconds. Current InstrumentReadyStatus is '{0}'.",
                        TyphoonFactory.Instance.InstrumentMonitor.ReadyState.readyStatus), true);

                    //TODO: Temporary to establish if the Instrument does eventually settle
                    waitForReady.Reset();

                    if (waitForReady.WaitOne(30000))
                    {
                        Report.Action(string.Format("Instrument settled in {0} ms.", stopwatch.ElapsedMilliseconds));
                    }
                    else
                    {
                        Report.Fail(string.Format(
                        "Instrument has not settled in after another 30 seconds. Current InstrumentReadyStatus is '{0}'.",
                        TyphoonFactory.Instance.InstrumentMonitor.ReadyState.readyStatus), true);
                    }
                    //TODO: Temporary to establish if the Instrument does eventually settle
                }
            }
            finally
            {
                TyphoonFactory.Instance.InstrumentMonitor.ReadyStateChange -= readyStateHandler;
            }
        }
    }
}
