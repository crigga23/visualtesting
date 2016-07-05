using Quartz.Support.Views;
using TechTalk.SpecFlow;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;

namespace Quartz.Features.General.StepDefinitions
{
    [Binding]
    public class AboutBoxSoftwareInformationSteps
    {
        private readonly AboutModal _aboutModal;

        public AboutBoxSoftwareInformationSteps(AboutModal aboutModal)
        {
            _aboutModal = aboutModal;
        }

        [BeforeScenario("AboutBoxInfo")]
        public static void BeforeScenario()
        {
            // TODO: Refactor move to better place for reuse
            Report.Debug("Waiting for Toast container to close");

            while (AboutModal.ToastContainerExists)
            {
                //do nothing
            }
            Report.Debug("Toast closed");
        }

        [AfterScenario("AboutBoxInfo")]
        public static void AfterScenario()
        {
            if (Modal.Exists)
            {
                AboutModal.OKButton.Click();
            }
        }

        [Given(@"that About Box is open")]
        public void GivenThatAboutBoxIsOpen()
        {
            QuartzHeader.AboutButton.Click();
            Wait.ForMilliseconds(5000);
        }

        [When(@"Quartz top level page is accessed")]
        public void WhenQuartzTopLevelPageIsAccessed()
        {
        }

        [When(@"the About Box is accessed")]
        public void WhenTheAboutBoxIsAccessed()
        {
            QuartzHeader.AboutButton.Click();
        }

        [When(@"the content is edited")]
        public void WhenTheContentIsEdited()
        {
            ScenarioContext.Current.Pending();
        }

        [When(@"the '(.*)' button is pressed")]
        public void WhenTheButtonIsPressed(string p0)
        {
            AboutModal.OKButton.Click();
        }

        [When(@"the top right '(.*)' button is pressed")]
        public void WhenTheTopRightButtonIsPressed(string p0)
        {
            Report.Action("Close the About Box by pressing the red x button");
            AboutModal.CancelButton.Click();
        }

        [When(@"'(.*)' is pressed on the keyboard")]
        public void WhenIsPressedOnTheKeyboard(string p0)
        {
            _aboutModal.PressEscapeKeyOnKeyBoard();
        }

        [Then(@"access to the '(.*)' is available")]
        public void ThenAccessToTheIsAvailable(string p0)
        {
            QuartzHeader.AboutButton.CheckDisplayed();
            QuartzHeader.AboutButton.CheckEnabled();
            QuartzHeader.AboutButton.Click();
            Report.Screenshot();
            Check.IsTrue(Modal.Exists, "About box is available");
            
            Wait.ForMilliseconds(5000);
            AboutModal.OKButton.Click();
        }

        [Then(@"the content of the About Quartz is available with Format")]
        public void ThenTheContentOfTheAboutQuartzIsAvailableWithFormat(Table table)
        {
            foreach (var row in table.Rows)
            {
                Report.Action(string.Format("Check the format of the '{0}' label", row["About Quartz"]));
                CheckFormatOfAboutModalLabel(row);
            }

            AboutModal.OKButton.Click();
        }

        private void CheckFormatOfAboutModalLabel(TableRow row)
        {
            switch (row["About Quartz"])
            {
                case "Quartz":
                    _aboutModal.CheckFormat(row["Format"], AboutModal.QuartzLabel, row["About Quartz"]);
                    break;
                case "Typhoon":
                    _aboutModal.CheckFormat(row["Format"], AboutModal.TyphoonLabel, row["About Quartz"]);
                    break;
                case "Dev Console":
                    _aboutModal.CheckFormat(row["Format"], AboutModal.DevConsoleLabel, row["About Quartz"]);
                    break;
                case "WRENS":
                    _aboutModal.CheckFormat(row["Format"], AboutModal.WrensLabel, row["About Quartz"]);
                    break;
                case "AMITS":
                    _aboutModal.CheckFormat(row["Format"], AboutModal.AMITSLabel, row["About Quartz"]);
                    break;
                case "Man Test":
                    _aboutModal.CheckFormat(row["Format"], AboutModal.ManTestLabel, row["About Quartz"]);
                    break;
            }
        }

        [Then(@"Company information and copyright information is displayed at bottom of the dialog")]
        public void ThenCompanyInformationAndCopyrightInformationIsDisplayedAtBottomOfTheDialog()
        {
            Wait.ForMilliseconds(5000);
            AboutModal.CopyRightsLabel.CheckDisplayed();
            Check.IsTrue(AboutModal.CopyRightsLabel.Text.ToLower().Contains("waters corporation"), "Company information is available");
            Report.Screenshot(AboutModal.CopyRightsLabel.Element);
            AboutModal.OKButton.Click();
        }

        [Then(@"the About Box information is no longer displayed")]
        public void ThenTheAboutBoxInformationIsNoLongerDisplayed()
        {
            Check.IsFalse(AboutModal.Exists, "About box is not displayed");
        }

    }
}
