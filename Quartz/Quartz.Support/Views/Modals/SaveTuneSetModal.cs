using System;
using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.Page;

namespace Quartz.Support.Views.Modals
{
    public class SaveTuneSetModal
    {
        private static TunePage tunePage = new TunePage();

        #region Control Constants

        private const string saveButtonId = "ssOkBtn";
        public const string cancelButtonId = "ssCancelBtn";
        private const string nameTextBoxId = "ssInputTxt";
        public static string AutomationId = "Dialog.SaveSet";

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
        /// Gets the 'SaveSet' name TextBox displayed in the modal
        /// </summary>
        public static TextBox TuneSetNameTextBox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id(nameTextBoxId)))
                {
                    Label = "Name"
                };
            }
        }


        /// <summary>
        /// The Load button from the 'SaveTuneSet' modal window
        /// </summary>
        public static Button SaveButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.Id(saveButtonId)));
            }
        }


        /// <summary>
        /// The Cancel button from the 'SaveTuneSet' modal window
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
        /// Save the tune set with the provided name.
        /// </summary>
        /// <param name="tuneSetName">The tune set name. If a name is not provided, a unique (DateTime is used) name will be assigned (eg: TuneSet_2014-07-14_20-19-49)</param>
        /// <returns>The name of the saved tune set.</returns>
        public static string EnterTuneSetNameAndSave(string tuneSetName = null)
        {
            int initialNoOfTuneSets = tunePage.GetAvailableNoOfTuneSetsIncludingVersions();

            string enteredTuneSetName = EnterTuneSetName(tuneSetName);
            Check.AreEqual(enteredTuneSetName, TuneSetNameTextBox.Text, "The entered tune set name is as expected");
          
            SaveButton.Click();
           
            Check.AreEqual(initialNoOfTuneSets + 1, () => tunePage.GetAvailableNoOfTuneSetsIncludingVersions(), "A new tune set has been created", false, 6000);

            return enteredTuneSetName;
        }

        /// <summary>
        /// Enters the tune set name without saving.
        /// </summary>
        /// <param name="tuneSetName">The tune set name. If a name is not provided, a unique (DateTime is used) name will be assigned (eg: TuneSet_2014-07-14_20-19-49)</param>
        /// <returns>The tune set name entered on the open Save Set modal.</returns>
        public static string EnterTuneSetName(string tuneSetName = null)
        {
            WaitForOpen();

            if (tuneSetName == null)
                tuneSetName = string.Format("TuneSet_{0:yyyy-MM-dd-HH-mm-ss}", DateTime.Now);

            TuneSetNameTextBox.TrySetText(tuneSetName);

            return tuneSetName;
        }

        #endregion Methods
    }
}