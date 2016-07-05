using System.Collections.Generic;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Modals
{
    public class LoadDevelopmentTabsModal
    {
        #region Control Constants
        private const string loadButtonId = "lsOkBtn";
        public const string cancelButtonId = "lsCancelBtn";
        private const string tuneParamsDropdownId = "lsTuneParamsList";
        public static string AutomationId = "Dialog.LoadSet";

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

        /// <summary>
        /// Gets the 'LoadSet' form displayed in the modal
        /// </summary>
        public static Form TuneParametersForm
        {
            get
            {
                IList<IWebElement> forms = AutomationDriver.Driver.FindElements(By.TagName("form"));
                foreach (IWebElement currentForm in forms)
                {
                    if (currentForm.Text.Contains("Load Development Tune Parameters"))
                    {
                        return new Form(currentForm);
                    }
                }
                return null;
            }
        }


        /// <summary>
        /// Gets the 'LoadSet' Dropdown displayed in the modal
        /// </summary>
        public static Dropdown TuneParametersDropdown
        {
            get
            {
                return new Dropdown(AutomationDriver.Driver.FindElement(By.Id(tuneParamsDropdownId)))
                {
                    Label = "Name"
                };
            }
        }


        /// <summary>
        /// The Load button from the 'LoadTuneSet' modal window
        /// </summary>
        public static Button LoadButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id(loadButtonId)));
            }
        }


        /// <summary>
        /// The Cancel button from the 'LoadTuneSet' modal window
        /// </summary>
        public static Button CancelButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id(cancelButtonId)));
            }
        }

        #endregion Controls

        #region Methods

        /// <summary>
        /// Check if on the "load tune sets" modal, at least one of the available tune sets is selected
        /// </summary>
        /// <param name="shouldBeSelected">True, if expecting the modal to display at least one selected tune set</param>
        public static void CheckTuneSetIsSelected(bool shouldBeSelected)
        {
            //when no sets are loaded, the modal displays an item as selected; just verify that the name is not empty
            bool isTuneSetSelected = !string.IsNullOrEmpty(TuneParametersDropdown.SelectedOption.Text);

            Check.AreEqual(shouldBeSelected, isTuneSetSelected, "A tune set is selected in the 'Load tune sets' modal window");
        }

        /// <summary>
        /// Check if on the "load tune sets" modal, at least one tune set is available
        /// </summary>
        /// <param name="shouldBeAvailable">True, if expecting the modal to display at least one tune set</param>
        public static void CheckTuneSetIsAvailable(bool shouldBeAvailable)
        {
            bool isTuneSetAvailable = (TuneParametersDropdown.Options.Count > 0) &&
                (TuneParametersDropdown.Options[0].Text != string.Empty); //when no sets are loaded, the modal displays an item as selected; just verify that the name is not empty

            Check.AreEqual(shouldBeAvailable, isTuneSetAvailable, "At least aune set is available in the 'Load tune sets' modal window");
        }
        #endregion Methods
    }
}