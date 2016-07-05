namespace Quartz.Support.Views.Page
{
    public class ProcessSetupCommand
    {
        private readonly DetectorSetupPage _detectorSetupPage;

        public ProcessSetupCommand(DetectorSetupPage detectorSetupPage)
        {
            _detectorSetupPage = detectorSetupPage;
        }

        public void Setup(ProcessType processType)
        {
            switch (processType)
            {
                case ProcessType.DetectorSetup:
                    _detectorSetupPage.Controls.ProcessSelector.SelectOptionFromDropDown("Detector Setup");
                    break;
                case ProcessType.MeasureIonArea:
                    _detectorSetupPage.Controls.ProcessSelector.SelectOptionFromDropDown("Measure Ion Area");
                    break;
            }
        }
    }
}