using System;
using System.IO;
using System.Linq;
using System.Reflection;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.Typhoon.Lib;
using Automation.WebFramework.Lib;
using Quartz.Support.Configuration;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.Modals;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.Acquisition.StepDefinitions
{
    [Binding]
    public class AcquisitionRecordSteps
    {
        private readonly TunePage _tunePage;
        private ITestConfiguration testConfiguration;     
		private IAcquisitionData _acquisitionData;
        private IAcquisitionSystem _acquisitionSystem;

		const string MOBILITY_FILE_TYPE_IND = "IND";
        const string MOBILITY_FILE_TYPE_CDT = "CDT";
        
		public AcquisitionRecordSteps(TunePage tunePage)
        {
            _tunePage = tunePage;
            _acquisitionData = AcquistionFactory.Instance.AcquisitionData;
            _acquisitionSystem = AcquistionFactory.Instance.AcquisitionSystem;
            testConfiguration = new TestConfiguration(new AppSettingsConfigurationManager());
        }

        private void ValidateInput(string inputString)
        {
            if (string.IsNullOrEmpty(inputString))
            {
                Report.Fail(string.Format("The {0} parameter must have a value", inputString));
            }
        }
        [When(@"an Acquisition Method Type is created and Saved with a unique name using the '(.*)' custom xml file")]
        public void WhenAnAcquisitionMethodTypeIsCreatedAndSavedWithAUniqueNameUsingTheCustomXmlFile(string methodXMLPath)
        {
            ValidateInput(methodXMLPath);
            _tunePage.SelectTuningMethod(methodXMLPath, testConfiguration.InstrumentMethodDirectory);
        }

        [When(@"this Method is run using Acquisition '(.*)'")]
        public void WhenThisMethodIsRunUsingAcquisition(string record)
        {
            ValidateInput(record);
            _acquisitionSystem.StartCapturingScans();                       
            TunePage.Tuning.StartRecording();

            TimeSpan runDuration = TimeSpan.FromSeconds(30);
            ScenarioContext.Current.Set<string>(runDuration.TotalSeconds.ToString(), "RunDuration");

            TunePage.Tuning.StopRecording(Convert.ToInt32(runDuration.TotalMilliseconds));

            TunePage.Tuning.SaveRecordedData();
        }

        [Then(@"the Functions list is (.*) in the plot toolbar")]
        public void ThenTheFalseInThePlotToolbar(string expectedState)
        {
            ValidateInput(expectedState);
            TunePage.Tuning.CheckFunctionsListIsEnabledOrDisabled(expectedState);
        }

        [Then(@"the Main Sample Data is Selectable (.*) for real time viewing in the MZ plot window")]
        public void ThenTheMainSampleDataIsSelectableFalseForRealTimeViewingInTheMZPlotWindow(string sampleData)
        {
            ValidateInput(sampleData);

            if (sampleData == "false")
            {
                TunePage.Tuning.CheckFunctionsListIsEnabledOrDisabled("Disabled");
            }
            else if (sampleData == "true")
            {
                //TODO: Rather than check the function list has functions abailable, it should select them and check the plot
                TunePage.Tuning.CheckFunctionListIsSelectable();
            }
        }

        [Then(@"the Lock Mass is Selectable (.*) for real time viewing in the MZ plot window")]
        public void ThenTheLockMassIsSelectableFalseForRealTimeViewingInTheMZPlotWindow(string sampleData)
        {
            ValidateInput(sampleData);

            Dropdown functionList = _tunePage.Controls.FunctionList;
            var lastFunction = functionList.Options.Last().Text.Split(':').Last().Trim();
            if (sampleData == "false")
            {
                if (functionList.Enabled)
                {
                    Check.IsTrue(lastFunction != "MS", "The last function is not MS");
                }
                else
                {
                    Check.IsFalse(functionList.Enabled, "The Function list is disabled, lockmass is not selectable");
                }
            }
            else if (sampleData == "true")
            {
                Check.IsTrue(lastFunction == "MS", "The last function is MS");
            }
        }

        [Then(@"a \.RAW subfolder with the Method name will be created")]
         public void ThenA_RAWSubfolderWithTheMethodNameWillBeCreated()
        {
            TunePage.Tuning.CheckRawDataFileHasBeenCreated();
        }


        [Then(@"the \.RAW subfolder will contain a '(.*)' file")]
        public void ThenThe_RAWSubfolderWillContainAFile(string rawSubFile)
        {
            ValidateInput(rawSubFile);
            string rawDataFilePath = TunePage.GetRawDataFilePath();
            bool rawSubFileExists = File.Exists(string.Format(@"{0}\{1}", rawDataFilePath, rawSubFile));
            Check.IsTrue(rawSubFileExists, string.Format("The external information file: {0} does exist", rawSubFile), continueOnFail: true);
        }

        [Then(@"the \.RAW subfolder will contain a '(.*)' file (.*) for each main Sample data Function")]
        public void ThenThe_RAWSubfolderWillContainAForEachMainSampleDataFunction(string fileType, string isFilePresentInFolder)
        {
            ValidateInput(fileType);
            ValidateInput(isFilePresentInFolder);
            TunePage.Tuning.CheckSpecifiedFileTypeExistsInRawDataFolder(fileType, isFilePresentInFolder);
        }
        [Then(@"the \.RAW subfolder will contain Mobility files (.*)")]
        public void ThenThe_RAWSubfolderWillContainMobilityFiles(string isFilePresentInFolder)
        {
            if (bool.TrueString.ToLowerInvariant() == isFilePresentInFolder.ToLowerInvariant())
            {
                ValidateInput(isFilePresentInFolder);
                ValidateInput(isFilePresentInFolder);
                TunePage.Tuning.CheckSpecifiedFileTypeExistsInRawDataFolder(MOBILITY_FILE_TYPE_IND, isFilePresentInFolder);
                TunePage.Tuning.CheckSpecifiedFileTypeExistsInRawDataFolder(MOBILITY_FILE_TYPE_CDT, isFilePresentInFolder);
            }
        }
        [Then(@"all \.RAW subfolder files generated are non-zero in size")]
        public void ThenAll_RAWSubfolderFilesGeneratedAreNon_ZeroInSize()
        {
            TunePage.Tuning.CheckSizeOfAllRawDataFilesGreaterThanZero();
        }


        [Given(@"a new Acquisition Method '(.*)' is created")]
        [Given(@"a new Acquisition Method '(.*)' is created using Acquisition Create")]
        public void GivenANewAcquisitionMethodIsCreated(string methodType)
        {
            _tunePage.Controls.AcquisitionDropdown.SelectDropdownOption("Create");

            Wait.Until(m => CreateAcquisitionModal.Exists, 5000, "Waiting for Create Acquisition Modal to be displayed...");

            CreateAcquisitionModal.Filename.SetText(TunePage.Tuning.GenerateUniqueAcquisitionName(), continueOnFail: true);
            ScenarioContext.Current.Set<string>(CreateAcquisitionModal.Filename.Text, "AcquisitionDataName");

            CreateAcquisitionModal.Description.SetText(ScenarioContext.Current.ScenarioInfo.Title, continueOnFail: true);

            CreateAcquisitionModal.AcquisitionSettings.Type.SelectOptionFromDropDown(methodType);
        }


        [Given(@"the Method is Saved")]
        public void GivenTheMethodIsSaved()
        {
            CreateAcquisitionModal.SaveAcquisition();
        }


        [Given(@"the method has a short Run Duration with Low Mass (.*), High Mass (.*), Lock Mass 1 (.*) and Lock Mass 2 (.*) parameters set")]
        public void GivenTheMethodHasAShortRunDurationWithLowMassHighMassLockMass1AndLockMass2ParametersSet(string lowMass, string highMass, string lockMass1, string lockMass2)
        {
            const string runDurationInMinutes = "0.15";
            CreateAcquisitionModal.AcquisitionSettings.RunDuration.SetText(runDurationInMinutes);
            ScenarioContext.Current.Set<string>(runDurationInMinutes, "RunDuration");

            CreateAcquisitionModal.AcquisitionSettings.HighMass.SetText(highMass);
            CreateAcquisitionModal.AcquisitionSettings.LowMass.SetText(lowMass);

            if (lockMass1 != "N/A" && lockMass2 != "N/A")
            {
                CreateAcquisitionModal.MassMeasurement.LockMass.SelectCheckBox();
                CreateAcquisitionModal.MassMeasurement.LockMass1.SetText(lockMass1);

                if (lockMass2 != "N/A")
                {
                    CreateAcquisitionModal.MassMeasurement.DualLockMass.SelectCheckBox();
                    CreateAcquisitionModal.MassMeasurement.LockMass2.SetText(lockMass2);
                }
            }
        }


        [When(@"the acquisition runs to completion")]
        public void WhenTheAcquisitionRunsToCompletion()
        {
            TunePage.Tuning.WaitForAcquisitionToFinishRecording();
        }


        [StepDefinition(@"during the method run an acquisition is '(.*)'")]
        [StepDefinition(@"the acquisition is '(.*)'")]
        public void GivenTheAcquisitionIsStopped(string action)
        {
            if (action == "Stopped")
            {
                TunePage.Tuning.StopRecording();
                TunePage.Tuning.SaveAcquisitionData();
            }
            else if (action == "Started")
            {
                TunePage.Tuning.StartRecording();
            }
            else
            {
                Report.Fail(string.Format("'{0}' action not implemented", action));
            }
        }


        [StepDefinition(@"the acquisition is Stopped after '(.*)' seconds")]
        public void GivenTheAcquisitionIsStopped(int seconds)
        {
            TunePage.Tuning.StopRecording(seconds * 1000);
            TunePage.Tuning.SaveAcquisitionData();
        }


        [StepDefinition(@"the '(.*)' is selected to be run via Acquisition \| Custom Tune XML")]
        [StepDefinition(@"'(.*)' is selected to be run via Acquisition \| Custom Tune XML")]
        [StepDefinition(@"a new '(.*)' is selected to be run via Acquisition \| Custom Tune XML")]
        public void GivenANewIsSelectedToBeRunViaAcquisitionCustomTuneXML(string method)
        {
            _tunePage.SelectTuningMethod(method);
        }

        [When(@"I try to run '(.*)' method via Acquisition \| Custom Tune XML")]
        public void WhenITryToRunMethodViaAcquisitionCustomTuneXML(string method)
        {
            _tunePage.SelectTuningMethod(method, null, false);
            _acquisitionSystem.StartCapturingScans();
        }

        [Then(@"no scan data is received")]
        public void ThenNoScanDataIsReceived()
        {
            _acquisitionSystem.WaitForMethodToComplete();
            Check.IsTrue(_acquisitionData.CurrentAcquiredData.Scans.Count == 0, "No scan data was received");
            _acquisitionSystem.StopCapturingScans();    
        }

        [Given(@"a new Acquisition Method '(.*)' XML file is created called '(.*)'")]
        public void GivenANewAcquisitionMethodXMLFileIsCreatedCalled(string methodType, string xmlFileName)
        {
            string methodPath = CreateMethodXml(xmlFileName);

            MethodCreatorHelper methodCreator = new MethodCreatorHelper(methodPath);
            methodCreator.SetFunctionType(methodType);

            if (methodType.StartsWith("HD"))
                methodCreator.SetMobilityMode();
        }


        [Given(@"the XML file (.*) method has a short Run Duration with Low Mass (.*), High Mass (.*), Lock Mass 1 (.*) and Lock Mass 2 (.*) parameters set")]
        public void GivenTheXMLFileMethodHasAShortRunDurationWithLowMassHighMassLockMassNAAndLockMassNAParametersSet(string xmlFileName, string lowMass, string highMass, string lockMass1, string lockMass2)
        {
            string methodPath = TyphoonHelper.MethodsDirectory + "\\" + xmlFileName;

            MethodCreatorHelper methodCreator = new MethodCreatorHelper(methodPath);

            methodCreator.SetFunctionDuration("20.0");
            methodCreator.AddFunctionSetting("EndMass", highMass);
            methodCreator.AddFunctionSetting("StartMass", lowMass);

            if (lockMass1 != "N/A")
                methodCreator.AddLockMassSetting("LockMass", lockMass1);

            if (lockMass2 != "N/A")
                methodCreator.AddLockMassSetting("LockMass", lockMass2);

        }

        [Given(@"a new '(.*)' XML file is manually created and saved with the following functions")]
        public void GivenANewXMLFileIsManuallyCreatedAndSavedWithTheFollowingFunctions(string xmlFileName, TechTalk.SpecFlow.Table table)
        {
            string methodPath = CreateMethodXml(xmlFileName);

            MethodCreatorHelper methodCreator = new MethodCreatorHelper(methodPath);

            int functionCount = 1;
            foreach (var function in table.Rows)
            {
                string type = function["Type"];
                string lockMass1 = function["LockMass 1"];
                string lockMass2 = function["LockMass 2"];
                string startMass = function["StartMass"];
                string endMass = function["EndMass"];
                string setMass = null;

                if (table.Header.Contains("SetMass"))
                {
                    setMass = function["SetMass"];
                }

                if (type != "LockMass")
                {
                    if (functionCount > 1) // 1 Function exists by default so only add a new function if function count > 1
                        methodCreator.AddFunction(type, "20.0");
                    else
                        methodCreator.SetFunctionType(type, functionCount);
                }

                if (lockMass1 != "N/A")
                    methodCreator.AddLockMassSetting("LockMass", lockMass1);

                if (lockMass2 != "N/A")
                    methodCreator.AddLockMassSetting("LockMass", lockMass2);

                if (startMass != "N/A")
                    methodCreator.AddFunctionSetting("StartMass", startMass, functionCount);

                if (endMass != "N/A")
                    methodCreator.AddFunctionSetting("EndMass", endMass, functionCount);

                if (setMass != null)
                {
                    if (setMass != "N/A")
                        methodCreator.AddFunctionSetting("SetMass", setMass, functionCount);
                }

                functionCount++;
            }
        }


        #region Helper Methods

        private static string CreateMethodXml(string xmlFileName)
        {
            // Copy xml file to the method directory
            string methodPath = TyphoonHelper.MethodsDirectory + "\\" + xmlFileName;
            string xmlDataPath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), @"Data\MethodTemplate.xml");
            File.Copy(xmlDataPath, methodPath, true);

            return methodPath;
        }

        #endregion Helper Methods

    }
}
