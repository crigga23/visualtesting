using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using Automation.Config.Lib.ConfigHelpers;
using Automation.Reporting.Lib;
using Quartz.Support.Configuration;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Modals;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.ManualTune.StepDefinitions
{
    [Binding]
    public class TunePageSavingAndLoadingSetsSteps
    {
        private TunePage tunePage;
        private readonly InstrumentControlWidget instrumentControl;
        private readonly TuneConfig tuneConfig;
        private readonly List<string> factoryDefaultsList;

        private const string CODING_ERROR_MESSAGE =
            "The method does not have an implementation to handle this parameter: ";

        private string lastSavedTuneSet = string.Empty;
        private Dictionary<string, string> controlParameterValuesAfterLastSave;
        private bool foundModifiedControls;
        private TuneConfig.ConfigTab selectedConfigTab;

        public TunePageSavingAndLoadingSetsSteps(TunePage tunePage)
        {
            this.tuneConfig = new TuneConfig(new TestConfiguration(new AppSettingsConfigurationManager()).Instrument);
            instrumentControl = new InstrumentControlWidget();
            factoryDefaultsList = new List<string>();
            this.tunePage = tunePage;
        }

        #region Givens

        [Given(@"that the browser is freshly opened on the Tune page")]
        public void GivenThatTheBrowserIsFreshlyOpenedOnTheTunePage()
        {
            //force a browser restart and log back into Quartz in order to be sure that 
            //the steps from a particular scenario are executed against a fresh Quartz session
            GivenTheBrowserIsClosedAndRe_Opened();
            NavigationMenu.TuneAnchor.Click();
        }

        [Given(@"the Control Parameters have not been modified within the current browser session")]
        public void GivenTheControlParametersHaveNotBeenModifiedWithinTheCurrentBrowserSession()
        {
            Check.IsFalse(foundModifiedControls, "Found unexpected modified controls.");

            if (foundModifiedControls)
            {
                //in case of unexpected behavior, just close the modal in order not to affect the other tests
                SaveTuneSetModal.CancelButton.Click();
            }
        }


        [Given(@"no tune sets have been previously saved")]
        public void GivenNoTuneSetsHaveBeenPreviouslySaved()
        {
            tunePage.DeleteAllTuneSets();
            tunePage.CheckAvailableNumberOfTuneSetsOnDisk(0);
        }

        [Given(@"some of the Control Parameters have been modified within the current browser session")]
        public void GivenSomeOfTheControlParametersHaveBeenModifiedWithinTheCurrentBrowserSession()
        {
            ModifyControlParametersOnSelectedTab();
        }

        [Given(@"there are tune sets available to load")]
        public void GivenThereAreTuneSetsAvailableToLoad()
        {
            Dictionary<string, int> availableTuneSets = tunePage.GetAvailableTuneSetsPaths();
            if (availableTuneSets.Count == 0)
                tunePage.ImportTuneSet("ExistingTuneSet_TestData");
            else
                Check.IsTrue(availableTuneSets.Count > 0, "At least one tune set is available.");
        }

        [Given(@"at least one Control Parameter set has been previously saved")]
        public void GivenAtLeastOneControlParameterSetHasBeenPreviouslySaved()
        {
            ModifyControlParametersOnSelectedTab();
            StoreChangesAfterSavingTuneSetParameters(selectedConfigTab.Title);
        }

        private void StoreChangesAfterSavingTuneSetParameters(string tabName = null)
        {
            tunePage.ClickSaveSetButton();
            lastSavedTuneSet = SaveTuneSetModal.EnterTuneSetNameAndSave();
            controlParameterValuesAfterLastSave = instrumentControl.GetControlsValuesFromSpecifiedTab(tabName);
            foundModifiedControls = false;
        }

        private void ModifyControlParametersOnSelectedTab()
        {
            TuneConfig.ConfigTuneParameter configTuneParameter = tuneConfig.GetTuneSetParameters.FirstOrDefault();
            selectedConfigTab = configTuneParameter.Tab;
            instrumentControl.ModifyControlsValuesFromSpecifiedTab(configTuneParameter.Tab.Title);
            foundModifiedControls = true;
        }

        [Given(@"the Browser is closed")]
        public void GivenTheBrowserIsClosed()
        {
            //make sure any other open windows are closed
            ServiceHelper.CloseQuartz();
            ServiceHelper.KillChrome(); 
            foundModifiedControls = false;
        }

        [Given(@"the Browser is re-opened")]
        public void GivenTheBrowserIsRe_Opened()
        {
            ServiceHelper.StartQuartz();
            // need to reinstantiate the Tune Page view after restarting Quartz during scenario run
            tunePage = new TunePage();
                
        }

        [Given(@"the Browser is closed and re-opened")]
        public void GivenTheBrowserIsClosedAndRe_Opened()
        {
            GivenTheBrowserIsClosed();
            GivenTheBrowserIsRe_Opened();
        }

        [Given(@"Typhoon is restarted without setting any parameter values")]
        public void GivenTyphoonIsRestarted()
        {
            ServiceHelper.StopTyphoon();
            ServiceHelper.StartTyphoon(false);
        }

        [Given(@"all the Control Parameter values are changed from their overwritten values")]
        [Given(@"all the Control Parameter values are changed from their current values")]
        [Given(@"all the Control Parameter values are changed from their Saved values")]
        [Given(@"all the Control Parameter values are changed from their initial values")]
        public void GivenAllTheControlParameterValuesAreChangedFromTheirInitialValues()
        {
            instrumentControl.ModifyControlsValuesFromAllTabs();
            foundModifiedControls = true;
        }

        [Given(@"Save Set is selected with a unique name specified for the save")]
        public void GivenSaveSetIsSelectedWithAUniqueNameSpecifiedForTheSave()
        {
            StoreChangesAfterSavingTuneSetParameters();
        }

        [Given(@"Save Set is selected with the SAME name \(overwritting the existing set\)")]
        public void GivenSaveSetIsSelectedWithTheSAMENameOverwrittingTheExistingSet()
        {
            tunePage.ClickSaveSetButton();
            SaveTuneSetModal.WaitForOpen();

            lastSavedTuneSet = SaveTuneSetModal.EnterTuneSetName(lastSavedTuneSet);
            SaveTuneSetModal.SaveButton.Click();

            DialogConfirmationModal.ClickYesAndClose();

            controlParameterValuesAfterLastSave = instrumentControl.GetControlsValuesFromSpecifiedTab();
            foundModifiedControls = false;
        }

        #endregion Givens


        #region Whens

        [When(@"an attempt is made to Load Set")]
        public void WhenAnAttemptIsMadeToLoadSet()
        {
            tunePage.ClickLoadSetButton(false);
        }

        [When(@"the current changes are then not saved")]
        public void WhenTheCurrentChangesAreThenNotSaved()
        {
            DialogConfirmationModal.WaitForOpen();
            Check.IsTrue(DialogConfirmationModal.Exists,
                "A modal is displayed when attempting to load a tune set as there are unsaved changes");
            DialogConfirmationModal.NoButton.Click();
        }

        [When(@"an attempt is made to Save Set")]
        public void WhenAnAttemptIsMadeToSaveSet()
        {
            tunePage.ClickSaveSetButton();
        }

        [When(@"the previously Saved set is selected")]
        public void WhenThePreviouslySavedSetIsSelected()
        {
            LoadTuneSetModal.TuneParametersDropdown.SelectOptionFromDropDown(lastSavedTuneSet);
            LoadTuneSetModal.LoadButton.Click();
            foundModifiedControls = false;
        }


        [When(@"one of the available Sets is selected")]
        public void WhenOneOfTheAvailableSetsIsSelected()
        {
            LoadTuneSetModal.CheckTuneSetIsSelected(true);
        }

        #endregion Whens


        #region Thens

        [Then(@"the option to save the Control Parameters is disabled")]
        public void ThenTheOptionToSaveTheControlParametersIsDisabled()
        {
            tunePage.Controls.SaveSetButton.CheckDisabled();
        }

        [Then(@"it is not possible to save the current Control Parameter set \(as no changes have been made\)")]
        public void ThenItIsNotPossibleToSaveTheCurrentControlParameterSetAsNoChangesHaveBeenMade()
        {
            //TODO: need to find another verification as this is not valid since the saveSetModal code was moved out of the TunePage.cs
            //Check.IsNull(tpSaveSetModal, "The 'Save Tune Parameters' window was not opened.");
        }

        [Then(@"there are no tune sets available for selection")]
        public void ThenThereAreNoTuneSetsAvailableForSelection()
        {
            LoadTuneSetModal.CheckTuneSetIsAvailable(false);
            tunePage.CheckAvailableNumberOfTuneSetsOnDisk(0);
            LoadTuneSetModal.CancelButton.Click();
        }

        [Then(@"it is possible to Save the Control Parameters set without any warnings or errors")]
        public void ThenItIsPossibleToSaveTheControlParametersSetWithoutAnyWarningsOrErrors()
        {
            lastSavedTuneSet = SaveTuneSetModal.EnterTuneSetNameAndSave();
            controlParameterValuesAfterLastSave = instrumentControl.GetControlsValuesFromSpecifiedTab();
            foundModifiedControls = false;
        }

        [Then(@"it is possible to Load the Control Parameter set without any warnings or errors")]
        public void ThenItIsPossibleToLoadTheControlParameterSetWithoutAnyWarningsOrErrors()
        {
            LoadTuneSetModal.LoadButton.Click();
            foundModifiedControls = false;
        }

        [Then(@"all non factory default Control Parameters are returned to their previously saved values")]
        public void ThenAllNonFactoryDefaultControlParameterValuesAreReturnedToTheirPreviouslySavedValues()
        {
            Dictionary<string, string> currentControlParameterValues = instrumentControl.GetControlsValuesFromSpecifiedTab();

            foreach (var tab in tuneConfig.Tabs)
            {
                if (tab.Title.Equals("MS Profile") || tab.Title.Equals("System2") || tab.Title.Equals("RF")) continue;

                tunePage.SelectTabById(tab.AutomationId);
                AddToFactoryDefaultsList(tab.Title, factoryDefaultsList);
            }

            instrumentControl.CompareControlParameterValues(controlParameterValuesAfterLastSave, currentControlParameterValues, factoryDefaultsList);
        }

        private void AddToFactoryDefaultsList(string tabName, List<string> factoryDefaultsList)
        {
            foreach (var factoryDefaultParameter in tuneConfig.GetFactoryDefaultParameters(tabName))
            {
                factoryDefaultsList.Add(factoryDefaultParameter.Setting);
            }
        }

        [Then(@"I should be able to specify a user defined (.*) having as result (.*)")]
        public void ThenIShouldBeAbleToSpecifyAUserDefinedHavingAsResult(string nameCategory, string expectedResult)
        {
            Report.Action("Create a names list for tune sets");

            #region User tune set names

            string[] tuneSetNames = null;

            switch (nameCategory)
            {
                case "Alpha":
                    tuneSetNames = new[] {"a", "bC", "DeF", "gHiJ", "KlMnO", "PqrsT"};
                    break;
                case "Numeric":
                    tuneSetNames = new[] {"1", "23", "456", "78910"};
                    break;
                case "Alpha-Numeric":
                    tuneSetNames = new[] {"a1", "2B", "Cd3", "e4F", "5Gh6", "I7j8"};
                    break;
                case "Approved Special Characters":
                    tuneSetNames = new[] {"-", "_"};
                    break;
                case "Special Characters":
                    tuneSetNames = new[]
                    {
                        string.Empty, " ", "`", "~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "/", "?", ".", ">",
                        ",", "<", "'", "[", "{", "}", "]", "|", "=", "+", @"\"
                    };
                    break;
                case "Alpha-Numeric-SpecialCharacters":
                    tuneSetNames = new[] {"a1@"};
                    break;
                case "150 characters":
                case "151 characters":
                    int numberOfCharacters = Convert.ToInt32(Regex.Match(nameCategory, @"\d+").Value);
                    tuneSetNames = new[] {new string('1', numberOfCharacters) };
                    break;
                default:
                    Report.Fail(CODING_ERROR_MESSAGE + nameCategory);
                    break;
            }

            Check.IsTrue(tuneSetNames != null, "The names list for tune sets saving is created");

            #endregion User tune set names

            switch (expectedResult.ToLower())
            {
                case "accepted":
                    SaveTuneSetsWithDifferentNames(tuneSetNames, true);
                    break;

                case "rejected":
                    SaveTuneSetsWithDifferentNames(tuneSetNames, false);
                    break;

                default:
                    Report.Fail(CODING_ERROR_MESSAGE + expectedResult);
                    break;
            }
        }

        /// <summary>
        /// Attempt to save tunse sets with different names for each namesCategory
        /// </summary>
        /// <param name="namesCategory">Can be: 'Alpha', 'Numeric', 'Alpha-Numeric', 'Special Characters' or 'Alpha-Numeric-SpecialCharacters'</param>
        /// <param name="expectedResult">'Accepted', if the save tune set action is expected to be successful. Otherwise is 'Rejected'</param>
        private void SaveTuneSetsWithDifferentNames(string[] tuneSetNames, bool shouldBeAccepted)
        {
            Report.Action("Attempt to save tune sets with different names");

            for (int currentTuneSetName = 0; currentTuneSetName < tuneSetNames.Length; currentTuneSetName++)
            {
                switch (shouldBeAccepted)
                {
                    #region Rejected tune set names

                    case false:
                    {
                        if (currentTuneSetName >= 1)
                            tunePage.ClickSaveSetButton();

                        string enteredTuneSetName = SaveTuneSetModal.EnterTuneSetName(tuneSetNames[currentTuneSetName]);

                        if ((SaveTuneSetModal.TuneSetNameTextBox.Text == enteredTuneSetName) || (SaveTuneSetModal.TuneSetNameTextBox.Text == string.Empty))
                        {
                            Check.IsTrue(!SaveTuneSetModal.SaveButton.Enabled, string.Format("Name '{0}' should not contain special characters. Tune set can not be saved (as expected).", tuneSetNames[currentTuneSetName]), true);
                        }
                        else
                        {
                            Check.IsTrue(SaveTuneSetModal.SaveButton.Enabled, string.Format("Desired tune set name '{0}' contains restricted characters and only a part of the name was introduced '{1}'. The tune set will not be saved (as expected).", tuneSetNames[currentTuneSetName], SaveTuneSetModal.TuneSetNameTextBox.Text), true);
                        }

                        SaveTuneSetModal.CancelButton.Click();
                        SaveTuneSetModal.WaitForClose();
                        break;
                    }

                    #endregion Rejected tune set names

                    #region Accepted tune set names

                    case true:
                    {
                        SaveTuneSetModal.EnterTuneSetNameAndSave(tuneSetNames[currentTuneSetName]);
                        tunePage.CheckTuneSetExists(tuneSetNames[currentTuneSetName]);

                        if (currentTuneSetName < tuneSetNames.Length - 1)
                        {
                            //prepare to enter next name (change value and reopen 'Save Tune Set' modal)
                            
                            TuneConfig.ConfigTuneParameter configTuneParameter = tuneConfig.GetTuneSetParameters.FirstOrDefault();
                            
                            if (configTuneParameter == null)
                            {
                                Report.Debug("Unable to find a random ");
                                break;
                            }

                            tunePage.ControlsWidget.ModifyValueForASingleControl(configTuneParameter.Tab.Title, configTuneParameter.Setting);
                            tunePage.ClickSaveSetButton();

                        }
                        break;
                    }

                    #endregion Accepted tune set names
                }
            }
        }

        #endregion Thens
    }
}