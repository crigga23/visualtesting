using OpenQA.Selenium;
using Waters.Automation.Reporting;
using WebAutomationFramework.Controls;

namespace QuartzAutomationSupport.Views.Page
{
    public class CalculateVeffPage : Page
    {

        public CalculateVeffPageControls Controls { get; set; }

        public CalculateVeffPage()
        {
            Controls = new CalculateVeffPageControls(this);
        }
    }

    public class CalculateVeffPageControls
    {
        private Page parent;

        public CalculateVeffPageControls(Page page)
        {
            parent = page;
        }

        #region Control Constants


        #endregion Control Constants

        #region Controls

        public IWebElement CalculatorDialog
        {
            get
            {
                return parent.Driver.FindElementById("calculateFrm");
            }
        }

        public TextBox ReferenceMassTextBox
        {
            get
            {
                return new TextBox(parent.Driver.FindElementById("referenceMassTxtBox"));
            }
        }

        public TextBox MeasuredMassTextBox
        {
            get
            {
                return new TextBox(parent.Driver.FindElementById("measuredMassTxtBox"));
            }
        }

        public TextBox GainTextBox
        {
            get
            {
                return new TextBox(parent.Driver.FindElementById("gainTxtBox"));
            }
        }

        public TextBox OriginalVeffTextBox
        {
            get
            {
                return new TextBox(parent.Driver.FindElementById("intensityThresholdTxtBox2"));
            }

        }

        public TextBox NewVeffTextBox
        {
            get
            {
                return new TextBox(parent.Driver.FindElementById("newVeffTxtBox"));
            }
        }

        public Button CalculateButton
        {
            get
            {
                return new Button(parent.Driver.FindElementById("calculateBtn"));
            }
        }

        public Button ApplyButton
        {
            get
            {
                return new Button(parent.Driver.FindElementById("ssOkBtn"));
            }
        }

        //public IWebElement ScanDataGraph
        //{
        //    get
        //    {
        //        return parent.Driver.FindElementByXPath("//*[@id='frame-contentId']");
        //    }
        //}

        //TODO : Replace with FindElementByID once Id's get added
        public Button CancelButton
        {
            get
            {
                return new Button(parent.Driver.FindElementById("ssCancelBtn"));
            }
        }

        public Button CloseButton
        {
            get
            {
                return new Button(parent.Driver.FindElementById("ssCloseIcon"));
            }
        }

        #endregion Controls


    }


}
