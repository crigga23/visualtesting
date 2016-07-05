using System;
using System.Collections.Generic;
using System.Linq;
using System.Timers;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Page
{
    public class VacuumPage : Page
    {
        public VacuumPageControls Controls { get; set; }

        private readonly Timer Timer = new Timer();
        public const string PumpedMessage = "Instrument pumped";
        public const string VentedMessage = "Venting: Vent valve open";

        public VacuumPage()
        {
            Controls = new VacuumPageControls(this);
        }

        #region Methods

        public void CheckVacuumStatus(string expectedStatus)
        {
            Check.AreEqual(expectedStatus.ToLower(), Controls.VacuumStatusTextBox.Text.ToLower(), "The Vacuum Status is " + expectedStatus);
            Report.Screenshot(Controls.StatusWidget.Element);
        }
        public void CheckAllTuboSpeedGaugesInZone(string startRegion)
        {
            foreach (var gauge in Controls.TurboSpeedGauges)
            {
                Report.Action(string.Format("Check the '{0}' pointer is in the '{1}' region", gauge.ControlText, startRegion));
                gauge.CheckPointerIsInZone(startRegion);
            }
        }

        /// <summary>
        /// Monitor the percentage change until reach the end percent
        /// </summary>
        /// <param name="endPercent">stops monitoring the percent when ALL gauges reach this value</param>
        /// <returns>List of percentages over time for each gauge</returns>
        public Dictionary<string, List<int>> MonitorTurboSpeedGaugePercentages(int endPercent)
        {
            Dictionary<string, List<int>> gaugePercentages = new Dictionary<string, List<int>>();

            // Make an initial check of each Turbo Speed Gauge
            foreach (var gauge in Controls.TurboSpeedGauges)
            {
                gaugePercentages.Add(gauge.ControlText, new List<int>() { gauge.PercentText });
            }

            Timer.Elapsed += timer_Elapsed;
            Timer.Interval = 180000;
            Timer.Start();

            // keep checking percentages of Turbo Speed gauges until all are at endPercent
            List<Gauge> gaugesReachedEnd = new List<Gauge>();
            do
            {
                foreach (var gauge in Controls.TurboSpeedGauges)
                {
                    var percent = gauge.PercentText;
                    gaugePercentages[gauge.ControlText].Add(percent);

                    if (percent == endPercent)
                    {
                        // Add the gauge to the list if it does not already exist
                        if (gaugesReachedEnd.Where(g => g.ControlText == gauge.ControlText).Count() == 0)
                            gaugesReachedEnd.Add(gauge);
                    }
                }
            }
            while (Timer.Enabled && gaugesReachedEnd.Distinct().ToList<Gauge>().Count < Controls.TurboSpeedGauges.Count);

            Timer.Stop();
            return gaugePercentages;
        }

        private void timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            Timer.Enabled = false;
        }

        public void CheckGaugeIsAvailable(string automationId, string message, bool continueOnFail = false)
        {
            var elements = AutomationDriver.Driver.FindElements(By.Id(automationId));
            Check.IsTrue(elements.Count > 0, message, continueOnFail);
            Report.Screenshot(elements);
        }

        public void CheckGaugeIsAvailable(string gaugeCaption)
        {
            CheckGaugeIsAvailable(gaugeCaption, Controls.AllGauges);
        }

        public void CheckGaugeIsAvailable(string gaugeCaption, List<Gauge> gauges)
        {
            Report.Action(string.Format("Check '{0}' gauge is displayed", gaugeCaption));
            Check.IsTrue(gauges.Any(p => p.ControlText == gaugeCaption), string.Format("Gauge {0} control exists", gaugeCaption));
            Report.Screenshot();
        }

        public Gauge FindGaugeByLabel(string label)
        {
            return Controls.AllGauges.FirstOrDefault(g => g.ControlText == label);
        }

        public Gauge GetTurboSpeedGauge(string gaugeLabel)
        {
            return Controls.TurboSpeedGauges.FirstOrDefault(g => g.ControlText == gaugeLabel);
        }

        public Gauge GetPressureGauge(string gaugeLabel)
        {
            return Controls.PressureGauges.FirstOrDefault(g => g.ControlText == gaugeLabel);
        }

        public string GetWarningDisplayed()
        {
            Report.Screenshot();
            if (Controls.PumpOverrideStatusPanel != null)
            {
                return Controls.PumpOverrideWarningText;
            }
            return "N/A (No Warning)";
        }

        public void WaitForVacuumStatus(string status, int timeoutInMilliseconds = 120000)
        {
            Wait.Until(f => Controls.VacuumStatusTextBox.Text.ToLower() == status.ToLower(), timeoutInMilliseconds, string.Format("Waiting for Vacuum Status to be '{0}'", status));
        }

        public void WaitForVacuumToStopPumpingOrVenting(int timeoutInMilliseconds = 120000)
        {
            Wait.Until(f => Controls.VacuumStatusTextBox.Text.ToLower() == PumpedMessage.ToLower() || Controls.VacuumStatusTextBox.Text.ToLower() == VentedMessage.ToLower(), timeoutInMilliseconds, "Waiting for the vacuum to stop venting or pumping");
        }

        public void SetSimulatorVacuumState(string vacuumState)
        {
            // unable to Vent manually if pump override is on, so must turn it off
            SetSimulatorPumpOverrideState("Not Active");

            Report.Debug("Setting the vacuum state to " + vacuumState);
            Report.Debug("The current vacuum state is " + Controls.VacuumStatusTextBox.Text);

            if (vacuumState.ToLower() == PumpedMessage.ToLower() || vacuumState.ToLower() == "pumped")
            {
                if (Controls.VacuumStatusTextBox.Text.ToLower() != PumpedMessage.ToLower())
                {
                    var button = Controls.PumpInstrumentButton;
                    button.CheckCaption("Pump Instrument");
                    button.Click();
                    WaitForVacuumStatus(PumpedMessage);
                }

                Report.Debug("The vacuum state is already " + vacuumState + ". No action taken");
                Report.Screenshot(Controls.StatusWidget.Element);
            }
            else if (vacuumState.ToLower() == VentedMessage.ToLower() || vacuumState.ToLower() == "vented")
            {
                if (Controls.VacuumStatusTextBox.Text.ToLower() != VentedMessage.ToLower())
                {
                    var button = Controls.PumpInstrumentButton;
                    button.CheckCaption("Vent Instrument");
                    button.Click();
                    WaitForVacuumStatus(VentedMessage);
                }

                Report.Debug("The vacuum state is already " + vacuumState + ". No action taken");
                Report.Screenshot(Controls.StatusWidget.Element);
            }
            else
            {
                throw new NotImplementedException("Vacuum state not implemented");
            }
        }


        public void SetSimulatorPumpOverrideState(string pumpOverrideStatus)
        {
            var currentState = TyphoonHelper.GetKeyValueStoreParameterValue("Simulator", "Simulation.PumpState");

            if (pumpOverrideStatus == "Not Active" || pumpOverrideStatus == "Auto")
            {
                if (currentState != "Auto")
                {
                    TyphoonHelper.SetKeyValueStoreParameterValue("Simulator", "Simulation.PumpState", "Auto");
                }
            }
            else if (pumpOverrideStatus == "Active")
            {
                if (currentState != "Override")
                {
                    TyphoonHelper.SetKeyValueStoreParameterValue("Simulator", "Simulation.PumpState", "Override");
                }
            }
            else
            {
                throw new NotImplementedException("Pump Override status not implemented");
            }

            Wait.ForMilliseconds(500);
        }


        #endregion Methods

        public void CheckReadbackControlExistsByLabel(string controlLabel)
        {
            Report.Action(string.Format("Check '{0}' exists on the screen", controlLabel));
            var element = Controls.SourceReadBackTextBox.Element;

            switch (controlLabel)
            {
                case "Source":
                    // TODO: refactor this Control.CheckDisplayed() so Controls.SourceReadBackTextBox.CheckDisplayed() can be used
                    element = Controls.SourceReadBackTextBox.Element;
                    Check.IsTrue(element.Displayed, "The Source readback control is displayed", true);
                    break;
                case "TOF":
                    element = Controls.TOFReadBackTextBox.Element;
                    Check.IsTrue(element.Displayed, "The TOF readback control is displayed", true);
                    break;
            }

            Report.Screenshot(element);
        }
    }

    public class VacuumPageControls
    {
        private readonly Page parent;
        public VacuumPageControls(Page page) { parent = page; }

        #region Control Constants

        private const string PRESSURE_GAUGES_PANEL_ID = "vacuumPressures";
        private const string TURBO_SPEED_GAUGES_PANEL_ID = "vacuumTurboSpeed";
        private const string TURBO_OPERATION_TIMES_PANEL_ID = "vacuumTurboOpnTime";
        private const string SOURCE_TURBO_OPERATION_TIMES_TEXTBOX_ID = "Vacuum.SourceTurboOperationTime.Readback";
        private const string TOF_TURBO_OPERATION_TIMES_TEXTBOX_ID = "Vacuum.TofTurboOperationTime.Readback";
        private const string QUADRUPOLE_TURBO_OPERATION_TIMES_TEXTBOX_ID = "Vacuum.QuadrupoleTurboOperationTime.Readback";

        private const string VACUUM_STATUS_TEXTBOX_ID = "pumpingStatusRb.Readback";
        private const string PUMP_OVERRIDE_WARNING_PANEL_ID = "vacuumAlert";
        private const string PUMP_VENT_BUTTON_ID = "Instrument.Vacuum.Setting";

        private const string BACKING_GAUGE_ID = "Vacuum.BackingPirani.Readback";
        private const string IMS_GAUGE_ID = "Vacuum.IMSPirani.Readback";
        private const string ION_GUIDE_GAUGE_ID = "Vacuum.SourcePirani.Readback";
        private const string CELL_1_GAUGE_ID = "Vacuum.Cell1Pirani.Readback";
        private const string CELL_2_GAUGE_ID = "Vacuum.Cell2Pirani.Readback";
        private const string TOF_PRESSURE_GAUGE_ID = "Vacuum.TofPenning.Readback";
        private const string SOURCE_TURBO_SPEED_GAUGE_ID = "Vacuum.SourceTurboSpeed.Readback";
        private const string QUADRUPOLE_TURBO_SPEED_GAUGE_ID = "Vacuum.QuadrupoleTurboSpeed.Readback";
        private const string TOF_TURBO_SPEED_GAUGE = "Vacuum.TofTurboSpeed.Readback";

        private const string PUMP_OVERRIDE_WARNING_TEXT_ID = "manualPumpOverrideStatus.Readback";
        private const string STATUS_PANEL_ID = "vacuumStatus";

        #endregion Control Constants

        #region Controls

        public List<Gauge> AllGauges
        {
            get
            {
                var gauges = new List<Gauge>();
                foreach (var gauge in parent.Driver.FindElements(By.TagName("gauge-ctrl")))
                {
                    gauges.Add(new Gauge(gauge));
                }
                return gauges;
            }
        }

        public List<Gauge> PressureGauges
        {
            get
            {
                var gauges = new List<Gauge>();
                foreach (var gauge in parent.Driver.FindElement(By.Id(PRESSURE_GAUGES_PANEL_ID)).FindElements(By.TagName("gauge-ctrl")))
                {
                    gauges.Add(new Gauge(gauge));
                }
                return gauges;
            }
        }

        public List<Gauge> TurboSpeedGauges
        {
            get
            {
                var gauges = new List<Gauge>();
                foreach (var gauge in parent.Driver.FindElement(By.Id(TURBO_SPEED_GAUGES_PANEL_ID)).FindElements(By.TagName("gauge-ctrl")))
                {
                    gauges.Add(new Gauge(gauge));
                }
                return gauges;
            }
        }

        public List<TextBox> TurboOperationTimeSections
        {
            get
            {
                var turboOperationTimesSections = new List<TextBox>();
                foreach (var section in parent.Driver.FindElement(By.Id(TURBO_OPERATION_TIMES_PANEL_ID)).FindElements(By.ClassName("watRow")))
                {
                    turboOperationTimesSections.Add(new TextBox(section));
                }
                return turboOperationTimesSections;
            }
        }

        public TextBox SourceReadBackTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(SOURCE_TURBO_OPERATION_TIMES_TEXTBOX_ID))); }
        }
        public TextBox TOFReadBackTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(TOF_TURBO_OPERATION_TIMES_TEXTBOX_ID))); }
        }

        public TextBox SourcePowerReadback
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id("Vacuum.SourceTurboPower.Readback"))); }
        }
        public TextBox SourceTemperatureReadback
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id("Vacuum.SourceTurboTemp.Readback"))); }
        }
        public TextBox TOFPowerReadback
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id("Vacuum.TofTurboPower.Readback"))); }
        }
        public TextBox TOFTemperatureReadback
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id("Vacuum.TofTurboTemp.Readback"))); }
        }

        public TextBox QuadrupoleReadBackTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(QUADRUPOLE_TURBO_OPERATION_TIMES_TEXTBOX_ID))); }
        }
        public Widget StatusWidget
        {
            get { return new Widget(AutomationDriver.Driver.FindElement(By.Id(STATUS_PANEL_ID))); }
        }
        public Widget PressuresWidget
        {
            get { return new Widget(AutomationDriver.Driver.FindElement(By.Id(PRESSURE_GAUGES_PANEL_ID))); }
        }
        public Widget TurboSpeedWidget
        {
            get { return new Widget(AutomationDriver.Driver.FindElement(By.Id(TURBO_SPEED_GAUGES_PANEL_ID))); }
        }
        public Widget TurboOperationTimeWidget
        {
            get { return new Widget(AutomationDriver.Driver.FindElement(By.Id(TURBO_OPERATION_TIMES_PANEL_ID))); }
        }
        public TextBox VacuumStatusTextBox
        {
            get { return new TextBox(parent.Driver.FindElement(By.Id(VACUUM_STATUS_TEXTBOX_ID))); }
        }
        public IWebElement PumpOverrideStatusPanel
        {
            get { return parent.Driver.FindElement(By.Id(PUMP_OVERRIDE_WARNING_PANEL_ID)); }
        }
        public string PumpOverrideWarningText
        {
            get { return parent.Driver.FindElement(By.Id(PUMP_OVERRIDE_WARNING_TEXT_ID)).Text; }
        }
        public Button PumpInstrumentButton
        {
            get { return new Button(parent.Driver.FindElement(By.Id(PUMP_VENT_BUTTON_ID))); }
        }

        public InstrumentControlWidget ControlsWidget
        {
            get { return new InstrumentControlWidget(); }
        }

        #endregion Controls

        #region Gauges
        public Gauge BackingPressuresGauge
        {
            get { return new Gauge(parent.Driver.FindElement(By.Id(BACKING_GAUGE_ID))); }
        }
        public Gauge IMSPressuresGauge
        {
            get { return new Gauge(parent.Driver.FindElement(By.Id(IMS_GAUGE_ID))); }
        }
        public Gauge IonGuidePressuresGauge
        {
            get { return new Gauge(parent.Driver.FindElement(By.Id(ION_GUIDE_GAUGE_ID))); }
        }
        public Gauge Cell1PressuresGauge
        {
            get { return new Gauge(parent.Driver.FindElement(By.Id(CELL_1_GAUGE_ID))); }
        }
        public Gauge Cell2PressuresGauge
        {
            get { return new Gauge(parent.Driver.FindElement(By.Id(CELL_2_GAUGE_ID))); }
        }
        public Gauge TofPressuresGauge
        {
            get { return new Gauge(parent.Driver.FindElement(By.Id(TOF_PRESSURE_GAUGE_ID))); }
        }
        public Gauge SourceTurboSpeedGauge
        {
            get { return new Gauge(parent.Driver.FindElement(By.Id(SOURCE_TURBO_SPEED_GAUGE_ID))); }
        }
        public Gauge QuadrupoleTurboSpeedGauge
        {
            get { return new Gauge(parent.Driver.FindElement(By.Id(QUADRUPOLE_TURBO_SPEED_GAUGE_ID))); }
        }
        public Gauge TofTurboSpeedGauge
        {
            get { return new Gauge(parent.Driver.FindElement(By.Id(TOF_TURBO_SPEED_GAUGE))); }
        }
        #endregion

    }
}
