using System;
using Automation.Reporting.Lib;
using OpenQA.Selenium;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using Quartz.Support.Views.TabViews;
using TechTalk.SpecFlow;

namespace Quartz.Features.Sources.StepDefinitions
{
    [Binding]
    public class APCISourceParametersSteps
    {
        private static InstrumentControlWidget instrumentControl = new InstrumentControlWidget();
        private static TunePage tunePage = new TunePage();


        [Then(@"the Corona mode parameter is available with following dropdown options")]
        public void ThenTheCoronaModeParameterIsAvailableWithFollowingDropdownOptions(TechTalk.SpecFlow.Table table)
        {
            var coronaModeDropdown = SourceTabView.CoronaModeDropdown;

            Check.IsNotNull(coronaModeDropdown, "Corona mode dropdown is displayed");
            Report.Screenshot(coronaModeDropdown);

            foreach (var row in table.Rows)
            {
                var coronaMode = row["Corona mode"];

                Report.Action("Check Corona mode has an option of: " + coronaMode);
                Check.IsTrue(coronaModeDropdown.GetAllOptionsFromDropDown().Contains(coronaMode), string.Format("'{0}' is an available option", coronaMode));     
            }
        }

        [Then(@"the default Corona Mode option is '(.*)'")]
        public void ThenTheDefaultCoronaModeOptionIs(string defaultOption)
        {
            var coronaModeDropdown = SourceTabView.CoronaModeDropdown;

            if (coronaModeDropdown != null)
            {
                string actual = coronaModeDropdown.SelectedOption.Text;
                if (string.IsNullOrEmpty(actual))
                {
                    actual = (String)((IJavaScriptExecutor)Report.Driver).ExecuteScript("return arguments[0].innerText", coronaModeDropdown.SelectedOption);
                }

                Check.IsTrue(actual == defaultOption, "The default selected dropdown option is " + defaultOption);
                Report.Screenshot(coronaModeDropdown);
            }
            else
            {
                Report.Fail("Unable to find Corona mode parameter");
            }
        }

    }
}
