using System;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.DevConsole.StepDefinitions
{
    [Binding]
    public class ScopeModeSteps
    {
        private ScopeModePage _scopeModePage;
        private InstrumentControlWidget _instrumentControlWidget;

        private IWebElement CurrentElement { get; set; }

        public ScopeModeSteps(ScopeModePage scopeModePage, InstrumentControlWidget instrumentControlWidget)
        {
            _scopeModePage = scopeModePage;
            _instrumentControlWidget = instrumentControlWidget;
        }

        [Given(@"the '(.*)' page has been accessed")]
        [When(@"Scope Mode is selected")]
        public void GivenThePageHasBeenAccessed(string scopeModePage)
        {
            ScopeModePage.GoTo();
            Wait.Until(() => !string.IsNullOrEmpty(_scopeModePage.Controls.MassTextBox.Text));
            Wait.Until(() => !string.IsNullOrEmpty(_scopeModePage.Controls.SpanTextBox.Text));
        }

        [Then(@"the following text parameters with a specific type will be available")]
        public void ThenTheFollowingParametersWithASpecificTypeWillBeAvailable(TechTalk.SpecFlow.Table controls)
        {
            foreach (var row in controls.Rows)
            {
                string labelText = row["Parameters"];
                string expectedControlType = row["Type"];

                var control = _scopeModePage.ControlDictionary[labelText].Setting as TextBox;
                Check.IsNotNull(control, "Found text parameter " + labelText);

                switch (expectedControlType)
                {
                    case "Numeric":
                        if (labelText.Equals("Mass") || labelText.Equals("Span"))
                        {
                            decimal testValue = decimal.Parse(control.Text) + 1;
                            control.SetText(Convert.ToInt32(testValue).ToString());
                            continue;
                        }
                        control.CheckIsNumeric(true);
                        break;
                    case "Decimal":
                        control.CheckIsDecimalOnly(false);
                        break;
                    default:
                        Report.Fail(string.Format("Unable to find a parameter {0}.", labelText), continueOnFail: true);
                        break;
                }
            }
        }

        [Then(@"the following dropdown parameters with specific options will be available")]
        public void ThenTheFollowingDropdownParametersWithSpecificOptionsWillBeAvailable(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                var field = row["Parameters"];
                var options = row["Options"];

                string[] expectedOptions = options.Split(new[] { ", " }, StringSplitOptions.None);

                var dropdownControl = _scopeModePage.ControlDictionary[field].Setting as Dropdown;
                Check.IsNotNull(dropdownControl, "Found dropdown parameter " + field);

                Check.AreEqual(expectedOptions.Length, dropdownControl.Options.Count, "The number of dropdown options available is equal to the number expected", true);

                foreach (var option in expectedOptions)
                {
                    dropdownControl.CheckOptionIsAvailable(option, true);
                }
            }
        }

        [AfterScenario("ScopeMode")]
        public void ThenTheMassIsResetBackToAndTheSpanIsResetBackTo()
        {
            _scopeModePage.Controls.MassTextBox.TrySetText("550");
            _scopeModePage.Controls.SpanTextBox.TrySetText("50");
        }


        [StepDefinition(@"the Mass is set to '(.*)'")]
        public void GivenTheMassIsSetTo(string value)
        {
            _scopeModePage.Controls.MassTextBox.SetText(value);
        }

        [StepDefinition(@"the Span is set to '(.*)'")]
        public void GivenTheSpanIsSetTo(string value)
        {
            _scopeModePage.Controls.SpanTextBox.SetText(value);
        }

        [Then(@"the '(.*)' value '(.*)' is allowed or disallowed (.*)")]
        public void ThenTheValueIsAllowedOrDisallowedYes(string parameter, string value, string allowed)
        {
            TextBox textBox;
            switch (parameter)
            {
                case "Span":
                    textBox = _scopeModePage.Controls.SpanTextBox;            
                    break;
                case "Mass":
                    textBox = _scopeModePage.Controls.MassTextBox;
                    break;
                default:
                    textBox = null;
                    Report.Fail("Unknown parameter: " + parameter);
                    break;
            }

            textBox.TrySetText(value);

            if (allowed.ToLower() == "yes")
            {
                Check.AreEqual(value, () => textBox.Text, value + " was accepted", false, 2000);
                Report.Screenshot();
            }
            else if (allowed.ToLower() == "no")
            {
                Check.IsTrue(() => textBox.Text != value, " value was NOT accepted", false, 5000);
                Report.Screenshot();
            }
            else
                Report.Fail("Unknown value of " + allowed);
        }

        [Then(@"the following Span values are allowed or disallowed")]
        public void ThenTheFollowingSpanValuesAreAllowedOrDisallowed(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                var spanValue = row["Span"];
                var allowed = row["Allowed"];

                var spanTextBox = _scopeModePage.Controls.SpanTextBox;                  
                spanTextBox.TrySetText(spanValue);

                if (allowed.ToLower() == "yes")
                    Check.AreEqual(spanValue, spanTextBox.Text, spanValue + " was accepted");
                else if (allowed.ToLower() == "no")
                    Check.AreNotEqual(spanValue, spanTextBox.Text, spanValue + " was NOT accepted");
                else
                    Report.Fail("Unknown value of " + allowed);
            }
        }




        [Then(@"the following Scope Mode settings have these default values with defined resolutions \(dp\)")]
        public void ThenTheFollowingScopeModeSettingsHaveTheseDefaultValuesWithDefinedResolutions(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                var scopeModeSetting = row["Scope Mode Settings"];
                var defaultInput = row["Default"];
                var resolutionInput = row["Resolution (dp)"];

                CheckScopeModeSettingValuesWithDefinedResolutions(scopeModeSetting, defaultInput, resolutionInput);
            }
        }

        private void CheckScopeModeSettingValuesWithDefinedResolutions(string scopeModeSetting, string defaultInput, string resolutionInput)
        {
            // TODO: Refactor this switch statement if possible
            switch (scopeModeSetting)
            {
                case "Mass":
                    _scopeModePage.Controls.MassTextBox.CheckValueAndResolution(defaultInput, resolutionInput);
                    break;
                case "Span":
                    _scopeModePage.Controls.SpanTextBox.CheckValueAndResolution(defaultInput, resolutionInput);
                    break;
                default:
                    throw new NoSuchElementException("Unable to find an element");
            }
        }
        
        [Then(@"they will be filtered to show only the '(.*)' tab")]
        public void ThenTheyWillBeFilteredToShowOnlyTheTab(string tabTitle)
        {
            int numberOfVisibleTabs = 1;
            Check.AreEqual(numberOfVisibleTabs, _instrumentControlWidget.TabControl.Tabs.Count, "The correct number of tabs are present", continueOnFail:true);
            Check.IsNotNull(_instrumentControlWidget.TabControl.FindTab(tabTitle), string.Format("The {0} tab is present", tabTitle), continueOnFail: true);
            Report.Screenshot();

        }
    }
}
