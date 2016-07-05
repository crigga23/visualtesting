using System;
using System.Collections.Generic;
using System.Linq;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.TabViews;

namespace Quartz.Support.Views.Page
{
    public class Page
    {

        #region Properties

        public virtual Dictionary<string, ControlGroup> ControlDictionary
        {
            get;
            set;
        }

        private string windowHandle;

        public string WindowHandle
        {
            get
            {
                return windowHandle ?? SetWindowHandle();
            }
        }

        private string SetWindowHandle()
        {
            windowHandle = AutomationDriver.Driver.WindowHandles.Last();
            return windowHandle;
        }

        public IWebDriver Driver
        {
            get
            {
                try
                {
                    return AutomationDriver.Driver.SwitchTo().Window(WindowHandle);
                }
                catch (Exception ex)
                {
                    Report.Warn("Window Handle not found, trying to find latest.");
                    Report.Debug(AutomationDriver.Driver.WindowHandles.Count + " window handles found");
                    Report.Debug(ex.Message);

                    return AutomationDriver.Driver.SwitchTo().Window(SetWindowHandle());
                }
            }
        }

        public List<Widget> AllWidgets
        {
            get
            {
                var widgets = new List<Widget>();
                foreach (var widget in AutomationDriver.Driver.FindElements(By.ClassName("panel")))
                {
                    widgets.Add(new Widget(widget));
                }
                return widgets;
            }
        }

        #endregion Properties

        #region Methods

        //TODO: This wait is excessive and the environment should be speeded up so this wait can be reduced
        public static void CheckUrl(string expectedUrl, int timeAllowanceInMilliseconds = 20000)
        {
            var timeout = TimeSpan.FromMilliseconds(timeAllowanceInMilliseconds);

            var stopwatch = new System.Diagnostics.Stopwatch();
            stopwatch.Start();


            while (stopwatch.Elapsed < timeout)
            {
                string url = "";
                Report.Debug("Request url from driver: " + stopwatch.Elapsed);
                try
                {
                    url = AutomationDriver.Driver.Url;
                    Report.Debug("Request received from driver: " + stopwatch.Elapsed);
                    Report.Debug("URL is " + url);
                }
                catch (WebDriverException we)
                {
                    Report.Warn("A WebDriverException occured reuqesting the URL from the driver");
                    Report.Debug(we.Message);
                    throw we;
                }
                catch (Exception e)
                {
                    Report.Warn("An Exception occured reuqesting the URL from the driver");
                    Report.Debug(e.Message);
                    throw e;
                }


                if (url == expectedUrl)
                {
                    stopwatch.Stop();
                    Report.Pass("The URL is as expected: " + expectedUrl);
                    return;
                }

                System.Threading.Thread.Sleep(1000);
            }

            stopwatch.Stop();

            Report.Fail(string.Format("The URL is not as expected. Expected {0}: , Actual: {1}", expectedUrl, AutomationDriver.Driver.Url));
        }

        public IWebElement FindWidget(string title)
        {
            var allWidgets = Driver.FindElements(By.ClassName("panel"));

            foreach (var widget in allWidgets)
            {
                if (widget.FindElement(By.TagName("h5")).Text == title)
                {
                    return widget;
                }
            }
            return null;
        }

        public Form FindForm(string title)
        {
            var allForms = AutomationDriver.Driver.FindElements(By.ClassName("form"));

            foreach (var form in allForms)
            {
                if (form.FindElement(By.TagName("h3")).Text == title)
                {
                    return new Form(form);
                }
            }
            return null;
        }

        public bool Exists(Object control)
        {
            try
            {
                var item = control;
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public void CheckButtonExists(string buttonText)
        {
            Button button = FindButtonByText(buttonText);
            Check.IsNotNull(button, string.Format("The {0} button exists", buttonText), continueOnFail: true);
            button.CheckDisplayed();
        }

        public void CheckControlValue(string controlLabel, string expectedValue, bool continueOnFail = false)
        {
            var control = ControlDictionary[controlLabel].Setting;

            if (control != null)
                control.CheckValue(expectedValue, continueOnFail);
            else
                Report.Fail(string.Format("Unable to find control '{0}'", controlLabel));
        }

        public static void CheckForHttp()
        {
            var elementsContainingHttp = AutomationDriver
                .Driver
                .FindElements(By.XPath("//*[contains(@href,'http://')] | //*[contains(@href,'https://')] | //*[contains(@src,'http://')] | //*[contains(@src,'https://')]"));
            Check.IsFalse(elementsContainingHttp.Any(), "There are no elements that require a connection to the internet", true);

        }

        public static void CheckLoginControlIsNotPresentOnPage()
        {
            Check.IsFalse(AutomationDriver.Driver.FindElements(By.Id("login_form"), 500).Any(), "The login control is not present");
        }

        public void CheckWidgetIsAvailable(List<Widget> widgets, string widgetTitle)
        {
            Check.IsTrue(widgets.Any(p => p.Title == widgetTitle), widgetTitle + " widget exists");
            Report.Screenshot();
        }

        public void CheckWidgetIsAvailable(string widgetTitle)
        {
            Check.IsTrue(AllWidgets.Any(p => p.Title == widgetTitle), widgetTitle + " widget exists");
            Report.Screenshot();
        }

        public void CheckWidgetsAreAvailable(string[] widgetTitles)
        {
            foreach (string title in widgetTitles)
            {
                CheckWidgetIsAvailable(title);
            }

        }

        public void CheckWidgetsAreAvailable(List<Widget> widgets, string[] widgetTitles)
        {
            foreach (string title in widgetTitles)
            {
                CheckWidgetIsAvailable(widgets, title);
            }
        }

        public void InstrumentSectionIsOpen(string sectionName)
        {

            IWebElement instrumentSection = Driver.FindElement(By.Id("primary_nav")).FindElement(By.LinkText("Instrument"));

            Check.IsNotNull(instrumentSection, string.Format("{0} section found", sectionName), true);
            Report.Screenshot(instrumentSection);

            instrumentSection.Click();
        }

        public void SetControlValue(string controlLabel, string value, bool continueOnFail = false)
        {
            var control = ControlDictionary[controlLabel].Setting;

            if (control != null)
            {
                switch (controlLabel)
                {
                    case "Set Mass":
                        if (MSProfileTabView.MSMSMSDropdown.SelectedOption.Text != "MSMS")
                            MSProfileTabView.MSMSMSDropdown.SelectOptionFromDropDown("MSMS");
                        break;
                    case "EDC Mass":
                    case "Delay Coefficient < 2000":
                    case "Delay Coefficient >= 2000":
                    case "Delay Offset < 2000":
                    case "Delay Offset >= 2000":
                        if (MSProfileTabView.SelectModeDropdown.SelectedOption.Text != "EDC")
                            MSProfileTabView.SelectModeDropdown.SelectOptionFromDropDown("EDC");
                        break;
                }

                control.SetValue(value, continueOnFail);
            }
            else
                Report.Fail(string.Format("Unable to find control '{0}'", controlLabel));
        }

        public static void WaitForPageToLoad(int milliseconds = 1500)
        {
            //TODO: Need better way to wait for page load. Wait for an element to exist does not always work either. We need to wait for angular to finish compiling
            Wait.ForMilliseconds(milliseconds);
        }

        public void SelectTabById(string id)
        {
            var tab = new Tab(AutomationDriver.Driver.FindElement(By.Id(id)));

            if (!tab.Selected)
                tab.Select();
        }

        public Button FindButtonByText(string buttonText)
        {
            if (string.IsNullOrEmpty(buttonText))
            {
                throw new ArgumentNullException("The button must have some text in it.");
            }

            var buttons = AutomationDriver.Driver.FindElements(By.TagName("button"));

            if (buttons == null)
            {
                buttons = AutomationDriver.Driver.FindElements(By.CssSelector(":button"));
            }

            if (buttons.Any())
            {
                return new Button(buttons.FirstOrDefault(b => b.Text.Equals(buttonText)));
            }

            return null;
        }

        public TextBox FindTextBoxById(string id)
        {
            var matchingElements = AutomationDriver.Driver.FindElements(By.Id(id));

            if (matchingElements.Count > 0)
                return new TextBox(matchingElements.FirstOrDefault());

            Report.Fail("Unable to find element with id " + id);
            return null;
        }

        public Dropdown FindDropdownById(string id)
        {
            var matchingElements = AutomationDriver.Driver.FindElements(By.Id(id));

            if (matchingElements.Count > 0)
                return new Dropdown(matchingElements.FirstOrDefault());

            Report.Fail("Unable to find element with id " + id);
            return null;
        }

        public Control FindControlById(string id)
        {
            var matchingElements = AutomationDriver.Driver.FindElements(By.Id(id));

            if (matchingElements.Count > 0)
            {
                switch (matchingElements.FirstOrDefault().TagName)
                {
                    case "input":
                        return new TextBox(matchingElements.FirstOrDefault());
                    case "select":
                        return new Dropdown(matchingElements.FirstOrDefault());
                    default:
                        return new Control(matchingElements.FirstOrDefault());
                }
            }

            Report.Fail("Unable to find element with id " + id);
            return null;
        }

        public Slot FindSlotById(string id)
        {
            var matchingElements = AutomationDriver.Driver.FindElements(By.Id(id));

            if (matchingElements.Count > 0)
                return new Slot(matchingElements.FirstOrDefault());

            Report.Fail("Unable to find element with id " + id);
            return null;
        }

        #endregion Methods
    }

}
