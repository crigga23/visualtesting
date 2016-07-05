using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Automation.Config.Lib.ConfigHelpers;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using Quartz.Support.Configuration;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.ManualTune.StepDefinitions
{
    [Binding]
    public class TunePageFactoryDefaultsSteps
    {

        public class FieldValue
        {
            public string Tab {get; set;}
            public string TabAutomationId { get; set; }
            public string FieldName { get; set; }
            public string Value1 { get; set; }
            public string Value2 { get; set; }
        }

        private List<FieldValue> _fieldValues;            
        private TunePage _tunePage;
        private TuneConfig _tuneConfig;
        private InstrumentControlWidget _instrumentControl;
                
        public TunePageFactoryDefaultsSteps(TunePage tunePage, InstrumentControlWidget instrumentControl)
        {
            _tunePage = tunePage;
            _instrumentControl = instrumentControl;
            _tuneConfig = new TuneConfig(new TestConfiguration(new AppSettingsConfigurationManager()).Instrument);
            _fieldValues = new List<FieldValue>();
        }

        [BeforeScenario("FactoryDefaults")]
        public static void BeforeScenario()
        {
            RestoreDefaultsToFactorySettings();
            TunePage tunePage = new TunePage();
            tunePage.LoadFactoryDefaults();
        }

        [AfterScenario("FactoryDefaults")]
        public static void RestoreToDefaults()
        {
            RestoreDefaultsToFactorySettings();
        }

        [Given(@"factory defaults have been reset")]
        public void GivenFactoryDefaultsHaveBeenReset()
        {
            _tunePage.ResetFactoryDefaults();
        }

        [Given(@"that '(.*)' file does not exist in the Config folder")]
        public void GivenThatFileDoesNotExistInTheConfigFolder(string fileName)
        {
            bool exists = File.Exists(TyphoonHelper.ConfigDirectory + fileName);

            if (exists)
            {
                File.Delete(TyphoonHelper.ConfigDirectory + fileName);
                Check.IsFalse(File.Exists(TyphoonHelper.ConfigDirectory + fileName), string.Format("File '{0}' does not exist in directory '{1}'", fileName, TyphoonHelper.ConfigDirectory));
            }
            else
            {
                Check.IsFalse(exists, string.Format("File '{0}' does not exist in directory '{1}'", fileName, TyphoonHelper.ConfigDirectory));
            }
        }
        
        [Given(@"that '(.*)' file already exists in the Config folder")]
        public void GivenThatFileAlreadyExistsInTheConfigFolder(string fileName)
        {
            // Code that creates the factory_settings.gpb
            _tunePage.SaveFactoryDefaults();

            Wait.Until(f => File.Exists(TyphoonHelper.ConfigDirectory + fileName), 5000, "Waiting for factory_settings.gpb to be created...");
            Check.IsTrue(File.Exists(TyphoonHelper.ConfigDirectory + fileName), string.Format("File '{0}' exists in directory '{1}'", fileName, TyphoonHelper.ConfigDirectory));
        }
        
        /// <summary>
        /// Background steps generates the field values between min and max.
        /// </summary>
        [Given(@"I have field values for Control Parameters")]
        public void GivenIHaveFieldValuesForControlParameter()
        {
            //clear the field values.
            _fieldValues.Clear();
            
            foreach (var configTab in _tuneConfig.Tabs)
            {
                //Excluding Fluidies and ESI LockSpray test.
                if (configTab.Title == "Fluidics" || configTab.Title == "ESI LockSpray")
                    continue;
               
                var expectedParameters = configTab.Parameters;

                foreach (var parameter in expectedParameters)
                {
                    
                    FieldValue fieldValue = new FieldValue();
                    fieldValue.Tab = configTab.Title;
                    fieldValue.TabAutomationId = configTab.AutomationId;
                    fieldValue.FieldName = parameter.Name;

                    //Ramp Time 1, Ramp Time2,  Dwell Time 1  and Dwell Time 2 collective has to be 100. so setting hardcode value.
                    //its default value is 20.
                    if (parameter.Name.StartsWith("Ramp Time") || parameter.Name.StartsWith("Dwell Time"))
                    {
                        fieldValue.Value1 = (decimal.Parse(_tuneConfig.GetParameterDefaultValue(parameter, _tunePage.GetCurrentConfiguration())) + 1).ToString(); ;
                        fieldValue.Value2 = (decimal.Parse(fieldValue.Value1) + 2).ToString(); // value2 is incremented by 2
                    }
                    else 
                    {
                        fieldValue.Value1 = parameter.GetValueBetweenMinAndMax;
                        fieldValue.Value2 = parameter.GetValueBetweenMinAndMax;
                    }
                    Report.Debug("fieldValue.FieldName:" + fieldValue.FieldName + " Value1:" + fieldValue.Value1 + " Value2 :" + fieldValue.Value2);
                    
                    _fieldValues.Add(fieldValue);
                }  
            }
        }


        [StepDefinition(@"all the Control Parameter values are '(.*)' to '(.*)' for '(.*)' mode combination")]
        public void WhenAllTheControlParameterValuesAreSetTo(string action, string value, string polarity)
        {
            foreach (var combination in _tuneConfig.PolarityModeCombinations.Where(p => p.Polarity.StartsWith(polarity)))
            {
                _tunePage.SwitchConfiguration(combination.Mode, combination.Polarity);

                var tabControl = _instrumentControl.TabControl;

                foreach (var field in _fieldValues)
                {
                    _tunePage.SelectTabById(field.TabAutomationId);                   
                    string val = null;
                                        
                    // this control is automatically calculated.
                    if (field.FieldName == "Ramp Time 2")
                        continue;

                    val = GetValueFromFieldValuesCollection(value, field);

                    _instrumentControl.SetDualControl(field.FieldName);
                                   
                    Control control = _tunePage.FindControlById(_tuneConfig.GetParameterByName(field.FieldName).Setting);

                    if (!string.IsNullOrEmpty(val) && control.Enabled)
                    {
                        if (action == "set")
                        {
                            control.SetValue(val, continueOnFail: false);
                        }
                        else if (action == "equal")
                        {
                            control.CheckValue(val, continueOnFail: false);
                        }
                    }                    
                }                
            } 
        }

        [StepDefinition(@"'(.*)' factory Defaults")]
        [StepDefinition(@"Factory Defaults are '(.*)'")]
        public void GivenFactoryDefaults(string action)
        {
            _tunePage.FactoryDefaultAction(action);            

        }


        [StepDefinition(@"'(.*)' factory Defaults for '(.*)' mode combination")]
        public void WhenFactoryDefaultsAreForPolarityModeCombination(string action, string polarity)
        {
            foreach (var combination in _tuneConfig.PolarityModeCombinations.Where(p => p.Polarity.StartsWith(polarity)))
            {
                _tunePage.SwitchConfiguration(combination.Mode, combination.Polarity);

                _tunePage.FactoryDefaultAction(action);
            }
        }

        [StepDefinition(@"the mode is (.*) and the polarity is (.*)")]
        public void WhenTheModeIsAndThePolarityIs(string mode, string polarity)
        {
            _tunePage.SwitchConfiguration(mode, polarity);
        }
        
        [Then(@"a '(.*)' file is created in the Config folder")]
        public void ThenAFileIsCreatedInTheConfigFolder(string fileName)
        {
            Check.IsTrue(File.Exists(TyphoonHelper.ConfigDirectory + fileName), string.Format("File '{0}' exists in directory '{1}'", fileName, TyphoonHelper.ConfigDirectory));
        }
               

        private static void RestoreDefaultsToFactorySettings()
        {
            // Deleting this gpb file essentially restores to out of the box defaults
            File.Delete(TyphoonHelper.ConfigDirectory + "factory_settings.gpb");
        }

        private static string GetValueFromFieldValuesCollection(string value, FieldValue field)
        {
            string val = string.Empty;
            if (value == "Value1")
                val = field.Value1;
            else if (value == "Value2")
                val = field.Value2;
            else
                throw new NotImplementedException("Unable to determine which value to enter");
            return val;
        }       

    }
}
