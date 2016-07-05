using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Modals
{
    public class AboutQuartzModal
    {
        private bool IsNoFormatSpecified;

        public static string AutomationId = "Dialog.About";

        public static bool Exists { get { return Modal.Exists(AutomationId); } }

        public static void WaitForClose()
        {
            Modal.WaitForClose(AutomationId);
        }

        public static void WaitForOpen()
        {
            Modal.WaitForOpen(AutomationId);
        }

        public static void CloseModalIfOpen()
        {
            Modal.CloseModalIfOpen(AutomationId);
        }

        public static Button Cancel
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("aboutBoxCancelButton"))); }
        }

        public static Button Ok
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("aboutBoxCloseButton"))); }
        }

        public static Label Quartz
        {
            get { return new Label(AutomationDriver.Driver.FindElement(By.Id("quartzLabel"))); }
        }

        public static Label Typhoon
        {
            get { return new Label(AutomationDriver.Driver.FindElement(By.Id("typhoonLabel"))); }
        }

        public static Label Osprey
        {
            get { return new Label(AutomationDriver.Driver.FindElement(By.Id("ospreyTargetLabel"))); }
        }

        public static Label Copyright
        {
            get { return new Label(AutomationDriver.Driver.FindElement(By.Id("copyright"))); }
        }

        public void CheckFormat(string format, Label label, string labelText)
        {
            label.CheckDisplayed();

            if (!string.IsNullOrEmpty(format))
            {
                string[] expectedContents = Array.ConvertAll(format.Split(','), s => s.TrimStart());
                Check.IsTrue(expectedContents.All(s => label.Text.Contains(s)), string.Format("The format of the '{0}' label is in the correct format: '{1}'", label, format), true);
            }
            else
            {
                Report.Fail("Specified format cannot be null");
            }

            Report.Screenshot(label.Element);
        }

        public static void CheckCopyrightInformationIsPresent()
        {
            var copyRight = Copyright;
            copyRight.CheckDisplayed();

            Check.IsTrue(copyRight.Text.ToLower().Contains("waters corporation"), "Company information is available",
                continueOnFail: true);

            CheckCopyrightYear(copyRight.Text);

            Report.Screenshot(copyRight.Element);
        }

        private static void CheckCopyrightYear(string copyrightInfo)
        {
            const string copyRightPattern = @"\s(?<copyRightYear>\d*)\s";
            Regex copyRightRegex = new Regex(copyRightPattern);

            int copyrightYear = 0;
            Match quartzCopyrightYearMatches = copyRightRegex.Match(copyrightInfo);

            if (quartzCopyrightYearMatches.Success)
            {
                copyrightYear = Convert.ToInt32(copyRightRegex.Match(copyrightInfo).Groups["copyRightYear"].Value);
            }

            Check.IsTrue(copyrightYear == DateTime.UtcNow.Year, "Company copyright year is correct: " + copyrightYear, continueOnFail: true);
        }

        public static void CheckContentIsNotEditable()
        {
            List<Label> quartzControls = new List<Label>  
            { 
                Quartz, Typhoon, Osprey, Copyright, 
            };

            if (quartzControls.Count > 0)
            {
                foreach (var quartzControl in quartzControls)
                {
                    string testData = "This is a test";

                    try
                    {
                        quartzControl.Element.SendKeys(testData);
                    }
                    catch (Exception)
                    {
                        // A label will not allow a send key event
                    }

                    Check.AreNotEqual(testData, quartzControl.Text, string.Format("The {0} control is not able to be edited by the user", quartzControl.Label));
                }
            }
        }
    }
}
