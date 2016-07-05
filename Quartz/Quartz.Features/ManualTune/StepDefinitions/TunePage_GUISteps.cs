using System;
using System.Linq;
using Automation.Config.Lib.ConfigHelpers;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.Configuration;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.ManualTune.StepDefinitions
{
    [Binding]
    public class TunePage_GUISteps
    {
        TunePage _tunePage;
        TuneConfig _tuneConfig;
        InstrumentControlWidget _instrumentControl;

        public TunePage_GUISteps(TunePage tunePage, InstrumentControlWidget instrumentControl)
        {
            _tunePage = tunePage;
            _instrumentControl = instrumentControl;
            _tuneConfig = new TuneConfig(new TestConfiguration(new AppSettingsConfigurationManager()).Instrument); ;
        }
                

        [AfterScenario("cleanup_ParameterValues")]
        public void RestoreParameterValues()
        {
            //TODO: Instead of restarting Typhoon we need to reset Hardware Control and flush the parameters to be default out of the box
            ServiceHelper.RestartTyphoonAndQuartz();
        }

        [AfterScenario("cleanup_TUN_04")]
        public void AfterScenario()
        {
            // Ensure the instrument is back in Operate mode
            _tunePage.Controls.OperateButton.Click();
        }

        //TODO: Do we want to put all navigation steps in a single step definition file?
        [StepDefinition(@"that the browser is opened on the Tune page")]
        [StepDefinition(@"the browser is opened on the Tune page")]
        [StepDefinition(@"that the Quartz Tune page is open")]
        public void GivenThatTheQuartzTunePageIsOpen()
        {
            NavigationMenu.TuneAnchor.Click();        
        }
        
        [Given(@"the instrument is in Standby")]
        public void GivenTheInstrumentIsInStandby()
        {
            _tunePage.Controls.StandByButton.Click();

            string expectedStatus = "red";
            Check.AreEqual(expectedStatus, () => _tunePage.GetOperateStatus().ToLower(), "The Instrument is in standby. The power indicator is: " + expectedStatus, false, 8000);
        }

        [When(@"the polarity is switched to (.*)")]
        [Given(@"the polarity is (.*)")]
        [Given(@"the polarity is '(.*)'")]
        public void GivenAndThePolarityIs(string polarity)
        {
            _tunePage.SwitchConfiguration(null, polarity, false);
        }

        [When(@"the mode is switched to (.*)")]
        public void WhenTheModeIsSwitchedTo(string mode)
        {
            _tunePage.SwitchConfiguration(mode, null, false);
        }

        [Then(@"the Controls panel will display the correct tabs")]
        public void ThenTheControlsPanelWillDisplayTheCorrectTabs()
        {
            foreach (var expectedTab in _tuneConfig.Tabs)
            {
                Check.Exists(By.Id(expectedTab.AutomationId), expectedTab.Title + " is displayed", true);
            }

            Check.AreEqual(_tuneConfig.Tabs.Count, _tunePage.ControlsWidget.TabControl.Tabs.Count, "The correct number of tabs are displayed");
            Report.Screenshot();
        }

        [Then(@"the correct plot header controls are enabled and preselected")]
        public void ThenTheCorrectPlotHeaderControlsAreEnabledAndPreselected()
        {
            foreach (var expectedControl in _tuneConfig.PlotHeaderControls)
            {
                CheckControlEnabledAndSelected(expectedControl);
            }
        }

        [Then(@"the correct plot controls are enabled and preselected")]
        public void ThenTheCorrectPlotControlsAreEnabledAndPreselected()
        {
            foreach (var expectedControl in _tuneConfig.PlotControls)
            {
                CheckControlEnabledAndSelected(expectedControl);
            }
        }

        [Then(@"the correct instrument controls are enabled and preselected")]
        public void ThenTheCorrectInstrumentControlsAreEnabledAndPreselected()
        {
            foreach (var expectedControl in _tuneConfig.InstrumentControls)
            {
                CheckControlEnabledAndSelected(expectedControl);
            }
        }

        [Then(@"the correct tab controls are enabled and preselected")]
        public void ThenTheCorrectTabControlsAreEnabledAndPreselected()
        {
            foreach (var expectedControl in _tuneConfig.TabControls)
            {
                CheckControlEnabledAndSelected(expectedControl);
            }
        }

        [StepDefinition(@"the '(.*)' tab is selected")]
        public void WhenTheTabIsSelected(string tab)
        {
            _instrumentControl.TabControl.Select(tab);
        }

        [Then(@"the correct panels are available")]
        public void ThenTheCorrectPanelsAreAvailable()
        {
            foreach (var expectedPanel in _tuneConfig.Panels)
            {
                Check.Exists(By.Id(expectedPanel.Id), expectedPanel.Title + " is displayed", true);  
            }

            Check.AreEqual(_tuneConfig.Panels.Count, _tunePage.AllWidgets.Count, "The correct number of panels are displayed");
            Report.Screenshot();
        }

        [Then(@"the customized tab view displays the correct available tabs")]
        public void ThenTheCustomizedTabViewDisplaysTheCorrectAvailableTabs()
        {
            var expectedTabs = _tuneConfig.Tabs.ConvertAll(t => t.Title).ToArray();
            var customTabView = _tunePage.Controls.ControlsWidget.TabVisibleSettingButton;
            
            Check.AreEqual(expectedTabs.Length, customTabView.DropdownOptions.Count, expectedTabs.Length + " tabs are available in the dropdown");      
            customTabView.CheckDropdownOptionDisplayed(expectedTabs);
        }


        [Then(@"the following '(.*)' are available with the '(.*)'")]
        public void ThenTheFollowingAreAvailableWithThe(string controlName, string selections, TechTalk.SpecFlow.Table table)
        {
            foreach (var control in table.Rows)
            {
                var dropdown = control[controlName];
                var expectedSelections = Array.ConvertAll(control[selections].Split(','), s => s.TrimStart());

                ButtonDropdown buttonDropdown;
                switch (dropdown)
                {
                    case "Factory Parameters":
                        buttonDropdown = _tunePage.Controls.FactoryDefaultsDropdown;
                        break;
                    case "Acquisition":
                        buttonDropdown = _tunePage.Controls.AcquisitionDropdown;
                        break;
                    case "User defined tab controls":
                        buttonDropdown = _tunePage.Controls.ControlsWidget.TabOptionsButton;
                        break;
                    case "Customize tab view":
                        buttonDropdown = _tunePage.Controls.ControlsWidget.TabVisibleSettingButton;
                        break;
                    default:
                        Report.Fail("Dropdown control not implemented");
                        buttonDropdown = null;
                        break;
                }

                buttonDropdown.CheckDropdownOptionDisplayed(expectedSelections);
                Check.AreEqual(expectedSelections.Length, buttonDropdown.DropdownOptions.Count, string.Format("The dropdown contains {0} selections", expectedSelections.Length));
            }
        }


        [StepDefinition(@"the correct readbacks are displayed for each polarity mode combination")]
        public void ThenTheCorrectReadbacksAreDisplayed()
        {
            foreach (var combination in _tuneConfig.PolarityModeCombinations)
            {
                _tunePage.SwitchConfiguration(combination.Mode, combination.Polarity);

                foreach (var configTab in _tuneConfig.Tabs)
                {
                    if (configTab.Title == "Fluidics" || configTab.Title == "ESI LockSpray")
                        continue;

                    _tunePage.SelectTabById(configTab.AutomationId);

                    var expectedParameters = configTab.Parameters;
                    foreach (var configTuneParameter in expectedParameters)
                    {
                        if (configTuneParameter.Readback != null)
                        {
                            Check.Exists(By.Id(configTuneParameter.Readback),
                                configTuneParameter.Name + " readback is displayed");
                        }
                    }

                    var expectedNumOfReadbacks = expectedParameters.Where(p => p.Readback != null).ToList().Count;

                    Check.AreEqual(expectedNumOfReadbacks,
                        () => _instrumentControl.FindReadbacks().Count,
                        "Expected number of readbacks displayed", false, 2000);

                    Report.Screenshot(_tunePage.Controls.ControlsPanel.Element);
                }
            }
        }

        [Then(@"the Control Parameter defaults match the instrument specification for each polarity mode combination")]
        public void ThenTheControlParameterDefaultsShouldMatchTheInstrumentSpecification()
        {
            foreach (var combination in _tuneConfig.PolarityModeCombinations)
            {
                _tunePage.SwitchConfiguration(combination.Mode, combination.Polarity);

                CheckControlsDefaultValue();
            }
        }

        [Then(@"the Control Parameter defaults match the instrument specification for '(.*)' mode combination")]
        public void ThenTheControlParameterDefaultsMatchTheInstrumentSpecificationForModeCombination(string polarity)
        {
            foreach (var combination in _tuneConfig.PolarityModeCombinations.Where(p => p.Polarity.StartsWith(polarity)))
            {
                _tunePage.SwitchConfiguration(combination.Mode, combination.Polarity);
                
                CheckControlsDefaultValue();
            }
        }        


        [Then(@"the Control Parameters min, max and resolution match the instrument specification for each '(.*)' mode combination")]
        public void ThenTheControlParametersMinMaxAndResolutionShouldMatchTheInstrumentSpecification(string polarity)
        {
            foreach (var combination in _tuneConfig.PolarityModeCombinations.Where(p => p.Polarity.StartsWith(polarity)))
            {
                _tunePage.SwitchConfiguration(combination.Mode, combination.Polarity);

                foreach (var configTab in _tuneConfig.Tabs)
                {
                    if (configTab.Title == "Fluidics" || configTab.Title == "ESI LockSpray")
                        continue;

                    _tunePage.SelectTabById(configTab.AutomationId);

                    foreach (var parameter in configTab.Parameters)
                    {
                        if (parameter.Name.StartsWith("Ramp Time") || parameter.Name.StartsWith("Dwell Time"))
                            continue;

                        var originalValue = _instrumentControl.SetDualControl(parameter.Name);

                        TextBox textbox = _tunePage.FindTextBoxById(parameter.Setting);
                        Wait.Until(c => textbox.Enabled, 1000);

                        // If resolution is null, then it is not a textbox
                        if (!string.IsNullOrEmpty(parameter.Resolution.ToString()))
                        {
                            // Check min,max and resolution
                            var decimalPlaces = parameter.Resolution.ToString().DecimalPlaces();

                            textbox.CheckMinimum(double.Parse(parameter.Min), parameter.Resolution, true);
                            textbox.CheckMaximum(double.Parse(parameter.Max), parameter.Resolution, true);
                            textbox.CheckResolution(decimalPlaces, true);
                        }
                        else
                        {
                            Report.Action("Unable to check minimum and maximum. Control is not a textbox");
                        }

                        _instrumentControl.SetDualControl(parameter.Name, originalValue);
                    }
                }
            }
        }


        [StepDefinition(@"the Dwell Time and Ramp Time parameter defaults match the instrument specification for each polarity mode combination")]
        public void ThenTheDwellTimeAndRampTimeParameterDefaultsMatchTheInstrumentSpecificationForEachPolarityModeCombination()
        {
            // Assumptions are made that the parameters are always linked across instruments, on the same tab, and linked to the Quadrople dropdown value.
            foreach (var combination in _tuneConfig.PolarityModeCombinations)
            {
                _tunePage.SwitchConfiguration(combination.Mode, combination.Polarity);

                CheckDwellAndRampTimeDefautValue();
            }
        }

        [Then(@"the Dwell Time and Ramp Time parameter defaults match the instrument specification for '(.*)' mode combination")]
        public void ThenTheDwellTimeAndRampTimeParameterDefaultsMatchTheInstrumentSpecificationForModeCombination(string polarity)
        {
            foreach (var combination in _tuneConfig.PolarityModeCombinations.Where(p => p.Polarity.StartsWith(polarity)))
            {
                _tunePage.SwitchConfiguration(combination.Mode, combination.Polarity);
                
                CheckDwellAndRampTimeDefautValue();
            }
        }
              

        [Then(@"the Dwell Time and Ramp Time parameter min, max and resolution match the instrument specification for each polarity mode combination")]
        public void ThenTheDwellTimeAndRampTimeParameterMinMaxAndResolutionMatchTheInstrumentSpecificationForEachPolarityModeCombination()
        {
            // Assumptions are made that the parameters are always linked across instruments, on the same tab, and linked to the Quadrople dropdown value.

            foreach (var combination in _tuneConfig.PolarityModeCombinations)
            {
                _tunePage.SwitchConfiguration(combination.Mode, combination.Polarity);

                var expectedControls =
                    _tuneConfig.Parameters.Where(p => p.Name.StartsWith("Dwell Time") || p.Name.StartsWith("Ramp Time"))
                        .ToList();

                if (expectedControls.Count > 0)
                {
                    _tunePage.SelectTabById(expectedControls[0].Tab.AutomationId);

                    var originalValue = _instrumentControl.SetDualControl("Dwell Time 1");

                    // Find interlinked controls. These parameters behave differently. Collectively they add up to 100, so to test min and max, all fields must be 0
                    TextBox dwellTime1TextBox =
                            _tunePage.FindTextBoxById(_tuneConfig.GetParameterByName("Dwell Time 1").Setting);
                    TextBox dwellTime2TextBox =
                        _tunePage.FindTextBoxById(_tuneConfig.GetParameterByName("Dwell Time 2").Setting);
                    TextBox rampTime1TextBox =
                        _tunePage.FindTextBoxById(_tuneConfig.GetParameterByName("Ramp Time 1").Setting);

                    foreach (var parameter in expectedControls)
                    {
                        if (parameter.Name == "Ramp Time 2")
                            continue;

                        dwellTime1TextBox.SetText("0");
                        dwellTime2TextBox.SetText("0");
                        rampTime1TextBox.SetText("0");

                        var textbox = _tunePage.FindTextBoxById(parameter.Setting);

                        // Check min, max and resolution
                        var decimalPlaces = parameter.Resolution.DecimalPlaces();

                        textbox.CheckMinimum(double.Parse(parameter.Min), parameter.Resolution, true);
                        textbox.CheckMaximum(double.Parse(parameter.Max), parameter.Resolution, true);
                        textbox.CheckResolution(decimalPlaces, true);
                    }

                    _instrumentControl.SetDualControl("Dwell Time 1", originalValue);
                }
                else
                {
                    Report.Fail("Unable to locate parameters in config file");
                }
            }
        }

        /// <summary>
        /// This method check the default value of tune config parameter for active polarity and mode.
        /// </summary>
        private void CheckControlsDefaultValue()
        {
            foreach (var configTab in _tuneConfig.Tabs)
            {
                if (configTab.Title == "Fluidics" || configTab.Title == "ESI LockSpray")
                    continue;

                _tunePage.SelectTabById(configTab.AutomationId);

                foreach (var parameter in configTab.Parameters)
                {
                    if (parameter.Name.StartsWith("Ramp Time") || parameter.Name.StartsWith("Dwell Time"))
                        continue;

                    var originalValue = _instrumentControl.SetDualControl(parameter.Name);

                    string expectedDefaultValue = _tuneConfig.GetParameterDefaultValue(parameter, _tunePage.GetCurrentConfiguration());

                    if (!parameter.IsAcquisitionMode)
                    {
                        Control control = _tunePage.FindControlById(parameter.Setting);
                        Wait.Until(c => control.Enabled, timeoutInMilliseconds: 1000);

                        control.CheckValue(expectedDefaultValue);
                    }

                    _instrumentControl.SetDualControl(parameter.Name, originalValue);

                }
            }
        }

        /// <summary>
        /// This method checks the default value for Dwell Time and Ramp Time for active polarity mode
        /// </summary>
        private void CheckDwellAndRampTimeDefautValue()
        {
            var expectedControls =
                _tuneConfig.Parameters.Where(p => p.Name.StartsWith("Dwell Time") || p.Name.StartsWith("Ramp Time"))
                    .ToList();

            if (expectedControls.Count > 0)
            {
                _tunePage.SelectTabById(expectedControls[0].Tab.AutomationId);

                var originalValue = _instrumentControl.SetDualControl("Dwell Time 1");


                foreach (var parameter in expectedControls)
                {
                    if (parameter.Name == "Ramp Time 2")
                        continue;

                    var textbox = _tunePage.FindTextBoxById(parameter.Setting);

                    // Check default value
                    string expectedDefaultValue = _tuneConfig.GetParameterDefaultValue(parameter, _tunePage.GetCurrentConfiguration());
                    textbox.CheckValue(expectedDefaultValue, true);
                }

                _instrumentControl.SetDualControl("Dwell Time 1", originalValue);



            }
            else
            {
                Report.Fail("Unable to locate parameters in config file");
            }
        }

        
        private void CheckControlEnabledAndSelected(TuneConfig.ConfigControl expectedControl)
        {
            var control = _tunePage.FindControlById(expectedControl.Id);

            control.CheckEnabledState(expectedControl.Enabled);
            control.CheckSelectedState(expectedControl.Selected);
        }
    }
}
