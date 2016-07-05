using System;
using System.IO;
using System.Linq;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Modals;
using Quartz.Support.Views.Page;
using Quartz.Support.Views.TabViews;
using TechTalk.SpecFlow;

namespace Quartz.Features.Sources.StepDefinitions
{
    [Binding]
    public class SourceParametersSteps
    {

        private string configPath = ServiceHelper.GetTyphoonBinFolder() + "\\..\\config\\";
        private InstrumentControlWidget instrumentControl = new InstrumentControlWidget();
        private TunePage tunePage = new TunePage();

        [AfterScenario("cleanup_SourceSwitching")]
        public static void AfterScenario()
        {
            Modal.CloseModalIfOpen();
        }

        [AfterFeature("cleanup_SourceSwitching")]
        public static void AfterFeature()
        {
            // If running on the simulator
            if (TyphoonHelper.SimulatedInstrument)
            {
                TyphoonHelper.SetSourceTypeOnSimulator("ESI Lockspray");

                Wait.Until(e => AutomationDriver.Driver.FindElements(By.TagName("a")).Where(f => f.Text == "ESI LockSpray") != null, 15000);
            }
        }


        [Given(@"(.*) source is attached to the instrument")]
        public void GivenSourceIsAttachedToTheInstrument(string sourceType)
        {
            // If running on the simulator
            if (TyphoonHelper.SimulatedInstrument && TyphoonHelper.GetSourceType() != sourceType)
            {
                TyphoonHelper.SetSourceTypeOnSimulator(sourceType);
            }

            Tab tab = null;
            switch (sourceType)
            {
                case "ESI Lockspray":
                    tab = instrumentControl.ESILockSprayTab;
                    break;
                case "APCI Lockspray":
                    tab = instrumentControl.ApciTab;
                    break;
                case "APGC":
                    tab = instrumentControl.ApgcTab;
                    break;
                case "NanoFlow Lockspray":
                    tab = instrumentControl.NanoFlowTab;
                    break;
                default:
                    Report.Fail("Unknown Source Type");
                    break;
            }

            Check.IsNotNull(tab, sourceType + " tab is displayed");
        }

        [Given(@"the instrument is in '(.*)' mode")]
        [When(@"the instrument is in '(.*)' mode")]
        [When(@"the instrument is quickly put back into '(.*)' mode")]
        [When(@"the instrument is put into '(.*)' mode")]
        public void WhenTheInstrumentIsPutIntoMode(string mode)
        {
            if (mode.ToLower() == "operate")
            {
                if (tunePage.Controls.OperateButton.Enabled)
                    tunePage.Controls.OperateButton.Click();
            }
            else if (mode.ToLower() == "standby")
            {
                if (tunePage.Controls.StandByButton.Enabled)
                    tunePage.Controls.StandByButton.Click();
            }
            else if (mode.ToLower() == "source standby")
            {
                if (tunePage.Controls.SourceButton.Enabled)
                    tunePage.Controls.SourceButton.Click();
            }
            else
            {
                throw new NotImplementedException(string.Format("Mode '{0}' has not been defined", mode));
            }
        }

        [Given(@"factory defaults have been loaded")]
        public void GivenFactoryDefaultsHaveBeenLoaded()
        {
            // Load factory defaults - first delete factory_settings.gpb
            File.Delete(configPath + "factory_settings.gpb");
            tunePage.LoadFactoryDefaults();
        }

        [When(@"I enter different values for the following parameters")]
        [When(@"new values are entered for the following parameters")]
        public void WhenNewValuesAreEnteredForTheFollowingParameters(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                var parameter = row["Parameter"];
                var value = row["Value"];

                // For Corona Voltage and Corona Current parameters, the setting field only becomes active when the Corona Mode has been set
                if (parameter == "Corona Voltage (kV)")
                {
                    SourceTabView.CoronaModeDropdown.SetValue("Voltage");
                }
                else if (parameter == "Corona Current (µA)")
                {
                    SourceTabView.CoronaModeDropdown.SetValue("Current");
                }

                var control = SourceTabView.ControlDictionary[parameter].Setting;
                Wait.Until(c => control.Enabled, 3000);

                if (control != null)
                {
                    control.SetValue(value, true);
                }
                else
                {
                    Report.Fail("Unable to find parameter " + parameter, true);
                }
            }
        }


        [When(@"a '(.*)' is performed")]
        public void WhenAnActionIsPerformed(string action)
        {
            switch (action)
            {
                case "Save Set":
                    {
                        string tuneSetName = string.Format("TuneSet{0:yyyyMMddHHmmss}", DateTime.Now);

                        tunePage.SaveTuneSet(tuneSetName);
                        // Add the unique tune set name to the scenario context, so that a load action can retrieve it
                        ScenarioContext.Current.Add("TuneSet", tuneSetName);

                        break;
                    }
                case "Load Set":
                    {
                        var tuneSetName = ScenarioContext.Current.Get<string>("TuneSet");
                        tunePage.LoadTuneSet(tuneSetName);

                        break;
                    }
                default:
                    {
                        throw new NotImplementedException("Action not recognized");
                    }
            }
        }

        [When(@"the Corona Mode option is '(.*)'")]
        public void WhenTheCoronaModeOptionIs(string parameter)
        {
            SourceTabView.CoronaModeDropdown.SetValue(parameter);
        }



        [Then(@"the following '(.*)' source parameters and readbacks are available")]
        public void ThenTheFollowingSourceParametersAndReadbacksAreAvailable(string sourceType, TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                var source = row["Source"];
                var parameter = row["Parameter"];
                var readback = row["Readback"];

                // select the Source tab
                if (instrumentControl.TabControl.ActiveTab.Name != source)
                {
                    instrumentControl.TabControl.Select(source);
                }

                var control = SourceTabView.ControlDictionary[parameter].Setting;

                Report.Action(string.Format("Check the '{0}' parameter is displayed on the {1} tab", parameter, source));
                Check.IsNotNull(control, string.Format("{0} is displayed", parameter), true);

                if (readback.ToLower() == "yes")
                {
                    Report.Action(string.Format("Check the '{0}' parameter has a readback field", parameter));
                    var readbackTextBox = SourceTabView.ControlDictionary[parameter].Readback;
                    Check.IsNotNull(readbackTextBox, string.Format("Readback is displayed for '{0}'", parameter), true);
                }
                else
                {
                    Report.Action(string.Format("Check the '{0}' parameter does not have a readback field", parameter));
                    var readbackTextBox = SourceTabView.ControlDictionary[parameter].Readback;
                    Check.IsNull(readbackTextBox, string.Format("Readback is NOT displayed for '{0}'", parameter), true);
                }
            }

            Report.Screenshot(tunePage.Controls.ControlsWidget);
        }

        [Then(@"only these '(.*)' parameters are displayed on the '(.*)' tab")]
        public void ThenOnlyTheseParametersAreDisplayedOnTheTab(int expectedCount, string tab)
        {
            Report.Action(string.Format("Check there are only '{0}' parameters on the {1} tab", expectedCount, tab));

            if (instrumentControl.TabControl.ActiveTab.Name != tab)
            {
                instrumentControl.TabControl.Select(tab);
            }

            var actualCount = instrumentControl.TabControl.ActiveTab.AllParameters.Count;
            Check.AreEqual(expectedCount, actualCount, string.Format("The correct number of parameters are displayed on the {0} tab", tab));
        }


        [Then(@"each Parameter has the following Default Value, Resolution and UOM")]
        public void ThenEachParameterHasTheFollowingDefaultValueResolutionAndUOM(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                var parameter = row["Parameter"];
                var defaultValue = row["Default Value"];
                string resolution = row["Resolution"];
                var uom = row["UOM"];


                if (parameter == "Corona Voltage (kV)")
                {
                    SourceTabView.CoronaModeDropdown.SetValue("Voltage");
                }
                else if (parameter == "Corona Current (µA)")
                {
                    SourceTabView.CoronaModeDropdown.SetValue("Current");
                }

                var control = SourceTabView.ControlDictionary[parameter].Setting;
                Check.IsNotNull(control, string.Format("Found '{0}' parameter", parameter), true);

                if (control != null)
                {
                    Report.Action("Check the default value is " + defaultValue);
                    (control as TextBox).CheckText(defaultValue, true);

                    Report.Action("Check the resolution is " + resolution);
                    int decimalPlaces = 0;
                    if (resolution.Contains("."))
                        decimalPlaces = resolution.Split(new char[] { '.' }).Last().Length;

                    (control as TextBox).CheckResolution(decimalPlaces, true);

                    Report.Action("Check the Unit of Measurement is " + uom);

                    var label = control.Element.FindElement(By.XPath("ancestor::div[contains(@class, 'watRow')]")).FindElement(By.TagName("label"));

                    Check.IsTrue(label.Text.Contains("(" + uom + ")"), "Unit of measurement is " + uom, true);
                }
                else
                {
                    Report.Fail("Unable to check resolution and unit of measurement", true);
                }
            }
        }

        [Then(@"Source values outside the Min or Max cannot be entered for the following parameters")]
        public void ThenSourceValuesOutsideTheMinOrMaxCannotBeEnteredForTheFollowingParameters(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                string parameter = row["Parameter"];
                double min = double.Parse(row["Min"]);
                double max = double.Parse(row["Max"]);
                string resolution =  row["Resolution"];

                // For Corona Voltage and Corona Current parameters, the setting field only becomes active when the Corona Mode has been set
                if (parameter == "Corona Voltage (kV)")
                {
                    Report.Action("Set the Corona Mode to 'Voltage'");
                    SourceTabView.CoronaModeDropdown.SetValue("Voltage");
                }
                else if (parameter == "Corona Current (µA)")
                {
                    Report.Action("Set the Corona Mode to 'Current'");
                    SourceTabView.CoronaModeDropdown.SetValue("Current");
                }

                Report.Action(string.Format("The following steps check that the '{0}' parameter only accepts values between '{1}' and '{2}'", parameter, min, max));
                var control = SourceTabView.ControlDictionary[parameter].Setting;
                Wait.Until(c => control.Enabled, 5000);

                if (control != null)
                {
                    (control as TextBox).CheckMinimum(min, resolution, true);
                    (control as TextBox).CheckMaximum(max, resolution, true);
                }
                else
                {
                    Report.Fail("Unable to find parameter " + parameter, true);
                }
            }
        }


        [Then(@"if the Default Value is changed to a New Value\tthe Readback starts updating towards the new value")]
        public void ThenIfTheDefaultValueIsChangedToANewValueTheReadbackStartsUpdatingTowardsTheNewValue(TechTalk.SpecFlow.Table table)
        {
            Report.Action(string.Format("The following steps check the readback field responds to parameter value changes"));

            foreach (var row in table.Rows)
            {
                string parameter = row["Parameter"];
                string defaultValue = row["Default Value"];
                string newValue = row["New Value"];

                // For Corona Voltage and Corona Current parameters, the setting field only becomes active when the Corona Mode has been set
                if (parameter == "Corona Voltage (kV)")
                {
                    Report.Action("Set the Corona Mode to 'Voltage'");
                    SourceTabView.CoronaModeDropdown.SetValue("Voltage");

                    // wait for readback to establish
                    WaitForReadbackToBeWithinRange(SourceTabView.CoronaVoltageReadback, SourceTabView.CoronaVoltageSetting, 15);
                }
                else if (parameter == "Corona Current (µA)")
                {
                    Report.Action("Set the Corona Mode to 'Current'");
                    SourceTabView.CoronaModeDropdown.SetValue("Current");

                    // wait for readback to establish
                    WaitForReadbackToBeWithinRange(SourceTabView.CoronaCurrentReadback, SourceTabView.CoronaCurrentSetting, 15);
                }

                Report.Action(string.Format("Change the {0} parameter to '{1}'", parameter, newValue));

                var setting = SourceTabView.ControlDictionary[parameter].Setting;
                Wait.Until(c => setting.Enabled, 3000);

                if (setting != null)
                {
                    if ((setting as TextBox).Text != defaultValue)
                    {
                        Report.Action(string.Format("Setting {0} parameter back to its default value of '{1}'", parameter, defaultValue));
                        (setting as TextBox).SetText(defaultValue);

                        // wait for readback to establish
                        WaitForReadbackToBeWithinRange(SourceTabView.ControlDictionary[parameter].Readback, (TextBox)setting, 15);
                    }

                    CheckReadbackValueUpdatesTowardsNewValue(parameter, defaultValue, newValue, setting);
                }
                else
                {
                    Report.Fail(string.Format("Unable to find parameter setting field for parameter '{0}'", parameter), true);
                }
            }
        }

        [Then(@"the following default values are loaded for the parameters")]
        public void ThenTheFollowingDefaultValuesAreLoadedForTheParameters(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                string parameter = row["Parameter"];
                string defaultValue = row["Default Value"];

                Report.Action(string.Format("Check the {0} parameter value is restored to its default value", parameter));

                if (parameter == "Corona Voltage (kV)")
                {
                    SourceTabView.CoronaModeDropdown.SetValue("Voltage");
                }
                else if (parameter == "Corona Current (µA)")
                {
                    SourceTabView.CoronaModeDropdown.SetValue("Current");
                }

                var control = SourceTabView.ControlDictionary[parameter].Setting;

                if (control != null)
                {
                    Check.AreEqual(defaultValue, (control as TextBox).Text, "Default value loaded as expected", true);
                }
                else
                {
                    Report.Fail("Unable to find parameter " + parameter, true);
                }
            }
        }

        [Then(@"the following values are loaded for the parameters")]
        public void ThenTheFollowingValuesAreLoadedForTheParameters(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                string parameter = row["Parameter"];
                string value = row["Value"];

                if (parameter == "Corona Voltage (kV)")
                {
                    SourceTabView.CoronaModeDropdown.SetValue("Voltage");
                }
                else if (parameter == "Corona Current (µA)")
                {
                    SourceTabView.CoronaModeDropdown.SetValue("Current");
                }

                Report.Action(string.Format("Check the {0} parameter value is restored to '{1}'", parameter, value));
                var control = SourceTabView.ControlDictionary[parameter].Setting;

                if (control != null)
                {
                    Check.AreEqual(value, (control as TextBox).Text, "Value is as expected", true);
                }
                else
                {
                    Report.Fail("Unable to find parameter " + parameter, true);
                }
            }
        }

        private void CheckReadbackValueUpdatesTowardsNewValue(string parameter, string startingValue, string newValue, Control setting)
        {
            var readback = SourceTabView.ControlDictionary[parameter].Readback;
            var startingReadback = readback.Text;
            var startingSetting = (setting as TextBox).Text;
            int tolerance;

            if (readback != null)
            {
                if (!string.IsNullOrEmpty(readback.Text))
                {
                    Report.Debug("Starting readback value was " + startingReadback);

                    (setting as TextBox).SetText(newValue, true);

                    if (TyphoonHelper.SimulatedInstrument == false && parameter == "Source Temperature (°C)")
                    {
                        Report.Action("Source Temperature on an instrument takes a long time to change. Moving onto the next readback...");
                    }
                    else if (TyphoonHelper.SimulatedInstrument == false && parameter == "Source Offset (V)")
                    {
                        Report.Action("Source Offset readback is dependant on other parameter values on an instrument. Check increasing the setting increases the readback by the same amount.");
                        int valueChangeExpected = Convert.ToInt32(startingSetting) - Convert.ToInt32(startingReadback.Replace("-", ""));
                        int expectedReadbackValue = Convert.ToInt32(newValue) - valueChangeExpected;

                        //TODO: CheckAreEqual needs updating to allow a time tolerance as well as a leeway
                        Wait.ForMilliseconds(20000);
                        tolerance = 5;
                        Check.AreEqual(expectedReadbackValue, Convert.ToInt32(readback.Text.Replace("-", "")), tolerance, "The Source Offset readback has updated correctly");
                    }
                    else
                    {
                        tolerance = 15; // this is in percentage.
                        WaitForReadbackToBeWithinRange(readback, (setting as TextBox), tolerance, 60000, false);

                        Check.IsTrue(IsReadBackWithinRange(readback, (setting as TextBox), tolerance), string.Format("Readback is within {0}% of the setting value. Setting value: {1}, Readback value: {2}", tolerance, (setting as TextBox).Text, readback.Text), true);
                        Report.Screenshot(readback.Element);
                    }
                }
                else
                {
                    Report.Fail("Readback value is null", true);
                }
            }
            else
            {
                Report.Fail(string.Format("Unable to find readback field for parameter '{0}'", parameter), true);
            }
        }

        private static bool IsReadBackWithinRange(TextBox readback, TextBox setting, int percentTolerance)
        {
            var settingValue = setting.Text;

            if (settingValue.Contains("."))
            {
                decimal minReadback = Convert.ToDecimal(settingValue) - (Convert.ToDecimal(settingValue) / 100) * percentTolerance;
                decimal maxReadback = Convert.ToDecimal(settingValue) + (Convert.ToDecimal(settingValue) / 100) * percentTolerance;

                var readbackText = Convert.ToDecimal(readback.Text);
                bool withinRange = readbackText >= minReadback && readbackText <= maxReadback;
                return withinRange;
            }
            else
            {
                int minReadback = Convert.ToInt32(settingValue) - Convert.ToInt32(((Convert.ToDouble(settingValue) / 100) * percentTolerance));
                int maxReadback = Convert.ToInt32(settingValue) + Convert.ToInt32(((Convert.ToDouble(settingValue) / 100) * percentTolerance));

                var readbackText = Convert.ToInt32(readback.Text.Replace("-", ""));
                bool withinRange = readbackText >= minReadback && readbackText <= maxReadback;
                return withinRange;
            }
        }

        public static void WaitForReadbackToBeWithinRange(TextBox readback, TextBox setting, int percentTolerance, int timeInMilliseconds = 6000, bool throwTimeOutException = true)
        {
            Wait.Until(f => IsReadBackWithinRange(readback, setting, percentTolerance), 6000, "Waiting for readback to be within acceptable range of setting value: " + percentTolerance + "%", throwTimeOutException);
        }
    }
}
