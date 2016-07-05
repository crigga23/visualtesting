using System.Collections.Generic;
using System.Linq;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Page
{
    public class QuadSetupPage : Page
    {
        public QuadSetupPageControls Controls { get; set; }

        public override Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {                  
                    { "Low Mass Resolution", new ControlGroup (() => Controls.LowMassResolutionTextBox ) },
                    { "High Mass Resolution", new ControlGroup (() => Controls.HighMassResolutionTextBox ) },
                    { "Linearity", new ControlGroup (() => Controls.LinearityTextBox ) },
                    { "Low Mass Scale Adjust", new ControlGroup (() => Controls.LowMassScaleAdjustTextBox ) },
                    { "High Mass Scale Adjust", new ControlGroup (() => Controls.HighMassScaleAdjustTextBox ) },
                    { "LM Resolution", new ControlGroup (() => Controls.LMResolutionTextBox ) },
                    { "HM Resolution", new ControlGroup (() => Controls.HMResolutionTextBox ) },
                    { "Ion Energy", new ControlGroup (() => Controls.IonEnergyTextBox ) },
                    { "Mass 1", new ControlGroup (() => Controls.Mass1TextBox ) },
                    { "Mass 2", new ControlGroup (() => Controls.Mass2TextBox ) },
                    { "Mass 3", new ControlGroup (() => Controls.Mass3TextBox ) },
                    { "Mass 4", new ControlGroup (() => Controls.Mass4TextBox ) },
                    { "Span(Da)", new ControlGroup (() => Controls.ScanSetupSpanDropDown ) },
                    { "Time per Step(Sec)", new ControlGroup (() => Controls.ScanSetupTimePerStepDropDown ) },
                    { "No.of Steps", new ControlGroup (() => Controls.ScanSetupNumberOfStepsDropDown ) },
                    { "Detector Window(Da)", new ControlGroup (() => Controls.ScanSetupDetectorWindowDropDown ) },
                    { "Mode", new ControlGroup (() => Controls.QuadModeDropDown ) },
                    { "Polarity", new ControlGroup (() => Controls.QuadPolarityDropDown ) }
                };
            }
        }

        public IReadOnlyCollection<IWebElement> PeakDisplayGraphs
        {
            get { return AutomationDriver.Driver.FindElements(By.ClassName("plotCtrlSize")); }
        }
        public QuadSetupPage()
        {
            Controls = new QuadSetupPageControls(this);
        }
    }
    public class QuadSetupPageControls
    {
        private readonly Page parent;

        private const string QUAD_SETUP_MASS_1_CHECKBOX_SETTING_ID = "qsMass1CheckBox";
        private const string QUAD_SETUP_MASS_2_CHECKBOX_SETTING_ID = "qsMass2CheckBox";
        private const string QUAD_SETUP_MASS_3_CHECKBOX_SETTING_ID = "qsMass3CheckBox";
        private const string QUAD_SETUP_MASS_4_CHECKBOX_SETTING_ID = "qsMass4CheckBox";

        private const string MS_MASS_1_SETTING_ID = "qsMass1TextBox";
        private const string MS_MASS_2_SETTING_ID = "qsMass2TextBox";
        private const string MS_MASS_3_SETTING_ID = "qsMass3TextBox";
        private const string MS_MASS_4_SETTING_ID = "qsMass4TextBox";

        private const string SCAN_SETUP_SPAN_DROP_DOWN_ID = "qsSpan";
        private const string SCAN_SETUP_TIME_PER_STEP_DROP_DOWN_ID = "qsTime";
        private const string SCAN_SETUP_NUMBER_OF_STEPS_DROP_DOWN_ID = "qsNoOfSteps";
        private const string SCAN_SETUP_DETECTOR_WINDOW_DROPDOWN_ID = "qsDetectorWindow";

        private const string RECALL_BUTTON_ID = "qsRecall";
        private const string SAVE_BUTTON_ID = "qsSave";
        private const string DEFAULT_BUTTON_ID = "qsDefault";

        private const string QUAD_MODE_DROPDOWN_ID = "Quad.CalibrationMode.Setting";
        private const string QUAD_POLARITY_DROPDOWN_ID = "Quad.DCPolarity.Setting";
        private const string LOW_MASS_RESOLUTION_SETTING_ID = "Quad.LowMassResolution.Setting";
        private const string HIGH_MASS_RESOLUTION_SETTING_ID = "Quad.ResolutionFine.Setting";
        private const string LINEARITY_SETTING_ID = "Quad.Linearity.Setting";
        private const string LOW_MASS_SCALE_ADJUST_SETTING_ID = "Quad.LowMassScaleAdjust.Setting";
        private const string HIGH_MASS_SCALE_ADJUST_SETTING_ID = "Quad.HighMassScaleAdjust.Setting";
        private const string RECTIFIED_RF_READBACK_ID = "quadRecRFRb.Readback";

        private const string LM_RESOLUTION_SETTING_ID = "Quad.LMResolution.Setting";
        private const string HM_RESOLUTION_SETTING_ID = "Quad.HMResolution.Setting";
        private const string ION_ENERGY_SETTING_ID = "Quad.IonEnergy.Setting";

        private const string QUAD_SETUP_CONTROL_PANEL_ID = "qsControlsPanel";
        private const string QUAD_SETUP_PLOT_PANEL_ID = "qsPlotPanel";
        private const string QUAD_SETUP_PANEL_ID = "qsQuadSetupPanel";

        public QuadSetupPageControls(Page page)
        {
            parent = page;
        }

        #region Controls

        public Checkbox Mass1CheckBox
        {
            get { return new Checkbox(parent.Driver.FindElement(By.Id(QUAD_SETUP_MASS_1_CHECKBOX_SETTING_ID))) { Label = "Mass 1 Checkbox", SettingId = QUAD_SETUP_MASS_1_CHECKBOX_SETTING_ID }; }
        }
        public Checkbox Mass2CheckBox
        {
            get { return new Checkbox(parent.Driver.FindElement(By.Id(QUAD_SETUP_MASS_2_CHECKBOX_SETTING_ID))) { Label = "Mass 2 Checkbox", SettingId = QUAD_SETUP_MASS_2_CHECKBOX_SETTING_ID }; }
        }
        public Checkbox Mass3CheckBox
        {
            get { return new Checkbox(parent.Driver.FindElement(By.Id(QUAD_SETUP_MASS_3_CHECKBOX_SETTING_ID))) { Label = "Mass 3 Checkbox", SettingId = QUAD_SETUP_MASS_3_CHECKBOX_SETTING_ID }; }
        }

        public Checkbox Mass4CheckBox
        {
            get { return new Checkbox(parent.Driver.FindElement(By.Id(QUAD_SETUP_MASS_4_CHECKBOX_SETTING_ID))) { Label = "Mass 4 Checkbox", SettingId = QUAD_SETUP_MASS_4_CHECKBOX_SETTING_ID }; }
        }
        public TextBox Mass1TextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(MS_MASS_1_SETTING_ID))) { Label = "Mass 1 Textbox", SettingId = MS_MASS_1_SETTING_ID }; }
        }
        public TextBox Mass2TextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(MS_MASS_2_SETTING_ID))) { Label = "Mass 2 Textbox", SettingId = MS_MASS_2_SETTING_ID }; }
        }
        public TextBox Mass3TextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(MS_MASS_3_SETTING_ID))) { Label = "Mass 3 Textbox", SettingId = MS_MASS_3_SETTING_ID }; }
        }
        public TextBox Mass4TextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(MS_MASS_4_SETTING_ID))) { Label = "Mass 4 Textbox", SettingId = MS_MASS_4_SETTING_ID }; }
        }
        public Dropdown ScanSetupSpanDropDown
        {
            get { return new Dropdown(parent.Driver.FindElement(By.Id(SCAN_SETUP_SPAN_DROP_DOWN_ID))); }
        }
        public Dropdown ScanSetupTimePerStepDropDown
        {
            get { return new Dropdown(parent.Driver.FindElement(By.Id(SCAN_SETUP_TIME_PER_STEP_DROP_DOWN_ID))); }
        }
        public Dropdown ScanSetupNumberOfStepsDropDown
        {
            get { return new Dropdown(parent.Driver.FindElement(By.Id(SCAN_SETUP_NUMBER_OF_STEPS_DROP_DOWN_ID))); }
        }
        public Dropdown ScanSetupDetectorWindowDropDown
        {
            get { return new Dropdown(parent.Driver.FindElement(By.Id(SCAN_SETUP_DETECTOR_WINDOW_DROPDOWN_ID))); }
        }
        /// <summary>
        /// m/z headers for quad setup plots
        /// </summary>
        public IList<string> PlotHeaders
        {
            get
            {
                IList<string> plotHeaders = new List<string>();

                IList<IWebElement> plotControls = parent.Driver.FindElements(By.ClassName("plot-header")).ToList<IWebElement>();
                foreach (var header in plotControls)
                {
                    string headerText = header.Text;
                    plotHeaders.Add(headerText.Substring(0, headerText.IndexOf(" ")));
                }
                return plotHeaders;
            }
        }
        public Button RecallButton
        {
            get { return new Button(parent.Driver.FindElement(By.Id(RECALL_BUTTON_ID))); }
        }
        public Button SaveButton
        {
            get { return new Button(parent.Driver.FindElement(By.Id(SAVE_BUTTON_ID))); }
        }
        public Button DefaultButton
        {
            get { return new Button(parent.Driver.FindElement(By.Id(DEFAULT_BUTTON_ID))); }
        }
        public Dropdown QuadModeDropDown
        {
            get { return new Dropdown(parent.Driver.FindElement(By.Id(QUAD_MODE_DROPDOWN_ID))); }
        }
        public Dropdown QuadPolarityDropDown
        {
            get { return new Dropdown(parent.Driver.FindElement(By.Id(QUAD_POLARITY_DROPDOWN_ID))); }
        }
        public TextBox LowMassResolutionTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(LOW_MASS_RESOLUTION_SETTING_ID))); }
        }
        public TextBox HighMassResolutionTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(HIGH_MASS_RESOLUTION_SETTING_ID))); }
        }
        public TextBox LinearityTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(LINEARITY_SETTING_ID))); }
        }
        public TextBox LowMassScaleAdjustTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(LOW_MASS_SCALE_ADJUST_SETTING_ID))); }
        }
        public TextBox HighMassScaleAdjustTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(HIGH_MASS_SCALE_ADJUST_SETTING_ID))); }
        }
        public TextBox RectifiedRFTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(RECTIFIED_RF_READBACK_ID))); }
        }
        public TextBox LMResolutionTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(LM_RESOLUTION_SETTING_ID))); }
        }
        public TextBox HMResolutionTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(HM_RESOLUTION_SETTING_ID))); }
        }
        public TextBox IonEnergyTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(ION_ENERGY_SETTING_ID))); }
        }
        /// <summary>
        /// Quad plot panel
        /// </summary>
        public List<IWebElement> QuadPlotPanels
        {
            get
            {
                return parent.Driver.FindElement(By.Id("frame-contentId")).FindElements(By.ClassName("plot")).ToList<IWebElement>();
            }
        }
        public Widget ControlsWidget
        {
            get { return new Widget(parent.Driver.FindElement(By.Id(QUAD_SETUP_CONTROL_PANEL_ID))); }
        }
        public Widget PlotDataWidget
        {
            get { return new Widget(parent.Driver.FindElement(By.Id(QUAD_SETUP_PLOT_PANEL_ID))); }
        }

        public Widget QuadSetupWidget
        {
            get { return new Widget(parent.Driver.FindElement(By.Id(QUAD_SETUP_PANEL_ID))); }
        }

        #endregion Controls
    }
}
