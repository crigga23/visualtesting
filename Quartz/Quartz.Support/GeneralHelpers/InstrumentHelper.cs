using System.Configuration;
using System.IO;
using System.Reflection;
using Automation.Reporting.Lib;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;

namespace Quartz.Support.GeneralHelpers
{
    public class InstrumentHelper
    {

        public static void RestoreFactoryDefaults()
        {
            ImportInstrumentFactoryDefaults();

            NavigationMenu.TuneAnchor.Click();
            TunePage tunePage = new TunePage();
            tunePage.LoadFactoryDefaults();
        }


        public static void ImportInstrumentTuneSet()
        {
            if (!TyphoonHelper.SimulatedInstrument)
            {
                Report.Action("This is an instrument test run");

                var instrumentName = ConfigurationManager.AppSettings["InstrumentName"];
                Report.Action("Instrument Name: " + instrumentName);

                string folderName = "";
                string tuneSetName = "";
                switch (instrumentName)
                {
                    case "Beta5":
                    case "beta5":
                        folderName = "Beta5";
                        tuneSetName = "SAA-005";
                        break;
                    default:
                        Report.Fail("automation: Instrument name not recognised.");
                        break;
                }

                if (!string.IsNullOrEmpty(tuneSetName))
                    CopyInstrumentTuneSets(folderName, tuneSetName);
                else
                    Report.Warn("Unable to copy tuneset to the instrument.");
            }
            else
            {
                Report.Action("This is a simulator test run. No factory defaults to import.");
            }
        }

        private static void CopyInstrumentTuneSets(string folderName, string tuneSetName)
        {
            string dataDirectory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + "\\Data\\InstrumentData\\" + folderName;

            // Copy the files and overwrite destination files if they already exist.
            var tuneSets = Directory.GetFiles(dataDirectory, tuneSetName + "*");

            foreach (string set in tuneSets)
            {
                // Use static Path methods to extract only the file name from the path.
                var destFile = System.IO.Path.Combine(TyphoonHelper.TuneSetDirectory, Path.GetFileName(set));
                System.IO.File.Copy(set, destFile, true);
            }
        }

        public static void ImportInstrumentFactoryDefaults()
        {
            if (!TyphoonHelper.SimulatedInstrument)
            {
                Report.Action("This is an instrument test run");

                var instrumentName = ConfigurationManager.AppSettings["InstrumentName"];
                Report.Action("Instrument Name: " + instrumentName);

                string folderName = "";
                string tuneSetName = "";
                switch (instrumentName)
                {
                    case "Beta3":
                    case "beta3":
                        folderName = "Beta3";
                        break;
                    case "Beta5":
                    case "beta5":
                        folderName = "Beta5";
                        tuneSetName = "SAA-005";
                        break;
                    case "Beta6":
                    case "beta6":
                        folderName = "Beta6";
                        break;
                    default:
                        Report.Fail("automation: Instrument name not recognised.");
                        break;
                }

                CopyInstrumentFactoryDefaults(folderName);
            }
            else
            {
                Report.Action("This is a simulator test run. No factory defaults to import.");
            }
        }

        private static void CopyInstrumentFactoryDefaults(string folderName)
        {
            Report.Action("Copying instrument Factory Defaults to the directories");

            if (!string.IsNullOrEmpty(folderName))
            {
                string dataDirectory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + "\\Data\\InstrumentData\\" + folderName;

                // Copy the factory defaults file and overwrite destination file if already exist.
                var destinationFile = System.IO.Path.Combine(TyphoonHelper.ConfigDirectory, "factory_settings.gpb");
                File.Copy(System.IO.Path.Combine(dataDirectory, "factory_settings.gpb"), destinationFile, true);
            }
            else
            {
                Report.Fail("Unable to load matching Factory Defaults.");
            }

            Report.Action("Finished copying instrument Factory Defaults to the directories");
        }
    }
}
