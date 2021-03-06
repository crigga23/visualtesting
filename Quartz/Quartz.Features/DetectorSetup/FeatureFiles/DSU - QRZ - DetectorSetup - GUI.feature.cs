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
    public partial class DSU_QRZ_DetectorSetup_GUIFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "DSU - QRZ - DetectorSetup - GUI.feature"
#line hidden
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassInitializeAttribute()]
        public static void FeatureSetup(Microsoft.VisualStudio.TestTools.UnitTesting.TestContext testContext)
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "DSU - QRZ - DetectorSetup - GUI", "In order to check \'Detector Setup\' GUI elements within a Quartz Environment\r\nI wa" +
                    "nt to check that the GUI elements are in place and respond to user input / proce" +
                    "ss state changes as expected", ProgrammingLanguage.CSharp, new string[] {
                        "DetectorSetup"});
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
                        && (TechTalk.SpecFlow.FeatureContext.Current.FeatureInfo.Title != "DSU - QRZ - DetectorSetup - GUI")))
            {
                Quartz.Features.DetectorSetup.FeatureFiles.DSU_QRZ_DetectorSetup_GUIFeature.FeatureSetup(null);
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
#line 43
#line 44
testRunner.Given("that the Quartz Detector Setup page is open", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line hidden
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 01 - DetectorSetup - GUI - Panel Availability")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - DetectorSetup - GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        public virtual void DSU_01_DetectorSetup_GUI_PanelAvailability()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 01 - DetectorSetup - GUI - Panel Availability", ((string[])(null)));
#line 46
this.ScenarioSetup(scenarioInfo);
#line 43
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Panels"});
            table1.AddRow(new string[] {
                        "Detector Setup"});
            table1.AddRow(new string[] {
                        "Positive Mass Results"});
            table1.AddRow(new string[] {
                        "Negative Mass Results"});
            table1.AddRow(new string[] {
                        "Progress Log"});
#line 47
testRunner.Then("the following Panels should be available on the detector setup page", ((string)(null)), table1, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 02 - DetectorSetup - GUI - Default Values")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - DetectorSetup - GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        public virtual void DSU_02_DetectorSetup_GUI_DefaultValues()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 02 - DetectorSetup - GUI - Default Values", ((string[])(null)));
#line 54
this.ScenarioSetup(scenarioInfo);
#line 43
this.FeatureBackground();
#line hidden
            TechTalk.SpecFlow.Table table2 = new TechTalk.SpecFlow.Table(new string[] {
                        "Field",
                        "Value"});
            table2.AddRow(new string[] {
                        "Negative Mass",
                        "554.2"});
            table2.AddRow(new string[] {
                        "Positive Mass",
                        "556.2"});
            table2.AddRow(new string[] {
                        "Checkbox (POS)",
                        "True"});
            table2.AddRow(new string[] {
                        "Checkbox (NEG)",
                        "True"});
            table2.AddRow(new string[] {
                        "Process Selection Dropdown",
                        "Detector Setup"});
            table2.AddRow(new string[] {
                        "Start Button",
                        "Start"});
            table2.AddRow(new string[] {
                        "Positive Detector Voltage",
                        ""});
            table2.AddRow(new string[] {
                        "Positive Ion Area",
                        ""});
            table2.AddRow(new string[] {
                        "Positive Status Text",
                        ""});
            table2.AddRow(new string[] {
                        "Negative Detector Voltage",
                        ""});
            table2.AddRow(new string[] {
                        "Negative Ion Area",
                        ""});
            table2.AddRow(new string[] {
                        "Negative Status Text",
                        ""});
            table2.AddRow(new string[] {
                        "Progress Log",
                        ""});
            table2.AddRow(new string[] {
                        "Follow Tail Checkox",
                        "True"});
#line 55
testRunner.Then("the Detector Setup fields should have the following default values", ((string)(null)), table2, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        public virtual void DSU_03_DetectorSetup_GUI_ModeCheckboxDependencies(string checkboxStatus, string editBoxStatus, string buttonStatus, string[] exampleTags)
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 03 - DetectorSetup - GUI - Mode Checkbox Dependencies", exampleTags);
#line 73
this.ScenarioSetup(scenarioInfo);
#line 43
this.FeatureBackground();
#line 74
testRunner.When(string.Format("the \'{0}\' is set", checkboxStatus), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 75
testRunner.Then(string.Format("the \'{0}\' will be changed accordingly", editBoxStatus), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line 76
 testRunner.And(string.Format("the button state will be \'{0}\'", buttonStatus), ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "And ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 03 - DetectorSetup - GUI - Mode Checkbox Dependencies")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - DetectorSetup - GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "Positive (un-ticked), Negative (ticked)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Checkbox status", "Positive (un-ticked), Negative (ticked)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Edit box Status", "Positive (disabled), Negative (enabled)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Button Status", "Enabled")]
        public virtual void DSU_03_DetectorSetup_GUI_ModeCheckboxDependencies_PositiveUn_TickedNegativeTicked()
        {
            this.DSU_03_DetectorSetup_GUI_ModeCheckboxDependencies("Positive (un-ticked), Negative (ticked)", "Positive (disabled), Negative (enabled)", "Enabled", ((string[])(null)));
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 03 - DetectorSetup - GUI - Mode Checkbox Dependencies")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - DetectorSetup - GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "Positive (ticked), Negative (ticked)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Checkbox status", "Positive (ticked), Negative (ticked)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Edit box Status", "Positive (enabled), Negative (enabled)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Button Status", "Enabled")]
        public virtual void DSU_03_DetectorSetup_GUI_ModeCheckboxDependencies_PositiveTickedNegativeTicked()
        {
            this.DSU_03_DetectorSetup_GUI_ModeCheckboxDependencies("Positive (ticked), Negative (ticked)", "Positive (enabled), Negative (enabled)", "Enabled", ((string[])(null)));
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 03 - DetectorSetup - GUI - Mode Checkbox Dependencies")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - DetectorSetup - GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("VariantName", "Positive (ticked), Negative (un-ticked)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Checkbox status", "Positive (ticked), Negative (un-ticked)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Edit box Status", "Positive (enabled), Negative (disabled)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("Parameter:Button Status", "Enabled")]
        public virtual void DSU_03_DetectorSetup_GUI_ModeCheckboxDependencies_PositiveTickedNegativeUn_Ticked()
        {
            this.DSU_03_DetectorSetup_GUI_ModeCheckboxDependencies("Positive (ticked), Negative (un-ticked)", "Positive (enabled), Negative (disabled)", "Enabled", ((string[])(null)));
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("DSU - 04 - DetectorSetup - GUI - Follow Tail")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "DSU - QRZ - DetectorSetup - GUI")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("DetectorSetup")]
        public virtual void DSU_04_DetectorSetup_GUI_FollowTail()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("DSU - 04 - DetectorSetup - GUI - Follow Tail", ((string[])(null)));
#line 84
this.ScenarioSetup(scenarioInfo);
#line 43
this.FeatureBackground();
#line 85
testRunner.Given("\'Follow Tail\' is ticked", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 86
testRunner.When("I scroll up the log", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 87
testRunner.Then("\'Follow Tail\' should become automatically unticked", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
