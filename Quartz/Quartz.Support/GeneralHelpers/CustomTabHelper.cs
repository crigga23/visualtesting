using QuartzAutomationSupport.Views;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Security;
using Waters.Automation.Reporting;

namespace QuartzAutomationSupport.GeneralHelpers
{
    public static class CustomTabHelper
    {
        private static InstrumentControlWidget ICW = new InstrumentControlWidget();

        private static List<string> customTabNames = new List<string>();

        public static void AddTab()
        {
            ICW.AddTab();
        }

        public static int CustomTabCount
        {
            get
            {
                return ICW.CustomTabCount;
            }
        }

        public static void ClearTabs()
        {
            ICW.TabOptionsButton.SelectDropdownOption("Clear");
        }

        public static void RenameAllTabs()
        {
            customTabNames.Clear();
            foreach (var tab in ICW.TabControl.CustomTabs)
            {
                CustomTab customTab = new CustomTab(tab);
                
                //Random String Generator
                var name = Membership.GeneratePassword(10, 0);

                customTabNames.Add(name);
                customTab.RenameTab(name);
            }
        }

        public static void CheckAllTabNames()
        {
            customTabNames.Clear();
            foreach (var tab in ICW.TabControl.CustomTabs)
            {
                CustomTab customTab = new CustomTab(tab);

                Check.AreEqual(customTabNames.First(), customTab.Name);
            }
        }
    }
}
