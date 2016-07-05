using System;
using System.Windows.Automation;
using System.Windows.Forms;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;

namespace Quartz.Support.GeneralHelpers
{
    public class FileDialogHelper
    {

        private static AutomationElement window;
        public static AutomationElement Window 
        {
            get
            {
                return window ?? null;
            }
            set
            {
                window = value;
            }
        }

        private static AutomationElement FindWindow(string title)
        {
		    // Find a dialog with a matching title
            AndCondition condition = new AndCondition(new PropertyCondition(AutomationElement.LocalizedControlTypeProperty, "Dialog"), new PropertyCondition(AutomationElement.NameProperty, title));
            Window = AutomationElement.RootElement.FindFirst(TreeScope.Descendants, condition);

            return Window;
        }

        public static AutomationElement FindDialog(string title)
        {
            Wait.Until(f => FindWindow(title) != null, 20000, "Looking for dialog...");

            Check.IsNotNull(Window, string.Format("{0} file dialog is open", title));
            Report.Screenshot(Window);

            return Window;
        }

        public static void SetCombobox(string automationId, string value)
        {
            var combobox = Window.FindFirst(TreeScope.Children, new PropertyCondition(AutomationElement.AutomationIdProperty, automationId));
            combobox.SetFocus();

            Report.Debug(string.Format("Found combobox {0} ...", automationId));

            var valuePattern = combobox.GetCurrentPattern(ValuePattern.Pattern) as ValuePattern;
            valuePattern.SetValue(value);
            
            Report.Debug(string.Format("Entered file name {0} ...", value));
            Check.AreEqual(value, valuePattern.Current.Value, "The combox is set to " + value);
            Report.Screenshot(Window);
        }

        public static void ClickOpenButton()
        {
            Wait.ForMilliseconds(1000);

            Report.Debug("Looking for Open button...");

            AndCondition condition = new AndCondition(new PropertyCondition(AutomationElement.ClassNameProperty, "Button"), new PropertyCondition(AutomationElement.AutomationIdProperty, "1"), new PropertyCondition(AutomationElement.NameProperty, "Open"));
            var button = Window.FindAll(TreeScope.Children, condition);

            Report.Debug(string.Format("Found {0} buttons matching condition. Choosing the first button.", button.Count));
            Report.DebugScreenshot(button[0]);

            ClickButton(button[0]);
        }

        public static void ClickCancelButton()
        {
            Wait.ForMilliseconds(1000);

            Report.Debug("Looking for Cancel button...");

            AndCondition condition = new AndCondition(new PropertyCondition(AutomationElement.ClassNameProperty, "Button"), new PropertyCondition(AutomationElement.AutomationIdProperty, "2"), new PropertyCondition(AutomationElement.NameProperty, "Cancel"));
            var button = Window.FindFirst(TreeScope.Children, condition);

            ClickButton(button);
        }

        private static void ClickButton(AutomationElement button)
        {
            Wait.ForMilliseconds(1000);

            if (button != null)
            {
                Report.Debug("Found button: " + button.Current.Name);

                Object ip;

                int count = 0;
                while (button.TryGetCurrentPattern(InvokePattern.Pattern, out ip) == false && count < 5)
                {
                    Wait.ForMilliseconds(1000, "Waiting for Invoke Pattern...");
                    count++;
                }

                try
                {
                    var pattern = ip as InvokePattern;
                    pattern.Invoke();
                }
                catch (Exception)
                {
                    Report.Debug("Unable to invoke the button pattern. Resorting to key press [Enter]");

                    Wait.ForMilliseconds(500);
                    SendKeys.SendWait("{ENTER}");
                        
                    Wait.ForMilliseconds(500);
                    Report.Debug("Key [Enter] sent");
                }
            }
            else
            {
                Report.Fail("Unable to find button");
            }
        }
    }
}
