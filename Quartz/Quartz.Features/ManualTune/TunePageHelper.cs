using Quartz.Support;
using Quartz.Support.View;
using OpenQA.Selenium;
using System.Threading;
using TechTalk.SpecFlow;

namespace Quartz.Features.Tune_Page
{
    public class TunePageHelper
    {
        QuartzTunePageView tpView;
        TunePageController tpController;
        TunePageTabController tabController;
        QuartzGeneralTabControlView quartzGeneralTabControlView;
        string currentTab;
        string readbackAvailable;
        private IWebElement controlElement;
        private bool isSelected;
        private string isEnabled;

        public TunePageHelper()
        {
            tpView = new QuartzTunePageView();
            tpController = new TunePageController();
            tabController = new TunePageTabController();
            quartzGeneralTabControlView = new QuartzGeneralTabControlView();
        }

        internal void OpenTunePage()
        {
            var tunePageLink = ChromeHelper.Driver.FindElement(By.CssSelector("a[href='#/manualTune']"));
            tunePageLink.Click();
            Thread.Sleep(1000);
        }

        internal IWebElement GetTunePage()
        {
            return tpView.TunePage;
        }

        internal IWebElement GetPlotDataPanel()
        {
            return tpView.PlotDataPanel;
        }

        internal IWebElement GetControlsPanel()
        {
            return tpView.ControlsPanel;
        }


        internal bool ArePanelsAvailable(Table table)
        {
            return tpController.ArePanelsAvailable(table);
        }

        internal bool InstrumentIsInStandByMode()
        {
            return tpController.InstrumentIsInStandByMode();
        }

        internal bool VerifyDropdownValues(string dropdown, string selections)
        {
            string[] expectedSelections = selections.Split(',');
            switch (dropdown)
            {
                case "Factory Defaults":
                    {
                        tpView.FactoryDefaultsDropdown.Click();
                        return tpController.VerifyDropdownValues(tpView.FactoryDefaultsDropdown, expectedSelections, tpView.FactoryDefaultsDropdownElements);

                    }
                case "Aquisition":
                    {
                        tpView.AcquisitionDropdown.Click();
                        return tpController.VerifyDropdownValues(tpView.AcquisitionDropdown, expectedSelections, tpView.AcquisitionDropdownElements);

                    }
                case "User defined tab controls":
                    {
                        quartzGeneralTabControlView.TabOptionsButton.Click();
                        return tpController.GetDropdownValues(quartzGeneralTabControlView.TabOptionsButton, expectedSelections, quartzGeneralTabControlView.TabOptionsList);

                    }
                case "Customize tab view":
                    {
                        quartzGeneralTabControlView.TabVisibileSettingButton.Click();
                        return tpController.GetDropdownValues(quartzGeneralTabControlView.TabVisibileSettingButton, expectedSelections, quartzGeneralTabControlView.TabVisibilityList);

                    }
            }
            return false;
        }

        internal void SelectTab(string tab)
        {
            ChromeHelper.Driver.FindElement(By.CssSelector("a[href='#/manualTune']")).Click();
            tabController.SelectTab(tab);
            currentTab = tab;
        }


        internal string SpecificReadbackIsAvailable()
        {
            return readbackAvailable;
        }

        internal bool SpecificControlIsAvailable(string control)
        {
            switch (control)
            {
                case "Capillary":
                    {
                        readbackAvailable = quartzGeneralTabControlView.SourceTab.CapillaryVoltageReadback != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.SourceTab.CapillaryVoltageSetting != null;

                    }
                case "Sample Cone":
                    {
                        readbackAvailable = quartzGeneralTabControlView.SourceTab.SampleConeVoltageReadback != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.SourceTab.SampleConeVoltageSetting != null;
                    }
                case "Source Offset":
                    {
                        readbackAvailable = quartzGeneralTabControlView.SourceTab.SourceOffsetReadback != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.SourceTab.SourceOffsetSetting != null;
                    }
                case "Source Temperature":
                    {
                        readbackAvailable = quartzGeneralTabControlView.SourceTab.SourceTemperatureReadback != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.SourceTab.SourceTemperatureSetting != null;
                    }
                case "Desolvation Temperature":
                    {
                        readbackAvailable = quartzGeneralTabControlView.SourceTab.DesolvationTemperatureReadback != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.SourceTab.DesolvationTemperatureSetting != null;
                    }
                case "Cone Gas":
                    {
                        readbackAvailable = quartzGeneralTabControlView.SourceTab.ConeGasFlowReadback != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.SourceTab.ConeGasFlowSetting != null;
                    }
                case "Desolvation Gas":
                    {
                        readbackAvailable = quartzGeneralTabControlView.SourceTab.DesolvationGasFlowReadback != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.SourceTab.DesolvationGasFlowSetting != null;
                    }
                case "Reference Capillary":
                    {
                        readbackAvailable = quartzGeneralTabControlView.SourceTab.ReferenceCapillaryReadback != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.SourceTab.ReferenceCapillarySetting != null;
                    }
                case "LM Resolution":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.InstrumentTab.LMResolutionSetting != null;
                    }
                case "HM Resolution":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.InstrumentTab.HMResolutionSetting != null;
                    }
                case "Pre-Filter":
                    {
                        readbackAvailable = quartzGeneralTabControlView.InstrumentTab.PrefilterReadback != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.InstrumentTab.PrefilterSetting != null;

                    }
                case "Ion Energy":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.InstrumentTab.IonEnergySetting != null;
                    }
                case "Collision Energy":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.InstrumentTab.CollisionEnergySetting != null;
                    }
                case "Detector Voltage":
                    {
                        readbackAvailable = quartzGeneralTabControlView.InstrumentTab.DetectorVoltageReadback != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.InstrumentTab.DetectorVoltageSetting != null;
                    }
                case "Acceleration 1":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.AccelerationReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.AccelerationSettingTextBox != null;
                    }
                case "Acceleration 2":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.Acceleration2ReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.Acceleration2SettingTextBox != null;
                    }
                case "Aperture 2":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.Aperture2ReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.Aperture2SettingTextBox != null;
                    }
                case "Transport 1":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.Transport1ReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.Transport1SettingTextBox != null;
                    }
                case "Transport 2":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.Transport2ReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.Transport2SettingTextBox != null;
                    }
                case "Steering":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.SteeringReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.SteeringSettingTextBox != null;
                    }
                case "Tube Lens":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.TubeLensReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.TubeLensSettingTextBox != null;
                    }
                case "Entrance":
                    {
                        if (currentTab == "System1")
                        {
                            readbackAvailable = quartzGeneralTabControlView.System1Tab.EntranceReadbackTextBox != null ? "Yes" : "No";
                            return quartzGeneralTabControlView.System1Tab.EntranceSettingTextBox != null;
                        }
                        else if (currentTab == "T-Wave")
                        {
                            readbackAvailable = quartzGeneralTabControlView.TWaveTab.EntranceOutputOffsetReadbackTextBox != null ? "Yes" : "No";
                            return quartzGeneralTabControlView.TWaveTab.EntranceOutputOffsetSettingTextBox != null;
                        }
                        break;
                    }
                case "Pusher":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.PusherReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.PusherSettingTextBox != null;
                    }
                case "Pusher Offset":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.PusherOffsetReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.PusherOffsetSettingTextBox != null;
                    }
                case "Puller Offset":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.PullerOffsetReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.PullerOffsetSettingTextBox != null;
                    }
                case "Puller":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.PullerReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.PullerSettingTextBox != null;
                    }
                case "Flight Tube":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.FlightTubeReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.FlightTubeSettingTextBox != null;
                    }
                case "Reflectron":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.ReflectronVoltsReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.ReflectronVoltsSettingTextBox != null;
                    }
                case "Reflectron Grid":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System1Tab.ReflectronGridVoltsReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System1Tab.ReflectronGridVoltsSettingTextBox != null;
                    }
                case "Collector":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System2Tab.CollectorReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System2Tab.CollectorSettingTextBox != null;
                    }
                case "Collector Pulse":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.System2Tab.CollectorPulseSettingTextBox != null;
                    }
                case "Stopper":
                    {
                        readbackAvailable = quartzGeneralTabControlView.System2Tab.StoppperReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.System2Tab.StopperSettingTextBox != null;
                    }
                case "Stopper Pulse":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.System2Tab.StopperPulseSettingTextBox != null;
                    }
                case "pDRE Attentuation":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.System2Tab.pDREAttenuateDropdown != null;
                    }
                case "pDRE Transmission":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.System2Tab.TransmissionSettingTextBox != null;
                    }
                case "Interscan Time":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.System2Tab.InterScanTimeSettingTextBox != null;
                    }
                case "Baseline Threshold":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.ADC_Tab.BaselineThresholdSettingTextBox != null;
                    }
                case "Amplitude threshold":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.ADC_Tab.AmplitudeThresholdSettingTextBox != null;
                    }
                case "Ion Area threshold":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.ADC_Tab.IonAreaThresholdSettingTextBox != null;
                    }
                case "T0":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.ADC_Tab.T0SettingTextBox != null;
                    }
                case "Veff":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.ADC_Tab.VeffSettingTextBox != null;
                    }
                case "Trigger Threshold":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.ADC_Tab.TriggerVoltageSettingTextBox != null;
                    }
                case "Centroid threshold":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.ADC_Tab.CentroidThresholdSettingTextBox != null;
                    }
                case "Ion Area Offset":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.ADC_Tab.IonAreaOffsetSettingTextBox != null;
                    }
                case "Average Single Ion Intensity":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.ADC_Tab.AverageIonIntensitySettingTextBox != null;
                    }
                case "Measured m/z":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.ADC_Tab.AverageIonAreaMZSettingTextBox != null;
                    }
                case "Measures charge":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.ADC_Tab.AverageIonAreaChargeSettingTextBox != null;
                    }
                case "1. Mass":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.MSProfileTab.MSMass1SettingTextBox != null;
                    }
                case "1. Dwell Time":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.MSProfileTab.MSDwellTime1SettingTextBox != null;
                    }
                case "1. Ramp Time":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.MSProfileTab.MSTime1SettingTextBox != null;
                    }
                case "2. Mass":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.MSProfileTab.MSMass2SettingTextBox != null;
                    }
                case "2. Dwell Time":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.MSProfileTab.MSDwellTime2SettingTextBox != null;
                    }
                case "2. Ramp Time":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.MSProfileTab.MSTime2SettingTextBox != null;
                    }
                case "3. Mass":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.MSProfileTab.MSMass3SettingTextBox != null;
                    }
                case "StepWave Offset":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.StepwaveTab.SW2OffsetSettingTextBox != null;
                    }
                case "Diff Ap 1":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.StepwaveTab.Aperture1SettingTextBox != null;
                    }
                case "Diff Ap 2":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.StepwaveTab.Aperture2SettingTextBox != null;
                    }
                case "SW 1 Velocity":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.StepwaveTab.Twave1InVelocitySettingTextBox != null;
                    }
                case "SW 1 Pulse Height":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.StepwaveTab.Twave1InPulseHeightSettingTextBox != null;
                    }
                case "SW 2 Velocity":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.StepwaveTab.Twave1OutVelocitySettingTextBox != null;
                    }
                case "SW2 Pulse Height":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.StepwaveTab.Twave1OutPulseHeightSettingTextBox != null;
                    }
                case "IG Velocity":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.StepwaveTab.Twave2VelocitySettingTextBox != null;
                    }
                case "IG Pulse Height":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.StepwaveTab.Twave2HeightSettingTextBox != null;
                    }
                case "StepWave RF":
                    {
                        readbackAvailable = quartzGeneralTabControlView.StepwaveTab.RFOffsetReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.StepwaveTab.RFOffsetSettingTextBox != null;
                    }
                case "Ion Guide RF":
                    {
                        readbackAvailable = quartzGeneralTabControlView.StepwaveTab.IonGuideRFReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.StepwaveTab.IonGuideRFSettingTextBox != null;
                    }
                case "Exit":
                    {
                        readbackAvailable = quartzGeneralTabControlView.TWaveTab.ExitOutputOffsetSettingTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.TWaveTab.ExitOutputOffsetReadbackTextBox != null;
                    }
                case "Static Offset":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.TWaveTab.CollisionStaticOffsetSettingTextBox != null;
                    }
                case "Cell RF":
                    {
                        readbackAvailable = quartzGeneralTabControlView.TWaveTab.TwigRFOffsetReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.TWaveTab.TrappingVoltageSettingTextBox != null;
                    }
                case "Wave Velocity":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.TWaveTab.VelocitySettingTextBox != null;
                    }
                case "Wave Height":
                    {
                        readbackAvailable = quartzGeneralTabControlView.TWaveTab.PulseHeightReadbackTextBox != null ? "Yes" : "No";
                        return quartzGeneralTabControlView.TWaveTab.PulseHeightSettingTextBox != null;
                    }
                case "Trap Height":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.TWaveTab.TrappingVoltageSettingTextBox != null;
                    }
                case "Extract Height":
                    {
                        readbackAvailable = "No";
                        return quartzGeneralTabControlView.TWaveTab.ExtractionVoltageSettingTextBox != null;
                    }
            }
            return false;
        }

        internal void InspectElements(string element)
        {
            switch (element)
            {
                case "Pop Out button":
                    {
                        controlElement = tpView.PopOutButton;
                        isEnabled = tpView.PopOutButton.Enabled.ToString();
                        isSelected = tpView.PopOutButton.Selected;
                        break;
                    }
                case "Start button":
                    {
                        controlElement = tpView.StartButton;
                        isEnabled = tpView.StartButton.Enabled.ToString();
                        isSelected = tpView.StartButton.Selected;
                        break;
                    }
                case "Stop button":
                    {
                        controlElement = tpView.StopButton;
                        isEnabled = tpView.StopButton.Enabled.ToString();
                        isSelected = tpView.StopButton.Selected;
                        break;
                    }
                case "Save Set button":
                    {
                        controlElement = tpView.SaveSetButton;
                        isEnabled = tpView.SaveSetButton.Enabled.ToString();
                        isSelected = tpView.SaveSetButton.Selected;
                        break;
                    }
                case "Load Set button":
                    {
                        controlElement = tpView.LoadSetButton;
                        isEnabled = tpView.LoadSetButton.Enabled.ToString();
                        isSelected = tpView.LoadSetButton.Selected;
                        break;
                    }
                case "Load  button":
                    {
                        controlElement = tpView.LoadButton;
                        isEnabled = tpView.LoadButton.Enabled.ToString();
                        isSelected = tpView.LoadButton.Selected;
                        break;
                    }
                case "Factory defaults dropdown":
                    {
                        controlElement = tpView.FactoryDefaultsDropdown;
                        isEnabled = tpView.FactoryDefaultsDropdown.Enabled.ToString();
                        isSelected = tpView.FactoryDefaultsDropdown.Selected;
                        break;
                    }
                case "Aquisition dropdown":
                    {
                        controlElement = tpView.AcquisitionDropdown;
                        isEnabled = tpView.AcquisitionDropdown.Enabled.ToString();
                        isSelected = tpView.AcquisitionDropdown.Selected;
                        break;
                    }
                case "Tune button":
                    {
                        controlElement = tpView.TuneButton;
                        isEnabled = tpView.TuneButton.Enabled.ToString();
                        isSelected = tpView.TuneButton.Selected;
                        break;
                    }
                case "Abort button":
                    {
                        controlElement = tpView.AbortButton;
                        isEnabled = tpView.AbortButton.Enabled.ToString();
                        isSelected = tpView.AbortButton.Selected;
                        break;
                    }
                case "Scan Data Graph":
                    {
                        controlElement = tpView.ScanDataGraph;
                        isEnabled = tpView.ScanDataGraph.Enabled.ToString();
                        isSelected = tpView.ScanDataGraph.Selected;
                        break;
                    }
                case "MZ button":
                    {
                        controlElement = tpView.MZButton;
                        isEnabled = tpView.MZButton.Enabled.ToString();
                        isSelected = controlElement.GetAttribute("class") == "btn ng-isolate-scope ng-binding active";
                        break;
                    }
                case "DT button":
                    {
                        controlElement = tpView.DTButton;
                        isEnabled = tpView.DTButton.Enabled.ToString();
                        isSelected = controlElement.GetAttribute("class") == "btn ng-isolate-scope ng-binding active";
                        break;
                    }
                case "BPI button":
                    {
                        controlElement = tpView.BPIButton;
                        isEnabled = tpView.BPIButton.Enabled.ToString();
                        isSelected = controlElement.GetAttribute("class") == "btn ng-isolate-scope ng-binding active";
                        break;
                    }
                case "TIC button":
                    {
                        controlElement = tpView.TICButton;
                        isEnabled = tpView.TICButton.Enabled.ToString();
                        isSelected = controlElement.GetAttribute("class") == "btn ng-isolate-scope ng-binding active";
                        break;
                    }
                case "RB button":
                    {
                        controlElement = tpView.RBButton;
                        isEnabled = tpView.RBButton.Enabled.ToString();
                        isSelected = controlElement.GetAttribute("class") == "btn ng-isolate-scope ng-binding active";
                        break;
                    }
                case "PP button":
                    {
                        controlElement = tpView.PPButton;
                        isEnabled = tpView.PPButton.Enabled.ToString();
                        isSelected = controlElement.GetAttribute("class") == "btn ng-isolate-scope ng-binding active";
                        break;
                    }
                case "Clear button":
                    {
                        controlElement = tpView.ClearButton;
                        isEnabled = tpView.ClearButton.Enabled.ToString();
                        isSelected = controlElement.GetAttribute("class") == "btn ng-binding active";
                        break;
                    }

                case "Normalise On button":
                    {
                        controlElement = tpView.NormalizeButton;
                        isEnabled = tpView.NormalizeButton.Enabled.ToString();
                        isSelected = controlElement.GetAttribute("class") == "btn pull-right ng-binding active";
                        break;
                    }
                case "Positive button":
                    {
                        controlElement = tpView.PositiveModeButton;
                        isEnabled = tpView.PositiveModeButton.Enabled.ToString();
                        isSelected = tpView.PositiveModeButton.Selected;
                        break;
                    }
                case "Negative button":
                    {
                        controlElement = tpView.NegativeModeButton;
                        isEnabled = tpView.NegativeModeButton.Enabled.ToString();
                        isSelected = tpView.NegativeModeButton.Selected;
                        break;
                    }
                case "Resoution button":
                    {
                        controlElement = tpView.ResolutionButton;
                        isEnabled = tpView.ResolutionButton.Enabled.ToString();
                        isSelected = tpView.ResolutionButton.Selected;
                        break;
                    }
                case "Sensitivity button":
                    {
                        controlElement = tpView.SensitivityButton;
                        isEnabled = tpView.SensitivityButton.Enabled.ToString();
                        isSelected = tpView.SensitivityButton.Selected;
                        break;
                    }
                case "API Gas button":
                    {
                        controlElement = tpView.APIGasButton;
                        isEnabled = tpView.APIGasButton.Enabled.ToString();
                        isSelected = tpView.APIGasButton.Selected;
                        break;
                    }
                case "Collision Gas button":
                    {
                        controlElement = tpView.CollisionGasButton;
                        isEnabled = tpView.CollisionGasButton.Enabled.ToString();
                        isSelected = tpView.CollisionGasButton.Selected;
                        break;
                    }
                case "Operate button":
                    {
                        controlElement = tpView.OperateButton;
                        isEnabled = tpView.OperateButton.Enabled.ToString();
                        isSelected = tpView.OperateButton.Selected;
                        break;
                    }
                case "Source button":
                    {
                        controlElement = tpView.SourceButton;
                        isEnabled = tpView.SourceButton.Enabled.ToString();
                        isSelected = tpView.SourceButton.Selected;
                        break;
                    }
                case "Standby button":
                    {
                        controlElement = tpView.StandByButton;
                        isEnabled = tpView.StandByButton.Enabled.ToString();
                        isSelected = tpView.StandByButton.Selected;
                        break;
                    }
                case "Instrument Status colour":
                    {
                        controlElement = tpView.OperateStatus;
                        //isEnabled = tpView.OperateStatus.GetAttribute("style");
                        //isEnabled = GetTheFilledColour(tpView.OperateStatus.GetAttribute("style"));
                        isSelected = tpView.OperateStatus.Selected;
                        break;
                    }
                case "Source tab":
                    {
                        IWebElement el = tabController.GetTabElement("Source");
                        controlElement = el.FindElement(By.TagName("a"));
                        isEnabled = controlElement.Enabled.ToString();
                        isSelected = el.GetAttribute("class") == "ng-scope active";
                        break;
                    }
                case "Instrument tab":
                    {
                        IWebElement el = tabController.GetTabElement("Instrument");
                        controlElement = el.FindElement(By.TagName("a"));
                        isEnabled = controlElement.Enabled.ToString();
                        isSelected = el.GetAttribute("class") == "ng-scope active";
                        break;
                    }
                case "Fluidics tab":
                    {
                        IWebElement el = tabController.GetTabElement("Fluidics");
                        controlElement = el.FindElement(By.TagName("a"));
                        isEnabled = controlElement.Enabled.ToString();
                        isSelected = el.GetAttribute("class") == "ng-scope active";
                        break;
                    }
                case "System1 button":
                    {
                        IWebElement el = tabController.GetTabElement("System1");
                        controlElement = el.FindElement(By.TagName("a"));
                        isEnabled = controlElement.Enabled.ToString();
                        isSelected = el.GetAttribute("class") == "ng-scope active";
                        break;
                    }
                case "System2 button":
                    {
                        IWebElement el = tabController.GetTabElement("System2");
                        controlElement = el.FindElement(By.TagName("a"));
                        isEnabled = controlElement.Enabled.ToString();
                        isSelected = el.GetAttribute("class") == "ng-scope active";
                        break;
                    }
                case "ADC button":
                    {
                        IWebElement el = tabController.GetTabElement("ADC");
                        controlElement = el.FindElement(By.TagName("a"));
                        isEnabled = controlElement.Enabled.ToString();
                        isSelected = el.GetAttribute("class") == "ng-scope active";
                        break;
                    }
                case "MS Profile button":
                    {
                        IWebElement el = tabController.GetTabElement("MS Profile");
                        controlElement = el.FindElement(By.TagName("a"));
                        isEnabled = controlElement.Enabled.ToString();
                        isSelected = el.GetAttribute("class") == "ng-scope active";
                        break;
                    }
                case "StepWave button":
                    {
                        IWebElement el = tabController.GetTabElement("StepWave");
                        controlElement = el.FindElement(By.TagName("a"));
                        isEnabled = controlElement.Enabled.ToString();
                        isSelected = el.GetAttribute("class") == "ng-scope active";
                        break;
                    }
                case "T-Wave button":
                    {
                        IWebElement el = tabController.GetTabElement("T-Wave");
                        controlElement = el.FindElement(By.TagName("a"));
                        isEnabled = controlElement.Enabled.ToString();
                        isSelected = el.GetAttribute("class") == "ng-scope active";
                        break;
                    }
                case "Gear icon":
                    {
                        controlElement = quartzGeneralTabControlView.TabOptionsButton;
                        isEnabled = quartzGeneralTabControlView.TabOptionsButton.Enabled.ToString();
                        isSelected = quartzGeneralTabControlView.TabOptionsButton.Selected;
                        break;
                    }
                case "List icon":
                    {
                        controlElement = quartzGeneralTabControlView.TabVisibileSettingButton;
                        isEnabled = quartzGeneralTabControlView.TabVisibileSettingButton.Enabled.ToString();
                        isSelected = quartzGeneralTabControlView.TabVisibileSettingButton.Selected;
                        break;
                    }

            }
        }

        //private string GetTheFilledColour(string style)
        //{
        //    string str = "";
        //    if(style.Contains("stroke: rgb(0, 102, 0); fill: "))
        //        str = style.Replace("stroke: rgb(0, 102, 0); fill: ", " ").Trim().TrimEnd(';');
        //    //isEnabled.Replace("stroke: rgb(0, 102, 0); fill: ", " ").Trim().TrimEnd(';');
        //    string[] strArray = str.Split('(');
        //    string rgbString = strArray[1].TrimEnd(')');

        //    string[] rgbValues = rgbString.Split(',');

        //    System.Drawing.Color color = System.Drawing.Color.FromArgb(Convert.ToInt32(rgbValues[0]), Convert.ToInt32(rgbValues[1]), Convert.ToInt32(rgbValues[2]));
        //    Color colour = (Color)System.Windows.Media.ColorConverter.ConvertFromString("#"+color.Name);
        //    return colour.ToString();
        //}

        public IWebElement ControlElement
        {
            get
            {
                return controlElement;
            }
        }

        public string IsSelected
        {
            get
            {
                if (isSelected)
                    return "Selected";
                else
                return "Unselected";
            }
        }

        public string IsEnabled
        {
            get
            {
                if (isEnabled == "True")
                    return "Enabled";
                else if (isEnabled == "Red")
                    return "Red";
                else if (isEnabled == "False")
                    return "Disabled";

                return string.Empty;
            }
        }

    }
}
