using System;
using System.Collections.Generic;
using System.Linq;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views
{
    public static class NavigationMenu
    {
        public const string tuneAnchorLabel = "Tune";
        public const string manualCalibrationAnchorLabel = "Manual Calibration";
        public const string instrumentSetupAnchorLabel = "Instrument Setup";
        public const string vacuumAnchorLabel = "Vacuum";
        public const string quadSetupAnchorLabel = "Quad Setup";
        public const string detectorSetupAnchorLabel = "Detector Setup";
        public const string scopeModeAnchorLabel = "Scope Mode";
        public const string sourcePressureTestAnchorLabel = "Source Pressure Test";
        public const string imsPressureControlAnchorLabel = "IMS Pressure Control";
        public const string healthStatusAnchorLabel = "Health Status";

        public static Dictionary<string, Lazy<Anchor>> AnchorsDictionary = new Dictionary<string, Lazy<Anchor>>()
        {
            { tuneAnchorLabel, new Lazy<Anchor>(() => (TuneAnchor)) },
            { manualCalibrationAnchorLabel, new Lazy<Anchor>(() => (ManualCalibrationAnchor)) },
            { instrumentSetupAnchorLabel, new Lazy<Anchor>(() => (InstrumentSetupAnchor)) },
            { vacuumAnchorLabel, new Lazy<Anchor>(() => (VacuumAnchor)) },
            { quadSetupAnchorLabel, new Lazy<Anchor>(() => (QuadSetupAnchor)) },
            { detectorSetupAnchorLabel, new Lazy<Anchor>(() => (DetectorSetupAnchor)) },
            { scopeModeAnchorLabel, new Lazy<Anchor>(() => (ScopeModeAnchor)) },
            { sourcePressureTestAnchorLabel, new Lazy<Anchor>(() => (SourcePressureTestAnchor)) },
            { imsPressureControlAnchorLabel, new Lazy<Anchor>(() => (IMSPressureControlAnchor)) },
            { healthStatusAnchorLabel, new Lazy<Anchor>(() => (HealthStatusAnchor)) }
        };

        public static void SelectRandomPage(Anchor excludingPage = null)
        {
            List<Anchor> tempList = Anchors;
            tempList.Remove(excludingPage);

            Random rnd = new Random();
            var anchor = tempList[rnd.Next(tempList.Count)];

            Report.Action("Navigate to the " +  anchor.Label + " page");
            anchor.Click();

            Page.Page.WaitForPageToLoad();
        }

        public static void SelectAnchor(string anchorLabel)
        {
            var anchor = AnchorsDictionary[anchorLabel].Value;

            if (anchor != null)
                anchor.Click();
            else
                Report.Fail("Unable to find anchor with label: " + anchorLabel);
        }
      

        #region Controls

        public static IWebDriver Driver
        {
            get { return AutomationDriver.Driver.SwitchTo().Window(AutomationDriver.Driver.WindowHandles.First()); }
        }

        public static List<Anchor> Anchors
        {
            get { return new List<Anchor>() { TuneAnchor, ManualCalibrationAnchor, VacuumAnchor, QuadSetupAnchor, DetectorSetupAnchor, ScopeModeAnchor, InstrumentSetupAnchor, SourcePressureTestAnchor, IMSPressureControlAnchor, HealthStatusAnchor }; }
        }

        public static Anchor SourcePressureTestAnchor
        {
            get { return new Anchor(Driver.FindElement(By.CssSelector("a[href='#/sourcePressureTest ']")), sourcePressureTestAnchorLabel); }
        }

        public static Anchor InstrumentSetupAnchor
        {
            get { return new Anchor(Driver.FindElement(By.CssSelector("a[href='#/app/instrument/instrumentSetup']")), instrumentSetupAnchorLabel); }
        }

        public static Anchor TuneAnchor
        {
            get { return new Anchor(Driver.FindElement(By.CssSelector("a[href='#/app/instrument/tune']")), tuneAnchorLabel); }
        }

        public static Anchor ManualCalibrationAnchor
        {
            get { return new Anchor(Driver.FindElement(By.CssSelector("a[href='#/app/instrument/manualCalibration']")), manualCalibrationAnchorLabel); }
        }

        public static Anchor VacuumAnchor
        {
            get { return new Anchor(Driver.FindElement(By.CssSelector("a[href='#/app/instrument/vacuum']")), vacuumAnchorLabel); }
        }

        public static Anchor QuadSetupAnchor
        {
            get { return new Anchor(Driver.FindElement(By.CssSelector("a[href='#/quadSetup']")), quadSetupAnchorLabel); }
        }

        public static Anchor DetectorSetupAnchor
        {
            get { return new Anchor(Driver.FindElement(By.CssSelector("a[href='#/detectorSetup']")), detectorSetupAnchorLabel); }
        }

        public static Anchor ScopeModeAnchor
        {
            get { return new Anchor(Driver.FindElement(By.CssSelector("a[href='#/app/instrument/scopeMode']")), scopeModeAnchorLabel); }
        }
        public static Anchor IMSPressureControlAnchor
        {
            get { return new Anchor(Driver.FindElement(By.CssSelector("a[href='#/app/instrument/imsPressureControl']")), imsPressureControlAnchorLabel); }
        }
        public static Anchor HealthStatusAnchor
        {
            get { return new Anchor(Driver.FindElement(By.CssSelector("a[href='#/app/instrument/healthMonitor']")), healthStatusAnchorLabel); }
        }

        #endregion

    }
}
