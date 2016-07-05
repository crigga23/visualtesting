using System.Configuration;
using System.Diagnostics;
using Automation.SystemSupport.Lib;
using Automation.WebFramework.Lib;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using Quartz.Support.GeneralHelpers;

namespace Quartz.Support.Views.Page
{
    public class LoginPage : Page
    {

        private const string tokenFileId = "token";
        private const string quartzLoginId = "quartzLoginButton";

        public static string Url
        {
            get
            {
                return string.Format("{0}{1}/Login", ConfigurationManager.AppSettings["QuartzServerUrl"],
                    ConfigurationManager.AppSettings["QuartzServerPort"]);
            }
        }

        public static TextBox TokenFile { get { return new TextBox(AutomationDriver.Driver.FindElement(By.Id(tokenFileId))); } }
        public static Button QuartzLoginButton { get { return new Button(AutomationDriver.Driver.FindElement(By.Id(quartzLoginId))); } }
        private static string QuartzAutomationUsername { get { return ConfigurationManager.AppSettings["QuartzAutomationUsername"]; } }
        private static string QuartzAutomationPassword { get { return ConfigurationManager.AppSettings["QuartzAutomationPassword"]; } }

        public static void LoginAsAutomationTestUser()
        {
            try
            {
                Wait.Until(ExpectedConditions.ElementExists(By.Id(LoginPage.quartzLoginId)), 120000);
                Wait.Until(ExpectedConditions.ElementIsVisible(By.Id(LoginPage.quartzLoginId)), 120000);

                Debug.WriteLine("automation: Entering username");
                LoginPageControls.TokenUsername.SetText(QuartzAutomationUsername);
                Debug.WriteLine("automation: Entering password");
                LoginPageControls.TokenPassword.SetText(QuartzAutomationPassword);

                Debug.WriteLine("automation: Clicking the Login button...");
                QuartzLoginButton.Click();

                Debug.WriteLine("automation: Checking the URL...");
                Page.CheckUrl(ApplicationsPage.Url, 180000);
                Debug.WriteLine("automation: The URL is: " + ApplicationsPage.Url);
            }
            catch (WebDriverException webException)
            {
                Debug.WriteLine("WebDriverException in LoginAsAutomationTestUser");
                throw webException;
            }
            catch (System.Exception ex)
            {
                throw ex;
            }
        }
    }

    public class LoginPageControls
    {
        private Page parent;

        private const string tokenUsernameId = "tokenUsername";
        private const string tokenPasswordId = "tokenPassword";

        public LoginPageControls(Page page)
        {
            parent = page;
        }

        public static TextBox TokenUsername
        {
            get
            {
                var tokenUsername = new TextBox(AutomationDriver.Driver.FindElement(By.Id(tokenUsernameId)))
                {
                    Label = "Token Username"
                };
                return tokenUsername;
            }
        }

        public static TextBox TokenPassword
        {
            get
            {
                var tokenPassword = new TextBox(AutomationDriver.Driver.FindElement(By.Id(tokenPasswordId)))
                {
                    Label = "Token Password"
                };
                return tokenPassword;
            }
        }
    }
}
