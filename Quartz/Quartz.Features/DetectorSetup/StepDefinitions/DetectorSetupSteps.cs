using System;
using System.Linq;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.DetectorSetup.StepDefinitions
{
    [Binding]
    public class DetectorSetupSteps
    {
        private DetectorSetupPage _detectorSetupPage;
        private double _positiveDetectorVoltage;
        private double _positiveIonArea;
        private double _negativeDetectorVoltage;
        private double _negativeIonArea;
        private static string OriginalStartingVoltage;

        public DetectorSetupSteps(DetectorSetupPage detectorSetupPage)
        {
            _detectorSetupPage = detectorSetupPage;
        }

        [BeforeFeature("DetectorSetup")]
        public static void BeforeFeature()
        {
            if (TyphoonHelper.SimulatedInstrument)
            {
                //Update DetectorSetupConfiguration.xml - set starting voltage.
                XmlManager xmlHelper = new XmlManager(string.Concat(TyphoonHelper.ConfigDirectory, "DetectorSetupConfiguration.xml"));

                var node = xmlHelper.XmlDoc.Descendants("DetectorLevelConfiguration").FirstOrDefault();
                OriginalStartingVoltage = node.Attribute("startingvoltage").Value;
                node.SetAttributeValue("startingvoltage", "1100");
                xmlHelper.Save();                
            }
        }

        [AfterFeature("DetectorSetup")]
        public static void AfterFeature()
        {
            if (TyphoonHelper.SimulatedInstrument)
            {
                //Update DetectorSetupConfiguration.xml - set starting voltage to its original
                XmlManager xmlHelper = new XmlManager(string.Concat(TyphoonHelper.ConfigDirectory, "DetectorSetupConfiguration.xml"));

                var node = xmlHelper.XmlDoc.Descendants("DetectorLevelConfiguration").FirstOrDefault();
                node.SetAttributeValue("startingvoltage", OriginalStartingVoltage);
                xmlHelper.Save();                
            }
        }

        [AfterScenario("DetectorSetup")]
        public void AfterScenario()
        {
            NavigationMenu.DetectorSetupAnchor.Click();

            if (_detectorSetupPage.DetectorSetupIsRunningInPositiveOrNegativeMode)
                _detectorSetupPage.StopDetectorSetup();
        }


        [Then(@"the field value is between Minimum and Maximum")]
        public void ThenTheFieldValueIsBetweenMinimumAndMaximum(Table detectorSetupFields)
        {
            foreach (TableRow detectorSetupRow in detectorSetupFields.Rows)
            {                
                if (!Double.TryParse(_detectorSetupPage.Controls.PositiveDetectorVoltageTextBox.Text, out _positiveDetectorVoltage))
                {
                    _positiveDetectorVoltage = 0;
                }

                if (!Double.TryParse(_detectorSetupPage.Controls.PositiveIonAreaTextBox.Text, out _positiveIonArea))
                {
                    _positiveIonArea = 0;
                }

                if (!Double.TryParse(_detectorSetupPage.Controls.NegativeDetectorVoltageTextBox.Text, out _negativeDetectorVoltage))
                {
                    _negativeDetectorVoltage = 0;
                }

                if (!Double.TryParse(_detectorSetupPage.Controls.NegativeIonAreaTextBox.Text, out _negativeIonArea))
                {
                    _negativeIonArea = 0;
                }

                string field = detectorSetupRow["Field"];
                double value = 0;

                switch (field)
                {
                    case "Positive Detector Voltage":
                        value = _positiveDetectorVoltage;
                        break;
                    case "Positive Ion Area":
                        value = _positiveIonArea;
                        break;
                    case "Negative Detector Voltage":
                        value = _negativeDetectorVoltage;
                        break;
                    case "Negative Ion Area":
                        value = _negativeIonArea;
                        break;
                }

                double min = double.Parse(detectorSetupRow["Minimum"]);
                double max = double.Parse(detectorSetupRow["Maximum"]);

                Check.IsTrue(value >= min, string.Format("{0} value is less than minimum", field));
                Check.IsTrue(value <= max, string.Format("{0} value is greater than maximum", field));
            }
        }

        [Then(@"the field value should be")]
        public void ThenTheTextFieldValueShouldBe(Table detectorSetupFields)
        {
            foreach (TableRow detectorSetupFieldRow in detectorSetupFields.Rows)
            {
                string status = string.Empty;
                string field = detectorSetupFieldRow[0];
                switch (field)
                {
                    case "Positive Status":
                        status = _detectorSetupPage.Controls.PositiveResultsPanelStatus.Text;
                        break;
                    case "Negative Status":
                        status = _detectorSetupPage.Controls.NegativeResultsPanelStatus.Text;
                        break;
                    case "Negative Detector Voltage":
                        status = _detectorSetupPage.Controls.NegativeDetectorVoltageTextBox.Text;
                        break;
                    case "Negative Ion Area":
                        status = _detectorSetupPage.Controls.NegativeIonAreaTextBox.Text;
                        break;
                }

                string value = detectorSetupFieldRow[1];
                Check.AreEqual(value, string.IsNullOrEmpty(status) ? "Blank" : status, string.Format("{0} doesn't have expected value {1}", field, value));            
            }
        }

        [Then(@"the Mass Results values match the Progress Log")]
        public void ThenTheMassResultsValuesMatchTheProgressLog()
        {
            if (_detectorSetupPage.Controls.PositiveMassEnabledCheckBox.Selected)
            {
                var detectorVoltage = _detectorSetupPage.Controls.PositiveDetectorVoltageTextBox.Text;
                var progressLogDetectorVoltage = _detectorSetupPage.GetProgressLogPositiveVoltage();
                var ionArea = _detectorSetupPage.Controls.PositiveIonAreaTextBox.Text;
                var progressLogIonArea = _detectorSetupPage.GetProgressLogPositiveIonArea();

                Check.IsNull(_detectorSetupPage.Controls.PositiveDetectorVoltageTextBox.GetFractionalPart(), "Positive Detector Voltage is an integer", true);
                Check.IsTrue(detectorVoltage == progressLogDetectorVoltage, "Detector Voltage is the same in the progress log as the Positive Mass Results panel. " + string.Format("Results Panel = {0}, Progress Log = {1}", detectorVoltage, progressLogDetectorVoltage), true);

                Check.IsTrue(ionArea == progressLogIonArea, "Ion Area is the same in the progress log as the Positive Mass Results panel. " + string.Format("Results Panel = {0}, Progress Log = {1}", ionArea, progressLogIonArea), true);
            }

            if (_detectorSetupPage.Controls.NegativeMassEnabledCheckBox.Selected)
            {
                var detectorVoltage = _detectorSetupPage.Controls.NegativeDetectorVoltageTextBox.Text;
                var progressLogDetectorVoltage = _detectorSetupPage.GetProgressLogNegativeVoltage();
                var ionArea = _detectorSetupPage.Controls.NegativeIonAreaTextBox.Text;
                var progressLogIonArea = _detectorSetupPage.GetProgressLogNegativeIonArea();

                Check.IsNull(_detectorSetupPage.Controls.NegativeDetectorVoltageTextBox.GetFractionalPart(), "Negative Detector Voltage is an integer", true);
                Check.IsTrue(_detectorSetupPage.Controls.NegativeDetectorVoltageTextBox.Text == _detectorSetupPage.GetProgressLogNegativeVoltage(), "Detector Voltage is the same in the progress log as the Negative Mass Results panel. " + string.Format("Results Panel = {0}, Progress Log = {1}", detectorVoltage, progressLogDetectorVoltage), true);

                Check.IsTrue(_detectorSetupPage.Controls.NegativeIonAreaTextBox.Text == _detectorSetupPage.GetProgressLogNegativeIonArea(), "Ion Area is the same in the progress log as the Negative Mass Results panel. " + string.Format("Results Panel = {0}, Progress Log = {1}", ionArea, progressLogIonArea), true);
            }
        }

        [Then(@"the Measure Ion Area Mass Results values match the Progress Log")]
        public void ThenTheMeasureIonAreaMassResultsValuesMatchTheProgressLog()
        {
            if (_detectorSetupPage.Controls.PositiveMassEnabledCheckBox.Selected)
            {
                var ionArea = _detectorSetupPage.Controls.PositiveIonAreaTextBox.Text;
                var progressLogIonArea = _detectorSetupPage.GetProgressLogPositiveIonArea();

                Check.IsTrue(ionArea == progressLogIonArea, "Ion Area is the same in the progress log as the Positive Mass Results panel. " + string.Format("Results Panel = {0}, Progress Log = {1}", ionArea, progressLogIonArea), true);
            }

            if (_detectorSetupPage.Controls.NegativeMassEnabledCheckBox.Selected)
            {
                var ionArea = _detectorSetupPage.Controls.NegativeIonAreaTextBox.Text;
                var progressLogIonArea = _detectorSetupPage.GetProgressLogNegativeIonArea();

                Check.IsTrue(_detectorSetupPage.Controls.NegativeIonAreaTextBox.Text == _detectorSetupPage.GetProgressLogNegativeIonArea(), "Ion Area is the same in the progress log as the Negative Mass Results panel. " + string.Format("Results Panel = {0}, Progress Log = {1}", ionArea, progressLogIonArea), true);
            }
        }

        [Then(@"the message should exist in the Progress Log")]
        public void ThenShouldExistInTheProgressLog(Table table)
        {
            foreach (var row in table.Rows)
            {
                var message = row["Message"];
                Check.IsTrue(_detectorSetupPage.Controls.ProgressLogTextArea.Text.Contains(message), string.Concat("Progress Log does not contain message: ", message));
            }
        }

        [Then(@"the Detector Setup should complete within (.*) minutes")]
        public void ThenTheDetectorSetupShouldCompleteWithinMinutes(int minutes)
        {
            TimeSpan timeTaken = _detectorSetupPage.GetDetectorSetupCompletionTime();
            Check.IsTrue(timeTaken.Minutes < minutes, string.Format("Detector Setup took longer than {0} minutes to complete", minutes));
        }

        [Then(@"the Detector Setup should complete within (.*) seconds")]
        public void ThenTheDetectorSetupShouldCompleteWithinSeconds(int seconds)
        {
            TimeSpan timeTaken = _detectorSetupPage.GetDetectorSetupCompletionTime();
            Check.IsTrue(timeTaken.Seconds < seconds, string.Format("Measure Ion Area took longer than {0} seconds to complete", seconds));
        }
    }
}
