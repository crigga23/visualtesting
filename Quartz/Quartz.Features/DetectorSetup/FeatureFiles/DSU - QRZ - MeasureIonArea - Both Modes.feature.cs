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
namespace Quartz.Features.DetectorSetup.FeatureFiles
{
    using TechTalk.SpecFlow;
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("TechTalk.SpecFlow", "1.9.0.77")]
    [System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [Microsoft.VisualStudio.TestTools.UnitTesting.TestClassAttribute()]
    public partial class DSU_QRZ_MeasureIonArea_BothModesFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "DSU - QRZ - MeasureIonArea - Both Modes.feature"
#line hidden
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassInitializeAttribute()]
        public static void FeatureSetup(Microsoft.VisualStudio.TestTools.UnitTesting.TestContext testContext)
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "DSU - QRZ - MeasureIonArea - Both Modes", "In order to check \'Measure Ion Area\' processes with both the modes within a Quart" +
                    "z environment\r\nI want to check that \'Measure Ion Area\' functions as expected and" +
                    " generates the expected outputs when ran in \'Both Modes\'.", ProgrammingLanguage.CSharp, new string[] {
                        "DetectorSetup",
                        "MeasureIonArea"});
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
                        && (TechTalk.SpecFlow.FeatureContext.Current.FeatureInfo.Title != "DSU - QRZ - MeasureIonArea - Both Modes")))
            {
                Quartz.Features.DetectorSetup.FeatureFiles.DSU_QRZ_MeasureIonArea_BothModesFeature.FeatureSetup(null);
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
#line 37
#line 38
testRunner.Given("the browser is opened on the Tune page", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Baffle Position",
                        "Reservoir",
                        "Flow Path",
                        "Flow Rate"});
            table1.AddRow(new string[] {
                        "Reference",
                        "B",
                        "Infusion",
                        "20.00"});
#line 39
 testRunner.And("reference fluidics are set to", ((string)(null)), table1, "And ");
#line 42
 testRunner.And("the reference fluidic level is not less than \'10.00\' minutes", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 43
 testRunner.And("the instrument has a beam", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 44
 testRunner.And("you start reference infusing", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 45
 testRunner.And("that the Quartz Detector Setup page is open", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 46
testRunner.When("Measure Ion Area has been selected", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 47
 testRunner.And("detector setup is run for \'Both\' mode", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 01 - MeasureIonArea - Both mode - Negative Mass Results - Status")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - MeasureIonArea - Both Modes")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("MeasureIonArea")]
        public virtual void DSU_01_MeasureIonArea_BothMode_NegativeMassResults_Status()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 01 - MeasureIonArea - Both mode - Negative Mass Results - Status", ((string[])(null)));
#line 49
this.ScenarioSetup(scenarioInfo);
#line 37
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value"});
            table2.AddRow(new string[] {
                        "Positive Status",
                        "Complete"});
            table2.AddRow(new string[] {
                        "Negative Status",
                        "Complete"});
#line 50
testRunner.Then("the field value should be", ((string)(null)), table2, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 02 - MeasureIonArea - Both mode - Positive and Negative Mass Results - Valu" +
            "es")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - MeasureIonArea - Both Modes")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("MeasureIonArea")]
        public virtual void DSU_02_MeasureIonArea_BothMode_PositiveAndNegativeMassResults_Values()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 02 - MeasureIonArea - Both mode - Positive and Negative Mass Results - Valu" +
                    "es", ((string[])(null)));
#line 56
this.ScenarioSetup(scenarioInfo);
#line 37
this.FeatureBackground();
#line 57
testRunner.Then("the Measure Ion Area Mass Results values match the Progress Log", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 03 - MeasureIonArea - Both mode - Positive and Negative Mass Results - Setu" +
            "p Completion Time")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - MeasureIonArea - Both Modes")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("MeasureIonArea")]
        public virtual void DSU_03_MeasureIonArea_BothMode_PositiveAndNegativeMassResults_SetupCompletionTime()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 03 - MeasureIonArea - Both mode - Positive and Negative Mass Results - Setu" +
                    "p Completion Time", ((string[])(null)));
#line 59
this.ScenarioSetup(scenarioInfo);
#line 37
this.FeatureBackground();
#line 60
testRunner.Then("the Measure Ion Area Setup should complete within 120 seconds", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 04 - MeasureIonArea - Both mode - Progress Log - Messages")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - MeasureIonArea - Both Modes")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("MeasureIonArea")]
        public virtual void DSU_04_MeasureIonArea_BothMode_ProgressLog_Messages()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 04 - MeasureIonArea - Both mode - Progress Log - Messages", ((string[])(null)));
#line 62
this.ScenarioSetup(scenarioInfo);
#line 37
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Message"});
            table3.AddRow(new string[] {
                        "Measured Ion Area"});
            table3.AddRow(new string[] {
                        "IPP check at voltage"});
#line 63
testRunner.Then("the message should exist in the Progress Log", ((string)(null)), table3, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion