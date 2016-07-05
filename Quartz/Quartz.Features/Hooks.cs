using Automation.Reporting.Lib;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.Modals;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features
{
    [Binding]
    class Hooks
    {

        private static StringWriter BeforeFeatureWriter;
        private static StringWriter BeforeTestRunWriter;
        private static bool EnableTrace = TyphoonHelper.EnableTrace;
        private static bool AppendConsoleOutput = false;
        private static TextWriter OriginalOutputStream;
        [BeforeTestRun]
        public static void BeforeTestRun()
        {
            // preserve the original stream
             OriginalOutputStream = Console.Out;
            try
            {
                //Allow append output of BeforeTestAndFeature in Before Scenario
                AppendConsoleOutput = false;

                BeforeTestRunWriter = new StringWriter();
                Console.SetOut(BeforeTestRunWriter);
                Report.Action("Start of BeforeTestRun");

                // kill application error reporting process before starting debug monitor.
                ServiceHelper.KillMSErrReportingProcess();

                if (EnableTrace)
                {
                    try
                    {
                        DebugLogger.StartTest();
                        Report.Action("End of Debug Monitor");
                    }
                    catch (Exception)
                    {
                        Report.Debug("Encountered an exception starting DebugLogger. Attempting to close existing instances and retry...");
                        DebugLogger.Close();
                        DebugLogger.StartTest();
                    }

                }

                Debug.WriteLine("-------------------------------------------");
                Debug.WriteLine("Start of Test Run");
                Debug.WriteLine("-------------------------------------------");

                ServiceHelper.KillChromeProcesses();

                ServiceHelper.KillProcessesByName("MSTest.exe");

                ServiceHelper.KillTestRunnerProcesses();
            }
            catch (ThreadAbortException ex)
            {
                Report.Warn("ThreadAbortException in BeforeTestRun");
                FeatureContext.Current.Add("BeforeTestRunException", ex.ToString());
            }
            catch (Exception e)
            {
                Report.Warn("Exception in BeforeTestRun");
                FeatureContext.Current.Add("BeforeTestRunException", e.ToString());
            }
            finally
            {
                Report.Action("End of BeforeTestRun");
                BeforeTestRunWriter.Close();
                // Redirect output to standard console output stream
                Console.SetOut(OriginalOutputStream);
            }
        }

        [BeforeFeature]
        public static void BeforeFeature()
        {
            BeforeFeatureWriter = new StringWriter();
            Console.SetOut(BeforeFeatureWriter);

            Report.Action("Start of BeforeFeature");

            ReportHelper.SetupQuartzReport();

            FeatureContext.Current.Add("FluidicsRequired", false);

            if (FeatureContext.Current.FeatureInfo.Title.Equals("KIT - Quartz Installation")) return;
            if (FeatureContext.Current.FeatureInfo.Tags.Contains("visualtestingfeature")) return;            // JUST RETURN FOR VISUAL TESTING!!!!)

            Debug.WriteLine("-------------------------------------------");
            Debug.WriteLine("Start of Feature: " + FeatureContext.Current.FeatureInfo.Title);
            Debug.WriteLine("-------------------------------------------");

            try
            {
                ServiceHelper.StartTyphoonAndQuartz();
            }
            catch (OpenQA.Selenium.WebDriverException webDriverEx)
            {
                Report.Warn("WebDriverException in BeforeFeature ");
                FeatureContext.Current.Add("BeforeFeatureException", webDriverEx.Message);
            }
            catch (ThreadAbortException ex)
            {
                Report.Warn("ThreadAbortException in BeforeFeature ");
                FeatureContext.Current.Add("BeforeFeatureException", ex.Message);
            }
            catch (Exception e)
            {
                Debug.WriteLine("automation: Exception occurred in Before Feature...");
                if (e.GetType().IsAssignableFrom(typeof(System.Net.Sockets.SocketException)))
                {
                    CaptureSocketInformation();
                }
                FeatureContext.Current.Add("BeforeFeatureException", e.ToString());
            }
            finally
            {
                Report.Action("End of BeforeFeature");
                BeforeFeatureWriter.Close();
                // Redirect output to standard console output stream
                Console.SetOut(OriginalOutputStream);
            }

        }

        [BeforeScenario]
        public static void BeforeScenario()
        {
            if (FeatureContext.Current.FeatureInfo.Tags.Contains("visualtestingfeature")) return;            // JUST RETURN FOR VISUAL TESTING!!!!

            try
            {
                 
                if (!AppendConsoleOutput)
                {
                    WriteOutputStream(BeforeTestRunWriter);
                    WriteOutputStream(BeforeFeatureWriter);
                    AppendConsoleOutput = true;
                }
                
                Report.Action("Start of BeforeScenario");
                Debug.WriteLine("Starting Automated Test: " + ScenarioContext.Current.ScenarioInfo.Title);

                if (FeatureContext.Current.ContainsKey("BeforeTestRunException"))
                {
                    // Report.fail adds an exception to ScenarioContext which ensures the test will fail
                    Report.Fail("Something went wrong in the Before Test Run", true);
                    Report.Debug(FeatureContext.Current.Get<string>("BeforeTestRunException"));
                    Report.Screenshot();
                }

                if (FeatureContext.Current.ContainsKey("BeforeFeatureException"))
                {
                    // Report.fail adds an exception to ScenarioContext which ensures the test will fail
                    Report.Fail("Something went wrong in the Before Feature", true);
                    Report.Debug(FeatureContext.Current.Get<string>("BeforeFeatureException"));
                    Report.Screenshot();
                }
            }
            catch (ThreadAbortException ex)
            {
                Report.Fail("ThreadAbortException in BeforeScenario" + ex.ToString());
            }
            catch (Exception e)
            {
                Report.Fail("Exception in BeforeScenario" + e.ToString());
            }
            finally
            {
                Report.Action("End of BeforeScenario");
            }
        }

        [AfterScenario]
        public static void AfterScenario()
        {

            if (FeatureContext.Current.FeatureInfo.Tags.Contains("visualtestingfeature")) return;            // JUST RETURN FOR VISUAL TESTING!!!!

            Report.Action("Start of After Scenario");

            try
            {
                try
                {
                    Modal.CloseModalIfOpen();
                }
                catch (Exception) { }

                if (FeatureContext.Current.ContainsKey("BeforeFeatureException"))
                {

                    if (EnableTrace)
                    {
                        DebugLogger.OutputOnFailure();
                    }

                    Report.Fail("Something went wrong in the Before Feature", true);
                    Report.ScreenshotOfDesktop();

                    Report.Action("Restarting Typhoon and Quartz in preparation for the next test...");
                    FeatureContext.Current.Remove("BeforeFeatureException");
                    ServiceHelper.RestartTyphoonAndQuartz();
                }

                if (!FeatureContext.Current.FeatureInfo.Title.Equals("KIT - Quartz Installation"))
                {
                    if (FeatureContext.Current.Get<bool>("FluidicsRequired"))
                        TunePage.FluidicsSetup.EnsureSampleAndReferenceNotInfusing();
                }

                if (ScenarioContext.Current.TestError != null)
                {
                    if (EnableTrace)
                    {
                        DebugLogger.OutputOnFailure();
                    }

                    var error = ScenarioContext.Current.TestError;
                    Report.Fail("Test Failed. Screenshot at time of test failure:", true);
                }

                Debug.WriteLine("Ending Automated Test: " + ScenarioContext.Current.ScenarioInfo.Title);

                if (ScenarioContext.Current.ContainsKey("EXCEPTION"))
                {
                    throw new AssertFailedException("One or more steps failed");
                }

                ReportContext.Current.ThrowPendingExceptions();
            }
            catch (ThreadAbortException ex)
            {
                Report.Fail("ThreadAbortException in AfterScenario" + ex.ToString());
            }
            finally
            {
                Report.Action("End of AfterScenario");
            }
        }

        [AfterFeature]
        public static void AfterFeature()
        {
            if (FeatureContext.Current.FeatureInfo.Tags.Contains("visualtestingfeature")) return;            // JUST RETURN FOR VISUAL TESTING!!!!
            Report.Action("Running AfterFeature steps...");

            try
            {

                if (FeatureContext.Current.FeatureInfo.Title == "KIT - Quartz Installation") return;

                Debug.WriteLine("-------------------------------------------");
                Debug.WriteLine("End of Feature: " + FeatureContext.Current.FeatureInfo.Title);
                Debug.WriteLine("-------------------------------------------");

                ServiceHelper.StopTyphoonAndQuartz();

                Report.Action("Finished AfterFeature steps...");
            }
            catch (ThreadAbortException ex)
            {
                Report.Fail("ThreadAbortException in AfterFeature" + ex.ToString());
            }
            catch (Exception e)
            {
                Report.Fail("Exception in AfterFeature" + e.ToString());
            }
            finally
            {
                Report.Action("End of AfterFeature");
            }
        }

        [AfterTestRun]
        public static void AfterTestRun()
        {
            Report.Action("Start of AfterTestRun");

            try
            {
                if (EnableTrace)
                {
                    DebugLogger.Close();
                }
            }
            catch (ThreadAbortException ex)
            {
                Report.Fail("ThreadAbortException in AfterTestRun" + ex.ToString());
            }
            catch (Exception e)
            {
                Report.Fail("Exception in AfterTestRun" + e.ToString());
            }
            finally
            {
                // kill application error reporting process after  stoping debug monitor.
                ServiceHelper.KillMSErrReportingProcess();
                ServiceHelper.KillChromeProcesses();
                Report.Action("End of AfterTestRun");
            }
        }

        private static void CaptureSocketInformation()
        {
            Report.Action("Checking Scoket status");
            ProcessStartInfo processStartInfo = new ProcessStartInfo();
            processStartInfo.Arguments = "-a -n -o -b";
            processStartInfo.FileName = "netstat.exe";
            processStartInfo.UseShellExecute = false;
            processStartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            processStartInfo.RedirectStandardInput = true;
            processStartInfo.RedirectStandardOutput = true;
            processStartInfo.RedirectStandardError = true;

            Process process = new Process();
            process.StartInfo = processStartInfo;
            process.Start();
            using (StreamReader reader = process.StandardOutput)
            {
                string result = reader.ReadToEnd();
                string debugfldPath = System.IO.Path.GetDirectoryName(
                                        System.Reflection.Assembly.GetExecutingAssembly().GetName().CodeBase);
                string localPath = debugfldPath + "\\TestResults\\Reports\\Documents";
                string pathString = new Uri(localPath).LocalPath;
                System.IO.Directory.CreateDirectory(pathString);

                string path = Report.DocumentDirectory + "SocketLog.Log";
                StreamWriter Outputwriter;
                Outputwriter = File.CreateText(path);
                Outputwriter.WriteLine(result);
                Outputwriter.Close();
                reader.Close();
                Report.DocumentLocation("SocketLog.Log", "SocketLog");
            }
        }

        private static void WriteOutputStream(StringWriter stringWriter)
        {
            if (stringWriter != null)
            {
                StringReader reader = new StringReader(stringWriter.ToString());
                Console.WriteLine(reader.ReadToEnd());
            }
        }
    }
}
