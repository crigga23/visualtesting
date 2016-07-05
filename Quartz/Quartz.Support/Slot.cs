using Automation.Reporting.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using System;

namespace Quartz.Support
{
    public class Slot : Checkbox
    {
        public Slot(IWebElement element): base(element)
        {
        }

        public bool Hidden
        {
            get 
            {
                if (Element.GetAttribute("class").Contains("ng-hide"))
                    return true;
                else return
                    false;
            }
        }

        public string SlotState
        {
            get
            {
                if (Selected && !Hidden)
                {
                    return "Active";
                }
                else
                {
                    return "Inactive";
                }
            }
        }

        public string RunState 
        { 
            get 
            {
                var parent = Element.FindParent();
                return parent.Text;
            } 
        }

        public string AutomationId
        {
            get
            {
                return Element.GetAttribute("id");
            }
        }

        public void Activate()
        {
            Report.Action(string.Format("Activate '{0}' slot", AutomationId));
            if (SlotState == "Inactive")
            {
                if (!Hidden)
                {
					SelectCheckBox();
				}
                else
                {
                    Report.Fail("Unable to activate slot. Slot is hidden.");
                }
            }
            else
            {
                Report.Debug("Slot is already activated. No action taken.");
            }

            CheckSlotState("Active", false);
        }

        public void Deactivate()
        {
            Report.Action(string.Format("Deactivate '{0}' slot", AutomationId));
            if (SlotState == "Active" && !Hidden)
            {
                UnSelectCheckBox();                
            }
            else
            {
                Report.Debug("Slot is already deactivated. No action taken.");
            }

            CheckSlotState("Inactive", false);
        }

        public void CheckSlotState(string expected, bool continueOnFail = false)
        {
            Check.AreEqual(expected, ()=> SlotState, String.Format("Slot '{0}' state is as expected", AutomationId), continueOnFail, 1000);
            Report.Screenshot(Element);
        }

        public void CheckSlotRunStatus(string expectedSlotRunStatus, bool continueOnFail = false)
        {
            Check.AreEqual(expectedSlotRunStatus, RunState, String.Format("Slot '{0}' Run status is as expected", AutomationId), continueOnFail);
            Report.Screenshot(Element);
        }

        public void CheckSelectedState(bool expected, bool continueOnFail = false, int timeAllowanceForConditionInMilliseconds = 500)
        {
            Report.Action(string.Format("Check {0} slot is set to {1}", AutomationId, expected));
            Check.AreEqual(expected, () => Element.Selected, String.Format("'{0}' slot selected state is as expected", AutomationId), continueOnFail, timeAllowanceForConditionInMilliseconds);
            Report.DebugScreenshot(Element);
        }
    }
}
