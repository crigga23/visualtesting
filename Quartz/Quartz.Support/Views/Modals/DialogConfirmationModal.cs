using System.Linq;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Modals
{
    public class DialogConfirmationModal
    {

        #region Control Constants

        private const string YesButtonName = "Yes";
        private const string NoButtonName = "No";
        private const string CancelButtonName = "Cancel";
        public const string AutomationId = "Dialog.Confirmation";

        #endregion Control Constants

        public static bool Exists { get { return Modal.Exists(AutomationId); } }

        public static void WaitForClose()
        {
            Modal.WaitForClose(AutomationId);
        }

        public static void WaitForOpen()
        {
            Modal.WaitForOpen(AutomationId);
        }


        #region Controls

        private static IWebElement element;
        private static IWebElement Element
        {
            get
            {
                var elements = AutomationDriver.Driver.FindElements(By.ClassName("modal"), 2000);
                var element = elements.Where(e => e.FindElement(By.TagName("h3")).Text.Contains("Information")).FirstOrDefault();

                return element;
            }
        }

        public static Button YesButton { get { return new Button(Element.FindElements(By.TagName("button")).FirstOrDefault(b => b.Text == YesButtonName)); } }
        public static Button NoButton { get { return new Button(Element.FindElements(By.TagName("button")).FirstOrDefault(b => b.Text == NoButtonName)); } }
        public static Button CancelButton { get { return new Button(Element.FindElements(By.TagName("button")).FirstOrDefault(b => b.Text == CancelButtonName)); } }
        #endregion Controls


        #region Methods

        public static void ClickNoAndClose()
        {
            // Wait for modal to stabilise on the screen
            WaitForOpen();

            DialogConfirmationModal.NoButton.Click();

            WaitForClose();
            Check.IsFalse(Exists, "Modal has closed");
        }

        public static void ClickYesAndClose()
        {
            // Wait for modal to stabilise on the screen
            WaitForOpen();

            DialogConfirmationModal.YesButton.Click();

            WaitForClose();
            Check.IsFalse(Exists, "Modal has closed");
        }

        #endregion Methods
    }
}