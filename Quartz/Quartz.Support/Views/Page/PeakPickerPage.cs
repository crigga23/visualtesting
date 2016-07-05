using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using Automation.Reporting.Lib;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;

namespace Quartz.Support.Views.Page
{
    public class PeakPickerPage : Page
    {
        private int defaultOffset = 0;
		public PeakPickerControls Controls { get; private set; } 

        public PeakPickerPage()
        {
            Controls = new PeakPickerControls(this);
        }

        #region Methods

        public void CreateRandomCalibration()
        {
            CreateEmptyCalibration();

            //JavaScriptExecutor required because of problems clicking on peak picker plots
            var executor = Driver as IJavaScriptExecutor;
            var random = new Random();

            Report.Action("Randomly matching peaks for manual calibration.");

            for (int i = 0; i < 6; i++)
            {
                int referencePeakIndexToClick = 0;

                if (Controls.UnmatchedReferencePeakList.Count > 0)
                {
                    referencePeakIndexToClick = random.Next(Controls.UnmatchedReferencePeakList.Count);

                    Report.Action("Selecting reference peak.");
                    executor.ExecuteScript
                        ("var event = document.createEvent(\"SVGEvents\"); event.initEvent(\"click\",true,true); arguments[0].dispatchEvent(event);",
                        Controls.UnmatchedReferencePeakList[referencePeakIndexToClick]);

                    Wait.ForMilliseconds(500);
                }
                else
                {
                    Report.Fail("Reference Peak List is empty");
                }

                if (Controls.UnmatchedSamplePeakList.Count > 0)
                {
                    Report.Action("Selecting sample peak.");
                    executor.ExecuteScript
                        ("var event = document.createEvent(\"SVGEvents\"); event.initEvent(\"click\",true,true); arguments[0].dispatchEvent(event);",
                        Controls.UnmatchedSamplePeakList[random.Next(Controls.UnmatchedSamplePeakList.Count)]);
                    Wait.ForMilliseconds(500);

                    Report.Action("Deselecting reference peak.");
                    executor.ExecuteScript
                        ("var event = document.createEvent(\"SVGEvents\"); event.initEvent(\"click\",true,true); arguments[0].dispatchEvent(event);",
                        Controls.ReferencePlotTitle);

                    Wait.ForMilliseconds(500);
                }
                else
                {
                    Report.Fail("Sample Peak List is empty");
                }

                Check.AreEqual(i + 1, Controls.MatchedSamplePeakList.Count, string.Format("Matched peak list count equals: {0}", i + 1), true);
            }
        }

        public void CreateEmptyCalibration()
        {
            Report.Action("Deselecting all peaks to create an 'empty' calibration.");

            var builder = new Actions(Driver);
            var executor = Driver as IJavaScriptExecutor;

            while (Controls.MatchedReferencePeakList.Count > 0)
            {
                var currentCount = Controls.MatchedReferencePeakList.Count;

                Report.Action("Deselecting matched reference peak.");
                Report.DebugScreenshot();

                executor.ExecuteScript
                    ("var event = document.createEvent(\"SVGEvents\"); event.initEvent(\"click\",true,true); arguments[0].dispatchEvent(event);",
                    Controls.MatchedReferencePeakList.Last());
                Wait.ForMilliseconds(200);

                Report.DebugScreenshot();
                builder.Click(Controls.SelectedSamplePeak).Perform();
                Wait.ForMilliseconds(200);

                Report.DebugScreenshot();
                builder.Click(Controls.SelectedReferencePeak).Perform();
                Wait.ForMilliseconds(200);

                Check.AreEqual(currentCount - 1, Controls.MatchedReferencePeakList.Count, string.Format("Matched peak list count equals: {0}", currentCount - 1), true);
            }
        }

        public void ZoomIn()
        {
            Wait.ForMilliseconds(200);

            new Actions(Driver)
                .MoveToElement(Controls.SamplePlot)
                .MoveByOffset(new Random().Next(Controls.SamplePlot.Size.Width), defaultOffset)
                .ClickAndHold()
                .MoveByOffset(new Random().Next(Controls.SamplePlot.Size.Width), defaultOffset)
                .Release()
                .Build()
                .Perform();

        }

        public void ZoomOut()
        {
            Wait.ForMilliseconds(200);

            new Actions(Driver)
                .MoveToElement(Controls.SamplePlot)
                .MoveByOffset(new Random().Next(Controls.SamplePlot.Size.Width), defaultOffset)
                .ContextClick()
                .Build()
                .Perform();
        }

        public void AcceptCalibration()
        {
            Controls.AcceptCalibrationButton.Click();
        }

        public void RejectCalibration()
        {
            Controls.RejectCalibrationButton.Click();
        }

        public void OpenReport()
        {
            Controls.ReportButton.Click();
        }

        public void WaitForLoad()
        {
            Report.Action("Opening Peak Picker Page.");
            //Switch to Peak Picker page before screenshot.
            Driver.SwitchTo().Window(WindowHandle);
            Report.Action("Switched to Peak Picker Page");
            Report.Screenshot();
            try
            {
                if (Controls.ModalWait.Element.Displayed)
                    Wait.Until(f => !Controls.ModalWait.Element.Displayed, 15000, "Waiting for Peak Picker Page to load...");
            }
            catch (NoSuchElementException nseex)
            {
                Report.Action(string.Format("Unable to find The Peak Picker Page: {0}", nseex.StackTrace));
            }
        }

        #endregion
    }


    public class PeakPickerControls
    {
        private Page parent;

        public PeakPickerControls(Page page)
        {
            parent = page;
        }

        #region Control Constants

        private const string AcceptButtonId = "ppAcceptBtn";
        private const string RejectButtonId = "ppRejectBtn";
        private const string ToolsButtonId = "ppToolsBtn";
        private const string ReportButtonId = "ppReportBtn";
        private const string CalibratedResidualsButtonId = "ppCalResidualsBtn";
        private const string LinearResidualsButtonId = "ppLinResidualsBtn";
        private const string SamplePeaksXPath = "/html/body/div/div[2]/div[2]/div/div[1]/stick-plot-ctrl/*[name()='svg']/*[name()='g']/*[name()='line']";
        private const string ReferencePeaksXPath = "/html/body/div/div[2]/div[2]/div/div[2]/stick-plot-ctrl/*[name()='svg']/*[name()='g']/*[name()='line']";
        private const string CalibratedPointsXpath = "/html/body/div/div[2]/div[2]/div/div[3]/residuals-plot-ctrl/*[name()='svg']/*[name()='g']/*[name()='circle']";
        private const string MatchedReferencePeaksXPath = "/html/body/div/div[2]/div[2]/div/div[2]/stick-plot-ctrl/*[name()='svg']/*[name()='g']/*[name()='line' and contains(@class, 'matched')]";
        private const string UnmatchedReferencePeaksXPath = "/html/body/div/div[2]/div[2]/div/div[2]/stick-plot-ctrl/*[name()='svg']/*[name()='g']/*[name()='line' and not(contains(@class, 'matched'))]";
        private const string MatchedSamplePeaksXPath = "/html/body/div/div[2]/div[2]/div/div[1]/stick-plot-ctrl/*[name()='svg']/*[name()='g']/*[name()='line' and contains(@class, 'matched')]";
        private const string UnmatchedSamplePeaksXPath = "/html/body/div/div[2]/div[2]/div/div[1]/stick-plot-ctrl/*[name()='svg']/*[name()='g']/*[name()='line' and not(contains(@class, 'matched'))]";
        private const string SelectedReferencePeakXPath = "/html/body/div/div[2]/div[2]/div/div[2]/stick-plot-ctrl/*[name()='svg']/*[name()='g']/*[name()='line' and contains(@class, 'selected')]";
        private const string SelectedSamplePeakXPath = "/html/body/div/div[2]/div[2]/div/div[1]/stick-plot-ctrl/*[name()='svg']/*[name()='g']/*[name()='line' and contains(@class, 'selected')]";

        private const string SamplePlotXPath = "/html/body/div/div[2]/div[2]/div/div[1]/stick-plot-ctrl/*[name()='svg']/*[name()='g']/*[contains(@class, 'brush')]";
        private const string ReferencePlotXPath = "/html/body/div/div[2]/div[2]/div/div[2]/stick-plot-ctrl/*[name()='svg']/*[name()='g']/*[contains(@class, 'brush')]";
        private const string ResidualsPlotXPath = "/html/body/div/div[2]/div[2]/div/div[3]/stick-plot-ctrl/*[name()='svg']/*[name()='g']/*[contains(@class, 'brush')]";

        private const string SummaryItemsXPath = "/html/body/div/div[3]/ng-include/div/div[2]/div//*[@class='watRow']";
        private const string ReferencePlotTitleId = "ReferencePlotTitle";


        #endregion Control Constants

        #region Controls

        public Control ModalWait
        {
            get
            {
                return new Control(parent.Driver.FindElement(By.ClassName("modal_wait")));
            }
        }

        public Button AcceptCalibrationButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(AcceptButtonId)));
            }
        }

        public Button RejectCalibrationButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(RejectButtonId)));
            }
        }

        public Button ToolsButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(ToolsButtonId)));
            }
        }

        public Button ReportButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(ReportButtonId)));
            }
        }

        public Button CalibratedResidualsButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(CalibratedResidualsButtonId)));
            }
        }

        public Button LinearResidualsButton
        {
            get
            {
                return new Button(parent.Driver.FindElement(By.Id(LinearResidualsButtonId)));
            }
        }

        public ReadOnlyCollection<IWebElement> SamplePeakList
        {
            get
            {
                return parent.Driver.FindElements(By.XPath(SamplePeaksXPath));
            }
        }

        public ReadOnlyCollection<IWebElement> ReferencePeakList
        {
            get
            {
                return parent.Driver.FindElements(By.XPath(ReferencePeaksXPath));
            }
        }

        public ReadOnlyCollection<IWebElement> MatchedReferencePeakList
        {
            get
            {
                WebDriverWait wait = new WebDriverWait(parent.Driver, TimeSpan.FromMilliseconds(5));
                var list = wait.Until(d =>
                {
                    return parent.Driver.FindElements(By.XPath(MatchedReferencePeaksXPath))
                           ?? new ReadOnlyCollection<IWebElement>(new List<IWebElement>(0));
                });

                return list;
            }
        }

        public ReadOnlyCollection<IWebElement> UnmatchedReferencePeakList
        {
            get
            {
                parent.Driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(5));

                var list = parent.Driver.FindElements(By.XPath(UnmatchedReferencePeaksXPath))
                    ?? new ReadOnlyCollection<IWebElement>(new List<IWebElement>(0));

                parent.Driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(5));

                return list;
            }
        }

        public IWebElement FirstMatchedReferencePeak
        {
            get
            {
                return parent.Driver.FindElement(By.XPath(MatchedReferencePeaksXPath));

            }
        }

        public IWebElement ReferencePlotTitle
        {
            get
            {
                return parent.Driver.FindElement(By.XPath(ReferencePlotTitleId));
            }
        }

        public ReadOnlyCollection<IWebElement> MatchedSamplePeakList
        {
            get
            {
                return parent.Driver.FindElements(By.XPath(MatchedSamplePeaksXPath))
                    ?? new ReadOnlyCollection<IWebElement>(new List<IWebElement>(0));
            }
        }

        public ReadOnlyCollection<IWebElement> UnmatchedSamplePeakList
        {
            get
            {
                return parent.Driver.FindElements(By.XPath(UnmatchedSamplePeaksXPath))
                    ?? new ReadOnlyCollection<IWebElement>(new List<IWebElement>(0));
            }
        }

        public ReadOnlyCollection<IWebElement> CalibrationPointsList
        {
            get
            {
                return parent.Driver.FindElements(By.XPath(CalibratedPointsXpath))
                    ?? new ReadOnlyCollection<IWebElement>(new List<IWebElement>(0));
            }
        }

        public IWebElement SelectedReferencePeak
        {
            get
            {
                return parent.Driver.FindElement(By.XPath(SelectedReferencePeakXPath));
            }
        }

        public IWebElement SelectedSamplePeak
        {
            get
            {
                return parent.Driver.FindElement(By.XPath(SelectedSamplePeakXPath));
            }
        }

        public IWebElement SamplePlot
        {
            get
            {
                return parent.Driver.FindElement(By.XPath(SamplePlotXPath));
            }
        }

        public IWebElement ReferencePlot
        {
            get
            {
                return parent.Driver.FindElement(By.XPath(ReferencePlotXPath));
            }
        }

        public IWebElement ResidualsPlot
        {
            get
            {
                return parent.Driver.FindElement(By.XPath(ResidualsPlotXPath));
            }
        }

        public ReadOnlyCollection<IWebElement> SummaryItems
        {
            get
            {
                // TODO: Broken in Bootstrap
                return parent.Driver.FindElements(By.XPath(SummaryItemsXPath));
            }
        }

        #endregion Controls

    }
}
