﻿// ------------------------------------------------------------------------------
//  <auto-generated>
//      This code was generated by SpecFlow (http://www.specflow.org/).
//      SpecFlow Version:1.9.0.77
//      SpecFlow Generator Version:1.9.0.0
//      Runtime Version:4.0.30319.18408
// 
//      Changes to this file may cause incorrect behavior and will be lost if
//      the code is regenerated.
//  </auto-generated>
// ------------------------------------------------------------------------------
#region Designer generated code
#pragma warning disable
namespace Quartz.Features.QuadSetup.FeatureFiles
{
    using TechTalk.SpecFlow;
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("TechTalk.SpecFlow", "1.9.0.77")]
    [System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [Microsoft.VisualStudio.TestTools.UnitTesting.TestClassAttribute()]
    [Microsoft.VisualStudio.TestTools.UnitTesting.IgnoreAttribute()]
    public partial class QuadSetupPeakDisplayFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "QuadSetupPeakDisplay.feature"
#line hidden
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassInitializeAttribute()]
        public static void FeatureSetup(Microsoft.VisualStudio.TestTools.UnitTesting.TestContext testContext)
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "QuadSetupPeakDisplay", "", ProgrammingLanguage.CSharp, new string[] {
                        "ignore"});
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
                        && (TechTalk.SpecFlow.FeatureContext.Current.FeatureInfo.Title != "QuadSetupPeakDisplay")))
            {
                Quartz.Features.QuadSetup.FeatureFiles.QuadSetupPeakDisplayFeature.FeatureSetup(null);
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
#line 11
#line 12
 testRunner.Given("the Quad Setup Page is Open", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("Quad Setup Peak Display - Main Peak Display")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "QuadSetupPeakDisplay")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("QuadSetupMode")]
        public virtual void QuadSetupPeakDisplay_MainPeakDisplay()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Quad Setup Peak Display - Main Peak Display", new string[] {
                        "QuadSetupMode"});
#line 17
 this.ScenarioSetup(scenarioInfo);
#line 11
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Controls",
                        "Unit",
                        "Default"});
            table1.AddRow(new string[] {
                        "Peak Displays for Mass 1",
                        "m/z",
                        "172.88"});
            table1.AddRow(new string[] {
                        "Peak Displays for Mass 2",
                        "m/z",
                        "472.62"});
            table1.AddRow(new string[] {
                        "Peak Displays for Mass 3",
                        "m/z",
                        "772.45"});
            table1.AddRow(new string[] {
                        "Peak Displays for Mass 4",
                        "m/z",
                        "922.35"});
#line 18
  testRunner.Then("the following quad setup peak display windows should be available", ((string)(null)), table1, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("Quad Setup Peak Display - Peak Controls")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "QuadSetupPeakDisplay")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("QuadSetupMode")]
        public virtual void QuadSetupPeakDisplay_PeakControls()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Quad Setup Peak Display - Peak Controls", new string[] {
                        "QuadSetupMode"});
#line 26
 this.ScenarioSetup(scenarioInfo);
#line 11
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Controls",
                        "Checked",
                        "Default"});
            table2.AddRow(new string[] {
                        "Mass1 textbox",
                        "True",
                        "172.88"});
            table2.AddRow(new string[] {
                        "Mass2 textbox",
                        "True",
                        "472.62"});
            table2.AddRow(new string[] {
                        "Mass3 textbox",
                        "True",
                        "772.45"});
            table2.AddRow(new string[] {
                        "Mass4 textbox",
                        "True",
                        "922.35"});
#line 27
  testRunner.Then("the following quad setup mass textboxes should be available", ((string)(null)), table2, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("Quad Setup Peak Display - Peak Display can be removed")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "QuadSetupPeakDisplay")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("QuadSetupMode")]
        public virtual void QuadSetupPeakDisplay_PeakDisplayCanBeRemoved()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Quad Setup Peak Display - Peak Display can be removed", new string[] {
                        "QuadSetupMode"});
#line 36
 this.ScenarioSetup(scenarioInfo);
#line 11
this.FeatureBackground();
#line 37
  testRunner.When("A mass checkbox is deselected", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 38
  testRunner.Then("the corresponding peak display should not be present", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("Quad Setup Peak Display - Peak Display can be reinstated")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "QuadSetupPeakDisplay")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("QuadSetupMode")]
        public virtual void QuadSetupPeakDisplay_PeakDisplayCanBeReinstated()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Quad Setup Peak Display - Peak Display can be reinstated", new string[] {
                        "QuadSetupMode"});
#line 41
 this.ScenarioSetup(scenarioInfo);
#line 11
this.FeatureBackground();
#line 42
  testRunner.When("A mass checkbox is reselected", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 43
  testRunner.Then("the corresponding peak display should be present", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("Quad Setup Display - Additional parameter defaults and ranges")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "QuadSetupPeakDisplay")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("QuadSetupMode")]
        public virtual void QuadSetupDisplay_AdditionalParameterDefaultsAndRanges()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Quad Setup Display - Additional parameter defaults and ranges", new string[] {
                        "QuadSetupMode"});
#line 47
 this.ScenarioSetup(scenarioInfo);
#line 11
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table3 = new TechTalk.SpecFlow.Table(new string[] {
                        "Parameters",
                        "Default"});
            table3.AddRow(new string[] {
                        "Span",
                        "10"});
            table3.AddRow(new string[] {
                        "Number of steps",
                        "10"});
            table3.AddRow(new string[] {
                        "Time Per Step",
                        "0.1"});
            table3.AddRow(new string[] {
                        "Detector Window",
                        "4"});
#line 48
  testRunner.Then("it should have the following quad setup parameters present", ((string)(null)), table3, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("Quad Setup Peak Display - Parameter predefined values")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "QuadSetupPeakDisplay")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("QuadSetupMode")]
        public virtual void QuadSetupPeakDisplay_ParameterPredefinedValues()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Quad Setup Peak Display - Parameter predefined values", new string[] {
                        "QuadSetupMode"});
#line 56
 this.ScenarioSetup(scenarioInfo);
#line 11
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table4 = new TechTalk.SpecFlow.Table(new string[] {
                        "Parameters",
                        "Predefined"});
            table4.AddRow(new string[] {
                        "Span",
                        "1,2,4,10,20,50"});
            table4.AddRow(new string[] {
                        "Number of steps",
                        "10,20,30,50"});
            table4.AddRow(new string[] {
                        "Time Per Step",
                        "0.023,0.04,0.06,0.1"});
            table4.AddRow(new string[] {
                        "Detector Window",
                        "1,2,4,10,100"});
#line 57
    testRunner.Then("the parameters should have the following predefined values present", ((string)(null)), table4, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
