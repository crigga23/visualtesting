using System;
using System.Threading;
using Automation.SystemSupport.Lib;
using Quartz.Support.Views.Page;
using Quartz.Support.Views.TabViews;
using TechTalk.SpecFlow;
using Waters.Control.Client;

namespace Quartz.Features.Calibration.StepDefinitions
{
    [Binding]
    class CalibrationBackgroundSteps
    {
        TunePage tunePage = new TunePage();

        public CalibrationBackgroundSteps()
        {
            if (!FeatureContext.Current.ContainsKey("recordingCreated"))
                FeatureContext.Current.Add("recordingCreated", false);            
        }

        [Given(@"Detector Voltage has been set to (.*)")]
        public void GivenDetectorVoltageHasBeenSetTo(int voltage)
        {
            if ((bool)FeatureContext.Current["recordingCreated"] == false)
            {
                tunePage.ControlsWidget.TabControl.Select("Instrument");
                InstrumentTabView.DetectorVoltageSetting.SetText(voltage.ToString());
            }
        }

        [Given(@"Average Ion Area has been set to (.*)")]
        public void GivenAverageIonAreaHasBeenSetTo(int input)
        {
            if ((bool)FeatureContext.Current["recordingCreated"] == false)
            {
                tunePage.ControlsWidget.TabControl.Select("ADC");
                ADCTab2View.AverageIonIntensitySettingTextBox.SetText(input.ToString());
            }
        }

        [Given(@"I have set positive and negative ADC values")]
        public void GivenIHaveSetPositiveAndNegativeADCValues()
        {
            var hc = TyphoonFactory.Instance.HardwareControl;
            
            var wait = new AutoResetEvent(false);
            if (!hc.IsOnline)
            {
                hc.OnlineEvent += o => wait.Set();
                wait.WaitOne(5000);
            }

            hc.Operate();

            hc.SetMode("Polarity", "Positive");
            hc.Set("TofADC.AverageIonArea.Setting", 25.0);
            hc.Set("TofADC.AverageIonAreaCharge.Setting", 1.0);
            hc.Set("TofADC.AverageIonAreaMZ.Setting", 556.27);

            hc.SetMode("Polarity", "Negative");
            hc.Set("TofADC.AverageIonArea.Setting", 25.0);
            hc.Set("TofADC.AverageIonAreaCharge.Setting", -1.0);
            hc.Set("TofADC.AverageIonAreaMZ.Setting", 554.27);

            wait.WaitOne(20000);             
        }


        [Given(@"a recording has been created of")]
        public void GivenARecordingHasBeenCreatedOf(Table table)
        {
            if ((bool)FeatureContext.Current["recordingCreated"] == false)
            {
                tunePage.SelectTuningMethod("MS");

                foreach (var row in table.Rows)
                {
                    tunePage.ControlsWidget.TabControl.Select("Fluidics");
                    FluidicsTabView.SampleFluidicsReservoirSettingDropdown.SelectOptionFromDropDown(row["Reservoir"]);
                    Wait.ForMilliseconds(10000);

                    tunePage.SwitchConfiguration(null, row["Polarity"]);

                    TunePage.Tuning.StartTuning();

                    var saveName = row["Compound"] + DateTime.Now.ToString("yyyyMMddHmm");
                    TunePage.Tuning.RecordAndSaveAcquisition(10000, saveName);

                    TunePage.Tuning.AbortTuning();

                    FeatureContext.Current.Add(row["Compound"], saveName);
                }
            }
            FeatureContext.Current["recordingCreated"] = true;
        }
    }
}
