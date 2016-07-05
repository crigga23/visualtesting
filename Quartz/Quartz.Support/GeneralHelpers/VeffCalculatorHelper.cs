using System;
using System.Linq;
using Automation.Config.Lib.ConfigHelpers.Veff;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.Views.Modals;

namespace Quartz.Support.GeneralHelpers
{
    public class VeffCalculatorHelper
    {
        private ControlFactory controlFactory;
        private VeffCalculatorModal veffCalculatorModal;
        private VeffConfig veffConfig;

        public VeffCalculatorHelper(ControlFactory controlFactory, VeffCalculatorModal veffCalculatorModal)
        {
            this.controlFactory = controlFactory;
            this.veffCalculatorModal = veffCalculatorModal;
            this.veffConfig = new VeffConfig();
        }

        public void CheckVeffPersistsToCalculator(string originalVeffValue)
        {
            Report.Action("Check the Veff is persisted to the Veff calculator");
            Check.AreEqual(originalVeffValue,  veffCalculatorModal.VeffCalculatorOriginalVeffSetting.Text, "Original Veff value has been correctly passed through");
            Report.Screenshot();
        }

        public void CheckVeffCalculatorControlsEnabledState()
        {
            foreach (var calculatorControl in veffConfig.CalculatorControls)
            {
                var veffControl = controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(calculatorControl.Id)));
                veffControl.CheckEnabledState(enabled: true, continueOnFail: true);
            }
        }

        public void CheckVeffCalculatorParameterControlsEnabledState()
        {
            foreach (var parameterControl in veffConfig.Parameters)
            {
                var veffParameterControl = controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(parameterControl.AutomationId)));

                veffParameterControl.CheckEnabledState(enabled: true, continueOnFail: true);

                bool hasResolution = String.IsNullOrEmpty(parameterControl.Resolution);
                if (hasResolution)
                {
                    veffParameterControl.CheckIsReadOnly(continueOnFail: true);
                }
                else
                {
                    veffParameterControl.CheckIsNotReadOnly(continueOnFail: true);
                }
            }
        }

        public void CheckParametersMinMaxAndResolutionLimits()
        {
            foreach (var configVeffParameter in veffConfig.Parameters.Where(x => !String.IsNullOrEmpty(x.Resolution)))
            {
                try
                {
                    TextBox control = controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(configVeffParameter.AutomationId))) as TextBox;
                    control.CheckCompliesWithMinAndMax(configVeffParameter.Min, configVeffParameter.Max, configVeffParameter.Resolution, continueOnFail: true);
                    control.CheckResolution(configVeffParameter.Resolution.DecimalPlaces(), continueOnFail: true);
                }
                catch (NullReferenceException ex)
                {
                    Report.Fail(String.Format("The control {0} must not be null", configVeffParameter.Name), ex, continueOnFail: true, screenshotOnFailure: true);
                }
            }
        }

        public static void WaitForClose()
        {
            Modal.WaitForClose(VeffCalculatorModal.AutomationId);
        }

        public static void WaitForOpen()
        {
            Modal.WaitForOpen(VeffCalculatorModal.AutomationId);
        }
    }
}
