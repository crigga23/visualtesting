using Automation.Reporting.Lib;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.DetectorSetup.StepDefinitions
{
    [Binding]
    public class DetectorSetupGUISteps
    {
        DetectorSetupPage _detectorSetupPage;

        public DetectorSetupGUISteps(DetectorSetupPage detectorSetupPage)
        {
            _detectorSetupPage = detectorSetupPage;
        }

        [Given(@"the Detector setup process is started for Positive mode")]
        public void GivenTheDetectorSetupProcessIsStartedForPositiveMode()
        {
            _detectorSetupPage.RunDetectorSetup("Positive");
        }
        
        [Given(@"'(.*)' is ticked")]
        public void GivenIsTicked(string p0)
        {
            _detectorSetupPage.Controls.FollowTailCheck.SelectCheckBox();
        }  

        [When(@"the '(.*)' is set")]
        public void WhenTheIsSet(string checkBoxStatus)
        {
           switch (checkBoxStatus)
            {
                case "Positive (un-ticked), Negative (ticked)":
                    _detectorSetupPage.Controls.NegativeMassEnabledCheckBox.SelectCheckBox();
                    _detectorSetupPage.Controls.PositiveMassEnabledCheckBox.UnSelectCheckBox();
                    break;
                case "Positive (ticked), Negative (ticked)":
                    _detectorSetupPage.Controls.PositiveMassEnabledCheckBox.SelectCheckBox();
                    _detectorSetupPage.Controls.NegativeMassEnabledCheckBox.SelectCheckBox();
                    break;
                case "Positive (ticked), Negative (un-ticked)":
                    _detectorSetupPage.Controls.PositiveMassEnabledCheckBox.SelectCheckBox();
                    _detectorSetupPage.Controls.NegativeMassEnabledCheckBox.UnSelectCheckBox();
                    break;
            }
        }

        [When(@"I scroll up the log")]
        public void WhenIScrollUpTheLog()
        {
            _detectorSetupPage.SimulateMouseWheelScrollEvent();
        }

        [Then(@"the Detector Setup fields should have the following default values")]
        public void ThenTheFollowingFieldsHaveTheAppropriateDefault(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                var field = row["Field"];
                var value = row["Value"];

                Report.Action(string.Format("Check the {0} control is set to {1}", field, value));
                switch (field)
                {
                    case "Negative Mass":
                        _detectorSetupPage.Controls.NegativeMassTextBox.CheckText(value);
                        break;
                    case "Positive Mass":
                        _detectorSetupPage.Controls.PositiveMassTextBox.CheckText(value);
                        break;
                    case "Checkbox (POS)":
                        _detectorSetupPage.Controls.PositiveMassEnabledCheckBox.CheckValue(value);
                        break;
                    case "Checkbox (NEG)":
                        _detectorSetupPage.Controls.NegativeMassEnabledCheckBox.CheckValue(value);
                        break;
                    case "Process Selection Dropdown":
                        _detectorSetupPage.Controls.ProcessSelector.CheckSelectOption(value);
                        break;
                    case "Start Button":
                        _detectorSetupPage.Controls.StartStopButton.CheckCaption(value);
                        break;
                    case "Positive Detector Voltage":
                        _detectorSetupPage.Controls.PositiveDetectorVoltageTextBox.CheckText(value);
                        break;
                    case "Positive Ion Area":
                        _detectorSetupPage.Controls.PositiveIonAreaTextBox.CheckText(value);
                        break;
                    case "Positive Status Text":
                        Check.AreEqual(value, _detectorSetupPage.Controls.PositiveResultsPanelStatus.Text, string.Format("{0} default is equal to {1}", field, value));
                        Report.DebugScreenshot(_detectorSetupPage.Controls.PositiveMassResultsPanel.Element);
                        break;
                    case "Negative Detector Voltage":
                        _detectorSetupPage.Controls.NegativeDetectorVoltageTextBox.CheckText(value);
                        break;
                    case "Negative Ion Area":
                        _detectorSetupPage.Controls.NegativeIonAreaTextBox.CheckText(value);
                        break;
                    case "Negative Status Text":
                        Check.AreEqual(value, _detectorSetupPage.Controls.NegativeResultsPanelStatus.Text, string.Format("{0} default is equal to {1}", field, value));
                        Report.DebugScreenshot(_detectorSetupPage.Controls.NegativeMassResultsPanel.Element);
                        break;
                    case "Progress Log":
                        _detectorSetupPage.Controls.ProgressLogTextArea.CheckText(value);
                        break;
                    case "Follow Tail Checkox":
                        _detectorSetupPage.Controls.FollowTailCheck.CheckValue(value);
                        break;
                    default:
                        Report.Fail("Unknown detector setup field: " + field);
                        break;
                }
            }  
        }

        [Then(@"the following Panels should be available on the detector setup page")]
        public void ThenTheFollowingPanelsShouldBeAvailableOnTunePage(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                _detectorSetupPage.CheckWidgetIsAvailable(row["Panels"]);
            }
        }

        [Then(@"the '(.*)' will be changed accordingly")]
        public void ThenTheWillBeChangedAccordingly(string editBoxStatus)
        {
            Check.AreEqual(_detectorSetupPage.Controls.PositiveMassEnabledCheckBox.Selected,
                _detectorSetupPage.Controls.PositiveMassTextBox.Enabled);
            Check.AreEqual(_detectorSetupPage.Controls.NegativeMassEnabledCheckBox.Selected,
                _detectorSetupPage.Controls.NegativeMassTextBox.Enabled);
        }

        [Then(@"the button state will be '(.*)'")]
        public void ThenTheButtonStateWillBe(string buttonState)
        {
            Check.IsTrue(_detectorSetupPage.Controls.StartStopButton.Enabled, string.Format("Button state is '{0}'", buttonState));
        }

        [Then(@"'(.*)' should become automatically unticked")]
        public void ThenShouldBecomeAutomaticallyUnticked(string p0)
        {
            Check.IsFalse(_detectorSetupPage.Controls.FollowTailCheck.Selected, string.Format("Follow tail is '{0}'", p0));
        }


    }
}
