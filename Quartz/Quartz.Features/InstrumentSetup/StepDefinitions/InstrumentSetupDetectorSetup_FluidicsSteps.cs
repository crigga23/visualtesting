using System;
using System.Collections.Generic;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;

namespace Quartz.Features.InstrumentSetup.StepDefinitions
{
    [Binding]
    public class InstrumentSetupDetectorSetup_FluidicsSteps
    {
        public Dictionary<string, string> ReservoirParameters = new Dictionary<string, string>() { { "A", "0.0" }, { "B", "1.0" }, { "C", "2.0" }, { "Wash", "3.0" } };
        public Dictionary<string, string> BaffleParameters = new Dictionary<string, string>() { { "Sample", "0.0" }, { "Reference", "1.0" } };
        public Dictionary<string, string> SampleFlowPathParameters = new Dictionary<string, string>() { { "Infusion", "0.0" }, { "Combined", "1.0" }, { "LC", "2.0" }, { "Waste", "3.0" } };
        public Dictionary<string, string> ReferenceFlowPathParameters = new Dictionary<string, string>() { { "Infusion", "0.0" }, { "Waste", "1.0" } };

        [Given(@"the InstrumentSetupConfiguration\.xml has Reservoir (.*), Flow Rate (.*), Flow Path (.*) and Baffle Position (.*) set for Detector Setup")]
        public void GivenTheInstrumentSetupConfiguration_XmlHasReservoirBFlowRateFlowPathInfusionAndBafflePositionReferenceSetForInstrumentSetup(string reservoir, string flowRate, string flowPath, string bafflePosition)
        {
            XmlManager xmlHelper = new XmlManager(string.Concat(TyphoonHelper.ConfigDirectory, "InstrumentSetupConfiguration.xml"));

            var detectorSetupNode = xmlHelper.GetNode("Service", "DetectorSetup");
            var descendantNodes = detectorSetupNode.Parent.Descendants();

            var reservoirNode = xmlHelper.GetNode(descendantNodes, "Parameter", "Name", "Reservoir");
            var flowRateNode = xmlHelper.GetNode(descendantNodes, "Parameter", "Name", "FlowRate");
            var flowPathNode = xmlHelper.GetNode(descendantNodes, "Parameter", "Name", "FlowPath");
            var bafflePositionNode = xmlHelper.GetNode(descendantNodes, "Parameter", "Name", "BafflePosition");

            reservoirNode.SetAttributeValue("Value", ReservoirParameters[reservoir]);
            flowRateNode.SetAttributeValue("Value", flowRate);
            bafflePositionNode.SetAttributeValue("Value", BaffleParameters[bafflePosition]);

            if (bafflePosition == "Sample")
                flowPathNode.SetAttributeValue("Value", SampleFlowPathParameters[flowPath]);
            else
                flowPathNode.SetAttributeValue("Value", ReferenceFlowPathParameters[flowPath]);

            xmlHelper.Save();

        }


        [Given(@"the Tune Page (.*) fluidics '(.*)' is set to (.*)")]
        public void GivenTheTunePageReferenceFluidicsIsSetToIdle(string fluidics, string parameter, string value)
        {
            TunePage.FluidicsSetup.SelectFluidicsTab();

            if (fluidics == "Sample")
            {
                switch(parameter)
                {
                    case "Idle":
                        TunePage.FluidicsSetup.SetSampleInfusionState(FluidicsSetupCommand.InfusionState.Idle);
                        break;
                    default:
                        Report.Fail("Parameter not implemented: " + parameter);
                        break;
                }
            }
            else if (fluidics == "Reference")
            {
                throw new NotImplementedException("Reference not implemented yet");
            }
            else
            {
                throw new NotImplementedException("Unknown fluidics type: " + fluidics);
            }

        }



    }
}
