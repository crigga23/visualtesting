using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public static class TWaveTabView
    {
        #region Controls
        public static TextBox EntranceOutputOffsetSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.EntranceOutputOffset.Setting"))); }
        }
        public static TextBox EntranceOutputOffsetReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.EntranceOutputOffset.Readback"))); }
        }
        public static TextBox ExitOutputOffsetSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.ExitOutputOffset.Setting"))); }
        }
        public static TextBox ExitOutputOffsetReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.ExitOutputOffset.Readback"))); }
        }
        public static TextBox CollisionStaticOffsetSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("VoltageBias.collisionStaticOffset.Setting"))); }
        }
        public static TextBox TwigRFOffsetSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.TwigRFOffset.Setting"))); }
        }
        public static TextBox TwigRFOffsetReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.TwigRFOffset.Readback"))); }
        }
        public static TextBox VelocitySettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.Velocity.Setting"))); }
        }
        public static TextBox PulseHeightSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.PulseHeight.Setting"))); }
        }
        public static TextBox PulseHeightReadbackTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.PulseHeight.Readback"))); }
        }
        public static TextBox TrappingVoltageSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.TrappingVoltage.Setting"))); }
        }
        public static TextBox ExtractionVoltageSettingTextBox
        {
            get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id("Collision.ExtractionVoltage.Setting"))); }
        }
        #endregion Controls
    }
}