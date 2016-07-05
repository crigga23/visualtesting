
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Page
{
    public class MobilityPopupPage : Page
    {
        public void CloseMobilityPopoutWindow()
        {
            AutomationDriver.Driver.SwitchTo().Window(WindowHandle).Close();
        }
    }
}
