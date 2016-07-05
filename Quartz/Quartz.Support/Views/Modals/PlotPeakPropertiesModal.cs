using System;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Modals
{
    public class PlotPeakPropertiesModal
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

        public static void CheckExists()
        {
            Check.IsTrue(Exists, "The Plot Peak Properties Modal exists", true);
        }

        public static Dropdown TrackerIonList 
        {
            get
            {
                //TODO: Working in Bootstrap - Change to id
                return new Dropdown(AutomationDriver.Driver.FindElement(By.XPath("//select[@ng-model='trackerIon']")));
            }
        }

        public static Dropdown PropertyList {
            get
            {
                //TODO: Working in Bootstrap - Change to id
                return new Dropdown(AutomationDriver.Driver.FindElement(By.XPath("//select[@ng-model='peakProperty']")));
            }
        }

        public static Button PlotButton 
        {
            //TODO: Working in Bootstrap - Change to id
            get { return new Button(AutomationDriver.Driver.FindElement(By.XPath("//button[@ng-click='ok()']"))); }
        }

        public static Button CancelButton
        {
            //TODO: Broken in Bootstrap
            get { return new Button(AutomationDriver.Driver.FindElement(By.XPath("//button[@ng-click='cancel()']"))); }
        }

        public static void Cancel()
        {
            CancelButton.Click();
        }

        public static void Plot()
        {
            PlotButton.Click();
        }

        public static void SelectRandomTrackerAndProperty()
        {
            TrackerIonList.SelectByIndex(new Random().Next(0, TrackerIonList.Options.Count - 1));
            PropertyList.SelectByIndex(new Random().Next(0, PropertyList.Options.Count - 1));
        }

        public static void CheckPlotPeakPropertiesModalControls()
        {
            Check.IsTrue(TrackerIonList.Options.Count > 0, "The Plot Peak Tracker Ion List is populated exist", true);
            Check.IsTrue(PropertyList.Options.Count > 0, "The Plot Peak Properties List is populated exist", true);
            PlotButton.CheckDisplayed();
            CancelButton.CheckEnabled();
        }
    }
}