using System;
using System.Collections.Generic;
using System.Linq;
using Automation.Config.Lib.ConfigHelpers;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.Configuration;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.Modals;
using Quartz.Support.Views.TabViews;
using TechTalk.SpecFlow;

namespace Quartz.Support.Views
{
    public class InstrumentControlWidget
    {
        private TuneConfig tuneConfig;
        private readonly IList<string> defaultTabs;
        internal static Dictionary<string, string> currentControlsValues;
        private const string CHANGE_VALUE_ACTION_TYPE = "Change Value";
        private string controlParameterSetting;
        private ControlFactory controlFactory;

        public InstrumentControlWidget()
        {
            defaultTabs = new List<string> { "ESI LockSpray", "Instrument", "Fluidics", "System1", "System2", "ADC2", "MS Profile", "StepWave", "Trap/IMS", "Cell1", "Cell2", "RF", "Gases" };
            currentControlsValues = new Dictionary<string, string>();
            tuneConfig = new TuneConfig(new TestConfiguration(new AppSettingsConfigurationManager()).Instrument);
            controlFactory = new ControlFactory();
        }

        #region Properties

        public int CustomTabCount
        {
            get
            {
                return CustomTabs.Count;
            }
        }

        #endregion Properties

        #region Controls

        public Dictionary<string, ControlGroup> ControlsDictionary
        {
            get
            {
                var controls = new Dictionary<string, ControlGroup>();


                controls = DictionaryManager.MergeDictionaries(controls, SourceTabView.ControlDictionary);
                controls = DictionaryManager.MergeDictionaries(controls, InstrumentTabView.ControlDictionary);
                controls = DictionaryManager.MergeDictionaries(controls, StepWaveTabView.ControlDictionary);
                controls = DictionaryManager.MergeDictionaries(controls, TrapIMSTabView.ControlDictionary);
                controls = DictionaryManager.MergeDictionaries(controls, Cell1TabView.ControlDictionary);
                controls = DictionaryManager.MergeDictionaries(controls, Cell2TabView.ControlDictionary);
                controls = DictionaryManager.MergeDictionaries(controls, System1TabView.ControlDictionary);
                controls = DictionaryManager.MergeDictionaries(controls, System2TabView.ControlDictionary);
                controls = DictionaryManager.MergeDictionaries(controls, ADCTab2View.ControlDictionary);
                controls = DictionaryManager.MergeDictionaries(controls, MSProfileTabView.ControlDictionary);
                controls = DictionaryManager.MergeDictionaries(controls, RFTabView.ControlDictionary);
                controls = DictionaryManager.MergeDictionaries(controls, GasesTabView.ControlDictionary);

                return controls;
            }
        }

        /// <summary>
        /// User defined tabs
        /// </summary>
        public List<CustomTab> CustomTabs
        {
            get
            {
                var tabs = new List<CustomTab>();
                foreach (var element in AutomationDriver.Driver.FindElements(By.XPath("//ul[contains(@class,'nav-tabs')]/li/a[contains(@id, 'Development')]")))
                {
                    tabs.Add(new CustomTab(element));
                }
                return tabs;
            }
        }

        public TabControl TabControl
        {
            get { return new TabControl(AutomationDriver.Driver.FindElement(By.Id("allTabs"))); }
        }

        public Tab ESILockSprayTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Source.ESI"))); }
        }

        public Tab InstrumentTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Instrument"))); }
        }

        public Tab FluidicsTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Fluidics"))); }
        }

        public Tab System1Tab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.System1"))); }
        }

        public Tab System2Tab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.System2"))); }
        }

        public Tab AdcTab2
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.ADC2"))); }
        }

        public Tab RFTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.RF"))); }
        }

        public Tab MsProfileTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.MSProfile"))); }
        }

        public Tab StepWaveTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Stepwave"))); }
        }

        public Tab GasesTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Gas"))); }
        }

        public Tab TrapIMSTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.TrapIMS"))); }
        }

        public Tab Cell1Tab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Cell1"))); }
        }

        public Tab Cell2Tab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Cell2"))); }
        }

        public Tab TWaveTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.TWave"))); }
        }

        public Tab ApciTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Source.APCI"))); }
        }

        public Tab ApgcTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Source.APGC"))); }
        }

        public Tab NanoFlowTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Source.Nanoflow"))); }
        }

        public Tab AppiTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Source.APPI"))); }
        }

        public Tab DualAppiTab
        {
            get { return new Tab(AutomationDriver.Driver.FindElement(By.XPath("//*[@id=\"allTabs\"]/div/div/ul/li[1]/a"))); }
        }

        public ButtonDropdown TabOptionsButton
        {
            get { return new ButtonDropdown(AutomationDriver.Driver.FindElement(By.Id("tabControlsDropdown"))); }
        }

        public ButtonDropdown TabOptionsButtonTooltipText
        {
            get { return new ButtonDropdown(AutomationDriver.Driver.FindElement(By.Id("tabControlsDropdown")).FindElement(By.TagName("a"))); }
        }

        public ButtonDropdown TabVisibleSettingButton
        {
            get { return new ButtonDropdown(AutomationDriver.Driver.FindElement(By.Id("tabVisibleSettingDropDown"))); }
        }

        public ButtonDropdown TabVisibleSettingButtonTooltipText
        {
            get { return new ButtonDropdown(AutomationDriver.Driver.FindElement(By.Id("tabVisibleSettingDropDown")).FindElement(By.TagName("a"))); }
        }

        public Button AddTabButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id("Tab.Panel.Add.Tab")));
            }
        }

        public TextBox FindTextBoxReadbackByLabel(string label)
        {
            try
            {
                // Using XPath is marginally faster
                string xPath = string.Format("//label[text()='{0}:' or text()='{0}']/ancestor::div[@class='watRow']//descendant::input[contains(@class, 'readback')]", label);
                return new TextBox(AutomationDriver.Driver.FindElement(By.XPath(xPath)));
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<TextBox> FindReadbacks()
        {
            var elements = AutomationDriver.Driver.FindElements(By.XPath("//input[contains(@class, 'readback')]"));
            var visibleReadbacks = elements.Where(e => e.Displayed).ToList();

            List<TextBox> readbacks = new List<TextBox>();

            if (visibleReadbacks.Count > 0)
                visibleReadbacks.ForEach(e => readbacks.Add(new TextBox(e)));

            return readbacks;
        }

        #endregion Controls

        #region Methods - Operations on tabs

        public void RestoreDefaultTabView()
        {
            DeleteCustomizedTabs();
            ShowAllDefaultTabs();
        }

        public void DeleteCustomizedTabs()
        {
            foreach (Tab tab in TabControl.Tabs)
            {
                string tabName = tab.Name;
                if (!string.IsNullOrEmpty(tabName))
                {
                    if (!defaultTabs.Contains(tabName))
                    {
                        DeleteTab(tabName);
                    }
                }
                else
                {
                    Report.Debug("Tab name is empty");
                }
            }
        }

        public void ShowAllDefaultTabs()
        {
            TabVisibleSettingButton.Expand();
            foreach (string tab in defaultTabs)
            {
                TickTabInTabVisibility(tab);
            }
            TabVisibleSettingButton.Collapse();
        }

        private void TickTabInTabVisibility(string option)
        {
            IList<ListItem> options = TabVisibleSettingButton.DropdownOptions;
            foreach (ListItem optionItem in options)
            {
                if (optionItem.Text == option)
                {
                    Report.Action(string.Format("Display the {0} tab", option));
                    //Checks if option has no tick in front of it, if that is the case it will click it
                    if (optionItem.Element.FindElement(By.TagName("span")).GetAttribute("class") == "icon-padding")
                    {
                        optionItem.Click();
                    }
                    Report.DebugScreenshot(TabControl.Element);
                }
                else
                {
                    Report.Fail(string.Format("Unable to tick option '{0}' in the tab visibility dropdown.", option));
                }
            }

        }

        private void UntickTabInTabVisibility(string option)
        {
            IList<ListItem> options = TabVisibleSettingButton.DropdownOptions;
            foreach (ListItem optionItem in options)
            {
                if (optionItem.Text == option)
                {
                    Report.Action(string.Format("Hide the {0} tab", option));
                    //Checks if option has no tick in front of it, if that is the case it will click it
                    if (optionItem.Element.FindElement(By.TagName("span")).GetAttribute("class") == "icon-ok")
                    {
                        optionItem.Click();
                    }
                    Report.DebugScreenshot(TabControl.Element);
                }
            }
        }

        public void ShowTab(string tab)
        {
            TabVisibleSettingButton.Expand();
            TickTabInTabVisibility(tab);
            TabVisibleSettingButton.Collapse();
        }

        public void HideTab(string tab)
        {
            TabVisibleSettingButton.Expand();
            UntickTabInTabVisibility(tab);
            TabVisibleSettingButton.Collapse();
        }

        public void AddTab()
        {
            // Count the number of tabs prior to the Add operation
            var existingTabCount = TabControl.Tabs.Count;

            Report.Action("Add a new tab");
            AddTabButton.Click();

            // There should be one more tab.
            Check.AreEqual(existingTabCount + 1, TabControl.Tabs.Count, string.Format("A new tab was successfully added"), true);
            Report.DebugScreenshot(TabControl.Element);
        }

        public void SaveTabs(string saveName)
        {
            Report.Action("Save the tab");
            TabOptionsButton.SelectDropdownOption("Save set");

            SaveDevelopmentTabsModal.EnterNameAndSave(saveName);
        }

        public void DeleteTab(string tab)
        {
            // Count the number of tabs prior to the Add operation
            var existingTabCount = TabControl.Tabs.Count;

            Report.Action(string.Format("Delete the {0} tab", tab));
            TabControl.Select(tab);
            TabOptionsButton.SelectDropdownOption("Delete");

            Check.IsTrue(TabControl.Tabs.Count == existingTabCount - 1, string.Format("{0} tab successfully deleted", tab), true);
            Report.DebugScreenshot(TabControl.Element);
        }

        public void DeleteTab()
        {
            // Count the number of tabs prior to the Add operation
            var existingTabCount = TabControl.Tabs.Count;

            Report.Action(string.Format("Delete the current tab"));

            TabOptionsButton.SelectDropdownOption("Delete");

            Check.IsTrue(TabControl.Tabs.Count == existingTabCount - 1, string.Format("Current tab successfully deleted"), true);
            Report.DebugScreenshot(TabControl.Element);
        }

        public void LoadTab(string loadName)
        {
            Report.Action("Load the tab");
            TabOptionsButton.SelectDropdownOption("Load set");

            LoadDevelopmentTabsModal.WaitForOpen();

            LoadDevelopmentTabsModal.TuneParametersDropdown.SelectOptionFromDropDown(loadName);
            LoadDevelopmentTabsModal.LoadButton.Click();

            LoadDevelopmentTabsModal.WaitForClose();

            Wait.ForMilliseconds(2000);
        }

        public void ClearTabs()
        {
            AutomationDriver.Driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(0));

            // Count the number of tabs prior to the Add operation
            var existingTabCount = TabControl.Tabs.Count;

            Report.Action(string.Format("Clearing all Custom tabs."));
            TabOptionsButton.SelectDropdownOption("Clear");

            if (DialogConfirmationModal.Exists)
            {
                DialogConfirmationModal.ClickNoAndClose();
            }

            Check.AreEqual(0, CustomTabCount, "Checking equal tab counts.", true);
            Report.DebugScreenshot(TabControl.Element);

            AutomationDriver.Driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(Wait.ImplicitWaitSeconds));
        }

        #endregion Methods - Operations on tabs

        #region Methods - Modify Controls - Public

        /// <summary>
        /// Modify the default values of all controls (from the specified tab) available on Tune\Scope Mode pages.
        /// The mechanism for automatically changing the values is as follow:
        /// - for dropdowns a different option will be selected
        /// - for text boxes: it will change the string or in case of numbers it will increase the int by 1 and the double by 0.1 (or if a multiplier is specified)
        /// In case of maximum allowed value is already setup, the value will be decreased by 2 units.
        /// </summary>
        /// <param name="tabName">The tab name. All tabs will be changed in case no parameter is provided</param>
        public Dictionary<string, string> ModifyControlsValuesFromAllTabs()
        {
            currentControlsValues = new Dictionary<string, string>();
            PerformActionOnAllTuneSetParameters(CHANGE_VALUE_ACTION_TYPE);
            return currentControlsValues;
        }
        public Dictionary<string, string> ModifyControlsValuesFromSpecifiedTab(string tabName = null)
        {
            currentControlsValues = new Dictionary<string, string>();
            ScenarioContext.Current.Add("tabName", tabName);
            PerformActionOnControlParametersForSpecificTab(CHANGE_VALUE_ACTION_TYPE, tabName);
            return currentControlsValues;
        }

        /// <summary>
        /// Applies the same mechanism as ModifyControlsValuesFromSpecifiedTab method but to a single designated control.
        /// </summary>
        /// <param name="tabName">The tab name</param>
        /// <param name="control">The control</param>
        public void ModifyValueForASingleControl(string tabName, Control control)
        {
            SelectSpecificTab(tabName);
            PerformActionOnControl(CHANGE_VALUE_ACTION_TYPE, control);
        }

        public void SelectSpecificTab(string tabName)
        {
            //make sure the specified tab is selected
            if (TabControl.ActiveTab.Name != tabName)
                TabControl.Select(tabName);
        }

        public void ModifyValueForASingleControl(string tabName, string automationId)
        {
            ModifyValueForASingleControl(tabName, controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(automationId))));
        }

        /// <summary>
        /// Reads the controls values from the specified tab. If a tab is not specified then all tabs will be interogated.
        /// </summary>
        public Dictionary<string, string> GetControlsValuesFromSpecifiedTab(string tabName = null)
        {
            if (string.IsNullOrEmpty(tabName) && ScenarioContext.Current.ContainsKey("tabName"))
            {
                tabName = ScenarioContext.Current["tabName"] as string;
            }

            currentControlsValues = new Dictionary<string, string>();

            if (string.IsNullOrEmpty(tabName))
            {
                PerformActionOnAllTuneSetParameters(string.Empty);
            }
            else
            {
                PerformActionOnControlParametersForSpecificTab(string.Empty, tabName);
            }
            
            return currentControlsValues;
        }

        /// <summary>
        /// Compare two dictionaries and fails/pass the interogations based on the 'expectingChanges' flag
        /// </summary>
        /// <param name="previouslySavedControlParameterValues">The dictionary with old values</param>
        /// <param name="newControlParameterValues">The dictionary with new values</param>
        /// <param name="factoryDefaultsList"></param>
        public void CompareControlParameterValues(Dictionary<string, string> previouslySavedControlParameterValues, Dictionary<string, string> newControlParameterValues, List<string> factoryDefaultsList = null)
        {
            CheckControlsParameterCollectionsCountsAreEqual(previouslySavedControlParameterValues.Count, newControlParameterValues.Count);
            CheckPreviouslySavedParametersAndNewControlParametersAreEquality(previouslySavedControlParameterValues, newControlParameterValues, factoryDefaultsList);
        }

        /// <summary>
        /// Set the dual control for linked parameter.
        /// </summary>
        /// <param name="parameter">linked parameter</param>
        /// <param name="value"></param>
        /// <returns>original value of the controls</returns>
        public string SetDualControl(string parameter, string value = null)
        {
            string originalValue = null;

            // Handle dual controls
            switch (parameter)
            {
                case "Set Mass":
                    Dropdown msmsmsDropdown = (Dropdown)GetControl("MS/MSMS");
                    originalValue = msmsmsDropdown.SelectedOption.Text;
                    msmsmsDropdown.SetValue(value ?? "MSMS");
                    Wait.Until(c => value == null? GetControl(parameter).Enabled: true, timeoutInMilliseconds: 1000);
                    break;
                case "EDC Mass":
                case "Delay Coefficient Low":
                case "Delay Coefficient High":
                case "Delay Offset Low":
                case "Delay Offset High":
                    Dropdown selectModeDropdown = (Dropdown)GetControl("Select Mode");
                    originalValue = selectModeDropdown.SelectedOption.Text;
                    selectModeDropdown.SetValue(value ?? "EDC");
                    Wait.Until(c => value == null ? GetControl(parameter).Enabled : true, timeoutInMilliseconds: 1000);
                    break;
                case "Mass 1":
                case "Mass 2":
                case "Mass 3":
                case "Dwell Time 1":
                case "Dwell Time 2":
                case "Ramp Time 1":
                    Dropdown quadropleDropdown = (Dropdown)GetControl("Quadrupole Options");
                    originalValue = quadropleDropdown.SelectedOption.Text;
                    quadropleDropdown.SetValue(value ?? "Manual Profile");
                    Wait.Until(c => value == null ? GetControl(parameter).Enabled : true, timeoutInMilliseconds: 1000);
                    break;
                case "pDRE Transmission":
                    Dropdown attenuateDropdown = (Dropdown)GetControl("pDRE Attenuate");
                    originalValue = attenuateDropdown.SelectedOption.Text;
                    attenuateDropdown.SetValue(value ?? "On");
                    Wait.Until(c => value == null ? GetControl(parameter).Enabled : true, timeoutInMilliseconds: 1000);
                    break;
                case "pDRE HD Transmission":
                    Dropdown hdAttenuateDropdown = (Dropdown)GetControl("pDRE HD Attenuate");
                    originalValue = hdAttenuateDropdown.SelectedOption.Text;
                    hdAttenuateDropdown.SetValue(value ?? "On");
                    Wait.Until(c => value == null ? GetControl(parameter).Enabled : true, timeoutInMilliseconds: 1000);
                    break;
            }            
            return originalValue;
        }

       

        private void CheckPreviouslySavedParametersAndNewControlParametersAreEquality(Dictionary<string, string> previouslySavedControlParameterValues, Dictionary<string, string> newControlParameterValues, List<string> factoryDefaultsList)
        {
            foreach (string savedControlParameterSetting in previouslySavedControlParameterValues.Keys)
            {
                this.controlParameterSetting = savedControlParameterSetting;

                if (newControlParameterValues.ContainsKey(this.controlParameterSetting))
                {
                    var previouslySavedControlParameterValue = previouslySavedControlParameterValues[this.controlParameterSetting];
                    var newControlParameterValue = newControlParameterValues[this.controlParameterSetting];

                    CheckControlParameterValuesAreEquality(previouslySavedControlParameterValue, newControlParameterValue, IsInFactoryDefaultsList(factoryDefaultsList));
                    continue;
                }

                Report.Fail("Controls collection missmatch. Could not find key " + savedControlParameterSetting, true);
            }
        }

        private void CheckControlParameterValuesAreEquality(string previouslySavedControlParameterValue, string newControlParameterValue, bool isInFactoryDefaultsList)
        {
            if (isInFactoryDefaultsList)
            {
                Check.AreNotEqual(previouslySavedControlParameterValue, newControlParameterValue, string.Format("Found different values (old='{0}' and new='{1}') for control {2}.", new object[] { previouslySavedControlParameterValue, newControlParameterValue, controlParameterSetting }), continueOnFail: true, screenshotOnFailure: false);
            }
            else
            {
                Check.AreEqual(previouslySavedControlParameterValue, newControlParameterValue, string.Format("Found same value (old='{0}' and new='{1}') for control {2}.", new object[] { previouslySavedControlParameterValue, newControlParameterValue, controlParameterSetting }), continueOnFail: true, screenshotOnFailure: false);
            }
        }

        private bool IsInFactoryDefaultsList(List<string> factoryDefaultsList)
        {
            return factoryDefaultsList.Contains(controlParameterSetting);
        }

        private void CheckControlsParameterCollectionsCountsAreEqual(int previouslySavedControlParameterValues, int newControlParameterValues)
        {
            Check.IsTrue(newControlParameterValues.Equals(previouslySavedControlParameterValues), "The previously saved control parameters collection and the current control parameters collection contain the same number of items.", continueOnFail: true);
        }

        #endregion Modify Controls - Public

        #region Methods - Modify Controls - Private

        /// <summary>
        /// Get control
        /// </summary>
        /// <param name="parameter">control name</param>
        /// <returns></returns>
        private Control GetControl(string parameter)
        {
            return controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(tuneConfig.GetParameterByName(parameter).Setting)));
        }
        
        //set Sample Cone

        /// <summary>
        /// Modify the default values of all controls from the Tune's page "Source" tab.
        /// The current value will be increased\decreased (for text boxes) or a different option will be selected (dropdowns)
        /// </summary>
        private void PerformActionOnAllTuneSetParameters(string actionType)
        {
            foreach (var parameter in tuneConfig.GetTuneSetParameters)
            {
                if (parameter.Tab.Title.Equals("MS Profile")) continue;
                
                TabControl.Select(parameter.Tab.Title);

                Control ctrl = controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(parameter.Setting)));

                if (ctrl.Enabled)
                {
                    PerformActionOnControl(actionType, ctrl);
                    Report.Screenshot(TabControl.Element);
                }
            }
        }

        private void PerformActionOnControlParametersForSpecificTab(string actionType, string tabName)
        {
            foreach (var parameter in tuneConfig.GetTabParameters(tabName))
            {
                TabControl.Select(parameter.Tab.Title);
                PerformActionOnControl(actionType, controlFactory.Create(AutomationDriver.Driver.FindElement(By.Id(parameter.Setting))));
                Report.Screenshot(TabControl.Element);
            }
        }

        /// <summary>
        /// Perform a read or modify action on the specified control. 
        /// In both cases the dictionary with current controls values is updated.
        /// </summary>
        private void PerformActionOnControl(string actionType, Control control)
        {
            switch (control.ControlType.Name)
            {
                case "TextBox":
                    TextBox textBox = (TextBox)control;
                    if (actionType == CHANGE_VALUE_ACTION_TYPE)
                        ModifyTextBoxValue(textBox);

                    UpdateDictionaryWithCurrentControlValue(textBox.SettingId, textBox.Text);
                    break;

                case "Dropdown":
                    Dropdown dropdown = (Dropdown)control;
                    if (actionType == CHANGE_VALUE_ACTION_TYPE)
                        dropdown.SelectAnotherOptionFromDropdown();

                    UpdateDictionaryWithCurrentControlValue(dropdown.SettingId, dropdown.SelectedOption.Text);
                    break;

                default:
                    Report.Fail("The method does not have an implementation to handle this type of parameter: " + control.ControlType.ToString(), true);
                    break;
            }
        }

        /// <summary>
        /// Changes the string or in case of numbers it will increase the int by 1 and the double by 0.1
        /// In case of maximum allowed value is already setup, the value will be decreased by the doubled unit.
        /// </summary>
        /// <param name="textBox"></param>
        /// <param name="increaseCurrentValue"></param>
        private void ModifyTextBoxValue(TextBox textBox, bool increaseCurrentValue = true)
        {
            string initialValueAsString;
            string updatedValueAsString;
            CalculateValueToEnter(textBox, increaseCurrentValue, out initialValueAsString, out updatedValueAsString);

            Report.Debug("Initial value was: " + initialValueAsString);
            textBox.TrySetText(updatedValueAsString, true);

            if (textBox.Text == initialValueAsString)
            {
                // the control was already set at maximum value
                //instead of trying to increase it, we will decrease it this time to get a different value
                Report.Debug(string.Format("Reached maximum {2} for '{0}' (id='{1}'). Attempting to enter a lower value.", textBox.Label, textBox.SettingId, initialValueAsString));
                CalculateValueToEnter(textBox, false, out initialValueAsString, out updatedValueAsString);

                textBox.TrySetText(updatedValueAsString, true);
                textBox.CheckText(updatedValueAsString);
            }
            else
            {
                textBox.CheckText(updatedValueAsString);
            }

            Report.Debug(string.Format("Changed the value of '{0}' (id='{1}') from {2} to {3}", textBox.Label, textBox.SettingId, initialValueAsString, updatedValueAsString));
        }

        private static void CalculateValueToEnter(TextBox textBox, bool increaseCurrentValue, out string initialValueAsString, out string updatedValueAsString)
        {
            initialValueAsString = textBox.Text;

            int initialValueAsInt;
            int updatedValueAsInt;
            double initialValueAsDouble;
            double updatedValueAsDouble;

            if (Int32.TryParse(initialValueAsString, out initialValueAsInt))
            {
                if (increaseCurrentValue)
                    updatedValueAsInt = initialValueAsInt + 1;
                else
                    updatedValueAsInt = initialValueAsInt - 2;
                updatedValueAsString = updatedValueAsInt.ToString();
            }
            else if (Double.TryParse(initialValueAsString, out initialValueAsDouble))
            {
                if (increaseCurrentValue)
                    updatedValueAsDouble = initialValueAsDouble + 0.1;
                else
                    updatedValueAsDouble = initialValueAsDouble - 0.2;
                updatedValueAsString = updatedValueAsDouble.ToString();
            }
            else
            {
                //not the common scenario, but a string can still be handled to generate a different result
                updatedValueAsString = initialValueAsString + "1";
            }
        }
        /// <summary>
        /// Adds a key-value pair to the dictionary or replaces the existing value.
        /// </summary>
        private void UpdateDictionaryWithCurrentControlValue(string settingsIdKey, string value)
        {
            if (currentControlsValues.ContainsKey(settingsIdKey))
            {
                currentControlsValues.Remove(settingsIdKey);
            }
            currentControlsValues.Add(settingsIdKey, value);

        }
        #endregion Methods - Modify Controls - Private
    }

}