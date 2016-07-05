using System;
using Automation.Config.Lib.ConfigHelpers;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using Quartz.Support.Configuration;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.Modals;
using Quartz.Support.Views.TabViews;

namespace Quartz.Support.Views.Page
{
    public class VeffCalculatorCommand
    {
        private readonly VeffCalculatorModal veffCalculator;
        private readonly VeffCalculatorHelper veffCalculatorHelper;
        private readonly TunePage tunePage;
        private readonly TuneConfig tuneConfig;
        private const string VeffParameterName = "Veff";

        public VeffCalculatorCommand(VeffCalculatorModal veffCalculator, VeffCalculatorHelper veffCalculatorHelper, TunePage tunePage)
        {
            this.veffCalculator = veffCalculator;
            this.veffCalculatorHelper = veffCalculatorHelper;
            this.tunePage = tunePage;

            TestConfiguration testConfiguration = new TestConfiguration(new AppSettingsConfigurationManager());
            this.tuneConfig = new TuneConfig(testConfiguration.Instrument);
        }

        public string NewVeff   
        {
            get { return veffCalculator.VeffCalculatorNewVeffSetting.Text; }
        }

        public string OriginalVeff
        {
            get { return veffCalculator.VeffCalculatorOriginalVeffSetting.Text; }
        }

        public string Gain
        {
            get { return veffCalculator.VeffCalculatorGainSetting.Text; }
        }

        public Control ReferenceMass
        {
            get { return veffCalculator.VeffCalculatorReferenceMassSetting; }
        }

        public Control MeasuredMass
        {
            get { return veffCalculator.VeffCalculatorMeasuredMassSetting; }
        }

        public void Cancel()
        {
            veffCalculator.VeffCalculatorCancelControl.Click();
        }

        public void Calculate()
        {
            veffCalculator.VeffCalculatorCalculateControl.Click();
        }

        public void Apply()
        {
            veffCalculator.VeffCalculatorApplyControl.Click();
        }

        public void Close()
        {
            veffCalculator.VeffCalculatorCloseControl.Click();
        }

        public void Open()
        {
            SelectParentTab();

            Report.Action("Checking the Veff calculator is loaded");
            Report.Action("Open the Veff Calculator");
            ADCTab2View.VeffCalculatorButton.Click();

            Check.IsTrue(VeffCalculatorModal.Exists, "Veff calculator is available", continueOnFail: true);
            Report.Screenshot(veffCalculator.VeffCalculatorDialog);
        }

        public void CleanupVeff()
        {
            try
            {
                if (veffCalculator.VeffCalculatorDialog.Displayed)
                {
                    Cancel();
                }
            }
            catch (Exception) { }
        }

        public void SelectParentTab()
        {
            tunePage.SelectTabById(tuneConfig.GetParameterByName(VeffParameterName).Tab.AutomationId);
        }

        public void CheckOriginalVeffIsUnchangedWhenCancelled(string CalculatedVeffValue, string OriginalVeffValue)
        {
            // Make note of this value before any operation
            CalculatedVeffValue = veffCalculator.VeffCalculatorNewVeffSetting.Text;
            Cancel();

            // check new veff not applied
            Check.AreNotEqual(CalculatedVeffValue, ADCTab2View.VeffSettingTextBox.Text, "The Calculated New Veff value has not been applied");

            // check original veff is unchanged
            Report.Action("Check the veff setting is unchanged from the value it was it was set to before 'Calculate' was performed.");
            Check.AreEqual(OriginalVeffValue, ADCTab2View.VeffSettingTextBox.Text, "The veff setting is unchanged");
        }

        public void CheckVeffPersistsToCalculator(string originalVeffValue)
        {
            veffCalculatorHelper.CheckVeffPersistsToCalculator(originalVeffValue);
        }

        public void CheckParametersMinMaxAndResolutionLimits()
        {
            veffCalculatorHelper.CheckParametersMinMaxAndResolutionLimits();
        }

        public void CheckVeffCalculatorControlsEnabledState()
        {
            veffCalculatorHelper.CheckVeffCalculatorControlsEnabledState();
        }

        public void CheckVeffCalculatorParameterControlsEnabledState()
        {
            veffCalculatorHelper.CheckVeffCalculatorParameterControlsEnabledState();
        }

        public void SetVeff(string valueToSet)
        {
            ADCTab2View.VeffSettingTextBox.SetText(valueToSet);
        }

        public void SetInstrumentPolarity(string polarity)
        {
            tunePage.SwitchConfiguration(null, polarity);
        }
    }
}