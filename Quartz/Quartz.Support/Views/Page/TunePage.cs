using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.Modals;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Reflection;
using Automation.Typhoon.Lib;
using Quartz.Support.Exceptions;
using TechTalk.SpecFlow;
using Button = Automation.WebFramework.Lib.Button;
using WindowsForm = System.Windows.Forms;

namespace Quartz.Support.Views.Page
{
    public class TunePage : Page
    {
        public static string Url
        {
            get
            {
                return string.Format("{0}{1}/#/app/instrument/tune", ConfigurationManager.AppSettings["QuartzServerUrl"], ConfigurationManager.AppSettings["QuartzServerPort"]);
            }
        }


        public TechTalk.SpecFlow.Table InstrumentSpec;

        public InstrumentControlWidget ControlsWidget
        { get { return new InstrumentControlWidget(); } }

        public TunePageControls Controls { get; set; }

        public override Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                var controls = new Dictionary<string, ControlGroup>();
                            
                controls = DictionaryManager.MergeDictionaries(controls, ControlsWidget.ControlsDictionary);

                return controls;
            }
        }

        public TunePage()
        {
            Controls = new TunePageControls(this);
        }

        #region Methods

        public void RecordAcquisition(int milliseconds, string fileName)
        {
            Controls.StartButton.Click();
            Wait.ForMilliseconds(milliseconds);
            Controls.StopButton.Click();

            RecordDataModal.FileName.SetText(fileName);
            RecordDataModal.SaveButton.Click();
        }

        /// <summary>
        /// Selects a method xml to run
        /// </summary>
        /// <param name="method">method file name</param>
        /// <param name="customFilePath">Specify this if the method does not live in the default Typhoon Method directory</param>
        /// <param name="waitForScanData">Waits for scan data to be received before continuing</param>
        public void SelectTuningMethod(string method, string customFilePath = null, bool waitForScanData = true)
        {
            Report.Action(string.Format("Select the {0} method type", method));
            const string fileNameAutomationId = "1148";

            Controls.AcquisitionDropdown.SelectDropdownOption("Custom Tune");

            FileDialogHelper.FindDialog("Open");

            string xmlFile;
            if (string.IsNullOrEmpty(customFilePath))
            {
                if (method.Contains(".xml"))
                {
                    method = method.Replace(".xml", "");
                }

                xmlFile = GetMethodXmlFile(method);
            }
            else
            {
                xmlFile = string.Concat(customFilePath, method);
            }

            if (xmlFile != null)
            {
                Wait.ForMilliseconds(1000);
                FileDialogHelper.SetCombobox(fileNameAutomationId, xmlFile);
                Wait.ForMilliseconds(1000);
            }
            else
            {
                Report.Fail(string.Format("Unable to locate '{0}' xml file", method));
            }

            FileDialogHelper.ClickOpenButton();

            Wait.Until(f => FileDialogHelper.Window.Current.IsOffscreen, 5000, "Waiting for Open File Dialog to close...", false);

            if (!FileDialogHelper.Window.Current.IsOffscreen)
            {
                Report.Warn("The Open Dialog did not close as expected when clicking the Open button. Re-enter xml location in combobox and press Enter");
                FileDialogHelper.SetCombobox(fileNameAutomationId, xmlFile);
                Wait.ForMilliseconds(2000);
                WindowsForm.SendKeys.SendWait("{ENTER}");

                Wait.Until(f => FileDialogHelper.Window.Current.IsOffscreen, 5000, "Waiting for Open File Dialog to close...");
            }

            if (waitForScanData)
            {
                AcquistionFactory.Instance.AcquisitionSystem.WaitForScanData();             
            }
        }


        private string GetMethodXmlFile(string method)
        {
            string methodDir = TyphoonHelper.MethodsDirectory;
            string fileName = method + ".xml";

            List<string> matchingFiles = new List<string>();

            // Check base directory first
            foreach (string f in Directory.GetFiles(methodDir, fileName))
            {
                matchingFiles.Add(f);
            }

            // Check subdirectories
            foreach (string d in Directory.GetDirectories(methodDir))
            {
                foreach (string f in Directory.GetFiles(d, fileName))
                {
                    matchingFiles.Add(f);
                }
            }

            if (matchingFiles.Count > 0)
            {
                if (matchingFiles.Count > 1)
                {
                    Report.Warn(string.Format("More than one matching file for '{0}' has been found. Returning the first file found.", fileName));
                }

                return matchingFiles.FirstOrDefault();
            }

            return null;
        }

        public void ResetFactoryDefaults()
        {
            Controls.FactoryDefaultsDropdown.Expand();
            Controls.FactoryDefaultsResettoDefaultButton.Click();

            if (DialogConfirmationModal.Exists)
            {
                DialogConfirmationModal.ClickNoAndClose();
            }

            // Waiting for parameters to update
            Wait.ForMilliseconds(3000);
        }

        public void SaveFactoryDefaults()
        {
            Controls.FactoryDefaultsDropdown.Expand();
            Controls.FactoryDefaultsSaveButton.Click();
            Wait.ForMilliseconds(6000);
        }

        public void LoadFactoryDefaults()
        {
            Controls.FactoryDefaultsDropdown.Expand();
            Controls.FactoryDefaultsLoadButton.Click();

            if (DialogConfirmationModal.Exists)
            {
                DialogConfirmationModal.ClickNoAndClose();
            }

            // Waiting for parameters to update
            Wait.ForMilliseconds(3000);
        }
        
        /// <summary>
        /// Load or set the factory default
        /// </summary>
        /// <param name="action"></param>
        public void FactoryDefaultAction(string action)
        {
            if (action.ToLower().Contains("load"))
            {
                LoadFactoryDefaults();
            }
            else if (action.ToLower().Contains("save"))
            {
                SaveFactoryDefaults();
            }
        }

        public enum InstrumentPolarity
        {
            Positive,
            Negative
        }

        public enum InstrumentMode
        {
            Resolution,
            Sensitivity
        }

        /// <summary>
        /// Switch to Postive/Negative modes and Resolution/Sensitivity polarities
        /// </summary>
        /// <param name="mode"></param>
        /// <param name="polarity"></param>
        public void SwitchConfiguration(string mode, string polarity, bool waitForSettle = true)
        {
            if (!string.IsNullOrEmpty(mode))
            {
                Report.Action(string.Format("Setting mode to '{0}'", mode));

                if (mode.Equals(InstrumentMode.Resolution.ToString()))
                {
                    Controls.ResolutionButton.Click();
                    Controls.ResolutionButton.CheckDisabled();
                }
                else if (mode.Equals(InstrumentMode.Sensitivity.ToString()))
                {
                    Controls.SensitivityButton.Click();
                    Controls.SensitivityButton.CheckDisabled();
                }
                else
                {
                    throw new NoSuchInstrumentModeException(string.Format("No such instrument mode exists for '{0}' mode", mode));
                }
            }

            if (!string.IsNullOrEmpty(polarity))
            {
                Report.Action(string.Format("Setting polarity to '{0}'", polarity));

                if (polarity.Equals(InstrumentPolarity.Positive.ToString()))
                {
                    Controls.PositiveModeButton.Click();
                    Controls.PositiveModeButton.CheckDisabled();
                }
                else if (polarity.Equals(InstrumentPolarity.Negative.ToString()))
                {
                    Controls.NegativeModeButton.Click();
                    Controls.NegativeModeButton.CheckDisabled();
                }
                else
                {
                    throw new NoSuchInstrumentPolarityException(string.Format("No such instrument polarity exists for '{0}' polarity", polarity));
                }
            }

            if (waitForSettle)
            {
                TyphoonHelper.WaitForSettle();
            }

            Report.Debug(string.Format("Current polarity and mode is: '{0}'", GetCurrentConfiguration()));
        }

        /// <summary>
        /// Check if the tune sets available in 'Typhoon\bin\tune_sets' matches the expected number of tune sets
        /// </summary>
        /// <param name="expectedNoOfTuneSets">The expected number of tune sets to be found</param>
        /// <param name="includeVersions">If TRUE, will count also the available previous versions of the tune sets (these are not displayed in the LoadTuneParameters modal)</param>
        public void CheckAvailableNumberOfTuneSetsOnDisk(int expectedNoOfTuneSets, bool includeVersions = false)
        {
            int availableNoOfTuneSets = 0;

            if (includeVersions)
                availableNoOfTuneSets = GetAvailableNoOfTuneSetsIncludingVersions();
            else
                availableNoOfTuneSets = GetAvailableTuneSetsPaths().Count;

            Check.IsTrue(availableNoOfTuneSets == expectedNoOfTuneSets, string.Format("Expected {0} tune set(s). Found {1} tune set(s).", expectedNoOfTuneSets, availableNoOfTuneSets), true);
        }

        private string tuneSetsDirPath = TyphoonHelper.TuneSetDirectory;

        /// <summary>
        /// Deletes all the files from the Typhoon's tune_sets directory
        /// </summary>
        public void DeleteAllTuneSets()
        {
            if (!Directory.Exists(tuneSetsDirPath))
            {
                Report.Fail("Unable to find Tune Sets directory: " + tuneSetsDirPath);
            }
            else
            {
                var files = Directory.GetFiles(tuneSetsDirPath);
                try
                {
                    foreach (string file in files)
                    {
                        Report.Action(string.Format("Deleting tune set: {0}", file));
                        File.Delete(file);
                        Check.IsFalse(File.Exists(file), string.Format("Tune set '{0}' successfully deleted.", file));
                    }
                }
                catch (Exception ex)
                {
                    Report.Fail("Unable to delete tune set. Received unexpected exception: " + ex.Message);
                }
            }
        }

        /// <summary>
        /// Copy an existing tune set from the test data folder into Typhoon's tune sets location
        /// </summary>
        /// <param name="tuneSetName">The tune set name</param>
        public void ImportTuneSet(string tuneSetName)
        {
            int initialTuneSetsCount = GetAvailableNoOfTuneSetsIncludingVersions();
            string testDataFolder = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), @"Data\TestData\");

            if (Directory.Exists(tuneSetsDirPath) && Directory.Exists(testDataFolder))
            {
                string[] files = Directory.GetFiles(testDataFolder);
                if (files.Length > 0)
                {
                    try
                    {
                        foreach (string file in files)
                        {
                            if (file.EndsWith(tuneSetName) || file.EndsWith(tuneSetName + ".md5"))
                            {
                                string destFile = tuneSetsDirPath + "\\" + Path.GetFileName(file);
                                File.Copy(file, destFile, true);
                                Check.IsTrue(File.Exists(destFile), string.Format("Successfully copied tune set to '{0}'", destFile));
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Report.Fail("Could not copy the test data tune sets, received unexpected exception: " + ex.Message);
                    }
                }
            }
            CheckAvailableNumberOfTuneSetsOnDisk(initialTuneSetsCount + 1, true);
        }

        /// <summary>
        /// Retrieve the paths to the available Tune Sets from 'Typhoon\bin\tune_sets'
        /// </summary>
        /// <returns>The paths of the available Tune Sets</returns>
        public Dictionary<string, int> GetAvailableTuneSetsPaths()
        {
            string[] files = null;
            Dictionary<string, int> tuneSetsFiles = new Dictionary<string, int>();

            if (!Directory.Exists(tuneSetsDirPath))
            {
                Report.Fail("Tune Sets directory doesn't exist.");
            }
            else
            {
                files = Directory.GetFiles(tuneSetsDirPath);
                foreach (string file in files)
                {
                    //for each tune set it corresponds an *.md5 file
                    //but each tune set can have different versions - count them all
                    if (file.EndsWith(".md5"))
                    {
                        int versionsCount = -1; // not counting the md5 file
                        foreach (string fileVersions in files)
                        {
                            string fileName = Path.GetFileNameWithoutExtension(file);
                            if (fileName == Path.GetFileNameWithoutExtension(fileVersions))
                                versionsCount++;
                        }
                        tuneSetsFiles.Add(file, versionsCount);
                    }
                }
            }
            return tuneSetsFiles;
        }

        /// <summary>
        /// Reads the tune sets paths from Typhoon's tune_sets directory, including the old available versions (these are not displayed in the LoadTuneParameters modal)
        /// </summary>
        /// <returns></returns>
        public int GetAvailableNoOfTuneSetsIncludingVersions()
        {
            int totalCount = 0;
            Dictionary<string, int> tuneSets = GetAvailableTuneSetsPaths();

            foreach (string tuneSetName in tuneSets.Keys)
            {
                totalCount += tuneSets[tuneSetName];
            }

            return totalCount;
        }

        /// <summary>
        /// Verify if the 'Load Set' button is enabled and click on it
        /// </summary>
        public void ClickLoadSetButton(bool handleSaveChangesDialog = true)
        {
            Controls.LoadSetButton.CheckEnabled();
            Controls.LoadSetButton.Click();

            if (handleSaveChangesDialog)
            {
                // Handle the Save Changes modal
                if (DialogConfirmationModal.Exists)
                {
                    DialogConfirmationModal.ClickNoAndClose();
                }

                LoadTuneSetModal.WaitForOpen();

                Check.IsTrue(LoadTuneSetModal.Exists, "Load Tune Set Modal is displayed");
                Report.Screenshot();
            }
        }

        /// <summary>
        /// Verify if the 'Save Set' button is enabled and click on it
        /// </summary>
        public void ClickSaveSetButton()
        {
            Controls.SaveSetButton.CheckEnabled();
            Controls.SaveSetButton.Click();

            Check.IsTrue(SaveTuneSetModal.Exists, "Save Tune Set Modal is displayed");
            Report.Screenshot();
        }

        /// <summary>
        /// Gets the current mode and polarity configuration
        /// </summary>
        /// <returns>configuration</returns>
        public string GetCurrentConfiguration()
        {
            string mode;
            string polarity;
            //Find the current mode and polarity configuration
            if (Controls.PositiveModeButton.Enabled)
                polarity = "Negative";
            else
                polarity = "Positive";

            if (Controls.ResolutionButton.Enabled)
                mode = "Sensitivity";
            else
                mode = "Resolution";

            return String.Join(" ", polarity, mode);
        }

        /// <summary>
        /// Load a Tune Set
        /// </summary>
        /// <param name="tuneSetName"></param>
        /// <param name="continueOnFail"></param>
        public void LoadTuneSet(string tuneSetName, bool continueOnFail = false)
        {
            ClickLoadSetButton();

            LoadTuneSetModal.TuneParametersDropdown.SelectOptionFromDropDown(tuneSetName);

            LoadTuneSetModal.LoadButton.Click();
            Wait.Until(l => !LoadTuneSetModal.Exists, 4000);
        }

        /// <summary>
        /// Save a Tune Set
        /// </summary>
        /// <param name="tuneSetName">name</param>
        /// <param name="continueOnFail">true or false</param>
        public void SaveTuneSet(string tuneSetName, bool continueOnFail = false)
        {
            ClickSaveSetButton();

            int initialNoOfTuneSets = GetAvailableNoOfTuneSetsIncludingVersions();

            SaveTuneSetModal.EnterTuneSetNameAndSave(tuneSetName);

            Dictionary<string, int> existingTuneSets = GetAvailableTuneSetsPaths();
            bool foundExpectedTuneSet = false;

            foreach (string tunePath in existingTuneSets.Keys)
            {
                if (Path.GetFileNameWithoutExtension(tunePath) == tuneSetName)
                {
                    foundExpectedTuneSet = true;
                    break;
                }
            }

            Check.IsTrue(foundExpectedTuneSet, string.Format("Tune set '{0}'successfully saved.", tuneSetName), continueOnFail);
        }

        public void CheckTuneSetExists(string tuneSetName)
        {
            Dictionary<string, int> existingTuneSets = GetAvailableTuneSetsPaths();

            bool foundExpectedTuneSet = false;
            foreach (string tunePath in existingTuneSets.Keys)
            {
                if (Path.GetFileNameWithoutExtension(tunePath) == tuneSetName.Replace("@", "") && tuneSetName.Contains("@"))
                {
                    foundExpectedTuneSet = true;
                    break;
                }
                else if (Path.GetFileNameWithoutExtension(tunePath) == tuneSetName)
                {
                    foundExpectedTuneSet = true;
                    break;
                }
            }

            Check.IsTrue(foundExpectedTuneSet, string.Format("Tune set '{0}' successfully saved.", tuneSetName), true);
        }

        public string GetOperateStatus()
        {
            string fillColor = Controls.InstrumentPowerIndicator.GetCssValue("fill");

            if (fillColor.Contains("rgb"))
            {
                return HandleRgbValue(fillColor);
            }

            return fillColor.Equals("Chartreuse") ? "green" : fillColor;
        }

        private static string HandleRgbValue(string rgbValue)
        {
            string fillColor = null;
            switch (rgbValue)
            {
                case "rgb(255, 0, 0)":
                    fillColor = "red";
                    break;
                case "rgb(127, 255, 0)":
                    fillColor = "green";
                    break;
                case "rgb(255, 255, 0)":
                    fillColor = "yellow";
                    break;
                case "rgb(128, 128, 128)":
                    fillColor = "gray";
                    break;
            }

            return fillColor;
        }

        public static string GetRawDataFilePath()
        {
            string fileName = ScenarioContext.Current.Get<string>("AcquisitionDataName");
            string typhoonFolder = Directory.GetParent(ServiceHelper.GetTyphoonBinFolder()).FullName;
            string typhoonDataStoreFolder = string.Format(@"{0}\data_store", typhoonFolder);
            string rawDataFilePath = string.Format(@"{0}\{1}.raw", typhoonDataStoreFolder, fileName);
            return rawDataFilePath;
        }

        #endregion Methods

        public static TuningCommand Tuning
        {
            get { return new TuningCommand(new TunePage()); }
        }

        public static MobilityCommand MobilityMode
        {
            get { return new MobilityCommand(new TunePage()); }
        }

        public static TOFCommand TOFMode
        {
            get { return new TOFCommand(new TunePage()); }
        }

        public static FluidicsSetupCommand FluidicsSetup
        {
            get { return new FluidicsSetupCommand(new TunePage()); }
        }

        public static void CheckTopButtonBarIsVisible()
        {
            Wait.Until(ExpectedConditions.ElementExists(By.Id("quick_actions")), 60000);
            IWebElement topButtonBar = AutomationDriver.Driver.FindElement(By.Id("quick_actions"));

            Check.IsTrue((topButtonBar.Displayed && topButtonBar.Enabled),
                "The Tune page quick actions toolbar is visible and enabled");
        }
    }

    public class TunePageControls
    {
        // TODO: Is this dependency needed can we not just use the AutomationDriver.Driver to find elements?
        private Page parent;

        public TunePageControls(Page page)
        {
            parent = page;
        }

        #region Control Constants

        private const string popOutButtonId = "tpPopOutBtn";
        private const string startButtonId = "tpRecordStartBtn";
        private const string stopButtonId = "tpRecordStopBtn";
        private const string saveSetButtonId = "tpSaveSetBtn";
        private const string loadSetButtonId = "tpLoadSetBtn";
        private const string loadButtonId = "tpLoadBtn";

        //Factory Defaults and Acquisition
        private const string factoryDefaultsBtnId = "tpFactoryDefaultsBtn";
        private const string factoryDefaultsSaveBtnId = "tpFactoryDefaultsSaveBtn";
        private const string factoryDefaultsResettoDefaultBtnId = "tpFactoryDefaultsResetBtn";
        private const string factoryDefaultsResettoFactoryBtnId = "tpFactoryDefaultsResetFactoryBtn";
        private const string factoryDefaultsLoadBtnId = "tpFactoryDefaultsLoadBtn";
        private const string acquisitionComboboxId = "tpAcquisitionBtn";

        private const string tuneButtonId = "runMethod";
        private const string abortButtonId = "tpAbortBtn1";

        private const string mzButtonId = "tpMz";
        private const string dtButtonId = "tpDt";
        private const string bpiButtonId = "tpBpi";
        private const string ticButtonId = "tpTic";
        private const string rbButtonId = "tpRb";
        private const string ppButtonId = "tpPp";
        private const string clearButtonId = "tpChromClear";
        private const string normalizeButtonId = "tpNormaliseOff";

        private const string positiveModeButtonId = "Polarity.Positive";
        private const string negativeModeButtonId = "Polarity.Negative";
        private const string resolutionButtonId = "OpticMode.Resolution";
        private const string sensitivityButtonId = "OpticMode.Sensitivity";
        private const string APIGasButtonId = "Gas.APIGasOn.Setting";
        private const string collisionGasButtonId = "Gas.CollisionGasOn.Setting";
        private const string gasControlDropdownId = "GasControl";

        //TODO: Replace with correct ids
        private const string frequencyModeDropdownId = "Acquisition.FrequencyMode";
        private const string scanTimeDropdownId = "Acquisition.ScanTime";

        private const string tofModeButtonId = "TOFMode.TOF";
        private const string mobilityModeButtonId = "TOFMode.IMS";

        private const string functionsListId = "FunctionsList";

        private const string standbyButtonId = "Voltages.Standby";
        private const string operateButtonId = "Voltages.Operate";
        private const string sourceButtonId = "Voltages.SourceStandby";
        private const string powerLedId = "powerLed";
        private const string scanDataGraphId = "tpPlotPanel";
        private const string ControlsPanelId = "tpControlsPanel";

        #endregion Control Constants

        #region Controls

        public Widget PlotDataWidget
        {
            get
            {
                return new Widget(parent.FindWidget("Plot Data"));
            }
        }

        public Widget ControlsPanel
        {
            get { return new Widget(parent.Driver.FindElement(By.Id(ControlsPanelId))); }
        }

        public IWebElement ScanDataGraph
        {
            get
            {
                return parent.Driver.FindElement(By.Id(scanDataGraphId));
            }
        }

        public Button PopOutButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(popOutButtonId)));
            }
        }
        public Button StartButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(startButtonId)));
            }
        }
        public Button StopButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(stopButtonId)));
            }
        }
        public Button SaveSetButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(saveSetButtonId)));
            }
        }
        public Button LoadSetButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(loadSetButtonId)));
            }
        }
        public Button LoadButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(loadButtonId)));
            }
        }
        public Button TuneButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(tuneButtonId)));
            }
        }
        public Button AbortButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(abortButtonId)));
            }
        }
        public ButtonDropdown FactoryDefaultsDropdown
        {
            get
            {
                return new ButtonDropdown(parent.Driver.FindElement(By.Id(factoryDefaultsBtnId)))
                {
                    Label = "Factory Parameters"
                };
            }
        }
        public Button FactoryDefaultsLoadButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(factoryDefaultsLoadBtnId)));
            }
        }
        public Button FactoryDefaultsSaveButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(factoryDefaultsSaveBtnId)));
            }
        }
        public Button FactoryDefaultsResettoDefaultButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(factoryDefaultsResettoDefaultBtnId)));
            }
        }
        public Button FactoryDefaultsResettoFactoryButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(factoryDefaultsResettoFactoryBtnId)));
            }
        }


        public ButtonDropdown AcquisitionDropdown
        {
            get
            {
                return new ButtonDropdown(parent.Driver.FindElement(By.Id(acquisitionComboboxId)))
                {
                    Label = "Acquisition"
                };
            }
        }
        public InstrumentControlWidget ControlsWidget
        {
            get
            {
                return new InstrumentControlWidget();
            }
        }
        public Button MZButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(mzButtonId)));
            }
        }
        public Button DTButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(dtButtonId)));
            }
        }
        public Button BPIButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(bpiButtonId)));
            }
        }
        public Button TICButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(ticButtonId)));
            }
        }
        //public Button RBButton
        //{
        //    get
        //    {
        //        return new Button(parent.Driver.FindElement(By.Id(rbButtonId)));
        //    }
        //}
        //public Button PPButton
        //{
        //    get
        //    {
        //        return new Button(parent.Driver.FindElement(By.Id(ppButtonId)));
        //    }
        //}
        public Button ClearButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(clearButtonId)));
            }
        }

        public Dropdown FunctionList
        {
            get
            {
                return new Dropdown(parent.Driver.FindElement(By.Id(functionsListId)))
                {
                    Label = "FunctionsList"
                };
            }
        }

        public Button NormalizeButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(normalizeButtonId)));
            }
        }
        public Button PositiveModeButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(positiveModeButtonId)));
            }
        }
        public Button NegativeModeButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(negativeModeButtonId)));
            }
        }
        public Button ResolutionButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(resolutionButtonId)));
            }
        }
        public Button SensitivityButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(sensitivityButtonId)));
            }
        }

        public Button TOFButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(tofModeButtonId)));
            }
        }

        public Button MobilityButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(mobilityModeButtonId)));
            }
        }

        public Button APIGasButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(APIGasButtonId)));
            }
        }
        public Button CollisionGasButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(collisionGasButtonId)));
            }
        }

        public ButtonDropdown GasControlDropdown
        {
            get
            {
                return new ButtonDropdown(parent.Driver.FindElement(By.Id(gasControlDropdownId)))
                {
                    Label = "Gas Control"
                };
            }
        }

        public Dropdown FrequencyModeDropdown
        {
            get
            {
                return new Dropdown(parent.Driver.FindElement(By.Id(frequencyModeDropdownId)))
                {
                    Label = "Frequency Mode"
                };
            }
        }

        public Dropdown ScanTimeDropdown
        {
            get
            {
                return new Dropdown(parent.Driver.FindElement(By.Id(scanTimeDropdownId)))
                {
                    Label = "Scan Time"
                };
            }
        }

        public Button StandByButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(standbyButtonId)));
            }
        }
        public Button OperateButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(operateButtonId)));
            }
        }
        public Button SourceButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(sourceButtonId)));
            }
        }
        public IWebElement InstrumentPowerIndicator
        {
            get
            {
                return parent.Driver.FindElement(By.Id(powerLedId));
            }
        }

        #endregion Controls
    }
}