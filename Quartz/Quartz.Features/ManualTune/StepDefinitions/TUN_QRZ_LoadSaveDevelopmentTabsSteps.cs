using System;
using System.Collections.Generic;
using System.Linq;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using Quartz.Support.Views.TabViews;
using TechTalk.SpecFlow;

namespace Quartz.Features.ManualTune.StepDefinitions
{
    [Binding]
    public class TUN_QRZ_LoadSaveDevelopmentTabsSteps
    {
        public enum CustomControlType
        {
            FullSettingControl,
            SettingControl,
            ReadbackControl,
            CommandControl
        }

        public class CustomControlDetails
        {
            public CustomControlType Type { get; set; }
            public string Name { get; set; }
            public string Setting { get; set; }
            public string Readback { get; set; }
            public double DefaultValue { get; set; }
            public int DecimalPlaces { get; set; }
            public string MinimumValue { get; set; }
            public string MaximumValue { get; set; }
        }

        public class CustomTabDetails
        {
            public string Name { get; set; }
            public int ControlCount { get; set; }
            public List<CustomControlDetails> Controls { get; set; }

            public CustomTabDetails()
            {
                Controls = new List<CustomControlDetails>();
            }
        }

        private static readonly InstrumentControlWidget instrumentControlWidget = new InstrumentControlWidget();
        private static readonly List<CustomTabDetails> customTabDetails = new List<CustomTabDetails>();
        private static readonly Random random = new Random();
        private static string LastRandom { get; set; }
        private static string PreviousRandom { get; set; }

        private static string RandomString(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

            LastRandom = new string(
                Enumerable.Repeat(chars, length)
                            .Select(s => s[random.Next(s.Length)])
                            .ToArray());

            return LastRandom;
        }

        [AfterScenario("CustomTabCleanup")]
        public static void CleanUp()
        {
            instrumentControlWidget.ClearTabs();
            customTabDetails.Clear();
        }
            
        [Given(@"I add '(.*)' custom tabs")]
        public void GivenIAddCustomTabs(int count)
        {
            for (int i = 0; i < count; i++)
            {
                instrumentControlWidget.AddTab();

                var details = new CustomTabDetails()
                {
                    Name = instrumentControlWidget.TabControl.ActiveTab.Name.Replace(" x", "")
                };

                customTabDetails.Add(details);
            }
        }
        
        [Given(@"I rename all custom tabs")]
        public void GivenIRenameAllCustomTabs()
        {
            int customTabCount = instrumentControlWidget.CustomTabs.Count;

            if (customTabCount > 0)
            {
                for (int i = 0; i < customTabCount; i++)
                {
                    var tab = instrumentControlWidget.CustomTabs[i];

                    tab.Select();

                    var currentTabName = tab.Name;

                    //TODO: Working in Bootstrap
                    var button = tab.Element.FindElement(By.XPath("//li[contains(@class, 'active')]//span[contains(@ng-dblclick, 'dbClick')]"));
                    var executor = AutomationDriver.Driver as IJavaScriptExecutor;
                    executor.ExecuteScript
                        (
                            "var event = document.createEvent('MouseEvents'); " +
                            "event.initMouseEvent('dblclick', true, true, window, 2, 0, 0, 0, 0, false, false, false, false, 0, null); " +
                            "arguments[0].dispatchEvent(event);", button);

                    var name = RandomString(10);

                    Report.Action(string.Format("Setting {0} name to {1}", currentTabName, name));

                    var textBox = tab.Element.FindElement(By.XPath("//li[contains(@class, 'active')]//input"));

                    //NOTE: Cannot use SetText because of Check methods.
                    textBox.Clear();
                    textBox.SendKeys(name + Keys.Enter);

                    customTabDetails[i].Name = name;
                }
            }
            else
            {
                Report.Fail("Unable to find any custom tabs.");
                Report.Screenshot();
            }
        }
        
        [Given(@"I add multiple random custom controls")]
        public void GivenIAddMultipleRandomCustomControls()
        {
            for (int i = 0; i < instrumentControlWidget.CustomTabs.Count; i++)
            {
                var tab = instrumentControlWidget.CustomTabs[i];

                tab.Select();

                var customTab = new CustomTab(tab.Element);

                customTabDetails[i].Controls.Clear();

                int count = random.Next(1, 10);
                for (int j = 0; j < count; j++)
                {
                    //Add Control

                    var button = customTab.CreateButtonList[random.Next(customTab.CreateButtonList.Count)];

                    //TODO: Can this use the defined buttons in CustomTab.cs.
                    switch (button.Element.GetAttribute("title"))
                    {
                        case "Full setting control":
                            customTabDetails[i].Controls.Add(new CustomControlDetails(){Type = CustomControlType.FullSettingControl});
                            break;
                        case "Setting only control":
                            customTabDetails[i].Controls.Add(new CustomControlDetails(){Type = CustomControlType.SettingControl});
                            break;
                        case "Readback only control":
                            customTabDetails[i].Controls.Add(new CustomControlDetails(){Type = CustomControlType.ReadbackControl});
                            break;
                        case "Command control":
                            customTabDetails[i].Controls.Add(new CustomControlDetails(){Type = CustomControlType.CommandControl});
                            break;
                    }

                    button.Click();

                    //Edit Control

                    //TODO: Set Name
                    //TODO: Set Param
                    //TODO: Set Min/Max/Default/Precision
                }
                customTabDetails[i].ControlCount = count;
            }
        }
        
        [Given(@"I save custom tabs")]
        public void GivenISaveCustomTabs()
        {
            if (instrumentControlWidget.CustomTabCount > 0)
            {
                LastRandom = RandomString(10);
                instrumentControlWidget.SaveTabs(LastRandom);
            }
            else
            {
                LastRandom = null;
            }
        }

        [Given(@"All custom tabs are cleared")]
        [Given(@"I clear custom tabs")]
        public void GivenIClearCustomTabs()
        {
            instrumentControlWidget.ClearTabs();
        }
        
        [Given(@"I save a second set of custom tabs")]
        public void GivenISaveASecondSetOfCustomTabs()
        {
            PreviousRandom = LastRandom;
            instrumentControlWidget.SaveTabs(RandomString(10));
        }
        
        [When(@"I leave and return to the '(.*)'")]
        public void WhenILeaveAndReturnToThe(string page)
        {
            if (page.Contains("Tune"))
            {
                NavigationMenu.SelectRandomPage(NavigationMenu.TuneAnchor);

                NavigationMenu.TuneAnchor.Click();
                TunePage.WaitForPageToLoad();
            }
        }
        
        [When(@"I delete the last '(.*)' custom tabs")]
        public void WhenIDeleteTheLastCustomTabs(int count)
        {
            for (int i = 0; i < count; i++)
            {
                instrumentControlWidget.CustomTabs.Last().Select();
                instrumentControlWidget.CustomTabs.Last().Delete();

                customTabDetails.RemoveAt(customTabDetails.Count - 1);
            }
        }
        
        [When(@"I delete a random '(.*)' custom tabs")]
        public void WhenIDeleteARandomCustomTabs(int count)
        {
            for (int i = 0; i < count; i++)
            {
                var index = random.Next(0, instrumentControlWidget.CustomTabs.Count - 1);

                var tab = new CustomTab(instrumentControlWidget.CustomTabs[index].Element);
                tab.Select();

                tab.Delete();

                customTabDetails.RemoveAt(index);
            }
        }
        
        [When(@"I load custom tabs")]
        public void WhenILoadCustomTabs()
        {
            if (LastRandom != null)
                instrumentControlWidget.LoadTab(LastRandom);     
        }
        
        [Then(@"'(.*)' custom tabs should be visible")]
        public void ThenCustomTabsShouldBeVisible(int count)
        {
            Check.AreEqual(count, instrumentControlWidget.CustomTabCount, "Checking correct number of custom tabs.", true);
        }
        
        [Then(@"all custom tabs should have the correct name")]
        public void ThenAllCustomTabsShouldHaveTheCorrectName()
        {
            for (int i = 0; i < instrumentControlWidget.CustomTabs.Count; i++)
            {
                var customTab = instrumentControlWidget.CustomTabs[i];

                Check.AreEqual(customTabDetails[i].Name, customTab.Name);
            }
        }
        
        [Then(@"all controls should be visible and correct")]
        public void ThenAllControlsShouldBeVisibleAndCorrect()
        {
            for (int i = 0; i < instrumentControlWidget.CustomTabs.Count; i++)
            {
                var tab = instrumentControlWidget.CustomTabs[i];
                tab.Select();

                Check.AreEqual(customTabDetails[i].ControlCount, () => tab.CustomControlCount, "Checking custom control count", true, 5000);

                for (int j = 0; j < customTabDetails[i].ControlCount; j++)
                {
                    AutomationDriver.Driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(0));

                    Check.AreEqual(customTabDetails[i].Controls[j].Type.ToString(),
                        tab.CustomControls[j].ControlType.ToString(), "Checking control types correct", true);

                    AutomationDriver.Driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(Wait.ImplicitWaitSeconds));

                }
            }
        }
        
        [Then(@"the correct custom tabs are visible")]
        public void ThenTheCorrectCustomTabsAreVisible()
        {
            for (int i = 0; i < instrumentControlWidget.CustomTabs.Count; i++)
            {
                var tab = instrumentControlWidget.CustomTabs[i];

                Check.AreEqual(customTabDetails[i].Name, tab.Name, "Checking tab name",
                    true);
            }
        }
        
        [Then(@"the last custom tab is deleted")]
        public void ThenTheLastCustomTabIsDeleted()
        {
            var tab = instrumentControlWidget.CustomTabs.Last();
            tab.Select();

            instrumentControlWidget.DeleteTab();
        }
        
        [Then(@"I load a second set of custom tabs")]
        public void ThenILoadASecondSetOfCustomTabs()
        {
            instrumentControlWidget.LoadTab(PreviousRandom);
        }
    }
}
