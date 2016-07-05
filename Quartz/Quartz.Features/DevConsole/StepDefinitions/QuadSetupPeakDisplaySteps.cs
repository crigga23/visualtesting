using System;
using TechTalk.SpecFlow;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Threading;
using System.Collections.Generic;
using Quartz.Support.Views;
using Quartz.Support.GeneralHelpers;
using Automation.WebFramework.Lib;


namespace Quartz.Features.QuadSetup.StepDefinitions
{
    [Binding]
    public class QuadSetupPeakDisplaySteps
    {
        QuadSetupPage qsPage = new QuadSetupPage();

        [Then(@"the following quad setup peak display windows should be available")]
        public void ThenTheFollowingQuadSetupupPeakDisplayWindowsShouldBeAvailable(Table table)
        {
            Wait.ForMilliseconds(4000);
            foreach (var row in table.Rows)
            {
                switch (row["Controls"])
                {
                    case "Peak Displays for Mass 1":
                        {
                            Assert.AreEqual(row["Default"], qsPage.Controls.PlotHeaders[0]);
                            break;
                        }
                    case "Peak Displays for Mass 2":
                        {
                            Assert.AreEqual(row["Default"], qsPage.Controls.PlotHeaders[1]);
                            break;
                        }
                    case "Peak Displays for Mass 3":
                        {
                            Assert.AreEqual(row["Default"], qsPage.Controls.PlotHeaders[2]);
                            break;
                        }
                    case "Peak Displays for Mass 4":
                        {
                            Assert.AreEqual(row["Default"], qsPage.Controls.PlotHeaders[3]);
                            break;
                        }

                    default:
                        {
                            break;
                        }

                }
            }
        }

        [Then(@"the following quad setup mass textboxes should be available")]
        public void ThenTheFollowingQuadSetupMassTextboxesShouldBeAvailable(Table table)
        {
            foreach (var row in table.Rows)
            {
                switch (row["Controls"])
                {
                    case "Mass1 textbox":
                        {
                            Assert.AreEqual(row["Default"], qsPage.Controls.Mass1TextBox.Text);
                            Assert.AreEqual(row["Checked"], qsPage.Controls.Mass1CheckBox.Selected.ToString());
                            break;
                        }
                    case "Mass2 textbox":
                        {
                            Assert.AreEqual(row["Default"], qsPage.Controls.Mass2TextBox.Text);
                            Assert.AreEqual(row["Checked"], qsPage.Controls.Mass2CheckBox.Selected.ToString());
                            break;
                        }
                    case "Mass3 textbox":
                        {
                            Assert.AreEqual(row["Default"], qsPage.Controls.Mass3TextBox.Text);
                            Assert.AreEqual(row["Checked"], qsPage.Controls.Mass3CheckBox.Selected.ToString());
                            break;
                        }
                    case "Mass4 textbox":
                        {
                            Assert.AreEqual(row["Default"], qsPage.Controls.Mass4TextBox.Text);
                            Assert.AreEqual(row["Checked"], qsPage.Controls.Mass4CheckBox.Selected.ToString());
                            break;
                        }

                    default:
                        {
                            break;
                        }

                }
            }
        }

        [When(@"A mass checkbox is deselected")]
        public void WhenAMassCheckboxIsDeselected()
        {
            Wait.ForMilliseconds(4000);
            qsPage.Controls.Mass1CheckBox.UnSelectCheckBox();   
        }

        [Then(@"the corresponding peak display should not be present")]
        public void ThenTheCorrespondingPeakDisplayShouldNotBePresent()
        {
            string mass = qsPage.Controls.Mass1TextBox.Text;
            Assert.IsFalse(qsPage.Controls.PlotHeaders.Contains(mass));
            qsPage.Controls.Mass1CheckBox.SelectCheckBox();
        }

        [When(@"A mass checkbox is reselected")]
        public void WhenAMassCheckboxIsReselected()
        {
            Wait.ForMilliseconds(4000);
            qsPage.Controls.Mass1CheckBox.UnSelectCheckBox();
            string mass = qsPage.Controls.Mass1TextBox.Text;
            Assert.IsFalse(qsPage.Controls.PlotHeaders.Contains(mass));
            qsPage.Controls.Mass1CheckBox.SelectCheckBox(); 
            Wait.ForMilliseconds(2000);   
        }

        [Then(@"the corresponding peak display should be present")]
        public void ThenTheCorrespondingPeakDisplayShouldBePresent()
        {
              string mass = qsPage.Controls.Mass1TextBox.Text;
              Assert.IsTrue(qsPage.Controls.PlotHeaders.Contains(mass));
        }


        [Then(@"it should have the following quad setup parameters present")]
        public void ThenItShouldHaveTheFollowingQuadSetupParametersPresent(Table table)
        {
            foreach (var row in table.Rows)
            {
                switch (row["Parameters"])
                {
                    case "Span":
                        {
                            string defaultValue = qsPage.Controls.SpanDropDown.SelectedOption.Text;
                            Assert.AreEqual(row["Default"], defaultValue);
                            break;                           
                        }
                    case "Number of steps":
                        {
                            string defaultValue = qsPage.Controls.NumberOfStepsDropDown.SelectedOption.Text;
                            Assert.AreEqual(row["Default"], defaultValue);
                            break;
                        }
                    case "Time Per Step":
                        {
                            string defaultValue = qsPage.Controls.TimeDropDown.SelectedOption.Text;
                            Assert.AreEqual(row["Default"], defaultValue);
                            break;
                        }
                    case "Detector Window":
                        {
                            string defaultValue = qsPage.Controls.DetectorWindowDropDown.SelectedOption.Text;
                            Assert.AreEqual(row["Default"], defaultValue);
                            break;
                        }

                    default:
                        {
                            break;
                        }

                }
            }
            
        }

        [Then(@"the parameters should have the following predefined values present")]
        public void ThenTheParametersShouldHaveTheFollowingPredefinedValuesPresent(Table table)
        {
            foreach (var row in table.Rows)
            {
                switch (row["Parameters"])
                {
                    case "Span":
                        {
                            IList<string> options = qsPage.Controls.SpanDropDown.GetAllOptionsFromDropDown();
                            string[] allOptions = new string[options.Count];
                            options.CopyTo(allOptions, 0); 
                            CollectionAssert.AreEquivalent(row["Predefined"].Split(','), allOptions);
                            break;
                        }
                    case "Number of steps":
                        {
                            IList<string> options = qsPage.Controls.NumberOfStepsDropDown.GetAllOptionsFromDropDown();
                            string[] allOptions = new string[options.Count];
                            options.CopyTo(allOptions, 0);
                            CollectionAssert.AreEquivalent(row["Predefined"].Split(','), allOptions);
                            break;
                        }
                    case "Time Per Step":
                        {
                            IList<string> options = qsPage.Controls.TimeDropDown.GetAllOptionsFromDropDown();
                            string[] allOptions = new string[options.Count];
                            options.CopyTo(allOptions, 0);
                            CollectionAssert.AreEquivalent(row["Predefined"].Split(','), allOptions);
                            break;
                        }
                    case "Detector Window":
                        {
                            IList<string> options = qsPage.Controls.DetectorWindowDropDown.GetAllOptionsFromDropDown();
                            string[] allOptions = new string[options.Count];
                            options.CopyTo(allOptions, 0);
                            CollectionAssert.AreEquivalent(row["Predefined"].Split(','), allOptions);
                            break;
                        }

                    default:
                        {
                            break;
                        }

                }
            }
        }

    }
}
