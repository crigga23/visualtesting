﻿// ------------------------------------------------------------------------------
//  <auto-generated>
//      This code was generated by SpecFlow (http://www.specflow.org/).
//      SpecFlow Version:1.9.0.77
//      SpecFlow Generator Version:1.9.0.0
//      Runtime Version:4.0.30319.18444
// 
//      Changes to this file may cause incorrect behavior and will be lost if
//      the code is regenerated.
//  </auto-generated>
// ------------------------------------------------------------------------------
#region Designer generated code
#pragma warning disable
namespace Quartz.Features.InstrumentSetup.FeatureFiles
{
    using TechTalk.SpecFlow;
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("TechTalk.SpecFlow", "1.9.0.77")]
    [System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [Microsoft.VisualStudio.TestTools.UnitTesting.TestClassAttribute()]
    public partial class CAL_QRZ_InstrumentSetupCalibration_ButtonsAndProgressGUIFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI.feature"
#line hidden
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassInitializeAttribute()]
        public static void FeatureSetup(Microsoft.VisualStudio.TestTools.UnitTesting.TestContext testContext)
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI", @"In order to change initial Instrument Setup settings, control and monitor overall progress
I want to be able to toggle slot buttons, click Start / Cancel and view progress via a bar / messages
So that I can control the overall slots calibrated and interview if progress is not successful", ProgrammingLanguage.CSharp, new string[] {
                        "InstrumentSetup"});
            testRunner.OnFeatureStart(featureInfo);
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassCleanupAttribute()]
        public static void FeatureTearDown()
        {
            testRunner.OnFeatureEnd();
            testRunner = null;
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestInitializeAttribute()]
        public virtual void TestInitialize()
        {
            if (((TechTalk.SpecFlow.FeatureContext.Current != null) 
                        && (TechTalk.SpecFlow.FeatureContext.Current.FeatureInfo.Title != "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")))
            {
                Quartz.Features.InstrumentSetup.FeatureFiles.CAL_QRZ_InstrumentSetupCalibration_ButtonsAndProgressGUIFeature.FeatureSetup(null);
            }
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCleanupAttribute()]
        public virtual void ScenarioTearDown()
        {
            testRunner.OnScenarioEnd();
        }
        
        public virtual void ScenarioSetup(TechTalk.SpecFlow.ScenarioInfo scenarioInfo)
        {
            testRunner.OnScenarioStart(scenarioInfo);
        }
        
        public virtual void ScenarioCleanup()
        {
            testRunner.CollectScenarioErrors();
        }
        
        public virtual void FeatureBackground()
        {
#line 53
#line 62
testRunner.Given("the Instrument Setup page is accessed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 63
 testRunner.And("the Instrument Setup process is not running", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-01 - InstrumentSetupGUIandCalibration - Basic GUI Elements and States")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        public virtual void CAL_01_InstrumentSetupGUIandCalibration_BasicGUIElementsAndStates()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("CAL-01 - InstrumentSetupGUIandCalibration - Basic GUI Elements and States", ((string[])(null)));
#line 67
this.ScenarioSetup(scenarioInfo);
#line 53
this.FeatureBackground();
#line 68
 testRunner.Given("that the Instrument Setup process has not been run", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Button",
                        "Expected State"});
            table1.AddRow(new string[] {
                        "Run",
                        "Enabled"});
            table1.AddRow(new string[] {
                        "Cancel",
                        "Disabled"});
            table1.AddRow(new string[] {
                        "Select None",
                        "Enabled"});
#line 69
 testRunner.Then("the following Instrument Setup buttons are in the expected state", ((string)(null)), table1, "Then ");
#line 74
  testRunner.And("all slots are in the correct selected state", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 75
  testRunner.And("the progress message should be \'Last update performed : Never been run!\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        public virtual void CAL_02_InstrumentSetupGUIandCalibration_ButtonsStatus(string instrumentSetupState, string slots, string runButtonState, string cancelButtonState, string[] exampleTags)
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("CAL-02 - InstrumentSetupGUIandCalibration - Buttons Status", exampleTags);
#line 78
this.ScenarioSetup(scenarioInfo);
#line 53
this.FeatureBackground();
#line 79
 testRunner.Given("all slots are in a \'Not Run\' status", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 80
  testRunner.And(string.Format("\'{0}\' ADC setup slots are selected and run", slots), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 81
  testRunner.And(string.Format("an instrument state of {0}", instrumentSetupState), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 82
 testRunner.Then(string.Format("the Instrument Setup \'Run\' button should be \'{0}\'", runButtonState), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 83
  testRunner.And(string.Format("the Instrument Setup \'Cancel\' button should be \'{0}\'", cancelButtonState), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-02 - InstrumentSetupGUIandCalibration - Buttons Status")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("ExampleSetName", "States")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "Running")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Instrument Setup State", "Running")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Slots", "1")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Run Button State", "Disabled")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Cancel Button State", "Enabled")]
        public virtual void CAL_02_InstrumentSetupGUIandCalibration_ButtonsStatus_States_Running()
        {
            this.CAL_02_InstrumentSetupGUIandCalibration_ButtonsStatus("Running", "1", "Disabled", "Enabled", ((string[])(null)));
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-02 - InstrumentSetupGUIandCalibration - Buttons Status")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("ExampleSetName", "States")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "Aborted")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Instrument Setup State", "Aborted")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Slots", "1")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Run Button State", "Enabled")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Cancel Button State", "Disabled")]
        public virtual void CAL_02_InstrumentSetupGUIandCalibration_ButtonsStatus_States_Aborted()
        {
            this.CAL_02_InstrumentSetupGUIandCalibration_ButtonsStatus("Aborted", "1", "Enabled", "Disabled", ((string[])(null)));
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-02 - InstrumentSetupGUIandCalibration - Buttons Status")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("ExampleSetName", "States")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "Completed")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Instrument Setup State", "Completed")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Slots", "1")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Run Button State", "Enabled")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Cancel Button State", "Disabled")]
        public virtual void CAL_02_InstrumentSetupGUIandCalibration_ButtonsStatus_States_Completed()
        {
            this.CAL_02_InstrumentSetupGUIandCalibration_ButtonsStatus("Completed", "1", "Enabled", "Disabled", ((string[])(null)));
        }
        
        public virtual void CAL_03_InstrumentSetupGUIandCalibration_ProgressBarAndMessages(string instrumentSetupState, string slots, string progressBar, string progressMessage, string issueMessage, string[] exampleTags)
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("CAL-03 - InstrumentSetupGUIandCalibration - Progress Bar and Messages", exampleTags);
#line 91
this.ScenarioSetup(scenarioInfo);
#line 53
this.FeatureBackground();
#line 92
 testRunner.Given("all slots are in a \'Not Run\' status", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 93
  testRunner.And(string.Format("\'{0}\' ADC setup slots are selected and run", slots), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 94
  testRunner.And(string.Format("an instrument state of {0}", instrumentSetupState), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 95
 testRunner.Then(string.Format("the progress bar should be {0}", progressBar), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 96
  testRunner.And(string.Format("the progress message will be {0}", progressMessage), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 97
  testRunner.And(string.Format("the issue message will be {0}", issueMessage), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-03 - InstrumentSetupGUIandCalibration - Progress Bar and Messages")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "Running")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Instrument Setup State", "Running")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Slots", "2")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Bar", "Progressing left to right")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Message", "Running selected tests, x% complete")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Issue Message", "na")]
        public virtual void CAL_03_InstrumentSetupGUIandCalibration_ProgressBarAndMessages_Running()
        {
            this.CAL_03_InstrumentSetupGUIandCalibration_ProgressBarAndMessages("Running", "2", "Progressing left to right", "Running selected tests, x% complete", "na", ((string[])(null)));
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-03 - InstrumentSetupGUIandCalibration - Progress Bar and Messages")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "Aborted")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Instrument Setup State", "Aborted")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Slots", "1")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Bar", "Progress frozen at Aborted state")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Message", "Running selected tests,  100% complete")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Issue Message", "Last update performed : ddd-MMM-dd-yyyy - ADC Setup aborted")]
        public virtual void CAL_03_InstrumentSetupGUIandCalibration_ProgressBarAndMessages_Aborted()
        {
            this.CAL_03_InstrumentSetupGUIandCalibration_ProgressBarAndMessages("Aborted", "1", "Progress frozen at Aborted state", "Running selected tests,  100% complete", "Last update performed : ddd-MMM-dd-yyyy - ADC Setup aborted", ((string[])(null)));
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-03 - InstrumentSetupGUIandCalibration - Progress Bar and Messages")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "Completed")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Instrument Setup State", "Completed")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Slots", "1")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Bar", "Full")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Message", "Running selected tests,  100% complete")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Issue Message", "Last update performed : ddd-MMM-dd-yyyy - Instrument Setup Complete")]
        public virtual void CAL_03_InstrumentSetupGUIandCalibration_ProgressBarAndMessages_Completed()
        {
            this.CAL_03_InstrumentSetupGUIandCalibration_ProgressBarAndMessages("Completed", "1", "Full", "Running selected tests,  100% complete", "Last update performed : ddd-MMM-dd-yyyy - Instrument Setup Complete", ((string[])(null)));
        }
        
        public virtual void CAL_04_InstrumentSetupGUIandCalibration_ProgressBarAndMassCalibrationFailureMessages(string slots, string progressBar, string progressMessage, string issueMessage, string[] exampleTags)
        {
            string[] @__tags = new string[] {
                    "cleanup-xml"};
            if ((exampleTags != null))
            {
                @__tags = System.Linq.Enumerable.ToArray(System.Linq.Enumerable.Concat(@__tags, exampleTags));
            }
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("CAL-04 - InstrumentSetupGUIandCalibration - Progress Bar and Mass Calibration Fai" +
                    "lure Messages", @__tags);
#line 106
this.ScenarioSetup(scenarioInfo);
#line 53
this.FeatureBackground();
#line 107
 testRunner.Given("ADC Setup, Instrument Setup Detector Setup and Resolution Optimisation has been r" +
                    "un for all modes", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 108
  testRunner.And("calibration acceptance criteria has been modified to simulate a failure", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 109
  testRunner.And(string.Format("\'{0}\' mass calibration slots are selected and run", slots), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 110
  testRunner.Then("the activated mass calibration slots have a run state of \'Failed\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 111
 testRunner.Then(string.Format("the progress bar should be {0}", progressBar), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 112
  testRunner.And(string.Format("the progress message will be {0}", progressMessage), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 113
  testRunner.And(string.Format("the issue message will be {0}", issueMessage), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-04 - InstrumentSetupGUIandCalibration - Progress Bar and Mass Calibration Fai" +
            "lure Messages")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("cleanup-xml")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "1")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Slots", "1")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Bar", "Full")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Message", "Running selected tests,  100% complete")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Issue Message", "Last update performed : ddd-MMM-dd-yyyy - Instrument Setup Failed - see log messa" +
            "ges view for details")]
        public virtual void CAL_04_InstrumentSetupGUIandCalibration_ProgressBarAndMassCalibrationFailureMessages_1()
        {
            this.CAL_04_InstrumentSetupGUIandCalibration_ProgressBarAndMassCalibrationFailureMessages("1", "Full", "Running selected tests,  100% complete", "Last update performed : ddd-MMM-dd-yyyy - Instrument Setup Failed - see log messa" +
                    "ges view for details", ((string[])(null)));
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-04 - InstrumentSetupGUIandCalibration - Progress Bar and Mass Calibration Fai" +
            "lure Messages")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("cleanup-xml")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "2")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Slots", "2")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Bar", "Full")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Message", "Running selected tests,  100% complete")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Issue Message", "Last update performed : ddd-MMM-dd-yyyy - Instrument Setup Failed - see log messa" +
            "ges view for details")]
        public virtual void CAL_04_InstrumentSetupGUIandCalibration_ProgressBarAndMassCalibrationFailureMessages_2()
        {
            this.CAL_04_InstrumentSetupGUIandCalibration_ProgressBarAndMassCalibrationFailureMessages("2", "Full", "Running selected tests,  100% complete", "Last update performed : ddd-MMM-dd-yyyy - Instrument Setup Failed - see log messa" +
                    "ges view for details", ((string[])(null)));
        }
        
        public virtual void CAL_05_InstrumentSetupGUIandCalibration_ProgressBarAndMassCalibrationAbortMessage(string slots, string progressBar, string progressMessage, string issueMessage, string[] exampleTags)
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("CAL-05 - InstrumentSetupGUIandCalibration - Progress Bar and Mass Calibration Abo" +
                    "rt Message", exampleTags);
#line 120
this.ScenarioSetup(scenarioInfo);
#line 53
this.FeatureBackground();
#line 121
 testRunner.Given("ADC Setup, Instrument Setup Detector Setup and Resolution Optimisation has been r" +
                    "un for all modes", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 122
  testRunner.And(string.Format("\'{0}\' mass calibration slots are selected", slots), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 123
 testRunner.When("instrument setup process is \'started\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 124
 testRunner.And("instrument setup process is \'stopped\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 125
  testRunner.Then("the activated mass calibration slots have a run state of \'Aborted\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 126
 testRunner.Then(string.Format("the progress bar should be {0}", progressBar), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 127
  testRunner.And(string.Format("the progress message will be {0}", progressMessage), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 128
  testRunner.And(string.Format("the issue message will be {0}", issueMessage), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-05 - InstrumentSetupGUIandCalibration - Progress Bar and Mass Calibration Abo" +
            "rt Message")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "1")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Slots", "1")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Bar", "Progress frozen at Aborted state")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Progress Message", "Running selected tests,  100% complete")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Issue Message", "Last update performed : ddd-MMM-dd-yyyy - Mass Calibration aborted")]
        public virtual void CAL_05_InstrumentSetupGUIandCalibration_ProgressBarAndMassCalibrationAbortMessage_1()
        {
            this.CAL_05_InstrumentSetupGUIandCalibration_ProgressBarAndMassCalibrationAbortMessage("1", "Progress frozen at Aborted state", "Running selected tests,  100% complete", "Last update performed : ddd-MMM-dd-yyyy - Mass Calibration aborted", ((string[])(null)));
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-06 - InstrumentSetupGUIandCalibration - Reset Message")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        public virtual void CAL_06_InstrumentSetupGUIandCalibration_ResetMessage()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("CAL-06 - InstrumentSetupGUIandCalibration - Reset Message", ((string[])(null)));
#line 134
this.ScenarioSetup(scenarioInfo);
#line 53
this.FeatureBackground();
#line 135
 testRunner.When("the instrument setup \'Reset\' button is clicked", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 136
 testRunner.Then("the progress message should be \'Last update performed : Instrument Setup data res" +
                    "et by command\'", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("CAL-07 - InstrumentSetupGUIandCalibration - Select None")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "CAL - QRZ - Instrument Setup (Calibration) - Buttons and Progress GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("InstrumentSetup")]
        public virtual void CAL_07_InstrumentSetupGUIandCalibration_SelectNone()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("CAL-07 - InstrumentSetupGUIandCalibration - Select None", ((string[])(null)));
#line 139
this.ScenarioSetup(scenarioInfo);
#line 53
this.FeatureBackground();
#line 140
 testRunner.Given("all slots are selected", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 141
 testRunner.When("the instrument setup \'Select None\' button is clicked", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 142
 testRunner.Then("all Resolution Optimisation and Calibration slots are not selected", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
