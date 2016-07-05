using System;
using System.Collections.Generic;
using System.Linq;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.TabViews
{
    public class CustomTab : Tab
    {



        public new string Name
        {
            get
            {
                try
                {
                    AutomationDriver.Driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(5));

                    var element = Element.FindParent();

                    AutomationDriver.Driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(Wait.ImplicitWaitSeconds));

                    return element.Text;
                }
                catch (Exception)
                {
                    return "";
                }
            }
        }

        /// <summary>
        /// Counts the number of "x" buttons available in the tab to indicate the number of custom controls
        /// </summary>
        public int CustomControlCount
        {
            get
            {
                IWebElement tabview = AutomationDriver.Driver.FindElement(By.XPath(".//div[contains(@devel,'true') and contains(@class,'active')]"));

                if (tabview != null)
                {
                    List<IWebElement> list = tabview.FindElements(By.XPath(".//*[contains(@class, 'fa-times')]")).ToList<IWebElement>();

                    if (list != null)
                    {
                        List<Control> controls = new List<Control>();
                        list.ForEach(x => controls.Add(new Control(x)));

                        return controls.Count;
                    }
                }

                return 0;
            }
        }

        /// <summary>
        /// The Custom Controls in the Custom Tab
        /// </summary>
        public List<CustomControl> CustomControls
        {
            get
            {
                var els = Element.FindElements(By.XPath("//div[contains(@class, 'watRow') and @ng-repeat]"));

                List<CustomControl> customControls = new List<CustomControl>();
                foreach (var el in els)
                {
                    customControls.Add(new CustomControl(el));
                }

                return customControls;
            }
        }

        #region Constructor

        public CustomTab(IWebElement element)
            : base(element)
        {

        }


        #endregion Constructor

        #region Methods

        public void Select()
        {
            // The Name is at a different level to that of a normal tab
            Report.Action(string.Format("Select the {0} tab", Name));
            Element.Click();

            CheckSelected();
        }

        public void Rename(string newName)
        {
            Report.Action(string.Format("Rename the {0} tab", Name));

            RenameSpanButton.DoubleClick();

            RenameTextBox.SetText(newName);

            Check.AreEqual(newName, Name, "Tab name changed correctly to " + Name);
        }

        public void OpenControlEditor(Control element)
        {
            ConfigureControl(element.Element);
        }

        public void OpenControlEditor(IWebElement element)
        {
            ConfigureControl(element);
        }

        public void DeleteControl(IWebElement element)
        {
            Report.Action("Click the delete control icon.");

            var link = element.FindElements(By.TagName("a")).Where(x => x.GetAttribute("ng-click") == "delete()");
            link.FirstOrDefault().Click();

            Report.Screenshot(Element);
        }

        public void ConfigureControl(IWebElement element)
        {
            Report.Action("Click the configure control icon.");

            var link = element.FindElements(By.TagName("a")).Where(x => x.GetAttribute("ng-click") == "configure()");
            link.FirstOrDefault().Click();

            Report.Screenshot(Element);
        }


        #endregion  Methods

        #region Header Controls

        private Button RenameSpanButton
        {
            get
            {
                return new Button(Element.FindElement(By.XPath("//span[contains(@class, 'ng-binding')]")));
            }
        }

        private TextBox RenameTextBox
        {
            get
            {
                return new TextBox(Element.FindElement(By.TagName("input")));
            }
        }

        #endregion

        #region Content Controls

        public List<Button> CreateButtonList
        {
            get
            {
                return new List<Button>()
                {
                    CreateFullSettingControlButton,
                    CreateReadbackControlButton,
                    CreateSettingControlButton,
                    CreateCommandControlButton
                };
            }
        }

        public Button CreateFullSettingControlButton
        {
            get
            {
                return
                    new Button(
                        AutomationDriver.Driver.FindElement(By.ClassName("tab-content"))
                            .FindElement(By.XPath(".//button[@type='button' and @title='Full setting control']")));
            }
        }

        public Button CreateReadbackControlButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.ClassName("tab-content")).FindElement(By.XPath(".//button[@type='button' and @title='Setting only control']")));
            }
        }

        public Button CreateSettingControlButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.ClassName("tab-content")).FindElement(By.XPath(".//button[@type='button' and @title='Readback only control']")));
            }
        }

        public Button CreateCommandControlButton
        {
            get
            {
                return new Button(AutomationDriver.Driver.FindElement(By.ClassName("tab-content")).FindElement(By.XPath(".//button[@type='button' and @title='Command control']")));
            }
        }

        public Form EditControlModal
        {
            get
            {
                IList<IWebElement> modalWindows = AutomationDriver.Driver.FindElements(By.TagName("form"));
                foreach (IWebElement formWindow in modalWindows)
                {
                    if (formWindow.Text.Contains("Edit Custom Control"))
                    {
                        return new Form(formWindow);
                    }
                }
                return null;
            }
        }

        public TextBox EditControlModalLabelTextbox
        {
            get
            {
                return new TextBox(AutomationDriver.Driver.FindElement(By.Id("labelInput")));
            }
        }

        public Button EditControlModalCloseButton
        {
            get
            {
                Form modal = EditControlModal;
                if (modal != null)
                {
                    return new Button(modal.Element.FindElement(By.ClassName("close")));
                }
                return null;
            }
        }

        public Button EditControlModalOKButton
        {
            get
            {
                Form modal = EditControlModal;
                if (modal != null)
                {
                    return new Button(modal.Element.FindElement(By.XPath(".//button[@type='submit']")));
                }

                return null;
            }
        }

        public Button EditControlModalCancelButton
        {
            get
            {
                Form modal = EditControlModal;
                if (modal != null)
                {
                    return new Button(modal.Element.FindElement(By.XPath(".//button[@type='button']")));
                }

                return null;
            }
        }

        #endregion
    }
}