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
namespace Quartz.Features.Help.FeatureFiles
{
    using TechTalk.SpecFlow;
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("TechTalk.SpecFlow", "1.9.0.77")]
    [System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [Microsoft.VisualStudio.TestTools.UnitTesting.TestClassAttribute()]
    public partial class HLP_QRZ_AboutBoxQuartzFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "HLP - QRZ - About Box (Quartz).feature"
#line hidden
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassInitializeAttribute()]
        public static void FeatureSetup(Microsoft.VisualStudio.TestTools.UnitTesting.TestContext testContext)
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "HLP - QRZ - About Box (Quartz)", @"In order to access relevant and accurate software version information from the Quartz. I want to be able to access a modal dialog
that displays the credits and revision information of the Quartz software. This should include the product name, the installed version and the various application 
names with their respective versions along with the company name and copyright information.", ProgrammingLanguage.CSharp, new string[] {
                        "General",
                        "AboutQuartz"});
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
                        && (TechTalk.SpecFlow.FeatureContext.Current.FeatureInfo.Title != "HLP - QRZ - About Box (Quartz)")))
            {
                Quartz.Features.Help.FeatureFiles.HLP_QRZ_AboutBoxQuartzFeature.FeatureSetup(null);
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
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("HLP-QRZ-01 - About Quartz availability")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "HLP - QRZ - About Box (Quartz)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("General")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("AboutQuartz")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("SmokeTest")]
        public virtual void HLP_QRZ_01_AboutQuartzAvailability()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("HLP-QRZ-01 - About Quartz availability", new string[] {
                        "SmokeTest"});
#line 33
this.ScenarioSetup(scenarioInfo);
#line 34
testRunner.Then("the \'About Quartz\' software information is available", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("HLP-QRZ-02 - Versioning - Default modules installed")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "HLP - QRZ - About Box (Quartz)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("General")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("AboutQuartz")]
        public virtual void HLP_QRZ_02_Versioning_DefaultModulesInstalled()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("HLP-QRZ-02 - Versioning - Default modules installed", ((string[])(null)));
#line 37
this.ScenarioSetup(scenarioInfo);
#line 39
testRunner.When("the \'About Quartz\' software information is displayed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "Product",
                        "Format"});
            table1.AddRow(new string[] {
                        "Quartz",
                        "Build, Date"});
            table1.AddRow(new string[] {
                        "Typhoon",
                        "Build, Date"});
            table1.AddRow(new string[] {
                        "Osprey",
                        "Build, Date"});
#line 40
testRunner.Then("the content of the \'About Quartz\' software information is available in the follow" +
                    "ing Format", ((string)(null)), table1, "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("HLP-QRZ-04 - User is unable to edit the \'About Quartz\' software information")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "HLP - QRZ - About Box (Quartz)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("General")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("AboutQuartz")]
        public virtual void HLP_QRZ_04_UserIsUnableToEditTheAboutQuartzSoftwareInformation()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("HLP-QRZ-04 - User is unable to edit the \'About Quartz\' software information", ((string[])(null)));
#line 47
this.ScenarioSetup(scenarioInfo);
#line 48
testRunner.Given("the \'About Quartz\' software information is displayed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 49
testRunner.Then("the \'About Quartz\' software information should be readonly", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("HLP-QRZ-05 - \'About Quartz\' software information displays the Company and Copyrig" +
            "ht information")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "HLP - QRZ - About Box (Quartz)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("General")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("AboutQuartz")]
        public virtual void HLP_QRZ_05_AboutQuartzSoftwareInformationDisplaysTheCompanyAndCopyrightInformation()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("HLP-QRZ-05 - \'About Quartz\' software information displays the Company and Copyrig" +
                    "ht information", ((string[])(null)));
#line 51
this.ScenarioSetup(scenarioInfo);
#line 52
testRunner.When("the \'About Quartz\' software information is displayed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 53
testRunner.Then("Company and Copyright information is displayed at bottom of the dialog", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("HLP-QRZ-06 - \'About Quartz\' software information can be closed using the OK butto" +
            "n")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "HLP - QRZ - About Box (Quartz)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("General")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("AboutQuartz")]
        public virtual void HLP_QRZ_06_AboutQuartzSoftwareInformationCanBeClosedUsingTheOKButton()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("HLP-QRZ-06 - \'About Quartz\' software information can be closed using the OK butto" +
                    "n", ((string[])(null)));
#line 55
this.ScenarioSetup(scenarioInfo);
#line 56
testRunner.Given("the \'About Quartz\' software information is displayed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 57
testRunner.When("the \'OK\' button is clicked", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 58
testRunner.Then("the \'About Quartz\' software information is no longer displayed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("HLP-QRZ-07 - \'About Quartz\' software information can be closed using the Close ic" +
            "on")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "HLP - QRZ - About Box (Quartz)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("General")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("AboutQuartz")]
        public virtual void HLP_QRZ_07_AboutQuartzSoftwareInformationCanBeClosedUsingTheCloseIcon()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("HLP-QRZ-07 - \'About Quartz\' software information can be closed using the Close ic" +
                    "on", ((string[])(null)));
#line 60
this.ScenarioSetup(scenarioInfo);
#line 61
testRunner.Given("the \'About Quartz\' software information is displayed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 62
testRunner.When("the \'Close\' icon is clicked", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 63
testRunner.Then("the \'About Quartz\' software information is no longer displayed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("HLP-QRZ-08 - \'About Quartz\' software information can be closed via the keyboard b" +
            "y pressing the Escape button")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "HLP - QRZ - About Box (Quartz)")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("General")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCategoryAttribute("AboutQuartz")]
        public virtual void HLP_QRZ_08_AboutQuartzSoftwareInformationCanBeClosedViaTheKeyboardByPressingTheEscapeButton()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("HLP-QRZ-08 - \'About Quartz\' software information can be closed via the keyboard b" +
                    "y pressing the Escape button", ((string[])(null)));
#line 65
this.ScenarioSetup(scenarioInfo);
#line 66
testRunner.Given("the \'About Quartz\' software information is displayed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Given ");
#line 67
testRunner.When("the \'Esc\' button is pressed on the keyboard", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "When ");
#line 68
testRunner.Then("the \'About Quartz\' software information is no longer displayed", ((string)(null)), ((TechTalk.SpecFlow.Table)(null)), "Then ");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#pragma warning restore
#endregion
