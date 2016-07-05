using System;
using System.Configuration;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Page
{
    public class ApplicationsPage : Page
    {

        public ApplicationPageControls Controls { get; set; }

        public static string Url
        {
            get
            {
                return string.Format("{0}{1}/#/home/applications", ConfigurationManager.AppSettings["QuartzServerUrl"],
                    ConfigurationManager.AppSettings["QuartzServerPort"]);
            }
        }

        public ApplicationsPage()
        {
            Controls = new ApplicationPageControls(this);
        }

        public static void GoToQuartzFullTuningControls()
        {
            try
            {                
                Wait.Until(ExpectedConditions.ElementExists(By.Id(ApplicationPageControls.FullTuningControlId)), 120000);
                Wait.Until(ExpectedConditions.ElementIsVisible(By.Id(ApplicationPageControls.FullTuningControlId)), 120000);

                Wait.Until(ExpectedConditions.ElementExists(By.Id(ApplicationPageControls.QuartzToolsId)), 120000);
                Wait.Until(ExpectedConditions.ElementIsVisible(By.Id(ApplicationPageControls.QuartzToolsId)), 120000);

                ApplicationPageControls.FullTuningControl.Click();

                Page.CheckUrl(TunePage.Url, 120000);

                Wait.Until(ExpectedConditions.ElementExists(By.Id("tpControlsPanel")), 25000);
                Wait.Until(ExpectedConditions.ElementExists(By.Id("tpPlotPanel")), 20000);
                Wait.Until(ExpectedConditions.ElementExists(By.Id("operateStatus.Readback")), 10000);
            }
            catch (WebDriverException webException)
            {
                throw webException;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       
        public static void GoToQuartzTools()
        {
            ApplicationPageControls.Tools.Click();
        }
    }

    public class ApplicationPageControls
    {
        private Page parent;

        public ApplicationPageControls(Page page)
        {
            parent = page;
        }

        public static string FullTuningControlId = "TUNE_INFO_ID";
        public static string QuartzToolsId = "TOOLS_INFO_ID";

        public static Button FullTuningControl { get { return new Button(AutomationDriver.Driver.FindElement(By.Id(FullTuningControlId))); } }

        public static Button Tools { get { return new Button(AutomationDriver.Driver.FindElement(By.Id(QuartzToolsId))); } }

    }
}
