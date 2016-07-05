using System;
using System.Collections.Generic;
using System.Linq;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;
using Table = TechTalk.SpecFlow.Table;

namespace Quartz.Features.DevConsole.StepDefinitions
{
    [Binding]
    public class QuadSetupSteps
    {
        Dictionary<string, string> PeakDisplayGraphs = new Dictionary<string, string>();
        QuadSetupPage quadSetupPage = new QuadSetupPage();

        [Given(@"the browser is opened on the Quad Setup page")]
        public void GivenTheBrowserIsOpenedOnTheQuadSetupPage()
        {
            NavigationMenu.QuadSetupAnchor.Click();
        }

        [Given(@"all 4 Peak Display Graphs are displayed")]
        public void GivenAllPeakDisplayGraphsAreDisplayed()
        {
            quadSetupPage.Controls.Mass1CheckBox.SelectCheckBox();
            quadSetupPage.Controls.Mass2CheckBox.SelectCheckBox();
            quadSetupPage.Controls.Mass3CheckBox.SelectCheckBox();
            quadSetupPage.Controls.Mass4CheckBox.SelectCheckBox();
        }

        [Given(@"the quad is a (.*)")]
        public void GivenTheQuadIsA(string quad)
        {
            if (quad == "<get>")
            {
                GetQuadType();
            }
            else
            {
                string type = "4k";
                switch (quad)
                {
                    case "3940":
                        type = "4k";
                        break;
                    case "8000":
                        type = "8k";
                        break;
                    case "32000":
                        type = "32k";
                        break;
                    default:
                        Report.Fail("Unknown Quad type " + quad);
                        break;
                }

                TyphoonHelper.SetKeyValueStoreParameterValue("Simulator", "Simulation.QuadType", type);
                // Waiting allows the UI fields to respond to the quad change.
                Wait.ForMilliseconds(5000);
                Check.AreEqual(type, TyphoonHelper.GetKeyValueStoreParameterValue("Simulator", "Simulation.QuadType"), "The quad is a " + type);
            }
        }

        private string GetQuadType()
        {
            var quadType = TyphoonHelper.GetHardwareControlMode("QuadMode");
            Report.Action("The Quad Type is: " + quadType);
            return quadType;
        }

        [When(@"I change all the control parameters to")]
        [Given(@"all control parameters are set to")]
        public void GivenAllControlParametersAreSetTo(Table table)
        {
            foreach (var row in table.Rows)
            {
                var parameter = row["Parameter"];
                var value = row["Value"];

                Control control = quadSetupPage.ControlDictionary[parameter].Setting;
                Check.IsNotNull(control, string.Format("Found '{0}' parameter", parameter), true);

                control.SetValue(value, true);
            }
        }

        [Given(@"all 4 masses are selected")]
        public void GivenAllFourMassesAreSelected()
        {
            Report.Action("Check Mass 1, Mass 2, Mass 3 and Mass 4");

            quadSetupPage.Controls.Mass1CheckBox.SelectCheckBox();
            quadSetupPage.Controls.Mass2CheckBox.SelectCheckBox();
            quadSetupPage.Controls.Mass3CheckBox.SelectCheckBox();
            quadSetupPage.Controls.Mass4CheckBox.SelectCheckBox();

            Report.Action("Ensure 4 peak display graphs are displayed");
            Check.IsTrue(quadSetupPage.PeakDisplayGraphs.Count == 4, "4 graphs are displayed on the page");

            PeakDisplayGraphs.Clear();

            int mass = 1;
            foreach (var graph in quadSetupPage.PeakDisplayGraphs)
            {                 
                string id = graph.GetAttribute("id");
                PeakDisplayGraphs.Add("Mass " + mass, id);
                mass++;
            }
        }

        [Then(@"when I '(.*)' the Quad control parameter settings")]
        [When(@"I '(.*)' the Quad control parameter settings")]
        public void WhenITheQuadControlParameterSettings(string action)
        {
            switch (action)
            {
                case "Save":
                    Report.DebugScreenshot();
                    quadSetupPage.Controls.SaveButton.Click();
                    break;
                case "Recall":
                    quadSetupPage.Controls.RecallButton.Click();                 
                    break;
                case "Default":
                    quadSetupPage.Controls.DefaultButton.Click();
                    break;
                default:
                    Report.Fail("Action not implemented...", false);
                    break;
            }

            Wait.ForMilliseconds(5000);
            Report.DebugScreenshot();
        }


        [When(@"I deselect quad '(.*)'")]
        public void WhenIDeselect(string mass)
        {
            switch (mass)
            {
                case "Mass 1":
                    quadSetupPage.Controls.Mass1CheckBox.UnSelectCheckBox();
                    break;
                case "Mass 2":
                    quadSetupPage.Controls.Mass2CheckBox.UnSelectCheckBox();
                    break;
                case "Mass 3":
                    quadSetupPage.Controls.Mass3CheckBox.UnSelectCheckBox();
                    break;
                case "Mass 4":
                    quadSetupPage.Controls.Mass4CheckBox.UnSelectCheckBox();
                    break;
                case "Mass 1, Mass 2 and Mass 4":
                    quadSetupPage.Controls.Mass1CheckBox.UnSelectCheckBox();
                    quadSetupPage.Controls.Mass2CheckBox.UnSelectCheckBox();
                    quadSetupPage.Controls.Mass4CheckBox.UnSelectCheckBox();
                    break;
                default:
                    Report.Fail("Unrecognized action...");
                    break;
            }
        }

        [When(@"I select quad '(.*)'")]
        public void WhenISelect(string mass)
        {
            switch (mass)
            {
                case "Mass 1":
                    quadSetupPage.Controls.Mass1CheckBox.SelectCheckBox();
                    break;
                case "Mass 2":
                    quadSetupPage.Controls.Mass2CheckBox.SelectCheckBox();
                    break;
                case "Mass 3":
                    quadSetupPage.Controls.Mass3CheckBox.SelectCheckBox();
                    break;
                case "Mass 4":
                    quadSetupPage.Controls.Mass4CheckBox.SelectCheckBox();
                    break;
                default:
                    Report.Fail("Unrecognized action...");
                    break;
            }
        }

        [When(@"the Quad Mode parameter is set to '(.*)'")]
        public void WhenTheQuadModeParameterIsSetTo(string option)
        {
            quadSetupPage.Controls.QuadModeDropDown.SelectOptionFromDropDown(option);
            Wait.ForMilliseconds(4000, "Waiting for align mode to take effect...");
        }

        [Then(@"the Rectified RF readback will stay the same over all scans within tolerance '(.*)'")]
        public void ThenTheRectifiedRFReadbackWillStayTheSameOverAllScans(string tolerance)
        {
            Report.Action("Check the RF Readback values remains constant");         

            List<string> rfValues = new List<string>();
            
            //Read RF value for every 200 milliseconds 
            for (int i = 0; i < 10; i++)
            {
                var value = quadSetupPage.Controls.RectifiedRFTextBox.Text;
                rfValues.Add(value);
                Report.Debug("RF readback value is " + value);
                Wait.ForMilliseconds(200, "Waiting 200 milliseconds");
            }

            var startValue = rfValues[0];
            foreach (var value in rfValues)
            {
                Check.AreEqual(Convert.ToDouble(startValue), Convert.ToDouble(value), Convert.ToDouble(tolerance), "The RF readback value has stayed the same within tolerance of " + tolerance);
            }
        }

        [Then(@"the Rectified RF readback will vary over all scans")]
        public void ThenTheRectifiedRFReadbackWillVaryOverAllScans()
        {
            Report.Action("Check the RF Readback value varies over all scans");

            List<string> rfValues = new List<string>();
            
            //Read RF value for every 200 milliseconds 
            for (int i = 0; i < 10; i++)
            {
                var value = quadSetupPage.Controls.RectifiedRFTextBox.Text;
                rfValues.Add(value);
                Report.Debug("RF readback value is " + value);
                Wait.ForMilliseconds(200, "Waiting 200 milliseconds");
            }

            Check.IsTrue(rfValues.Distinct().Count() > 1, "The Rectified RF value is changing");
        }

        [Then(@"each field has the following Default Value and Resolution for the Quad Mass (.*)")]
        public void ThenEachFieldHasTheFollowingDefaultValueAndResolutionForTheQuadMass(string quad, Table table)
        {
            foreach (var row in table.Rows)
            {
                string parameter = row["Field"];
                string resolution = row["Resolution"];

                string expectedDefaultValue;
                if (quad == "<get>")
                    expectedDefaultValue = row[string.Format("{0} Default Value", GetQuadType())];
                else
                    expectedDefaultValue = row[string.Format("{0} Default Value", quad)];

                // Find parameter
                Control control = quadSetupPage.ControlDictionary[parameter].Setting;
                Check.IsNotNull(control, string.Format("Found '{0}' parameter", parameter), true);
                
                if (control != null)
                {
                    Report.Action("Check the default value is " + expectedDefaultValue);
                    control.CheckValue(expectedDefaultValue, true);

                    if (resolution != "na") // na = Not applicable to this parameter
                    {
                        Report.Action("Check the resolution is " + resolution);
                        int decimalPlaces = 0;
                        if (resolution.Contains("."))
                            decimalPlaces = resolution.Split(new char[] { '.' }).Last().Length;

                        if (control is TextBox)
                        {
                            CheckMassResolution((control as TextBox), decimalPlaces, true);
                        }
                    }
                }
                else
                {
                    Report.Fail("Unable to check default value and resolution for parameter " + parameter, true);
                }              
            }
        }
        public void CheckMassResolution(TextBox textbox, int decimalPlaces, bool continueOnFail = false)
        {
            if (decimalPlaces == 0)
            {
                Check.IsTrue(!textbox.Text.Contains("."), "Resolution is currently an integer", continueOnFail);

                Report.Action("Check TextBox does not accept a decimal");
                textbox.TrySetText(textbox.Text + ".0");

                Check.IsFalse(textbox.Text.Contains("."), "TextBox resolution does not accept a decimal", continueOnFail);

                Report.DebugScreenshot(textbox.Element);
            }
            else
            {
                if (textbox.GetFractionalPart() != null)
                {
                    Check.AreEqual(decimalPlaces, textbox.GetFractionalPart().Length, "TextBox resolution is to the correct number of decimal places", continueOnFail);
                }
                else
                {
                    Report.Fail("Resolution is not a decimal", true);
                    Report.Screenshot(textbox.Element);
                }
            }
        }

        [Then(@"the control parameters are equal to")]
        public void ThenTheControlParametersAreEqualTo(Table table)
        {
            foreach (var row in table.Rows)
            {
                string parameter = row["Parameter"];
                string value = row["Value"];

                var control = quadSetupPage.ControlDictionary[parameter].Setting;

                if (control != null)
                    control.CheckValue(value, true);
                else
                    Report.Fail("Unable to find parameter: " + parameter, true);
            }          
        }

        [Then(@"the control parameters are equal to the following default values for the Quad Mass (.*)")]
        public void ThenTheControlParametersAreEqualToTheFollowingDefaultValuesForTheQuadMass(string quad, Table table)
        {
            foreach (var row in table.Rows)
            {
                string parameter = row["Parameter"];

                string expectedDefaultValue;
                if (quad == "<get>")
                    expectedDefaultValue  = row[string.Format("{0} Default Value", GetQuadType())];
                else
                    expectedDefaultValue = row[string.Format("{0} Default Value", quad)];

                var control = quadSetupPage.ControlDictionary[parameter].Setting;

                if (control != null)
                    control.CheckValue(expectedDefaultValue, true);
                else
                    Report.Fail("Unable to find parameter: " + parameter, true);
            }
        }

        [Then(@"the '(.*)' Peak Display graph is removed")]
        public void ThenThePeakDisplayGraphIsRemoved(string mass)
        {
            bool displayed = false;
            foreach (var graph in quadSetupPage.PeakDisplayGraphs)
            {
                var graphId = graph.GetAttribute("id");

                if (PeakDisplayGraphs.ContainsKey(mass))
                {
                    if (PeakDisplayGraphs[mass] == graphId)
                    {
                        displayed = true;
                        break;
                    }
                }
                else
                {
                    Report.Fail(mass + " not recognized");
                }
            }

            Check.IsFalse(displayed, string.Format("The Peak Display for {0} is no longer displayed", mass));
        }

        [Then(@"(.*) Peak Display graphs are displayed")]
        public void ThenPeakDisplayGraphsAreDisplayed(int count)
        {
            Report.Action(string.Format("Check {0} Peak Display Graphs are displayed", count));
            Check.IsTrue(quadSetupPage.PeakDisplayGraphs.Count == count, string.Format("{0} Peak Display graphs are displayed", count));
        }

        [Then(@"it is not possibe to deselect '(.*)'")]
        public void ThenItIsNotPossibeToDeselect(string mass)
        {
            switch (mass)
            {
                case "Mass 1":
                    quadSetupPage.Controls.Mass1CheckBox.CheckDisabled();
                    break;
                case "Mass 2":
                    quadSetupPage.Controls.Mass2CheckBox.CheckDisabled();
                    break;
                case "Mass 3":
                    quadSetupPage.Controls.Mass3CheckBox.CheckDisabled();
                    break;
                case "Mass 4":
                    quadSetupPage.Controls.Mass4CheckBox.CheckDisabled();
                    break;
                default:
                    Report.Fail("Unrecognized action...");
                    break;
            }
        }

        [Then(@"the '(.*)' parameter is available with the following dropdown options")]
        public void ThenTheParameterIsAvailableWithTheFollowingDropdownOptions(string parameter, Table table)
        {
            Report.Action(string.Format("Check the {0} parameter dropdown options", parameter));

            IList<string> dropdownOptions = new List<string>();

            switch(parameter)
            {
                case "Span":
                    dropdownOptions = quadSetupPage.Controls.ScanSetupSpanDropDown.GetAllOptionsFromDropDown();
                    break;
                case "Number of Steps":
                    dropdownOptions = quadSetupPage.Controls.ScanSetupNumberOfStepsDropDown.GetAllOptionsFromDropDown();
                    break;
                case "Time per second":
                    dropdownOptions = quadSetupPage.Controls.ScanSetupTimePerStepDropDown.GetAllOptionsFromDropDown();
                    break;
                case "Detector window":
                    dropdownOptions = quadSetupPage.Controls.ScanSetupDetectorWindowDropDown.GetAllOptionsFromDropDown();
                    break;
                case "Mode":
                    dropdownOptions = quadSetupPage.Controls.QuadModeDropDown.GetAllOptionsFromDropDown();
                    break;
                case "Polarity":
                    dropdownOptions = quadSetupPage.Controls.QuadPolarityDropDown.GetAllOptionsFromDropDown();
                    break;
                default:
                    Report.Fail("Unknown parameter specified.");
                    break;
            }

            foreach (var option in table.Rows)
            {
                Check.IsTrue(dropdownOptions.Contains(option["Options"]), string.Format("'{0}' is a dropdown option", option["Options"]), true);
            }
        }

        [Then(@"the ADC frequency will be (.*) MHz")]
        public void ThenTheADCFrequencyWillBeGHz(Decimal freq)
        {
            Check.AreEqual(string.Format("setting:{0}", freq.ToString()), () => GetRioParameterValue("TofADC.SampFreq.Setting"), "ADC frequency is as expected", false, 30000);
        }

        private string GetRioParameterValue(string parameter)
        {
            var value = ((IJavaScriptExecutor)AutomationDriver.Driver).ExecuteScript(string.Format("return getRIOInfo('{0}');", parameter)).ToString();
            string[] rioProperty = value.Split(',');
            return rioProperty[2];
        }

        [Then(@"Quad values outside the Min or Max cannot be entered for the following parameters")]
        public void ThenQuadValuesOutsideTheMinOrMaxCannotBeEnteredForTheFollowingParameters(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                string parameter = row["Parameter"];
                double min = double.Parse(row["Min"]);
                double max = double.Parse(row["Max"]);
                string resolution = row["Resolution"];

                Report.Action(string.Format("The following steps check that the '{0}' parameter only accepts values between '{1}' and '{2}'", parameter, min, max));
                var control = quadSetupPage.ControlDictionary[parameter].Setting;
                Wait.Until(c => control.Enabled, 3000);

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

    }
}
