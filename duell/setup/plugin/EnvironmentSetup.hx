package duell.setup.plugin;

import duell.helpers.PlatformHelper;
import duell.helpers.AskHelper;
import duell.helpers.LogHelper;
import duell.helpers.CommandHelper;


import duell.objects.DuellProcess;

class EnvironmentSetup
{
    private static var appleXcodeURL = "http://developer.apple.com/xcode/";

    public function new()
    {

    }

    public function setup() : String
    {
        try
        {
            if(PlatformHelper.hostPlatform != Platform.MAC)
            {
                LogHelper.error("Wrong platform!");
            }

            LogHelper.info("");
            LogHelper.info("\x1b[2m------");
            LogHelper.info("Mac Setup");
            LogHelper.info("------\x1b[0m");
            LogHelper.info("");

            downloadXCode();

            LogHelper.println("");

            downloadCommandLineTools();

            LogHelper.info("");
            LogHelper.info("\x1b[2m------");
            LogHelper.info("end");
            LogHelper.info("------\x1b[0m");

        } catch(error : Dynamic)
        {
            LogHelper.error("An error occurred, do you need admin permissions to run the script? Check if you have permissions to write on the paths you specify. Error:" + error);
        }

        return "success";
    }

    private function downloadXCode()
    {
        LogHelper.println("Checking xcode installation...");

        var proc = new DuellProcess("", "xcode-select", ["-v"], {block:true, systemCommand:true, errorMessage: "checking for the xcode installation"});
        var output = proc.getCompleteStdout().toString(); 

        if(proc.exitCode() != 0 || output.indexOf("xcode-select version") == -1)
        {
            LogHelper.println("It seems xcode is not installed.");
            LogHelper.println("You must purchase Xcode from the Mac App Store or download using a paid");
            LogHelper.println("member account with Apple.");

            var answer = AskHelper.askYesOrNo("Do you want to visit the apple website to install it?");

            if(answer)
            {
                CommandHelper.openURL(appleXcodeURL);
            }

            LogHelper.println("Rerun the script with xcode installed.");


            Sys.exit(0);
        }
        else
        {
            LogHelper.println("Installed!");
        }
    }

    private function downloadCommandLineTools()
    {
        LogHelper.println("Checking xcode command line tools installation...");

        var proc = new DuellProcess("", "pkgutil", ["--pkg-info=com.apple.pkg.CLTools_Executables"], {block:true, systemCommand:true});
        var output = proc.getCompleteStdout().toString(); 

        if(proc.exitCode() != 0 || output == null || output.indexOf("package-id:") == -1)
        {
            LogHelper.println("It seems the xcode command line tools are not installed.");

            var answer = AskHelper.askYesOrNo("Do you want to install them?");

            CommandHelper.runCommand("", "xcode-select", ["--install"], {systemCommand:true, errorMessage: "trying to install the command line tools"});

            LogHelper.println("Rerun the script with the command line tools installed.");
        }
        else
        {
            LogHelper.println("Installed!");
        }
    }

}