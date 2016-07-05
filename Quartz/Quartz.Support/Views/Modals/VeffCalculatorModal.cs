using System.Collections.Generic;
using Automation.Config.Lib.ConfigHelpers.Veff;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Modals
{

    public class VeffCalculatorModal
    {
        private readonly ControlFactory controlFactory;
        private readonly VeffConfig veffConfig;

        public static string AutomationId = "Dialog.VeffCalculator";
        public static bool Exists { get { return Modal.Exists(AutomationId); } }

        public VeffCalculatorModal(ControlFactory controlFactory)
        {
            this.controlFactory = controlFactory;
            this.veffConfig = new VeffConfig();
        }

        #region Controls

        public IWebElement VeffCalculatorDialog
        {
            get { return AutomationDriver.Driver.FindElement(By.Id(AutomationId)); }
        }

        public TextBox VeffCalculatorOriginalVeffSetting
        {
            get { return controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(veffConfig.GetParameterByName("Original Veff").AutomationId))) as TextBox; }
        }

        public TextBox VeffCalculatorNewVeffSetting
        {
            get { return controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(veffConfig.GetParameterByName("New Veff").AutomationId))) as TextBox; }
        }

        public TextBox VeffCalculatorMeasuredMassSetting
        {
            get { return controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(veffConfig.GetParameterByName("Measured Mass").AutomationId))) as TextBox; }
        }

        public TextBox VeffCalculatorReferenceMassSetting
        {
            get { return controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(veffConfig.GetParameterByName("Reference Mass").AutomationId))) as TextBox; }
        }

        public TextBox VeffCalculatorGainSetting
        {
            get { return controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(veffConfig.GetParameterByName("Gain").AutomationId))) as TextBox; }
        }

        public Button VeffCalculatorCalculateControl
        {
            get { return controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(veffConfig.GetCalculatorControlByName("Calculate").Id))) as Button; }
        }

        public Button VeffCalculatorCancelControl
        {
            get { return controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(veffConfig.GetCalculatorControlByName("Cancel").Id))) as Button; }
        }

        public Button VeffCalculatorApplyControl
        {
            get { return controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(veffConfig.GetCalculatorControlByName("Apply").Id))) as Button; }
        }
        public Button VeffCalculatorCloseControl
        {
            get { return controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(veffConfig.GetCalculatorControlByName("Close").Id))) as Button; }
        }

        #endregion Controls
    }
}
