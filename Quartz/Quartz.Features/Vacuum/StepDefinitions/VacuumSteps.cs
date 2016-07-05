using System;
using System.Collections.Generic;
using System.Linq;
using Automation.Config.Lib.ConfigHelpers;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using Quartz.Support.Configuration;
using Quartz.Support.GeneralHelpers;
using Quartz.Support.Views;
using Quartz.Support.Views.Page;
using TechTalk.SpecFlow;
using Report = Automation.Reporting.Lib.Report;

namespace Quartz.Features.Vacuum.StepDefinitions
{
    [Binding]
    public class VacuumPageSteps
    {
        VacuumPage vacuumPage = new VacuumPage();
        VacuumConfig vacuumConfig = new VacuumConfig(new TestConfiguration(new AppSettingsConfigurationManager()).Instrument);

        [AfterScenario("Vacuum")]
        public void AfterScenario()
        {
            if (TyphoonHelper.SimulatedInstrument)
            {
                vacuumPage.SetSimulatorPumpOverrideState("Auto");
            }

            NavigationMenu.VacuumAnchor.Click();
            vacuumPage.WaitForVacuumToStopPumpingOrVenting();
        }

        [Given(@"the Pump Override status is '(.*)'")]
        public void GivenThePumpOverrideStatusIs(string pumpOverrideStatus)
        {
            vacuumPage.SetSimulatorPumpOverrideState(pumpOverrideStatus);
        }

        [Given(@"the vacuum is not venting or pumping")]
        public void GivenTheVacuumIsNotVentingOrPumping()
        {
            vacuumPage.WaitForVacuumToStopPumpingOrVenting();
            Report.DebugScreenshot(vacuumPage.Controls.VacuumStatusTextBox.Element);
        }

        [Then(@"'(.*)' will be displayed related to the pump override")]
        public void ThenWillBeDisplayedRelatedToThePumpOverride(string message)
        {
            if (message == "N/A (No Warning)")
            {
                string warningText;

                try
                {
                    Wait.ImplicitWaitSeconds = 5;
                    warningText = vacuumPage.Controls.PumpOverrideWarningText;
                }
                catch (Exception)
                {
                    warningText = null;
                }
                Wait.ImplicitWaitSeconds = 20;

                Check.IsNull(warningText, "No warning message is displayed", true);
            }
            else
            {
                Check.AreEqual(message, vacuumPage.Controls.PumpOverrideWarningText, "The Pump override message is as expected");
            }
        }

        [StepDefinition(@"the vacuum status is '(.*)'")]
        public void WhenThereIsAnInstrumentVacuum(string vacuumState)
        {
            vacuumPage.SetSimulatorVacuumState(vacuumState);
            vacuumPage.CheckVacuumStatus(vacuumState);
        }

        [When(@"a vacuum '(.*)' action is attempted")]
        public void WhenAnIsAttempted(string action)
        {
            if (action != "N/A")
            {
                var button = vacuumPage.Controls.PumpInstrumentButton;
                button.CheckCaption(action);
                button.CheckEnabled();
                Wait.ForMilliseconds(500);
                button.Click();
            }
            else
            {
                Report.Action("No action to be performed");
            }
        }

        [When(@"the option to '(.*)' is selected")]
        public void WhenTheOptionToIsSelected(string option)
        {
            var button = vacuumPage.Controls.PumpInstrumentButton;
            button.CheckCaption(option);
            button.CheckEnabled();
            button.Click();
        }

        [StepDefinition(@"the Vacuum page is accessed")]
        public void WhenTheVacuumPageIsAccessed()
        {
            NavigationMenu.VacuumAnchor.Click();
        }

        [Then(@"the vacuum instrument button caption will be '(.*)'")]
        public void ThenTheVacuumInstrumentButtonCaptionWillBe(string buttonCaption)
        {           
            vacuumPage.Controls.PumpInstrumentButton.CheckCaption(buttonCaption, 6000, true);
        }

        [Then(@"the following vacuum page sections will be available")]
        public void ThenTheFollowingVacuumPageSectionsWillBeAvailable(TechTalk.SpecFlow.Table table)
        {
            foreach (var row in table.Rows)
            {
                var section = row["Sections"];

                switch (section)
                {
                    case "Status":
                        vacuumPage.Controls.StatusWidget.CheckDisplayed();
						break;
                    case "Pressures (mBar)":
				        vacuumPage.Controls.PressuresWidget.CheckDisplayed();
						break;
                    case "Turbo Speeds (%)":
				        vacuumPage.Controls.TurboSpeedWidget.CheckDisplayed();
						break;
                    case "Turbo Operation Times (hours)":
                        vacuumPage.Controls.TurboOperationTimeWidget.CheckDisplayed();
						break;
                    default:
                        throw new NotImplementedException("Unrecognised widget...");
                }
            }
        }

        [Then(@"Turbo Operation Time controls are available")]
        public void ThenTurboOperationTimeControlsAreAvailable()
        {
            foreach (var expectedTurboOperationTime in vacuumConfig.TurboOperationTimes)
            {
                var elements = AutomationDriver.Driver.FindElements(By.Id(expectedTurboOperationTime.Readback));
                Check.IsTrue(elements.Count > 0, expectedTurboOperationTime.Name + " is available", true);
            }

            Report.Screenshot(vacuumPage.Controls.TurboOperationTimeWidget.Element);
        }

        [Then(@"the vacuum pressure gauges are available")]
        public void ThenTheVacuumPressureGaugesAreAvailable()
        {
            foreach (var gauge in vacuumConfig.PressureGauges)
            {
                vacuumPage.CheckGaugeIsAvailable(gauge.Readback, gauge.Name + " Pressure Gauge is displayed", true);
            }
        }

        [Then(@"the Turbo Speed Gauges are available")]
        public void ThenTheTurboSpeedGaugesAreAvailable()
        {
            foreach (var gauge in vacuumConfig.TurboSpeedGauges)
            {
                vacuumPage.CheckGaugeIsAvailable(gauge.Readback, gauge.Name + " Turbo Speed Gauge is displayed", true);
            }
        }

        [Then(@"the Turbo Operation Times display the correct units of measure")]
        public void ThenDisplayTheCorrectUnitsOfMeasure()
        {
            foreach (var expectedTurboOperationTime in vacuumConfig.TurboOperationTimes)
            {
                var readbackLabel = AutomationDriver.Driver.FindElementLabelByAttribute("label", expectedTurboOperationTime.Label);
                Check.IsTrue(readbackLabel.Text.Contains(expectedTurboOperationTime.Units, StringComparison.OrdinalIgnoreCase), expectedTurboOperationTime.Name + " contains unit of measure: " + expectedTurboOperationTime.Units);
            }

            Report.Screenshot(vacuumPage.Controls.TurboOperationTimeWidget.Element);
        }

        [Then(@"the pressures will be measured in '(.*)'")]
        public void ThenThePressuresWillBeMeasuredIn(string unit)
        {
            Check.IsTrue(vacuumPage.Controls.PressuresWidget.Title.Contains(string.Format("({0})", unit)), "The Pressure parameters are measured in " + unit);
            Report.Screenshot(vacuumPage.Controls.PressuresWidget.Element);
        }

        [Then(@"the speeds will be measured in '(.*)'")]
        public void ThenTheSpeedsWillBeMeasuredIn(string unit)
        {
            Check.IsTrue(vacuumPage.Controls.TurboSpeedWidget.Title.Contains(string.Format("({0})", unit)), "The Turbo Speed parameters are measured in " + unit);
            Report.Screenshot(vacuumPage.Controls.TurboSpeedWidget.Element);
        }

        [Then(@"there will be an '(.*)' followed by an '(.*)' and finally '(.*)' instrument vacuum status")]
        public void ThenThereWillBeAnFollowedByAnAndFinallyInstrumentVacuumStatus(string intermediate1, string intermediate2, string final)
        {
            Wait.Until(f => vacuumPage.Controls.VacuumStatusTextBox.Text.ToLower() == intermediate1.ToLower(), 3000, "Waiting for Vacuum status to be " + intermediate1);
            vacuumPage.CheckVacuumStatus(intermediate1);

            Wait.Until(f => vacuumPage.Controls.VacuumStatusTextBox.Text.ToLower() != intermediate1.ToLower(), 120000, "Waiting for Vacuum status to change");
            vacuumPage.CheckVacuumStatus(intermediate2);

            Wait.Until(f => vacuumPage.Controls.VacuumStatusTextBox.Text.ToLower() != intermediate2.ToLower(), 120000, "Waiting for Vacuum status to change");
            vacuumPage.CheckVacuumStatus(final);
        }

        [Then(@"the correct number of Pressure Gauges are displayed")]
        public void ThenTheCorrectNumberOfPressureGaugesAreDisplayed()
        {
            Check.AreEqual(vacuumConfig.PressureGauges.Count, vacuumPage.Controls.PressureGauges.Count, "The expected number of Pressure Gauges are displayed");
            Report.Screenshot(vacuumPage.Controls.PressuresWidget);
        }

        [Then(@"the correct number of Turbo Speed gauges are displayed")]
        public void ThenTheCorrectNumberOfTurboSpeedGaugesAreDisplayed()
        {
            Check.AreEqual(vacuumConfig.TurboSpeedGauges.Count, vacuumPage.Controls.TurboSpeedGauges.Count, "The expected number of Turbo Speed Gauges are displayed");
        }

        [Then(@"the Pressure Gauges are of the correct type")]
        public void ThenThePressureGaugesAreOfTheCorrectType()
        {
            foreach (var gauge in vacuumConfig.PressureGauges)
            {
                var element = new Gauge(AutomationDriver.Driver.FindElement(By.Id(gauge.Readback)));

                if (string.IsNullOrEmpty(gauge.Type))
                    Check.IsTrue(string.IsNullOrEmpty(element.Type), gauge.Name + " gauge does not have a type");
                else
                    Check.AreEqual(gauge.Type.ToLower(), element.Type.ToLower(), gauge.Name + " is of the expected type");
            }
        }

        [Then(@"each Turbo Speed gauge has the correct red and green zones")]
        public void ThenEachTurboSpeedGaugeHasTheCorrectRedAndGreenZones()
        {
            foreach (var turboSpeedGauge in vacuumConfig.TurboSpeedGauges)
            {
                var expectedRedZone = turboSpeedGauge.RedZones;
                var expectedGreenZone = turboSpeedGauge.GreenZones;

                var gauge = new Gauge(AutomationDriver.Driver.FindElement(By.Id(turboSpeedGauge.Readback)));

                Check.AreEqual(expectedRedZone, gauge.Element.GetAttribute("redzones"), "Red zone is as expected");
                Check.AreEqual(expectedGreenZone, gauge.Element.GetAttribute("greenzones"), "Green zone is as expected"); 
            }
        }

        [Then(@"each Turbo Operation Time is to the correct precision")]
        public void ThenEachTurboOperationTimeIsToTheCorrectPrecision()
        {
            foreach (var turboOperationTime in vacuumConfig.TurboOperationTimes)
            {
                var expectedPrecision = Convert.ToInt32(turboOperationTime.Dp);

                var operationTime =
                    new TextBox(AutomationDriver.Driver.FindElement(By.Id(turboOperationTime.Readback)));

                Check.AreEqual(expectedPrecision, Convert.ToInt32(operationTime.Element.GetAttribute("decimalplaces")), turboOperationTime.Name + " Operation Time is to the correct number of decimal places", true);
                Report.Screenshot(operationTime.Element);
            }        
        }

        [Then(@"the Vacuum Pressure Gauges will move from the '(.*)' region into the '(.*)' region over the period of the '(.*)' process")]
        public void ThenTheVacuumPressureGaugesWillMoveFromTheRegionIntoTheRegionOverThePeriodOfTheProcess(string startRegion, string endRegion, string process)
        {
            var gauges = vacuumConfig.PressureGauges.Select(g => g.Readback).ToList();

            CheckEachVacuumPressureGaugePointerIsInZone(startRegion, gauges);

            if (process == "pumping down")
                vacuumPage.WaitForVacuumStatus(VacuumPage.PumpedMessage);
            else if (process == "venting")
                vacuumPage.WaitForVacuumStatus(VacuumPage.VentedMessage);
            else
                throw new NotImplementedException("Unrecognized process " + process);

            CheckEachVacuumPressureGaugePointerIsInZone(endRegion, gauges);
        }

        private void CheckEachVacuumPressureGaugePointerIsInZone(string region, List<string> pressureGaugeIds)
        {
            foreach (var id in pressureGaugeIds)
            {
                Report.Action(string.Format("Check the '{0}' pointer is in the '{1}' region", id, region));

                // Get the pointer state and confirm it is in the endRegion
                var gauge = new Gauge(AutomationDriver.Driver.FindElement(By.Id(id)));
                gauge.CheckPointerIsInZone(region);
            }
        }
  
        [Then(@"the '(.*)' Pressure Gauge will finally move into the '(.*)' region")]
        [Then(@"the '(.*)' Pressure Gauge is in the '(.*)' region")]
        public void ThenThePressureGaugeIsInTheRegion(string gaugeLabel, string region)
        {
            var gauge = vacuumPage.Controls.PressureGauges.FirstOrDefault(g => g.ControlText == gaugeLabel);
            gauge.WaitForPointerToBeInZone(region);
            gauge.CheckPointerIsInZone(region);
        }

        [StepDefinition(@"after some time the '(.*)' Turbo Speed Gauge will move into the '(.*)' region")]
        public void WhenAfterSomeTimeTheTurboSpeedGaugeHasMovedIntoTheRegion(string gaugeLabel, string region)
        {
            var gauge = vacuumPage.Controls.TurboSpeedGauges.FirstOrDefault(g => g.ControlText == gaugeLabel);
            gauge.WaitForPointerToBeInZone(region);
            gauge.CheckPointerIsInZone(region);
        }

        [Then(@"all Turbo Speed Gauges will be in the '(.*)' region")]
        [Given(@"all Turbo Speed Gauges are in the '(.*)' region")]
        public void GivenAllTurboSpeedGaugesAreInTheRegion(string region)
        {
            foreach (var g in vacuumConfig.TurboSpeedGauges)
            {
                var gauge = new Gauge(AutomationDriver.Driver.FindElement(By.Id(g.Readback)));
                gauge.CheckPointerIsInZone(region);
            }
        }

        [Given(@"all Turbo Speed Gauges are at (.*)%")]
        public void GivenAllTurboSpeedGaugesAreAt(int percent)
        {
            Report.Action(string.Format("Check all Turbo Speed Gauges are at {0}%", percent));
            foreach (var g in vacuumConfig.TurboSpeedGauges)
            {
                var gauge = new Gauge(AutomationDriver.Driver.FindElement(By.Id(g.Readback)));
                Check.IsTrue(gauge.PercentText == percent, string.Format("{0} gauge is at {1}%", g.Name, percent));
            }

            Report.Screenshot(vacuumPage.Controls.TurboSpeedWidget.Element);
        }

        [Then(@"all Turbo Speed Gauges will progressively increase to (.*)%")]
        public void ThenAllTurboSpeedGaugesWillProgressivelyIncreaseTo(int endPercent)
        {
            Dictionary<string, List<int>> gaugePercentages = vacuumPage.MonitorTurboSpeedGaugePercentages(endPercent);

            foreach (var entry in gaugePercentages)
            {
                var distinctPercentages = entry.Value.Distinct().ToList<int>();
              
                // order the list to gain our expected list. If it in the correct order already the two list should match
                var actualPercentagesAsc = distinctPercentages.OrderBy(g => g);
      
                Check.IsTrue(distinctPercentages.Last().Equals(endPercent), string.Format("The {0} Turbo Speed Gauge is now at {1}%", entry.Key, endPercent), true);
                Check.IsTrue(distinctPercentages.SequenceEqual(actualPercentagesAsc), string.Format("The percentage increased upto {0}%", endPercent), true);
                Report.Debug("Percentage increases were: " + string.Join(", ", distinctPercentages.Select(s => s.ToString()).ToArray()));
            }
        }
        

        [Then(@"all Turbo Speed Gauges will progressively decrease to (.*)%")]
        public void ThenAllTurboSpeedGaugesWillProgressivelyDecreaseTo(int endPercent)
        {
            Dictionary<string, List<int>> gaugePercentages = vacuumPage.MonitorTurboSpeedGaugePercentages(endPercent);

            foreach (var entry in gaugePercentages)
            {
                var distinctPercentages = entry.Value.Distinct().ToList<int>();

                // order the list to gain our expected list. If it in the correct order already the two list should match
                var actualPercentagesAsc = distinctPercentages.OrderByDescending(g => g);

                Check.IsTrue(distinctPercentages.Last().Equals(endPercent), string.Format("The {0} Turbo Speed Gauge is now at {1}%", entry.Key, endPercent), true);
                Check.IsTrue(distinctPercentages.SequenceEqual(actualPercentagesAsc), string.Format("The percentage decreased to {0}%", endPercent), true);
                Report.Debug("Percentage decreases were: " + string.Join(", ", distinctPercentages.Select(s => s.ToString()).ToArray()));
            }
        }


        [Then(@"the '(.*)' Pressure Gauge will move from the '(.*)' region to '(.*)' and then to '(.*)'")]
        public void ThenThePressureGaugeWillMoveFromTheRegionToToAndThenTo(string gaugeLabel, string region1, string region2, string region3)
        {
            var gauge = vacuumPage.Controls.PressureGauges.FirstOrDefault(g => g.ControlText == gaugeLabel);

            gauge.WaitForPointerToBeInZone(region1);
            gauge.CheckPointerIsInZone(region1);

            gauge.WaitForPointerToBeInZone(region2);
            gauge.CheckPointerIsInZone(region2);

            gauge.WaitForPointerToBeInZone(region3);
            gauge.CheckPointerIsInZone(region3);
        }

        [Then(@"the vacuum status will remain at '(.*)'")]
        public void ThenTheVacuumStatusWillRemainAt(string status)
        {
            vacuumPage.CheckVacuumStatus(status);
            Report.Action("Wait 30 seconds before checking the vacuum status again.");
            Wait.ForMilliseconds(30000);
            vacuumPage.CheckVacuumStatus(status);
        }
    }
}
