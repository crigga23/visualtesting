using System;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Modals
{
    public class ChartReadbackModal
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
            Check.IsTrue(Exists, "The Chart Readback Modal exists", true);
        }

        public static Button PlotButton
        {
            //TODO: Working in Bootstrap - Change to id
            get { return new Button(AutomationDriver.Driver.FindElement(By.XPath("//button[@ng-click='ok()']"))); }
        }

        public static Button CancelButton
        {
            //TODO: Working in Bootstrap - Change to id
            get { return new Button(AutomationDriver.Driver.FindElement(By.XPath("//button[@ng-click='cancel()']"))); }
        }

        public static Button AddButton
        {
            //TODO: Working in Bootstrap - Change to id
            get { return new Button(AutomationDriver.Driver.FindElement(By.XPath("//button[@ng-click='add()']"))); }
        }

        public static Button RemoveButton
        {
            //TODO: Working in Bootstrap - Change to id
            get { return new Button(AutomationDriver.Driver.FindElement(By.XPath("//button[@ng-click='remove()']"))); }
        }

        public static Dropdown AvailableList 
        {
            //TODO: Working in Bootstrap - Change to id
            get { return new Dropdown(AutomationDriver.Driver.FindElement(By.XPath("//select[@ng-model='model.addSelection']"))); }
        }

        public static Dropdown CurrentlyPlottedList 
        {
            //TODO: Working in Bootstrap - Change to id
            get { return new Dropdown(AutomationDriver.Driver.FindElement(By.XPath("//select[@ng-model='model.removeSelection']"))); }
        }

        public static TextBox AvailableFilterTextBox
        {
            //TODO: Working in Bootstrap - Change to id
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.XPath("//input[@ng-model='model.availableFilter']"))); }
        }

        public static void Cancel()
        {
            CancelButton.Click();
        }

        public static void Plot()
        {
            PlotButton.Click();
        }

        public static void RemoveRandomChartReadbackProperty()
        {
            RemoveButton.Click();
            Check.IsTrue(CurrentlyPlottedList.Options.Count == 1,
                "The Chart Readback Currently Plotted List exists", true);
            Check.IsTrue(CurrentlyPlottedList.Options[0].Text.Equals(string.Empty),
                "The Chart Readback Currently Plotted List is empty", true);
        }

        public static void AddRandomChartReadbackProperty()
        {
            AvailableList.SelectByIndex(new Random().Next(0,
                AvailableList.Options.Count - 1));
            AddButton.Click();
            Check.IsTrue(CurrentlyPlottedList.Options.Count == 1,
                "The Chart Readback Currently Plotted List is populated with 1 item.", true);
        }

        public static void CheckChartReadbackModalControls()
        {
            Check.IsTrue(AvailableList.Options.Count > 0, "The Chart Readback Available List exists", true);
            Check.IsTrue(CurrentlyPlottedList.Options.Count == 1, "The Chart Readback Currently Plotted List exists", true);
            Check.IsTrue(CurrentlyPlottedList.Options[0].Text.Equals(string.Empty), "The Chart Readback Currently Plotted List is empty", true);

            AddButton.CheckDisplayed();
            AddButton.CheckEnabled();

            RemoveButton.CheckDisplayed();
            RemoveButton.CheckDisabled();

            PlotButton.CheckDisplayed();
            CancelButton.CheckDisplayed();

            Check.IsTrue(AvailableFilterTextBox.Element.Displayed, string.Format("The Chart Readback Available Filter textbox is displayed"));
            Report.DebugScreenshot(AvailableFilterTextBox);
        }
    }
}