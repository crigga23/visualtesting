using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.Modals;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.Help.StepDefinitions
{
    [Binding]
    public class AboutQuartzSoftwareInformationSteps
    {
        private readonly AboutQuartzModal _aboutQuartzModal;

        public AboutQuartzSoftwareInformationSteps(AboutQuartzModal aboutQuartzModal)
        {
            _aboutQuartzModal = aboutQuartzModal;
        }

        [BeforeScenario("AboutQuartz")]
        public static void BeforeScenario()
        {
            QuartzHeader.WaitForToastContainerToClose();
        }

        [StepDefinition(@"the 'About Quartz' software information is displayed")]
        public void GivenThatAboutBoxIsOpen()
        {
            QuartzHeader.AboutButton.Click();
            AboutQuartzModal.WaitForOpen();
        }

        [Then(@"the 'About Quartz' software information should be readonly")]
        public void ThenTheAboutQuartzSoftwareInformationShouldBeReadonly()
        {
            AboutQuartzModal.CheckContentIsNotEditable();
        }

        [When(@"the 'OK' button is clicked")]
        public void WhenTheButtonIsPressed()
        {
            AboutQuartzModal.Ok.Click();
        }

        [When(@"the 'Close' icon is clicked")]
        public void WhenTheCloseIconIsClicked()
        {
            Report.Action("Close the About Quartz software information by clicking the 'Close' icon");
            AboutQuartzModal.Cancel.Click();
        }

        [When(@"the 'Esc' button is pressed on the keyboard")]
        public void WhenEscapeButtonIsPressedOnTheKeyboard()
        {
            KeyboardOperations.PressEscape(AutomationDriver.Driver);
           
        }

        [Then(@"the 'About Quartz' software information is available")]
        public void ThenTheAboutQuartzSoftwareInformationIsAvailable()
        {
            QuartzHeader.AboutButton.CheckEnabled();
            QuartzHeader.AboutButton.Click();
            AboutQuartzModal.WaitForOpen();

            Check.IsTrue(AboutQuartzModal.Exists, "'About Quartz' software information is available");
            Report.Screenshot();

            AboutQuartzModal.Ok.Click();
            AboutQuartzModal.WaitForClose();
        }

        [Then(@"the content of the 'About Quartz' software information is available in the following Format")]
        public void ThenTheContentOfTheAboutQuartzSoftwareInformationIsAvailableInTheFollowingFormat(Table table)
        {
            //NOTE: Works with Incremental builds and MSI Installed versions
            foreach (var row in table.Rows)
            {
                Report.Action(string.Format("Check the format of the '{0}' label", row["Product"]));
                CheckFormatOfAboutModalLabel(row);
            }
            AboutQuartzModal.Ok.Click();
        }

        private void CheckFormatOfAboutModalLabel(TableRow row)
        {
            switch (row["Product"])
            {
                case "Quartz":
                    _aboutQuartzModal.CheckFormat(row["Format"], AboutQuartzModal.Quartz, row["Product"]);
                    break;
                case "Typhoon":
                    _aboutQuartzModal.CheckFormat(row["Format"], AboutQuartzModal.Typhoon, row["Product"]);
                    break;
                case "Osprey":
                    _aboutQuartzModal.CheckFormat(row["Format"], AboutQuartzModal.Osprey, row["Product"]);
                    break;
            }
        }

        [Then(@"Company and Copyright information is displayed at bottom of the dialog")]
        public void ThenCompanyAndCopyrightInformationIsDisplayedAtBottomOfTheDialog()
        {
            AboutQuartzModal.CheckCopyrightInformationIsPresent();
            AboutQuartzModal.Ok.Click();
        }

        [Then(@"the 'About Quartz' software information is no longer displayed")]
        public void ThenTheAboutQuartzInformationIsNoLongerDisplayed()
        {
            Check.IsFalse(AboutQuartzModal.Exists, "'About Quartz' software information is not displayed");
        }
    }
}
