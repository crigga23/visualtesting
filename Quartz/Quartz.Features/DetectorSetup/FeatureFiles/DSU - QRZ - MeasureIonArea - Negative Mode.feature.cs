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
    public partial class DSU_QRZ_MeasureIonArea_NegativeModeFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "DSU - QRZ - MeasureIonArea - Negative Mode.feature"
#line hidden
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassInitializeAttribute()]
        public static void FeatureSetup(Microsoft.VisualStudio.TestTools.UnitTesting.TestContext testContext)
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "DSU - QRZ - MeasureIonArea - Negative Mode", "In order to check \'Measure Ion Area\' processes for \'negative mode\' within a Quart" +
                    "z environment\r\nI want to check that the \'Measure Ion Area\' function as expected " +
                    "and generates the expected outputs when ran in \'negative mode\'.", ProgrammingLanguage.CSharp, new string[] {
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
                        && (TechTalk.SpecFlow.FeatureContext.Current.FeatureInfo.Title != "DSU - QRZ - MeasureIonArea - Negative Mode")))
            {
                Quartz.Features.DetectorSetup.FeatureFiles.DSU_QRZ_MeasureIonArea_NegativeModeFeature.FeatureSetup(null);
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
#line 30
#line 31
testRunner.Given("the browser is opened on the Tune page", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 32
 testRunner.And("the polarity is Negative", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
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
#line 33
 testRunner.And("reference fluidics are set to", ((string)(null)), table1, "And ");
#line 36
 testRunner.And("the reference fluidic level is not less than \'10.00\' minutes", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 37
 testRunner.And("the instrument has a beam", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 38
 testRunner.And("you start reference infusing", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 39
 testRunner.And("that the Quartz Detector Setup page is open", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line 40
testRunner.When("Measure Ion Area has been selected", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 41
 testRunner.And("detector setup is run for \'Negative\' mode", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 01 - MeasureIonArea - Negative mode - Negative Mass Results - Range")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - MeasureIonArea - Negative Mode")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("MeasureIonArea")]
        public virtual void DSU_01_MeasureIonArea_NegativeMode_NegativeMassResults_Range()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 01 - MeasureIonArea - Negative mode - Negative Mass Results - Range", ((string[])(null)));
#line 43
this.ScenarioSetup(scenarioInfo);
#line 30
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Minimum",
                        "Maximum"});
            table2.AddRow(new string[] {
                        "Negative Detector Voltage",
                        "0",
                        "3950"});
            table2.AddRow(new string[] {
                        "Negative Ion Area",
                        "0",
                        "100"});
#line 44
testRunner.Then("the field value is between Minimum and Maximum", ((string)(null)), table2, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 02 - MeasureIonArea - Negative mode - Negative Mass Results - Values")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - MeasureIonArea - Negative Mode")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("MeasureIonArea")]
        public virtual void DSU_02_MeasureIonArea_NegativeMode_NegativeMassResults_Values()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 02 - MeasureIonArea - Negative mode - Negative Mass Results - Values", ((string[])(null)));
#line 49
this.ScenarioSetup(scenarioInfo);
#line 30
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "FieldValue"});
            table3.AddRow(new string[] {
                        "Positive Detector Voltage",
                        "Blank"});
            table3.AddRow(new string[] {
                        "Positive Ion Area",
                        "Blank"});
#line 50
testRunner.Then("the field value should be", ((string)(null)), table3, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 03 - MeasureIonArea - Negative mode - Negative and Negative Mass Results - " +
            "Status")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - MeasureIonArea - Negative Mode")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("MeasureIonArea")]
        public virtual void DSU_03_MeasureIonArea_NegativeMode_NegativeAndNegativeMassResults_Status()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 03 - MeasureIonArea - Negative mode - Negative and Negative Mass Results - " +
                    "Status", ((string[])(null)));
#line 56
this.ScenarioSetup(scenarioInfo);
#line 30
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value"});
            table4.AddRow(new string[] {
                        "Positive Status",
                        "Blank"});
            table4.AddRow(new string[] {
                        "Negative Status",
                        "Complete"});
#line 57
testRunner.Then("the field value should be", ((string)(null)), table4, "Then ");
#line 61
 testRunner.And("the Measure Ion Area Setup should complete within 60 seconds", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 04 - MeasureIonArea - Negative mode - Negative Mass Results - Values")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - MeasureIonArea - Negative Mode")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("MeasureIonArea")]
        public virtual void DSU_04_MeasureIonArea_NegativeMode_NegativeMassResults_Values()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 04 - MeasureIonArea - Negative mode - Negative Mass Results - Values", ((string[])(null)));
#line 64
this.ScenarioSetup(scenarioInfo);
#line 30
this.FeatureBackground();
#line 65
testRunner.Then("the Measure Ion Area Mass Results values match the Progress Log", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 05 - MeasureIonArea - Negative mode - Progress Log - Messages")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - MeasureIonArea - Negative Mode")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("MeasureIonArea")]
        public virtual void DSU_05_MeasureIonArea_NegativeMode_ProgressLog_Messages()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 05 - MeasureIonArea - Negative mode - Progress Log - Messages", ((string[])(null)));
#line 67
this.ScenarioSetup(scenarioInfo);
#line 30
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table5 = new TechTalk.SpecFlow.Table(new string[] {
                        "Message"});
            table5.AddRow(new string[] {
                        "Measured Ion Area"});
            table5.AddRow(new string[] {
                        "IPP check at voltage"});
#line 68
testRunner.Then("the message should exist in the Progress Log", ((string)(null)), table5, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion