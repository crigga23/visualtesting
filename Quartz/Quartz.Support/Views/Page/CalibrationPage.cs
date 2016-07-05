using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;

namespace Quartz.Support.Views.Page
{
    public class CalibrationPage : Page
    {
        public CalibrationControls Controls { get; private set; }

        public CalibrationPage()
        {
            Controls = new CalibrationControls(this);
        }

        #region Methods

        public void CreateCalibration(string fileName)
        {
            Report.Action(string.Format("Create a Calibration from data file: {0}", fileName));
            Controls.RawDataFileSelector.SelectOptionFromDropDown(fileName);
            Controls.CreateCalibrationButton.Click();
        }

        #endregion
    }

    public class CalibrationControls
    {
        private Page parent;

        public CalibrationControls(Page page)
        {
            parent = page;
        }


        #region Controls

        /// <summary>
        /// Raw Data File dropdown
        /// </summary>
        public Dropdown ReferenceCompoundSelector
        {
            get
            {
                return new Dropdown(parent.Driver.FindElement(By.Id("calRefName")));
            }
        }

        /// <summary>
        /// Raw Data File dropdown
        /// </summary>
        public Dropdown RawDataFileSelector
        {
            get
            {
                return new Dropdown(parent.Driver.FindElement(By.XPath("//*[@id=\"content_wrap\"]/div/div[2]/div[2]/div/div[1]/div[4]/select")));
            }
        }

        /// <summary>
        /// Create Calibration Button
        /// </summary>
        public Button CreateCalibrationButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id("calCreateCalibrationBtn")));
            }
        }

        #endregion Controls

    }
}
