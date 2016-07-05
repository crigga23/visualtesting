using System;
using System.Threading;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using TechTalk.SpecFlow;
using System.Collections.ObjectModel;
using Quartz.Support.Views;
using Quartz.Support;
using System.Linq;
using Automation.WebFramework.Lib;

namespace Quartz.Features.QuadSetup.StepDefinitions
{
    [Binding]
    public class QuadSetupModeSteps
    {
        QuadSetupPage qsPage = new QuadSetupPage();

        [Given(@"the Quad Setup Page is Open")]
        public void GivenTheQuadSetupPageIsOpen()
        {
            NavigationMenu.QuadSetupAnchor.Click();
        }
        
        [When(@"the Quad Mode parameter is set to (.*)")]
        public void WhenTheQuadModeParameterIsSetToAlign(string option)
        {
            qsPage.Controls.QuadModeDropDown.SelectOptionFromDropDown(option);        
        }
        
        [Then(@"the ADC frequency will be 3 GHz")]
        public void ThenTheADCFrequencyWillBe3GHz()
        {
            string value = AutomationDriver.Driver.ExecuteScript("return getRIOInfo('TofADC.sampling_frequency');").ToString();
            string[] rioProperty = value.Split(',');
            Assert.AreEqual("setting:3", rioProperty[2]);
        }

        [Then(@"the MS Profile is not enabled")]
        public void ThenTheMSProfileIsNotEnabled()
        {
            //I believe the use of MSProfile is controlled by the property below, according to Richard Newton it should be 1 if deactivated
            string value = AutomationDriver.Driver.ExecuteScript("return getRIOInfo('Acquisition.MSProfile');").ToString();
            string[] rioProperty = value.Split(',');
            Assert.AreEqual("setting:1", rioProperty[2]);
        }
        
        [Then(@"the (.*) field should have default value (.*)")]
        public void ThenTheFieldShouldHaveDefaultValue(string label, string value)
        {
            var myControl = qsPage.Controls.FindControlByLabel(label);

            myControl.CheckValue(value);
        }

        [Then(@"the (.*) field should have minimum (.*) and maximum (.*) boundaries at a resolution of (.*)")]
        public void ThenTheFieldShouldHaveMinimumAndMaximumBoundaries(string label, string min, string max, string resolution)
        {
            var myControl = qsPage.Controls.FindControlByLabel(label);

            (myControl as TextBox).CheckMinimum(min, resolution);
            (myControl as TextBox).CheckMaximum(max, resolution);
        }

        [Then(@"the (.*) field should have resolution (.*)")]
        public void ThenTheFieldShouldHaveResolution(string label, string resolution)
        {
            var myControl = qsPage.Controls.FindControlByLabel(label);

            var decimalPlaces = 0;

            if (resolution.Contains("."))
                decimalPlaces = resolution.Split(new char[] { '.' }).Last().Length;

            (myControl as TextBox).CheckResolution(decimalPlaces);
        }
               
        [Then(@"the Rectified RF readback will stay the same over all scans")]
        public void ThenTheRectifiedRFReadbackWillStayTheSameOverAllScans()
        {
            bool AreTheSameValue = CheckIfRecRFtheSame();
            Assert.IsTrue(AreTheSameValue);
        }

        [Given(@"all four masses are selected")]
        public void GivenAllFourMassesAreSelected()
        {
            qsPage.Controls.Mass1CheckBox.SelectCheckBox();
            qsPage.Controls.Mass2CheckBox.SelectCheckBox();
            qsPage.Controls.Mass3CheckBox.SelectCheckBox();
            qsPage.Controls.Mass4CheckBox.SelectCheckBox();
        }

        [Then(@"the Rectified RF readback will vary over all scans")]
        public void ThenTheRectifiedRFReadbackWillVaryOverAllScans()
        {
            bool AreTheSameValue = CheckIfRecRFtheSame();
            Assert.IsFalse(AreTheSameValue);
        }

        private bool CheckIfRecRFtheSame()
        {
            string rfValue1 = qsPage.Controls.RectifiedRFTextBox.Text;
            Wait.ForMilliseconds(1000);
            string rfValue2 = qsPage.Controls.RectifiedRFTextBox.Text;
            Wait.ForMilliseconds(1000);
            string rfValue3 = qsPage.Controls.RectifiedRFTextBox.Text;
            Wait.ForMilliseconds(1000);
            string rfValue4 = qsPage.Controls.RectifiedRFTextBox.Text;

            bool AreTheSameValue = (rfValue1 == rfValue2) && (rfValue2 == rfValue3) && (rfValue3 == rfValue4);
            return AreTheSameValue;
        }

    }
}
