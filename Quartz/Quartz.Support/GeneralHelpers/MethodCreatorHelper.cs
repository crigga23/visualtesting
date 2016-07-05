using System.Linq;
using System.Xml.Linq;
using Automation.SystemSupport.Lib;

namespace Quartz.Support.GeneralHelpers
{
    public class MethodCreatorHelper
    {

        private XmlManager xmlHelper;
        private const int functionsCount = 1;
       
        public MethodCreatorHelper(string baseXmlFile)
        {
            xmlHelper = new XmlManager(baseXmlFile);

        }

        public void SetFunctionTypeAndDuration(string methodType, string duration, int function = functionsCount)
        {
            SetFunctionType(methodType, function);
            SetFunctionDuration(duration, function);
        }

        public void SetFunctionType(string methodType, int function = functionsCount)
        {
            var functions = xmlHelper.XmlDoc.Descendants().Where(p => p.Name == "Function").ToList();
            functions[function - 1].SetAttributeValue("Type", methodType);
            xmlHelper.Save();
        }

        public void SetFunctionDuration(string duration, int function = functionsCount)
        {
            var functions = xmlHelper.XmlDoc.Descendants().Where(p => p.Name == "Function").ToList();
            functions[function - 1].SetAttributeValue("TimeEnd", duration);
            xmlHelper.Save();
        }

        public void SetMobilityMode()
        {
            SetTofMode("IMS");
        }

        public void SetTofMode()
        {
            SetTofMode("TOF");
        }

        private void SetTofMode(string mode)
        {
            var modeNode = xmlHelper.XmlDoc.Descendants().Where(p => p.Name == "Mode").FirstOrDefault();

            modeNode.SetAttributeValue("Value", mode);
            xmlHelper.Save();
        }

        public void AddFunction(string functionType, string duration)
        {
            var functionNode = new XElement("Function");
            functionNode.Add(new XAttribute("Type", functionType));
            functionNode.Add(new XAttribute("TimeStart", "0.0"));
            functionNode.Add(new XAttribute("TimeEnd", duration));

            var instanceNode = new XElement("Instance");           
            functionNode.AddFirst(instanceNode);

            var settingsNode = new XElement("Settings");
            instanceNode.AddFirst(settingsNode);

            var startPosition = xmlHelper.XmlDoc.Descendants().Where(n => n.Name == "Function").LastOrDefault();

            startPosition.AddAfterSelf(functionNode);

            xmlHelper.Save();
        }

        private static XElement CreateSettingNode(string name, string value)
        {
            var newNode = new XElement("Setting");
            newNode.Add(new XAttribute("Name", name));
            newNode.Add(new XAttribute("Value", value));
            return newNode;
        }

        public void AddFunctionSetting(string name, string value, int function = functionsCount)
        {
            var newNode = CreateSettingNode(name, value);

            var instanceNode = xmlHelper.XmlDoc.Descendants().Where(n => n.Name == "Instance").ToList()[function - 1];
            var settingsNode = instanceNode.Descendants().Where(n => n.Name == "Settings").FirstOrDefault();

            settingsNode.AddFirst(newNode);
            xmlHelper.Save();
        }

        public void AddLockMassSetting(string name, string value)
        {
            var newNode = CreateSettingNode(name, value);

            var setupNode = xmlHelper.XmlDoc.Descendants().Where(n => n.Name == "Setup" && n.Attribute("Type").Value == "LockMass").FirstOrDefault();
            var settingsNode = setupNode.Descendants().Where(n => n.Name == "Settings").FirstOrDefault();

            settingsNode.AddFirst(newNode);
            xmlHelper.Save();
        }

    }
}
