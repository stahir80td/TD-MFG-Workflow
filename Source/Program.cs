using System;
using System.IO;
using System.Linq;
using System.Reflection;

namespace Setup1
{
    internal class Program
    {
        static void Main(string[] args)
        {
            /*
            var targetDir = "C:\\MFG-Algos";
            System.IO.Directory.CreateDirectory("C:\\MFG-Algos");



            var sourcePath = AppDomain.CurrentDomain.BaseDirectory + "\\MFG-Algos";
            //var sourcePath = AppDomain.CurrentDomain.BaseDirectory;

            Console.WriteLine("Copying files from " + sourcePath + " to " + targetDir);

            foreach (var file in Directory.GetFiles(sourcePath))
                File.Copy(file, Path.Combine(targetDir, Path.GetFileName(file)), true);
            */

            var InstallPath = AppDomain.CurrentDomain.BaseDirectory + "MFG-Algos";

            string path = @"C:\Windows\System32\WindowsPowerShell\v1.0\Profile.ps1";

            Console.WriteLine("Adding module to " + path);

            if (!System.IO.File.Exists(path))
                using (System.IO.File.CreateText(path));

            var allLines = File.ReadAllLines(path);
            var filteredLines = allLines.Where(x => !x.Contains("MFG"));
            File.WriteAllLines(path, filteredLines);

            File.AppendAllText(path, "Import-Module '" + InstallPath + @"\MFGAlgos.psm1' -Force -DisableNameChecking");

            Console.WriteLine("Setup has completed. Close Powershell ISE and open again to load new modules");

        }
    }
}
