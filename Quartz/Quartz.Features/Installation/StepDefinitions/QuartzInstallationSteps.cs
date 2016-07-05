using System;
using Automation.Instrument.Lib;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Modals;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;
using Table = TechTalk.SpecFlow.Table;

namespace Quartz.Features.Installation.StepDefinitions
{
    [Binding]
    public class QuartzInstallationSteps
    {
        private readonly QuartzHeader _quartzHeader;
        private readonly AboutQuartzModal _aboutModal;

        public QuartzInstallationSteps(QuartzHeader quartzHeader, AboutQuartzModal aboutModal)
        {
            _quartzHeader = quartzHeader;
            _aboutModal = aboutModal;
        }

        [Given(@"the installer is present")]
        public void GivenTheInstallerIsPresent()
        {
            ScenarioContext.Current.Set(TyphoonHelper.GetLatestQuartzInstallerPath(), "quartzInstallerPath");
            ScenarioContext.Current.Set(TyphoonHelper.TyphoonVersion, "quartzInstallerVersion");
        }

        [Given(@"I restart Quartz and Typhoon")]
        public void GivenIRestartQuartzAndTyphoon()
        {
            ServiceHelper.RestartTyphoonAndQuartz();
        }

        [StepDefinition(@"I install the latest version of the installer")]
        public void WhenIInstallTheLatestVersionOfTheInstaller()
        {
            InstallationManager.InstallLatestVersionOfQuartzSilently();
        }

        [Then(@"perform a soft reboot the instrument")]
        public void ThenPerformASoftRebootTheInstrument()
        {
            InstrumentCom.SoftReboot();
        }

        [StepDefinition(@"Quartz has been started")]
        public void QuartzHasBeenStarted()
        {
            ServiceHelper.StartTyphoon();
            ServiceHelper.StartQuartz();
        }

        [StepDefinition(@"I am able to login as a developer")]
        public void ThenIAmAbleToLogin()
        {
            LoginPage.LoginAsAutomationTestUser();
        }

        [When(@"toast status is closed")]
        public void WhenToastStatusIsClosed()
        {
            QuartzHeader.WaitForToastContainerToClose();
        }

        [StepDefinition(@"I navigate to the about page")]
        public void WhenINavigateToTheAboutPage()
        {
            QuartzHeader.AboutButton.Click();
            AboutQuartzModal.WaitForOpen();
        }

        [When(@"I click ok on the about page")]
        public void WhenIClickOkOnTheAboutPage()
        {
            AboutQuartzModal.Ok.Click();
        }

        [StepDefinition(@"the installed build matches the installer version")]
        public void ThenTheInstalledBuildMatchesTheInstallerVersion()
        {
            Check.IsNotNull(AboutQuartzModal.Quartz, "Quartz Label exists on About Quartz Modal Dialog");

            string installerVersion = ScenarioContext.Current.Get<string>("quartzInstallerVersion").Trim();

            if (AboutQuartzModal.Quartz.Text.Contains(installerVersion))
            {
                Check.IsTrue(AboutQuartzModal.Quartz.Text.Contains(installerVersion), "Installed Quartz Build matches installer version");
            }
            else
            {
                Report.Fail("This version of Quartz does not match the latest version of the MSI", true);
            }
                       
        }

        [StepDefinition(@"the installed build matches the version in add remove programs")]
        public void ThenTheInstalledBuildMatchesTheVersionInAddRemovePrograms()
        {
            Check.IsTrue(InstallationManager.QuartzBuildVersionMatchesAddRemoveProgramsVersion(),
                "Installed Quartz Build matches version in Add/Remove Programs");
        }

        [StepDefinition(@"I close the about page")]
        public void ThenICloseTheAboutPage()
        {
            AboutQuartzModal.CloseModalIfOpen();
        }

        [Then(@"it is possible to navigate to the following instrument pages")]
        public void ThenItIsPossibleToNavigateToTheFollowingInstrumentPages(Table table)
        {
            foreach (TableRow row in table.Rows)
            {
                string instrumentPage = row["instrument page"];
                int numberOfWidgets = int.Parse(row["number of widgets"]);
                string[] widgetTitles = row["widget title"].Split(new[] { ", " }, StringSplitOptions.None);

                NavigationMenu.SelectAnchor(instrumentPage);
                Page.WaitForPageToLoad();

                Page page = new Page();
                Check.AreEqual(numberOfWidgets, () => page.AllWidgets.Count, string.Format("The {0} page has the correct number widgets displayed", instrumentPage), false, 8000);
                page.CheckWidgetsAreAvailable(widgetTitles);

                Page.CheckLoginControlIsNotPresentOnPage();               
            }
        }

        [Given(@"Quartz is installed")]
        public void GivenQuartzIsInstalled()
        {
            Check.IsTrue(InstallationManager.IsQuartzInstalled(), "Quartz is currently installed");
        }

        [When(@"Quartz is uninstalled")]
        public void WhenQuartzIsUninstalled()
        {
            InstallationManager.UninstallQuartz();
        }

        [Then(@"the program is not present in add remove programs")]
        public void ThenTheProgramIsNotPresentInAddRemovePrograms()
        {
            Check.IsFalse(InstallationManager.IsQuartzInstalled(), "Quartz is not currently installed");
        }
    }
}
