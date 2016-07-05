using System;
using Automation.Reporting.Lib;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.DetectorSetup.StepDefinitions
{
    [Binding]
    public class MeasureIonAreaSteps
    {
        private readonly DetectorSetupPage _detectorSetupPage;

        public MeasureIonAreaSteps(DetectorSetupPage detectorSetupPage)
        {
            _detectorSetupPage = detectorSetupPage;
        }

        [When(@"Measure Ion Area has been selected")]
        public void GivenMeasureIonAreaHasBeenSelected()
        {
            DetectorSetupPage.Process.Setup(ProcessType.MeasureIonArea);
        }

        [Then(@"the Measure Ion Area Setup should complete within (.*) seconds")]
        public void ThenTheMeasureIonAreaSetupShouldCompleteWithinSeconds(int seconds)
        {
            TimeSpan timeTaken = _detectorSetupPage.GetDetectorSetupCompletionTime();
            Check.IsTrue(timeTaken.Seconds < seconds, string.Format("Measure Ion Area took longer than {0} seconds to complete", seconds));
        }
    }
}
