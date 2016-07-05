using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Modals
{
    public class CreateAcquisitionModal
    {
        public static string AutomationId = null;

        public static bool Exists { get { return Modal.Exists(AutomationId); } }

        public static void WaitForClose()
        {
            Modal.WaitForClose(AutomationId);
        }

        public static void WaitForOpen()
        {
            Modal.WaitForOpen(AutomationId);
        }

        public static TextBox Filename
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqFileName")));
            }
        }

        public static TextBox Description
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqDesc")));
            }
        }


        private static Button Save
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("acquisitionSaveBtn")));
            }
        }

        private static Button Cancel
        {
            get { return new Button(AutomationDriver.Driver.FindElement(By.Id("acquisitionCancelBtn"))); }
        }

        public static void SaveAcquisition()
        {
            if (!Save.Enabled)
            {
                Report.Fail("The Save button is not currently enabled", continueOnFail: true);
            }

            Save.Click();

        }

        public static void CancelAcquisition()
        {
            Cancel.Click();
        }

        public class AcquisitionSettings
        {
            public static Dropdown Type { get { return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("tpAcqType"))); } }
            public static Dropdown DataFormat { get { return new Dropdown(AutomationDriver.Driver.FindElement(By.Id("tpAcqData"))); } }
            public static TextBox RunDuration { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqRunDuration"))); } }
            public static TextBox ScanTime { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqScanTime"))); } }
            public static TextBox LowMass { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqLowMass "))); } }
            public static TextBox HighMass { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqHighMass"))); } }
            public static TextBox PrecursorMass { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqPrecursorMass"))); } }
            public static TextBox LowCE { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqLowCe"))); } }
            public static TextBox HighCE { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqHighCe"))); } }
        }

        public class MassMeasurement
        {
            public static Checkbox LockMass { get { return new Checkbox(AutomationDriver.Driver.FindElement(By.Id("tpAcqLockMassCheck"))); } }
            public static Checkbox DualLockMass { get { return new Checkbox(AutomationDriver.Driver.FindElement(By.Id("tpAcqDualLockMass"))); } }
            public static TextBox LockMass1 { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqLockMass1"))); } }
            public static TextBox LockMass2 { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqLockMass2"))); } }
            public static TextBox Interval { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqInterval"))); } }
            public static TextBox MassWindow { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("tpAcqMassWindow"))); } }

            public static void SetLockMass(string lockMassType)
            {
                switch (lockMassType)
                {
                    case "Single":
                        LockMass.SelectCheckBox();
                        break;
                    case "Dual":
                        LockMass.SelectCheckBox();
                        DualLockMass.SelectCheckBox();
                        break;
                }
            }
        }
    }
}
