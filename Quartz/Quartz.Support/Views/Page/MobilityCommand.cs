namespace Quartz.Support.Views.Page
{
    public class MobilityCommand
    {
        private readonly TunePage _tunePage;

        public MobilityCommand(TunePage tunePage)
        {
            _tunePage = tunePage;
            TunePage.Tuning.StartTuning();
        }

        public void Start()
        {
            _tunePage.Controls.MobilityButton.Click();
        }
    }
}