using System;

namespace Quartz.Support.Exceptions
{
    public class NoSuchMassTypeException : Exception
    {
        public NoSuchMassTypeException()
        {
        }

        public NoSuchMassTypeException(string message) : base(message)
        {
        }
    }
}