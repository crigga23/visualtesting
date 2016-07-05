using System.Collections.Generic;
using System.Configuration;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.TabViews;

namespace Quartz.Support.Views.Page
{
    public class ScopeModePage : Page
    {
        public ScopeModePageControls Controls { get; set; }

        public Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                var controls = new Dictionary<string, ControlGroup>()
                {                  
                    { "Mass", new ControlGroup (() => Controls.MassTextBox) },
                    { "Span", new ControlGroup (() => Controls.SpanTextBox) },
                };

                controls = DictionaryManager.MergeDictionaries(controls, ADCTab2View.ControlDictionary);

                return controls;
            }
        }

        public ScopeModePage(ScopeModePageControls controls)
        {
            Controls = controls;
        }

        public static void GoTo()
        {
            NavigationMenu.ScopeModeAnchor.Click();
            string scopeModeUrl = string.Format("{0}{1}/#/app/instrument/scopeMode", ConfigurationManager.AppSettings["QuartzServerUrl"], ConfigurationManager.AppSettings["QuartzServerPort"]);
            Check.IsTrue(AutomationDriver.Driver.Url.Equals(scopeModeUrl), "You are on the Scope Mode Page", continueOnFail: true);

            WaitForPageToLoad();
        }
    }

    public class ScopeModePageControls
    {
        private Page parent;

        public ScopeModePageControls(Page page)
        {
            parent = page;
        }

        #region Controls

        public TextBox MassTextBox
        {

            get
            {
                return new TextBox(parent.Driver.FindElement(By.Id("smMass"))) { Label = "Mass" };
            }
        }

        public TextBox SpanTextBox
        {

            get
            {
                return new TextBox(parent.Driver.FindElement(By.Id("smSpan"))) { Label = "Span" };
            }
        }

        #endregion Controls
    }
}
