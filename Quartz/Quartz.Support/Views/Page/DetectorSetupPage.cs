using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Timers;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Page
{
    public class DetectorSetupPage : Page
    {
        private const string finalVoltage = "Detector level complete: Final voltage ";
        private const string measuredIonArea = "Measured Ion Area: ";
        private const string completeStatus = "Complete";
        private const string abortStatus = "Aborted";
        private const string errorStatus = "Error";

        public DetectorSetupPageControls Controls;

        private readonly Timer _detectorSetupTimer;

        public static ProcessSetupCommand Process
        {
            get { return new ProcessSetupCommand(new DetectorSetupPage(new DetectorSetupPageControls(new Page()))); }
        }

        public DetectorSetupPage(DetectorSetupPageControls detectorSetupControls)
        {
            Controls = detectorSetupControls;

            _detectorSetupTimer = new Timer
            {
                Interval = 600000,
                Enabled = true
            };
            _detectorSetupTimer.Elapsed += OnTimedEvent;
        }

        #region Methods

        public void RunDetectorSetup(string mode, bool waitForCompletion = true)
        {
            switch (mode)
            {
                case "Positive":
                case "Positive only":
                    Controls.PositiveMassEnabledCheckBox.SelectCheckBox();
                    Controls.NegativeMassEnabledCheckBox.UnSelectCheckBox();
                    break;
                case "Negative":
                case "Negative only":
                    Controls.NegativeMassEnabledCheckBox.SelectCheckBox();
                    Controls.PositiveMassEnabledCheckBox.UnSelectCheckBox();
                    break;
                case "Both":
                case "Positive and Negative":
                    Controls.PositiveMassEnabledCheckBox.SelectCheckBox();
                    Controls.NegativeMassEnabledCheckBox.SelectCheckBox();
                    break;
                default:
                    throw new NotImplementedException("Mode specified has not been implemented");
            }

            if (DetectorSetupIsRunningInPositiveOrNegativeMode)
            {
                Report.Fail("Detector Setup is already running.");
            }
            else
            {
                if (Controls.StartStopButton.Text.Equals("Start"))
                {
                    Controls.StartStopButton.Click();
                }
                else
                {
                    Report.Fail("Start button is not displayed");
                }
            }

            if (waitForCompletion)
            {
                WaitForDetectorSetupToComplete(mode);
                Report.Debug(GetLineFromProgressLogContaining("Time taken:").ToString());
            }
        }

        public bool DetectorSetupIsRunningInPositiveOrNegativeMode
        {
            get
            {
                return Controls.PositiveResultsPanelStatus.Text.Contains("Running")
                            || Controls.NegativeResultsPanelStatus.Text.Contains("Running");
            }
        }

        /// <summary>
        /// Waits for a Complete status 
        /// </summary>
        /// <param name="mode">e.g. Positive, Negative, Positive and Negative or Both</param>
        public void WaitForDetectorSetupToComplete(string mode)
        {
            _detectorSetupTimer.Start();

            bool complete = false;

            while (!complete && _detectorSetupTimer.Enabled)
            {
                System.Windows.Forms.Application.DoEvents();
                Wait.ForMilliseconds(10000);

                if (mode.Equals("Positive") || mode.Equals("Positive only"))
                {
                    complete = Controls.PositiveResultsPanelStatus.Text.Contains(completeStatus);

                    if (Controls.PositiveResultsPanelStatus.Text.Contains(abortStatus))
                    {
                        Report.Debug(Controls.ProgressLogTextArea.Text);
                        Report.Screenshot();
                        Report.Fail("Detector Setup unexpectedly aborted");
                        break;
                    }
                    if (Controls.PositiveResultsPanelStatus.Text.Contains(errorStatus))
                    {
                        Report.Debug(Controls.ProgressLogTextArea.Text);
                        Report.Screenshot();
                        Report.Fail("Error occured while running Detector Setup");
                        break;
                    }
                }
                else if (mode.Equals("Negative") || mode.Equals("Negative only"))
                {
                    complete = Controls.NegativeResultsPanelStatus.Text.Contains(completeStatus);

                    if (Controls.NegativeResultsPanelStatus.Text.Contains(abortStatus))
                    {
                        Report.Debug(Controls.ProgressLogTextArea.Text);
                        Report.Screenshot();
                        Report.Fail("Detector Setup unexpectedly aborted");
                        break;
                    }
                    if (Controls.PositiveResultsPanelStatus.Text.Contains(errorStatus))
                    {
                        Report.Debug(Controls.ProgressLogTextArea.Text);
                        Report.Screenshot();
                        Report.Fail("Error occured while running Detector Setup");
                        break;
                    }
                }
                else if (mode.Equals("Both") || mode.Equals("Positive and Negative"))
                {
                    complete = Controls.PositiveResultsPanelStatus.Text.Contains(completeStatus)
                        && Controls.NegativeResultsPanelStatus.Text.Contains(completeStatus);

                    if (Controls.PositiveResultsPanelStatus.Text.Contains(abortStatus) || Controls.NegativeResultsPanelStatus.Text.Contains(abortStatus))
                    {
                        Report.Debug(Controls.ProgressLogTextArea.Text);
                        Report.Screenshot();
                        Report.Fail("Detector Setup unexpectedly aborted");
                        break;
                    }
                    if (Controls.PositiveResultsPanelStatus.Text.Contains(errorStatus) || Controls.NegativeResultsPanelStatus.Text.Contains(errorStatus))
                    {
                        Report.Debug(Controls.ProgressLogTextArea.Text);
                        Report.Screenshot();
                        Report.Fail("Error occured while running Detector Setup");
                        break;
                    }
                }

                System.Windows.Forms.Application.DoEvents();
            }

            if (_detectorSetupTimer.Enabled == false)
            {
                Report.Debug(Controls.ProgressLogTextArea.Text);
                Report.Screenshot();

                Report.Warn("Running Detector Setup timed out. Clicking stop manually.");
                Controls.StartStopButton.Click();

                Report.Fail("Running Detector Setup timed out. It did not complete within 10 minutes. Restarting Typhoon services.");
                _detectorSetupTimer.Enabled = false;

                ServiceHelper.RestartTyphoonAndQuartz();
            }

            // Report the detector setup status
            switch (mode)
            {
                case "Positive":
                case "Positive only":
                    Check.IsTrue(Controls.PositiveResultsPanelStatus.Text.Contains(completeStatus),
                        "Positive Detector Setup complete");
                    Report.Screenshot(Controls.PositiveMassResultsPanel);
                    break;
                case "Negative":
                case "Negative only":
                    Check.IsTrue(Controls.NegativeResultsPanelStatus.Text.Contains(completeStatus),
                        "Negative Detector Setup is complete");
                    Report.Screenshot(Controls.NegativeMassResultsPanel);
                    break;
                case "Both":
                case "Positive and Negative":
                    Check.IsTrue(Controls.PositiveResultsPanelStatus.Text.Contains(completeStatus)
                                 && Controls.NegativeResultsPanelStatus.Text.Contains(completeStatus),
                        "Positive and Negative Detector Setup are complete");
                    Report.Screenshot();
                    break;
            }
        }

        /// <summary>
        /// Waits for information to start being written to the progress log
        /// </summary>
        /// <returns>Time the information started appearing in the progress log</returns>
        public DateTime WaitForDetectorSetupToStart(int timeOutMilliSeconds = 10000)
        {
            Wait.Until(s => !string.IsNullOrEmpty(Controls.ProgressLogTextArea.Text), timeOutMilliSeconds);

            var startedRunning = DateTime.Now;
            Report.Debug(string.Format("Detector Setup started running at: {0}", startedRunning.ToString()));
            Report.Screenshot();

            return startedRunning;
        }

        private void OnTimedEvent(object sender, ElapsedEventArgs e)
        {
            _detectorSetupTimer.Enabled = false;
        }

        public void SimulateMouseWheelScrollEvent()
        {
            Report.Action("Scroll up in the Progress Log.");

            string javaScript = "var evObj = document.createEvent('MouseEvents');" +
                                "evObj.initMouseEvent(\"mousewheel\",true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);" +
                                "arguments[0].dispatchEvent(evObj);";
            IJavaScriptExecutor js = AutomationDriver.Driver as IJavaScriptExecutor;
            js.ExecuteScript(javaScript, Controls.ProgressLogTextArea.Element);
        }

        public void StopDetectorSetup()
        {
            Report.Action("Stop Detector Setup");
            if (Controls.StartStopButton.Text.Equals("Stop"))
            {
                Controls.StartStopButton.Click();
            }
            else
            {
                Report.Debug("Detector Setup not started. Stop action not performed");
            }
        }

        public string GetProgressLogPositiveVoltage()
        {
            var lines = GetLineFromProgressLogContaining(finalVoltage);
            return lines.FirstOrDefault(c => c.Contains("Positive")).Replace(finalVoltage + "(Positive):", string.Empty).Split('[')[0].Trim();
        }
       

        public string GetProgressLogPositiveIonArea()
        {
            var lines = GetLineFromProgressLogContaining(measuredIonArea);
            return lines.First().Replace(measuredIonArea, string.Empty).Trim();
        }

        public string GetProgressLogNegativeVoltage()
        {
            var lines = GetLineFromProgressLogContaining(finalVoltage);
            return lines.FirstOrDefault(c => c.Contains("Negative")).Replace(finalVoltage + "(Negative):", string.Empty).Split('[')[0].Trim();
        }

        public string GetProgressLogNegativeIonArea()
        {
            var lines = GetLineFromProgressLogContaining(measuredIonArea);
            return lines.Last().Replace(measuredIonArea, string.Empty).Trim();
        }

        public TimeSpan GetDetectorSetupCompletionTime()
        {
            string timeTaken = GetLineFromProgressLogContaining("Time taken:").FirstOrDefault();
            const string pattern = "(?<number>[0-9]+)";

            Regex regex = new Regex(pattern);
            MatchCollection matches = regex.Matches(timeTaken);


            if (matches.Count == 0)
            {
                Report.Fail("The number of matches must be greater than zero");
            }

            int minutes = int.Parse(matches[0].Value);
            int seconds = int.Parse(matches[1].Value);

            return new TimeSpan(0, minutes, seconds);
        }

        private IEnumerable<String> GetLineFromProgressLogContaining(string text)
        {
            string[] messageArray = Controls.ProgressLogTextArea.Text.Split(
                (new string[] { "\r\n" }), StringSplitOptions.None);

            return (from str in messageArray
                    where str.Contains(text)
                    select str);
        }

        #endregion Methods
    }

    public enum ProcessType
    {
        DetectorSetup,
        MeasureIonArea
    }

    public class DetectorSetupPageControls
    {
        private Page parent;

        public DetectorSetupPageControls(Page page)
        {
            parent = page;
        }

        #region Control Constants

        private const string detectorSetupPanelId = "dsDetectorSetupPanel";
        private const string processSelectorId = "dsSetupOptions";
        private const string positiveResultsPanelId = "dsPosResultsPanel";
        private const string negativeResultsPanelId = "dsNegResultsPanel";
        private const string progressLogPanelId = "dsProgressLogPanel";
        private const string progressLogTextAreaId = "progressLogTxtArea";
        private const string followTailCheckboxId = "dsFollowTailChk";
        private const string positiveMassTextboxId = "dsPositiveMass";
        private const string negativeMassTextboxId = "dsNegativeMass";
        private const string positiveMassEnabledCheckboxId = "dsEnablePositiveMass";
        private const string negativeMassEnabledCheckboxId = "dsEnableNegativeMass";
        private const string startButtonId = "dsStartStop";
        private const string positiveDetectorVoltageId = "dsPositiveDetectorVoltage";
        private const string negativeDetectorVoltageId = "dsNegativeDetectorVoltage";
        private const string positiveIonAreaId = "dsPositiveIonArea";
        private const string negativeIonAreaId = "dsNegativeIonArea";
        private const string negResultsStatusId = "dsNegativeResult";
        private const string posResultsStatusId = "dsPositiveResult";

        #endregion Control Constants

        #region Controls
        public Widget DetectorSetupWidget { get { return new Widget(parent.Driver.FindElement(By.Id(detectorSetupPanelId))); } }
        public Dropdown ProcessSelector
        {
            get
            {
                return new Dropdown(parent.Driver.FindElement(By.Id(processSelectorId)))
                {
                    // This is passed thru to prevent Automation.WebFramework.Lib.Control.Label
                    // from trying to call Automation.WebFramework.Lib.Control.GetControlLabel
                    Label = "Process Selector"
                };
            }
        }
        public Widget PositiveMassResultsPanel { get { return new Widget(parent.Driver.FindElement(By.Id(positiveResultsPanelId))); } }
        public Widget NegativeMassResultsPanel { get { return new Widget(parent.Driver.FindElement(By.Id(negativeResultsPanelId))); } }
        public Widget ProgressLog { get { return new Widget(parent.Driver.FindElement(By.Id(progressLogPanelId))); } }
        public TextArea ProgressLogTextArea { get { return new TextArea(parent.Driver.FindElement(By.Id(progressLogTextAreaId))); } }
        public Checkbox FollowTailCheck { get { return new Checkbox(parent.Driver.FindElement(By.Id(followTailCheckboxId))); } }
        public TextBox PositiveMassTextBox { get { return new TextBox(parent.Driver.FindElement(By.Id(positiveMassTextboxId))); } }
        public TextBox NegativeMassTextBox { get { return new TextBox(parent.Driver.FindElement(By.Id(negativeMassTextboxId))); } }
        public Checkbox PositiveMassEnabledCheckBox { get { return new Checkbox(parent.Driver.FindElement(By.Id(positiveMassEnabledCheckboxId))); } }
        public Checkbox NegativeMassEnabledCheckBox { get { return new Checkbox(parent.Driver.FindElement(By.Id(negativeMassEnabledCheckboxId))); } }
        public Button StartStopButton { get { return new Button(parent.Driver.FindElement(By.Id(startButtonId))); } }
        public TextBox PositiveDetectorVoltageTextBox { get { return new TextBox(parent.Driver.FindElement(By.Id(positiveDetectorVoltageId))); } }
        public TextBox NegativeDetectorVoltageTextBox { get { return new TextBox(parent.Driver.FindElement(By.Id(negativeDetectorVoltageId))); } }
        public TextBox PositiveIonAreaTextBox { get { return new TextBox(parent.Driver.FindElement(By.Id(positiveIonAreaId))); } }
        public TextBox NegativeIonAreaTextBox { get { return new TextBox(parent.Driver.FindElement(By.Id(negativeIonAreaId))); } }
        public IWebElement PositiveResultsPanelStatus { get { return parent.Driver.FindElement(By.Id(posResultsStatusId)); } }
        public IWebElement NegativeResultsPanelStatus { get { return parent.Driver.FindElement(By.Id(negResultsStatusId)); } }

        #endregion Controls
    }
}
