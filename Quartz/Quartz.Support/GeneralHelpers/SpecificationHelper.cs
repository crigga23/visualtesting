using System;
using System.IO;
using System.Linq;
using System.Reflection;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Support.GeneralHelpers
{
    public class SpecificationHelper
    {

        public enum Instrument
        {
            Osprey,
            Snownet
        }

        private string SourceType;
        private Instrument InstrumentType;

        TunePage _tunePage = new TunePage();

        private TechTalk.SpecFlow.Table instrumentSpecification;
        public TechTalk.SpecFlow.Table InstrumentTabSpecification
        {
            get
            {
                return instrumentSpecification ?? GetSpecification("InstrumentTabSpecification.txt");
            }
        }

        private TechTalk.SpecFlow.Table system1Specification;
        public TechTalk.SpecFlow.Table System1TabSpecification
        {
            get
            {
                return system1Specification ?? GetSpecification("System1TabSpecification.txt");
            }
        }

        private TechTalk.SpecFlow.Table system2Specification;
        public TechTalk.SpecFlow.Table System2TabSpecification
        {
            get
            {
                return system2Specification ?? GetSpecification("System2TabSpecification.txt");
            }
        }

        private TechTalk.SpecFlow.Table fluidicsSpecification;
        public TechTalk.SpecFlow.Table FluidicsTabSpecification
        {
            get
            {
                return fluidicsSpecification ?? GetSpecification("FluidicsTabSpecification.txt");
            }
        }

        private TechTalk.SpecFlow.Table adc2Specification;
        public TechTalk.SpecFlow.Table ADC2TabSpecification
        {
            get
            {
                return adc2Specification ?? GetSpecification("ADC2TabSpecification.txt");
            }
        }

        private TechTalk.SpecFlow.Table cell1Specification;
        public TechTalk.SpecFlow.Table Cell1TabSpecification
        {
            get
            {
                return cell1Specification ?? GetSpecification("Cell1TabSpecification.txt");
            }
        }

        private TechTalk.SpecFlow.Table cell2Specification;
        public TechTalk.SpecFlow.Table Cell2TabSpecification
        {
            get
            {
                return cell2Specification ?? GetSpecification("Cell2TabSpecification.txt");
            }
        }

        private TechTalk.SpecFlow.Table gasesSpecification;
        public TechTalk.SpecFlow.Table GasesTabSpecification
        {
            get
            {
                return gasesSpecification ?? GetSpecification("GasesTabSpecification.txt");
            }
        }

        private TechTalk.SpecFlow.Table rfSpecification;
        public TechTalk.SpecFlow.Table RFTabSpecification
        {
            get
            {
                return rfSpecification ?? GetSpecification("RFTabSpecification.txt");
            }
        }

        private TechTalk.SpecFlow.Table stepwaveSpecification;
        public TechTalk.SpecFlow.Table StepwaveTabSpecification
        {
            get
            {
                return stepwaveSpecification ?? GetSpecification("StepwaveTabSpecification.txt");
            }
        }

        private TechTalk.SpecFlow.Table trapIMSSpecification;
        public TechTalk.SpecFlow.Table TrapIMSTabSpecification
        {
            get
            {
                return trapIMSSpecification ?? GetSpecification("TrapIMSTabSpecification.txt");
            }
        }

        private TechTalk.SpecFlow.Table msProfileSpecification;
        public TechTalk.SpecFlow.Table MSProfileTabSpecification
        {
            get
            {
                return msProfileSpecification ?? GetSpecification("MSProfileTabSpecification.txt");
            }
        }


        #region Constructor

        public SpecificationHelper(Instrument instrument, string sourceType = "ESI")
        {
            SourceType = sourceType;
            InstrumentType = instrument;
        }

        #endregion Constructor


        private TableRow FindSpecificationRow(TechTalk.SpecFlow.Table specification, string fieldName)
        {
            if (specification != null)
            {
                // Find a matching row in the Specification
                try
                {
                    return specification.Rows.First(row => row["Field"] == fieldName);
                }
                catch (Exception)
                {
                    return null;
                }
            }
            else
            {
                return null;
            }
        }


        private TechTalk.SpecFlow.Table GetTabSpecification(string tabName)
        {
            TechTalk.SpecFlow.Table specification;
            switch (tabName)
            {
                case "Instrument":
                    specification = InstrumentTabSpecification;
                    break;
                case "Fluidics":
                    specification = FluidicsTabSpecification;
                    break;
                case "StepWave":
                    specification = StepwaveTabSpecification;
                    break;
                case "Trap/IMS":
                    specification = TrapIMSTabSpecification;
                    break;
                case "Cell1":
                    specification = Cell1TabSpecification;
                    break;
                case "Cell2":
                    specification = Cell2TabSpecification;
                    break;
                case "System1":
                    specification = System1TabSpecification;
                    break;
                case "System2":
                    specification = System2TabSpecification;
                    break;
                case "ADC2":
                    specification = ADC2TabSpecification;
                    break;
                case "MS Profile":
                    specification = MSProfileTabSpecification;
                    break;
                case "RF":
                    specification = RFTabSpecification;
                    break;
                case "Gases":
                    specification = GasesTabSpecification;
                    break;
                default:
                    Report.Fail("Tab specification not implemented");
                    specification = null;
                    break;

            }
            return specification;
        }

        private TechTalk.SpecFlow.Table GetSpecification(string specificationFileName)
        {
            string curDir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            string specificationLocation = null;

            switch (InstrumentType)
            {
                case Instrument.Osprey:
                    specificationLocation = curDir + "\\Data\\OspreySpecification";
                    break;
                case Instrument.Snownet:
                    specificationLocation = curDir + "\\Data\\SnownetSpecification";
                    break;
                default:
                    Report.Fail("Unknown Instrument type " + InstrumentType.ToString());
                    break;
            }

            if (!string.IsNullOrEmpty(specificationLocation))
            {
                string specificationFilePath = specificationLocation + "\\" + specificationFileName;

                if (File.Exists(specificationFilePath))


                    return TableManager.CreateSpecFlowTable(specificationFilePath);
                else
                    Report.Fail("Instrument specification not found at: " + specificationFilePath);
            }
            else
            {
                Report.Fail("Unable to locate Instrument Specification location " + specificationLocation);
            }

            return null;

        }
    }
}
