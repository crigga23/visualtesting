using System.Collections.Generic;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class System1TabView
    {
        public static Dictionary<string, ControlGroup> ControlDictionary
        {
            get
            {
                return new Dictionary<string, ControlGroup>()
                {                  
                    { "Acceleration 1 (V)", new ControlGroup (() => AccelerationSettingTextBox, () => AccelerationReadbackTextBox ) },
                    { "Acceleration 2 (V)", new ControlGroup (() => Acceleration2SettingTextBox, () => Acceleration2ReadbackTextBox) },
                    { "Aperture 3 (V)", new ControlGroup (() => Aperture3SettingTextBox, () => Aperture3ReadbackTextBox ) },
                    { "Transport 1 (V)", new ControlGroup (() => Transport1SettingTextBox, () => Transport1ReadbackTextBox ) },
                    { "Transport 2 (V)", new ControlGroup (() => Transport2SettingTextBox, () => Transport2ReadbackTextBox ) },
                    { "Steering (V)", new ControlGroup (() => SteeringSettingTextBox, () => SteeringReadbackTextBox ) },
                    { "Tube Lens (V)", new ControlGroup (() => TubeLensSettingTextBox, () => TubeLensReadbackTextBox ) },
                    { "System1 Entrance (V)", new ControlGroup (() => EntranceSettingTextBox, () => EntranceReadbackTextBox ) },
                    { "Pusher (V)", new ControlGroup (() => PusherSettingTextBox, () =>  PusherReadbackTextBox) },
                    { "Pusher Offset (V)", new ControlGroup (() => PusherOffsetSettingTextBox, () => PusherOffsetReadbackTextBox ) },
                    { "Puller (V)", new ControlGroup (() => PullerSettingTextBox, () => PullerReadbackTextBox ) },
                    { "Puller Offset (V)", new ControlGroup (() => PullerOffsetSettingTextBox, () => PullerOffsetReadbackTextBox ) },
                    { "Strike Plate (kV)", new ControlGroup (() => StrikePlateSettingTextBox, () => StrikePlateReadbackTextBox ) },
                    { "Flight Tube (kV)", new ControlGroup (() => FlightTubeSettingTextBox, () => FlightTubeReadbackTextBox ) },
                    { "Reflectron(kV)", new ControlGroup (() => ReflectronVoltsSettingTextBox, () => ReflectronVoltsReadbackTextBox ) },
                    { "Reflectron Grid(kV)", new ControlGroup (() => ReflectronGridVoltsSettingTextBox, () => ReflectronGridVoltsReadbackTextBox ) } 
                };
            }
        }


        #region Controls
        public static TextBox AccelerationSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Acceleration1.Setting"))); }
        }
        public static TextBox AccelerationReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Acceleration1.Readback"))); }
        }
        public static TextBox EntranceSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Entrance.Setting"))); }
        }
        public static TextBox EntranceReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Entrance.Readback"))); }
        }
        public static TextBox Acceleration2SettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Acceleration2.Setting"))); }
        }
        public static TextBox Acceleration2ReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Acceleration2.Readback"))); }
        }
        public static TextBox PusherSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Pusher.Setting"))); }
        }
        public static TextBox PusherReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Pusher.Readback"))); }
        }
        public static TextBox Aperture2SettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Aperture2.Setting"))); }
        }
        public static TextBox Aperture3SettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Aperture3.Setting"))); }
        }
        public static TextBox Aperture3ReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Aperture3.Readback"))); }
        }
        public static TextBox Aperture2ReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Aperture2.Readback"))); }
        }
        public static TextBox PusherOffsetSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.PusherOffset.Setting"))); }
        }
        public static TextBox PusherOffsetReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.PusherOffset.Readback"))); }
        }
        public static TextBox Transport1SettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Transport1.Setting"))); }
        }
        public static TextBox Transport1ReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Transport1.Readback"))); }
        }
        public static TextBox PullerSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Puller.Setting"))); }
        }
        public static TextBox PullerReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Puller.Readback"))); }
        }
        public static TextBox Transport2SettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Transport2.Setting"))); }
        }
        public static TextBox Transport2ReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Transport2.Readback"))); }
        }
        public static TextBox PullerOffsetSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.PullerOffset.Setting"))); }
        }
        public static TextBox StrikePlateSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.StrikePlate.Setting"))); }
        }
        public static TextBox StrikePlateReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.StrikePlate.Readback"))); }
        }
        public static TextBox PullerOffsetReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.PullerOffset.Readback"))); }
        }
        public static TextBox SteeringSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Steering.Setting"))); }
        }
        public static TextBox SteeringReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.Steering.Readback"))); }
        }
        public static TextBox FlightTubeSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.FlightTube.Setting"))); }
        }
        public static TextBox FlightTubeReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.FlightTube.Readback"))); }
        }
        public static TextBox TubeLensSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.TubeLens.Setting"))); }
        }
        public static TextBox TubeLensReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.TubeLens.Readback"))); }
        }
        public static TextBox ReflectronVoltsSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.ReflectronVolts.Setting"))); }
        }
        public static TextBox ReflectronVoltsReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.ReflectronVolts.Readback"))); }
        }
        public static TextBox ReflectronGridVoltsSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.ReflectronGridVolts.Setting"))); }
        }
        public static TextBox ReflectronGridVoltsReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("System1.ReflectronGridVolts.Readback"))); }
        }
        #endregion Controls
    }
}