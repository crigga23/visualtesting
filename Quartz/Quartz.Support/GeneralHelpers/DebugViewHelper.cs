using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Timers;
using System.Windows.Automation;
using System.Windows.Forms;
using Waters.Automation.Reporting;
using WebAutomationFramework;
using Timer = System.Timers.Timer;

namespace QuartzAutomationSupport.GeneralHelpers
{
    public class DebugViewHelper
    {
        private static AutomationElement DebugWindow { get; set; }
        private static Timer MyTimer = new Timer();
        public static Process DebugViewProcess = new Process();
        private static ProcessStartInfo DebugViewInfo = new ProcessStartInfo();

        
        /// <summary>
        /// Open 3rd party tool DebugView
        /// </summary>
        public static void OpenDebugView()
        {
            Report.Debug("Opening a DebugView session...");

            var curDir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            var dir = curDir + "\\Data\\";
            Report.Debug("File location: " + dir);

            DebugViewInfo.UseShellExecute = true;
            DebugViewInfo.WorkingDirectory = dir;
            DebugViewInfo.FileName = "Dbgview.exe";
            DebugViewProcess.StartInfo = DebugViewInfo;
            DebugViewProcess.Start();

            Report.DebugScreenshot();

            // Look for DebugView window          
            DebugWindow = AutomationElement.RootElement.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.ClassNameProperty, "dbgviewClass"));

            if (DebugWindow == null) // Handle occurances where the filter appears first
            {
                Report.Debug("Unable to find DebugWindow, looking for Message Filter window...");
                AutomationElement filterDialog = AutomationElement.RootElement.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.NameProperty, "DebugView Filter"));

                if (filterDialog != null)
                {
                    var includeCb = filterDialog.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.ComboBox));
                    includeCb.SetFocus();

                    SendKeys.SendWait("^{HOME}");
                    SendKeys.SendWait("^+{END}");
                    SendKeys.SendWait("{DEL}");
                    SendKeys.SendWait("*");

                    SendKeys.SendWait("{ENTER}");

                    //var okBtn = filterDialog.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.NameProperty, "OK"));
                    //ClickButton(okBtn);
                }
                else
                {
                    Report.Debug("Unable to find the Message Filter window...");
                }

                // Now look again for the main DebugView window
                DebugWindow = AutomationElement.RootElement.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.ClassNameProperty, "dbgviewClass"));
            }

            Report.Debug("DebugWindow found");
            Report.DebugScreenshot(DebugWindow);

            Report.Debug("Connecting to local machine...");
            var computerMenuItem = DebugWindow.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.AccessKeyProperty, "Alt+m"));
            Report.Debug("Menu item 'Computer' found");
            var pattern = computerMenuItem.GetCurrentPattern(ExpandCollapsePattern.Pattern) as ExpandCollapsePattern;
            pattern.Expand();
            Report.DebugScreenshot(DebugWindow);

            var connectLocalMenuItem = DebugWindow.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.NameProperty, "Connect Local"));
            Report.Debug("Menu item 'Connect Local' found");

            if (connectLocalMenuItem.Current.IsEnabled)
            {
                (connectLocalMenuItem.GetCurrentPattern(InvokePattern.Pattern) as InvokePattern).Invoke();
            }
            else
            {
                pattern.Collapse();
            }
        }

        /// <summary>
        /// Compare the Acquisition start time with the timestamp of the fMessage
        /// </summary>
        /// <param name="fMessage">message received</param>
        /// <param name="acquisitionStartTime">DateTime the acquisition started</param>
        public static void CheckFinishMessageReceivedBeforeAcquisitionRan(AutomationElement fMessage, DateTime acquisitionStartTime)
        {
            // Get the time the finished message was received
            var receivedFinishMessage = GetMessageTimeStamp(fMessage.Current.Name);
            Report.Debug(string.Format("Message '{0}' was received at '{1}'...", fMessage.Current.Name, receivedFinishMessage));

            // Check the finish message was received before the detector setup ran
            Check.IsTrue(receivedFinishMessage <= acquisitionStartTime, string.Format("The message '{0}' was received before the Acquisition started at '{1}'", fMessage.Current.Name, acquisitionStartTime));
        }

        /// <summary>
        /// Fired when a timeout occurs
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        public static void OnTimedEvent(object source, ElapsedEventArgs e)
        {
            MyTimer.Enabled = false;
        }

        /// <summary>
        /// Sets which messages to listen out for
        /// </summary>
        /// <param name="filter">keyword or wildcard</param>
        public static void SetMessageFilter(string filter)
        {
            Report.Debug("Setting message filter in DebugView window to " + filter);
            FocusDebugWindow();

            var filterIconBtn = DebugWindow.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.NameProperty, "Filter/Highlight (Ctrl+L)"));

            if (filterIconBtn == null)
            {
                // Try again
                int numAttempts = 0;
                while (filterIconBtn == null && numAttempts < 5)
                {
                    Report.Debug(numAttempts + " to find DebugView Filter button...");
                    Wait.ForMilliseconds(100);
                    FocusDebugWindow();
                    filterIconBtn = DebugWindow.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.NameProperty, "Filter/Highlight (Ctrl+L)"));
                    numAttempts++;
                }
            }

            ClickButton(filterIconBtn);

            Wait.ForMilliseconds(2000);

            AutomationElement filterDialog = DebugWindow.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.NameProperty, "DebugView Filter"));
            var includeCb = filterDialog.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.ComboBox));
            includeCb.SetFocus();

            SendKeys.SendWait("^{HOME}");
            SendKeys.SendWait("^+{END}");
            SendKeys.SendWait("{DEL}");
            SendKeys.SendWait(filter);

            var okBtn = filterDialog.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.NameProperty, "OK"));
            ClickButton(okBtn);

            Report.Debug("Finished setting message filter");

            MinimizeDebugWindow();
        }

        /// <summary>
        /// Clears any messages already in the DebugView window.
        /// </summary>
        public static void ClearDebugViewDisplay()
        {
            FocusDebugWindow();

            var clearDisplayBtn = DebugWindow.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.NameProperty, "Clear (Ctrl+X)"));
            ClickButton(clearDisplayBtn);
        }

        //[System.Runtime.InteropServices.DllImport("USER32.DLL")]
        //private static extern bool SetForegroundWindow(System.IntPtr hWnd);

        /// <summary>
        /// Brings the DebugView window to the front
        /// </summary>
        public static void FocusDebugWindow()
        {
            MaximizeDebugWindow();

            Process myProcess = Process.GetProcesses()
                    .Where(p => p.ProcessName.StartsWith("Dbgview"))
                    .ToList()[0];

            NativeMethods.SetForegroundWindow(myProcess.MainWindowHandle);
            Wait.ForMilliseconds(1000);
        }

        /// <summary>
        /// Clicks a AutomationElement Button
        /// </summary>
        /// <param name="element">element</param>
        public static void ClickButton(AutomationElement element)
        {
            var pattern = element.GetCurrentPattern(InvokePattern.Pattern);
            (pattern as InvokePattern).Invoke();
        }

        /// <summary>
        /// Get all messages received in DebugWindow
        /// </summary>
        /// <returns>collection of messages</returns>
        public static AutomationElementCollection GetAllSettleMessages()
        {
            //MaximizeDebugWindow();
            FocusDebugWindow();

            var messages = DebugWindow.FindAll(TreeScope.Descendants, new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.DataItem));
            return messages;
        }

        /// <summary>
        /// Returns a collection of messages that match
        /// </summary>
        /// <param name="message">message to find</param>
        /// <returns></returns>
        public static List<AutomationElement> GetMessagesContaining(string message)
        {
            FocusDebugWindow();

            List<AutomationElement> messages = new List<AutomationElement>();
            var allMessages = GetAllSettleMessages();

            if (allMessages.Count > 0)
            {
                for (int i = 0; i < allMessages.Count; i++)
                {
                    var m = allMessages[i].FindAll(TreeScope.Children, new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.Text))[2];

                    if (m.Current.Name.Contains(message))
                    {
                        Report.Debug(string.Format("Found message containing '{0}'", message));
                        messages.Add(m);
                    }
                }
            }

            if (messages.Count == 0)
            {
                Report.Debug(string.Format("Unable to find message containing '{0}'", message));
            }

            MinimizeDebugWindow();

            return messages;
        }

        /// <summary>
        /// Finds multiple messages using multiple search criteria
        /// </summary>
        /// <param name="messages">the message to look for</param>
        /// <returns>a collection of messages that matched</returns>
        public static List<AutomationElement> FindMessagesContaining(params string[] messages)
        {
            List<AutomationElement> messagesFound = new List<AutomationElement>();

            int maxAttempts = 0;
            AutomationElement match = null;
            foreach (var m in messages)
            {
                while ((match == null) && maxAttempts < 50)
                {
                    Wait.ForMilliseconds(500);

                    // Keep looking
                    if (match == null)
                        match = FindMessageContaining(m, false);

                    maxAttempts++;
                }

                if (match != null)
                {
                    messagesFound.Add(match);
                    match = null;
                }
                else
                {
                    Report.Fail("Could not find message within 25 seconds...");
                }
            }

            return messagesFound;
        }

        /// <summary>
        /// Look at the DebugView for a particular message
        /// </summary>
        /// <param name="messages">Optional - pass through a collection of messages collected previously</param>
        /// <param name="message">the message to find</param>
        /// <param name="reportFailIfNotFound">True - will expect the messsag eto be found and report a fail if it is not.</param>
        /// <returns></returns>
        public static AutomationElement FindMessageContaining(AutomationElementCollection messages, string message, bool reportFailIfNotFound)
        {
            //WindowPattern wpWindow = (WindowPattern)DebugWindow.GetCurrentPattern(WindowPattern.Pattern);
            //if (!wpWindow.Current.CanMinimize)
            //{
            //    MaximizeDebugWindow();
            //}

            FocusDebugWindow();

            if (reportFailIfNotFound)
            {
                Report.Action(string.Format("Find message containing '{0}'", message));
            }

            AutomationElement element = null;

            if (messages == null)
            {
                messages = GetAllSettleMessages();
            }

            if (messages.Count > 0)
            {
                for (int i = 0; i < messages.Count; i++)
                {
                    var m = messages[i].FindAll(TreeScope.Children, new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.Text))[2];

                    if (m.Current.Name.Contains(message))
                    {
                        element = m;
                        break;
                    }
                }
            }
            else
            {
                Report.Fail("No settle messages received at time of checking...");
            }

            if (reportFailIfNotFound)
            {
                Check.IsNotNull(element, string.Format("Found settling message: {0}", message));
            }

            return element;
        }

        public static AutomationElement FindMessageContaining(string message, bool reportFailIfNotFound)
        {
            return FindMessageContaining(null, message, reportFailIfNotFound);
        }

        /// <summary>
        /// Get the timestamp from the DebugView message
        /// </summary>
        /// <param name="message">The full message received</param>
        /// <returns>DateTime the message was received</returns>
        public static DateTime GetMessageTimeStamp(string message)
        {
            // Remove white spaces
            var timeStamp = message.Split(' ')[3];

            // Replace the colon before the milliseconds
            var lastStartColon = timeStamp.LastIndexOf(':');

            string subString = timeStamp.Substring(lastStartColon, timeStamp.Length - lastStartColon);
            subString = subString.Replace(':', '.');
            timeStamp = timeStamp.Remove(lastStartColon, timeStamp.Length - lastStartColon);
            timeStamp += subString;

            // Convert to datetime and check within tolerance
            var time = DateTime.Parse(timeStamp);

            return time;
        }

        /// <summary>
        /// Get the duration between two DebugView messages
        /// </summary>
        /// <param name="message1">DebugView message</param>
        /// <param name="message2">DebugView message</param>
        /// <returns>TimeSpan</returns>
        public static TimeSpan GetDurationBetweenMessages(string message1, string message2)
        {
            var startTimeStamp = GetMessageTimeStamp(message1);
            var finishTimeStamp = GetMessageTimeStamp(message2);

            return DateTime.Parse(finishTimeStamp.ToString()).Subtract(DateTime.Parse(startTimeStamp.ToString()));
        }

        /// <summary>
        /// Maximise the DebugView window
        /// </summary>
        public static void MaximizeDebugWindow()
        {
            WindowPattern wpWindow = (WindowPattern)DebugWindow.GetCurrentPattern(WindowPattern.Pattern);
            wpWindow.SetWindowVisualState(WindowVisualState.Normal);
        }

        /// <summary>
        /// Minimize the DebugView window
        /// </summary>
        public static void MinimizeDebugWindow()
        {
            WindowPattern wpWindow = (WindowPattern)DebugWindow.GetCurrentPattern(WindowPattern.Pattern);
            wpWindow.SetWindowVisualState(WindowVisualState.Minimized);
        }


    }

    internal static class NativeMethods
    {
        [DllImport("USER32.DLL")]
        [return: MarshalAs(UnmanagedType.Bool)]   
        internal static extern bool SetForegroundWindow(IntPtr hWnd);
    }
}
