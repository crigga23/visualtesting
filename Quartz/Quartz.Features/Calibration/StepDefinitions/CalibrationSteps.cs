using System.Collections.Generic;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.Calibration.StepDefinitions
{
    [Binding]
    public class CalibrationSteps
    {
        CalibrationPage calibrationPage = new CalibrationPage();
        PeakPickerPage peakPickerPage = new PeakPickerPage();

        [AfterScenario("Calibration")]
        public void ClosePopups()
        {

            if (FileDialogHelper.Window != null)
            {
                if (!FileDialogHelper.Window.Current.IsOffscreen)
                    FileDialogHelper.ClickCancelButton();
            }

            while (AutomationDriver.Driver.WindowHandles.Count > 1)
            {
                //Copy since we are about to close windows
                var handleList = new List<string>(AutomationDriver.Driver.WindowHandles);

                foreach (var handle in handleList)
                {
                    if (handle != calibrationPage.WindowHandle)
                    {
                        try
                        {
                            AutomationDriver.Driver.SwitchTo().Window(handle);
                            AutomationDriver.Driver.Close();
                        }
                        catch (NoSuchWindowException)
                        {
                            // Do Nothing.
                        }
                    }
                }
            }
            AutomationDriver.Driver.SwitchTo().Window(calibrationPage.WindowHandle);
        }

        [Given(@"the calibration tab is selected")]
        public void GivenTheCalibrationTabIsSelected()
        {
            NavigationMenu.ManualCalibrationAnchor.Click();
        }


        [Given(@"reference compound (.*) is selected")]
        public void GivenReferenceCompoundIsSelected(string compound)
        {
            calibrationPage.Controls.ReferenceCompoundSelector.SelectOptionFromDropDown(compound);
        }

        [Given(@"sample recording (.*) is selected")]
        public void GivenSampleRecordingIsSelected(string recording)
        {
            calibrationPage.Controls.RawDataFileSelector.SelectOptionFromDropDown(FeatureContext.Current[recording].ToString());
        }

        [Given(@"a calibration has been created")]
        public void GivenACalibrationHasBeenCreated()
        {
            calibrationPage.Controls.CreateCalibrationButton.Click();   
            peakPickerPage.WaitForLoad();
        }

        [When(@"I accept the calibration")]
        public void WhenIAcceptTheCalibration()
        {
            peakPickerPage.AcceptCalibration();
        }


        [When(@"I reject the calibration")]
        public void WhenIRejectTheCalibration()
        {
            peakPickerPage.RejectCalibration();
        }

        [When(@"I create a random calibration")]
        public void WhenICreateARandomCalibration()
        {
            peakPickerPage.CreateRandomCalibration();
        }

        [When(@"I create an empty calibration")]
        public void WhenICreateAnEmptyCalibration()
        {
            peakPickerPage.CreateEmptyCalibration();
        }

        [When(@"I zoom in and out of the peak picker '(.*)' times")]
        public void WhenIZoomInAndOutOfThePeakPickerMultipleTimes(int zoomAttempts)
        {
            for (int attempt = 0; attempt < zoomAttempts; attempt++)
            {
                peakPickerPage.ZoomIn();
                peakPickerPage.ZoomOut();
            }            
        }

        [When(@"I create a report")]
        public void WhenICreateAReport()
        {
            peakPickerPage.OpenReport();
        }

    }
}
