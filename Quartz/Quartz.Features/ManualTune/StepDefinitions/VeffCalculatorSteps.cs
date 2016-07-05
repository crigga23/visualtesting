using System.Globalization;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using Quartz.Support.Exceptions;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.Page;
using Quartz.Support.Views.TabViews;
using TechTalk.SpecFlow;

namespace Quartz.Features.ManualTune.StepDefinitions
{
    [Binding]
    public class VeffCalculatorSteps
    {
        private readonly VeffCalculatorCommand veffCalculator;
        private string OriginalVeffValue { get; set; }
        private string CalculatedVeffValue { get; set; }
        
        public VeffCalculatorSteps(VeffCalculatorCommand veffCalculator)
        {
            this.veffCalculator = veffCalculator;
        }

        [AfterScenario("cleanup-Veff")]
        public void AfterScenario()
        {
            veffCalculator.CleanupVeff();
        }

        [When(@"the polarity is '(.*)'")]
        public void WhenThePolarityIs(string polarity)
        {
            veffCalculator.SetInstrumentPolarity(polarity);
        }

        [When(@"the Original Veff is set to '(.*)'")]
        public void WhenTheOriginalVeffIsSetTo(string originalVeffValue)
        {
            veffCalculator.SelectParentTab();
            veffCalculator.SetVeff(originalVeffValue);
        }

        [StepDefinition(@"the veff is calculated")]
        public void GivenTheVeffIsCalculated()
        {
            veffCalculator.Calculate();
        }

        [Then(@"the veff is cancelled the new veff is not applied and the original veff remains unchanged")]
        public void WhenTheVeffIsCancelledTheNewVeffIsNotAppliedAndTheOriginalVeffRemainsUnchanged()
        {
            veffCalculator.CheckOriginalVeffIsUnchangedWhenCancelled(CalculatedVeffValue, OriginalVeffValue);
        }

        [When(@"Veff value is set to '(.*)'")]
        public void GivenVeffValueIsSetTo(string initialVeff)
        {
            veffCalculator.SelectParentTab();
            veffCalculator.SetVeff(initialVeff);
        }

        [StepDefinition(@"the calculated New Veff value is '(.*)'")]
        public void ThenTheNewVeffIsValueIs(string value)
        {
            Check.AreEqual(value, veffCalculator.NewVeff, string.Format("New Veff value is equal to {0}", value));
        }

        [Then(@"the veff is applied the new veff of '(.*)' is applied to the instrument")]
        public void WhenTheVeffIsAppliedTheNewVeffOfIsAppliedToTheInstrument(decimal veffValue)
        {
            veffCalculator.Apply();
            Check.AreEqual(veffValue.ToString(CultureInfo.InvariantCulture), () => ADCTab2View.VeffSettingTextBox.Text, "Veff value is correct", false, 2000);
        }

        [Then(@"the veff calculator will be available")]
        [StepDefinition(@"the calculator is accessed")]
        public void WhenTheCalculatorIsAccessed()
        {
            AccessVeffCalculator();
        }

        private void AccessVeffCalculator()
        {
            // Get the original veff value
            OriginalVeffValue = ADCTab2View.VeffSettingTextBox.Text;
            veffCalculator.Open();
        }

        [StepDefinition(@"the calculated Gain value is '(.*)'")]
        public void ThenTheCalculatedGainValueIs(string gain)
        {
            Check.AreEqual(gain, veffCalculator.Gain, string.Format("Gain value is as expected {0}", veffCalculator.Gain), true);
        }

        [StepDefinition(@"'(.*)' Mass is set to '(.*)'")]
        public void GivenMassIsSetTo(string massType, decimal massValue)
        {
            Control massControl = null;
            switch (massType)
            {
                case "Reference":
                    massControl = veffCalculator.ReferenceMass;
                    break;
                case "Measured":
                    massControl = veffCalculator.MeasuredMass;
                    break;
                default:
                    Report.Fail("There is no such Mass Type that exists for Veff", new NoSuchMassTypeException("There is no such Mass Type that exists for Veff"));
                    break;
            }

            if (massControl != null)
            {
                massControl.SetValue(massValue.ToString(CultureInfo.InvariantCulture), true);
            }
        }

        [When(@"veff calculator settings are '(.*)'")]
        public void WhenSettingsAre(string savedStatus)
        {
            switch (savedStatus)
            {
                case VeffCalculatorSettingStatus.NotSaved:
                    OriginalVeffValue = veffCalculator.OriginalVeff;
                    veffCalculator.Cancel();
                    break;
                case VeffCalculatorSettingStatus.Saved:
                    OriginalVeffValue = veffCalculator.NewVeff;
                    veffCalculator.Apply();
                    break;
            }
        }

        [When(@"user logs out and back in again")]
        public void WhenUserLogsOutAndBackInAgain()
        {
            ServiceHelper.RestartTyphoonAndQuartz();
        }

        [Then(@"the Original Veff value corresponds to the Veff applied to the instrument currently")]
        public void ThenTheOriginalVeffValueCorrespondsToTheVeffAppliedToTheInstrumentCurrently()
        {
            veffCalculator.CheckVeffPersistsToCalculator(OriginalVeffValue);
        }

        [Then(@"the Calculator parameters have the expected Min, Max and Resolution limits")]
        public void ThenTheCalculatorParametersHaveTheExpectedMinMaxAndResolutionLimits()
        {
            veffCalculator.CheckParametersMinMaxAndResolutionLimits();
        }

        [Then(@"the veff calculator controls are in the expected state")]
        public void ThenTheVeffCalculatorControlsAreInTheExpectedState()
        {
            veffCalculator.CheckVeffCalculatorControlsEnabledState();
            veffCalculator.CheckVeffCalculatorParameterControlsEnabledState();
        }

        [Then(@"Veff value applied to the instrument is equal to '(.*)'")]
        public void ThenVeffValueAppliedToTheInstrumentIsEqualTo(string value)
        {
            Check.AreEqual(value, OriginalVeffValue, string.Format("veff is applied {0}", OriginalVeffValue), true);
        }

        [When(@"New Veff value is equal to (.*)")]
        public void ThenNewVeffValueIsEqualTo(string value)
        {
            Check.AreEqual(value, veffCalculator.NewVeff, string.Format("New veff is {0}", value));
        }
    }
}
