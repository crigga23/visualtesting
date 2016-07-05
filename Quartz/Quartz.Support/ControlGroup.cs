using Automation.WebFramework.Lib;
using System;

namespace Quartz.Support
{
    public class ControlGroup
    {
        public Control Setting { get { return LazyControl.Value; } }
        public TextBox Readback
        {
            get
            {
                if (LazyTextbox != null)
                    return LazyTextbox.Value;
                else
                    return null;
            }
        }

        private Lazy<Control> LazyControl;
        private Lazy<TextBox> LazyTextbox;

        public ControlGroup(Func<Control> setting, Func<TextBox> readback)
        {
            LazyControl = new Lazy<Control>(setting);
            LazyTextbox = new Lazy<TextBox>(readback);
        }

        public ControlGroup(Func<Control> setting)
        {
            LazyControl = new Lazy<Control>(setting);
        }
    }
}
