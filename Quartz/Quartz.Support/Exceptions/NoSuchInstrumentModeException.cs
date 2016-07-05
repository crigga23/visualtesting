using System;

namespace Quartz.Support.Exceptions
{
    public class NoSuchInstrumentModeException : Exception
    {
        public NoSuchInstrumentModeException()
        {
        }

        public NoSuchInstrumentModeException(string message) : base(message)
        {
        }
    }
}
