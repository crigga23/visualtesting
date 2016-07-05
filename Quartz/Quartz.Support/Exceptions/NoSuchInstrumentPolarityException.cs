using System;

namespace Quartz.Support.Exceptions
{
    public class NoSuchInstrumentPolarityException : Exception
    {
        public NoSuchInstrumentPolarityException()
        {
        }

        public NoSuchInstrumentPolarityException(string message) : base(message)
        {
        }
    }
}
