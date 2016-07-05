using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using Quartz.Support.Views.TabViews;
using TechTalk.SpecFlow;

namespace Quartz.Features.DetectorSetup.StepDefinitions
{
    [Binding]
    public class DetectorSetupBackgroundSteps
    {
        TunePage tunePage;
        DetectorSetupPage detectorSetupPage;

        public DetectorSetupBackgroundSteps(TunePage _tunePage, DetectorSetupPage _detectorSetupPage)
        {
            tunePage = _tunePage;
            detectorSetupPage = _detectorSetupPage;
            Initialise();       
        }

        private static void Initialise()
        {
            if (!FeatureContext.Current.ContainsKey("VialBSelected"))
            {
                FeatureContext.Current.Add("VialBSelected", false);
            }

            if (!FeatureContext.Current.ContainsKey("pDREAttenuateIsON"))
            {
                FeatureContext.Current.Add("pDREAttenuateIsON", false);
            }

            if (!FeatureContext.Current.ContainsKey("setupHasRun"))
            {
                FeatureContext.Current.Add("setupHasRun", false);
            }
        }

        

        [Given(@"pDRE Attenuate is ON")]
        [When(@"pDRE Attenuate is ON")]
        public void GivenPDREAttenuateIsON()
        {
            if ((bool)FeatureContext.Current["pDREAttenuateIsON"] == false)
            {
                NavigationMenu.TuneAnchor.Click();
                tunePage.Controls.ControlsWidget.TabControl.Select("System2");
                System2TabView.pDREAttenuateDropdown.SelectOptionFromDropDown("On");

                FeatureContext.Current["pDREAttenuateIsON"] = true;
            }
        }

        [Given(@"that the Quartz Detector Setup page is open")]
        [When(@"that the Quartz Detector Setup page is open")]
        public void GivenThatTheQuartzDetectorSetupPageIsOpen()
        {
            NavigationMenu.DetectorSetupAnchor.Click();
            Page.WaitForPageToLoad();
        }

        [When(@"detector setup is run for '(.*)' mode")]
        public void WhenDetectorSetupIsRunForMode(string mode)
        {
            if ((bool)FeatureContext.Current["setupHasRun"] == false)
            {
                detectorSetupPage.RunDetectorSetup(mode);

                FeatureContext.Current["setupHasRun"] = true;
            }
        }


    }
}
