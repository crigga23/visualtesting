using System;
using Automation.SystemSupport.Lib;
using Quartz.Support.Views;
using TechTalk.SpecFlow;

namespace Quartz.Features.Performance.StepDefinitions
{   
    [Binding]
    public class GeneralGUISteps
    {

        [When(@"I select a random left hand side tabs (.*) times")]
        public void WhenISelectARandomLeftHandSideTabsTimes(int p0)
        {
            var random = new Random(NavigationMenu.Anchors.Count);

            for (int i = 0; i < p0; i++)
            {
                NavigationMenu.Anchors[random.Next(0, NavigationMenu.Anchors.Count - 1)].Click();
            }
        }

        [When(@"I select each left hand side tab in order (.*) times with a (.*) ms sleep")]
        public void WhenISelectEachLeftHandSideTabInOrderTimesWithAMsSleep(int p0, int p1)
        {
            for (int x = 0; x < p0; x++)
                for (int i = 0; i < 3; i++)
                    for (int j = 0; j < 3; j++)
                    {
                        NavigationMenu.Anchors[i].Click();
                        Wait.ForMilliseconds(p1);
                        NavigationMenu.Anchors[j].Click();
                        Wait.ForMilliseconds(p1);
                        NavigationMenu.Anchors[i].Click();
                        Wait.ForMilliseconds(p1);
                    }
        }

        
        [Then(@"Quartz should not crash")]
        public void ThenQuartzShouldNotCrash()
        {
            //TODO: How do we check state of Quartz
        }
    }
}
