using Automation.Reporting.Lib;
using Quartz.Support.Views;
using Quartz.Support.Views.TabViews;
using TechTalk.SpecFlow;

namespace Quartz.Features.Sources.StepDefinitions
{
    [Binding]
    public class APPISourceParametersSteps
    {
        private static InstrumentControlWidget instrumentControl = new InstrumentControlWidget();

        
        [Then(@"the APPI Lamp parameter is available with the following dropdown options")]
        public void ThenTheAPPILampParameterIsAvailableWithTheFollowingDropdownOptions(TechTalk.SpecFlow.Table table)
        {
            var lampDropdown = SourceTabView.LampDropdown;
            Check.IsNotNull(lampDropdown, "Lamp dropdown is displayed");
            Report.Screenshot(lampDropdown);

            foreach (var row in table.Rows)
            {
                var lampMode = row["Lamp"];

                Report.Action("Check Lamp parameter has an option of: " + lampMode);
                Check.IsTrue(lampDropdown.GetAllOptionsFromDropDown().Contains(lampMode), string.Format("'{0}' is an available option", lampMode));
            }
        }
        
        [Then(@"the default APPI Lamp option is '(.*)'")]
        public void ThenTheDefaultAPPILampOptionIs(string defaultOption)
        {
            var lampDropdown = SourceTabView.LampDropdown;

            if (lampDropdown != null)
            {
                Check.IsTrue(lampDropdown.SelectedOption.Text == defaultOption, "The default selected dropdown option is " + defaultOption);
                Report.Screenshot(lampDropdown);
            }
            else
            {
                Report.Fail("Unable to find Lamp parameter");
            }
        }

    }
}
