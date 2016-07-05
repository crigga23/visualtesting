using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views
{
    public class EditCustomControlForm
    {
        public EditCustomControlFormControls Controls;

        public EditCustomControlForm()
        {
            Controls = new EditCustomControlFormControls();
        }

    }

    public class EditCustomControlFormControls
    {
        public EditCustomControlFormControls()
        {
        }

        #region Controls

        public Button CloseButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.XPath("/html/body/div[2]/form/div/div[1]/button")));
            }
        }

        public Button OkButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.XPath("/html/body/div[2]/form/div/div[3]/button[1]")));
            }
        }

        public Button CancelButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.XPath("/html/body/div[2]/form/div/div[3]/button[2]")));
            }
        }

        public TextBox LabelTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("labelInput")));

            }
        }

        public TextBox SettingsFilterTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.XPath("/html/body/div[2]/form/div/div[2]/input[2]")));
            }
        }

        public Dropdown SettingsDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.XPath("/html/body/div[2]/form/div/div[2]/select[1]")));
            }
        }

        public TextBox ReadbacksFilterTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.XPath("/html/body/div[2]/form/div/div[2]/input[3]")));
            }
        }

        public Dropdown ReadbacksDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.XPath("/html/body/div[2]/form/div/div[2]/select[2]")));
            }
        }

        public TextBox DefaultValueTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.XPath("/html/body/div[2]/form/div/div[2]/input[4]")));
            }
        }

        public TextBox DecimalPlacesTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.XPath("/html/body/div[2]/form/div/div[2]/input[5]")));
            }
        }

        public TextBox MinimumValueTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.XPath("/html/body/div[2]/form/div/div[2]/input[6]")));
            }
        }

        public TextBox MaximumValueTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.XPath("/html/body/div[2]/form/div/div[2]/input[7]")));
            }
        }

        #endregion Controls
    }
}
