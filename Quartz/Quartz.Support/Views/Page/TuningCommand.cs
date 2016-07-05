using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.Typhoon.Lib;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.Modals;
using TechTalk.SpecFlow;

namespace Quartz.Support.Views.Page
{
    public class TuningCommand
    {
        private readonly TunePage _tunePage;
        private int _numberOfScreenShots;
        private int _intervalInSeconds;
        private bool _includeScreenShots;
        private IAcquisitionData _acquisitionData;
        private IAcquisitionSystem _acquisitionSystem;

        public TuningCommand(TunePage tunePage)
        {
            _tunePage = tunePage;
            _acquisitionData = AcquistionFactory.Instance.AcquisitionData;
            _acquisitionSystem = AcquistionFactory.Instance.AcquisitionSystem;
        }

        public TuningCommand WithScreenShots(int numberOfScreenShots, int intervalInSeconds)
        {
            _numberOfScreenShots = numberOfScreenShots;
            _intervalInSeconds = intervalInSeconds;
            _includeScreenShots = true;

            return this;
        }

        public void AbortTuning()
        {
            _tunePage.Controls.AbortButton.Click();

            if (_includeScreenShots)
            {
                TakeScreenShots();    
            }

            _acquisitionSystem.StopCapturingScans();                  
        }

        public void StartTuning(bool captureScanData = false)
        {
            _tunePage.Controls.TuneButton.Click();

            if (_includeScreenShots)
            {
                TakeScreenShots();    
            }

            if (captureScanData)
            {
                _acquisitionSystem.StartCapturingScans();
            }
        }

        public void StartRecording()
        {
            Report.Action("Start recording an acquisition");
            _tunePage.Controls.StartButton.Click();

            if (_includeScreenShots)
            {
                TakeScreenShots();
            }
        }

        public void StopRecording(int timeDelayInMilliseconds = 0)
        {
            Wait.ForMilliseconds(timeDelayInMilliseconds);

            Report.Action("Stop recording an acquisition");
            _tunePage.Controls.StopButton.Click();

            if (_includeScreenShots)
            {
                TakeScreenShots();
            }
        }

        private void TakeScreenShots()
        {
            Report.Screenshot();
            for (int i = 0; i < _numberOfScreenShots; i++)
            {
                Report.Action(string.Format("Wait {0} second(s) - Take Screenshot", _intervalInSeconds));
                Report.Screenshot();
                Wait.ForMilliseconds(TimeSpan.FromSeconds(_intervalInSeconds).Milliseconds);
            }
        }

        public void CreateAcquisition(string acquisitionMethodType, string lockMassType)
        {
            _tunePage.Controls.AcquisitionDropdown.SelectDropdownOption("Create");

            if (CreateAcquisitionModal.Exists)
            {
                string uniqueAcquisitionName = GenerateUniqueAcquisitionName();

                CreateAcquisitionModal.Filename.SetText(uniqueAcquisitionName, continueOnFail: true);
                ScenarioContext.Current.Set<string>(CreateAcquisitionModal.Filename.Text, "AcquisitionDataName");

                CreateAcquisitionModal.Description.SetText(GenerateUniqueAcquisitionDescription(acquisitionMethodType, uniqueAcquisitionName, lockMassType), continueOnFail: true);
                CreateAcquisitionModal.AcquisitionSettings.Type.SelectOptionFromDropDown(acquisitionMethodType);

                string runDuration = TimeSpan.FromMinutes(0.30).TotalSeconds.ToString();
                ScenarioContext.Current.Set<string>(runDuration, "RunDuration");
                CreateAcquisitionModal.AcquisitionSettings.RunDuration.SetText(runDuration);          // Refactor maybe a bit too complex
                CreateAcquisitionModal.MassMeasurement.SetLockMass(lockMassType);
                CreateAcquisitionModal.SaveAcquisition();
            }
        }

        private string GenerateUniqueAcquisitionDescription(string methodType, string testFileName, string lockMassType)
        {
            return string.Format("Create an {0} acquisition with lock mass type '{1}' called {2} @ {3}", methodType, lockMassType, testFileName, DateTime.UtcNow.ToString("dd/MM/yyyy"));
        }

        public string GenerateUniqueAcquisitionName()
        {
            return string.Format("Test_{0}", DateTime.UtcNow.ToString("MMddyyyy mHs tt"));
        }

        public void RecordAcquisition()
        {
            _tunePage.Controls.AcquisitionDropdown.SelectDropdownOption("Record");

            if (RecordAcquisitionModal.Exists)
            {
                string acquisitionDataName = ScenarioContext.Current.Get<string>("AcquisitionDataName");
                RecordAcquisitionModal.RunMethodList.SelectOptionFromDropDown(acquisitionDataName, continueOnFail: true);
                RecordAcquisitionModal.AcquisitionDataName.SetText(acquisitionDataName);
                RecordAcquisitionModal.StartRecordingAcquisition();
            }
        }

        public void RecordAndSaveAcquisition(int milliseconds, string fileName = null)
        {
            StartRecording();
            Wait.ForMilliseconds(milliseconds);
            StopRecording();

            SaveAcquisitionData(fileName);           
        }

        public void SaveAcquisitionData(string fileName = null)
        {
            RecordDataModal.WaitForOpen();

            if (string.IsNullOrEmpty(fileName))
            {
                RecordDataModal.FileName.SetText(TunePage.Tuning.GenerateUniqueAcquisitionName());
            }
            else
            {
                RecordDataModal.FileName.SetText(fileName);
            }

            var name = RecordDataModal.FileName.Text;
            Report.Action(string.Format("Saving Acquisition '{0}'", name));

            ScenarioContext.Current.Set<string>(name, "AcquisitionDataName");
            RecordDataModal.SaveButton.Click();
        }

        public void CheckFunctionsListIsEnabledOrDisabled(string expectedState)
        {
            Wait.ForMilliseconds(2000);
            _tunePage.Controls.FunctionList.CheckEnabledState(expectedState, continueOnFail: true);
        }

        public void CheckFunctionListIsSelectable()
        {
            bool doesFunctionsListContainsMoreThanOneFunction = _tunePage.Controls.FunctionList.Options.Count > 1 ? true : false;
            Check.IsTrue(doesFunctionsListContainsMoreThanOneFunction, "More than one function exists and is enabled so the Functions List is selectable", continueOnFail: true);
        }
        
        public void CheckRawDataFileHasBeenCreated()
        {
            WaitForAcquisitionToFinishRecording();

            string rawDataFileName = string.Concat(ScenarioContext.Current.Get<string>("AcquisitionDataName"), ".raw");
            string rawDataFilePath = string.Format(@"{0}\{1}", TyphoonHelper.TyphoonDataStoreLocation, rawDataFileName);           
            Check.IsTrue(Directory.Exists(rawDataFilePath), string.Format("A folder does exist in: {0} with the filename: {1}", rawDataFilePath, rawDataFileName), continueOnFail: true);
        }

        public string GetPolynomials(string rawFileName)
        {
            string rawFileLocation = string.Concat(TyphoonHelper.TyphoonDataStoreLocation, rawFileName, ".raw");
            string headerFileLocation = rawFileLocation + "\\_header.txt";

            Wait.Until(f => Directory.Exists(rawFileLocation), 4000, "Waiting for RAW file to be created");
            Wait.Until(f => File.Exists(headerFileLocation), 4000, "Waiting for _header.txt file to be created");

            var streamReader = File.OpenText(headerFileLocation);
            var content = streamReader.ReadToEnd();

            var index = content.LastIndexOf("$$ Cal Function 1:");
            string polynamialData = content.Substring(index).ToString().Replace("$$ Cal Function 1:", "").Trim();

            return polynamialData;
        }

        public void WaitForAcquisitionToFinishRecording()
        {
            string runDuration = ScenarioContext.Current.Get<string>("RunDuration");
            int timeToWaitInMilliSeconds = Convert.ToInt32(TimeSpan.FromSeconds(Double.Parse(runDuration)).TotalMilliseconds);
            const int extraTimeToWaitInMilliSeconds = 10000;

            Wait.Until(f => _tunePage.Controls.StopButton.Enabled == false && _tunePage.Controls.StartButton.Enabled, timeToWaitInMilliSeconds + extraTimeToWaitInMilliSeconds, "Waiting for acquisition to stop...");
            Check.IsFalse(_tunePage.Controls.StopButton.Enabled, "Acquisition has stopped");
        }

        private void CheckCorrectNumberOfFunctionsAreCreated(string numberOfFunctionsToExpect, string rawDataFilePath)
        {
            CheckCorrectNumberOfFunctionAreCreatedByCheckingNumberOfFunctionDataFiles(numberOfFunctionsToExpect, rawDataFilePath);
        }

        private void CheckCorrectNumberOfFunctionAreCreatedByCheckingNumberOfFunctionDataFiles(string numberOfFunctionsToExpect, string rawDataFilePath)
        {
            IEnumerable<FileInfo> datFiles = GetAllDATFiles(rawDataFilePath);

            int functionNumber = GetFunctionNumberFromAmountOfDATFilesInRawFolder(datFiles);

            Check.AreEqual(int.Parse(numberOfFunctionsToExpect), functionNumber, "The number of functions is correct", continueOnFail: true);
        }

        private IEnumerable<FileInfo> GetAllDATFiles(string rawDataFilePath)
        {
            IEnumerable<FileInfo> datFiles = new DirectoryInfo(rawDataFilePath)
                .EnumerateFiles("*.dat", SearchOption.TopDirectoryOnly);
            return datFiles;
        }

        private int GetFunctionNumberFromAmountOfDATFilesInRawFolder(IEnumerable<FileInfo> datFiles)
        {
            int functionNumber = datFiles
                .OrderByDescending(f => f.Name)
                .Select(n => new
                {
                    FunctionNumber = int.Parse(n.Name.Replace("_func", string.Empty).Replace(".dat", string.Empty))
                }).FirstOrDefault().FunctionNumber;

            return functionNumber;
        }

        public void CheckSpecifiedFileTypeExistsInRawDataFolder(string fileType, string isFilePresentInFolder)
        {
            bool checkIfFileExistsInRawFolder = Boolean.Parse(isFilePresentInFolder);
            bool doesFileTypeExist = IsSpecifiedFileTypeInFolder(fileType);

            if (checkIfFileExistsInRawFolder)
            {
                Check.IsTrue(doesFileTypeExist, string.Format("The {0} exists in the raw folder", fileType), continueOnFail: true);
            }
            else
            {
                Check.IsFalse(doesFileTypeExist, string.Format("The {0} does not exist in the raw folder", fileType), continueOnFail: true);
            }
        }

        private static bool IsSpecifiedFileTypeInFolder(string fileType)
        {
            DirectoryInfo directoryInfo = new DirectoryInfo(TunePage.GetRawDataFilePath());
            bool doesFileTypeExist = directoryInfo.GetFiles(string.Format("*.{0}", fileType), SearchOption.TopDirectoryOnly).Length > 0;
            return doesFileTypeExist;
        }

        public void CheckSizeOfAllRawDataFilesGreaterThanZero()
        {
            DirectoryInfo directoryInfo = new DirectoryInfo(TunePage.GetRawDataFilePath());

            IEnumerable<FileInfo> acquisitionfiles = directoryInfo.EnumerateFiles();
            foreach (var acquisitionfile in acquisitionfiles)
            {
                bool fileSizeIsGreaterThanZero = acquisitionfile.Length > 0;
                Check.IsTrue(fileSizeIsGreaterThanZero, string.Format("The file size of {0} is greater than zero.", acquisitionfile.Name), continueOnFail: true);
            }
        }

        public void SaveRecordedData()
        {
            RecordDataModal.WaitForOpen();

            string uniqueAcquisitionName = GenerateUniqueAcquisitionName();
            RecordDataModal.FileName.SetText(uniqueAcquisitionName, continueOnFail: true);
            ScenarioContext.Current.Set<string>(RecordDataModal.FileName.Text, "AcquisitionDataName");
            RecordDataModal.Save();

            RecordDataModal.WaitForClose();
        }
    }
}