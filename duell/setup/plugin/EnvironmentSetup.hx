package duell.setup.plugin;

import duell.helpers.PlatformHelper;
import duell.helpers.AskHelper;
import duell.helpers.LogHelper;
import duell.helpers.ProcessHelper;

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

        var output : String = ProcessHelper.runProcess("", "xcode-select", ["-v"], true, true, true, false);

        if(output.indexOf("xcode-select version") == -1)
        {
            LogHelper.println("It seems xcode is not installed.");
            LogHelper.println("You must purchase Xcode from the Mac App Store or download using a paid");
            LogHelper.println("member account with Apple.");

            var answer = AskHelper.askYesOrNo("Do you want to visit the apple website to install it?");

            if(answer)
            {
                ProcessHelper.openURL(appleXcodeURL);
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

        var output : String = ProcessHelper.runProcess("", "pkgutil", ["--pkg-info=com.apple.pkg.CLTools_Executables"], true, true, true, false);

        if(output == null || output.indexOf("package-id:") == -1)
        {
            LogHelper.println("It seems the xcode command line tools are not installed.");

            var answer = AskHelper.askYesOrNo("Do you want to install them?");

            var output : String = ProcessHelper.runProcess("", "xcode-select", ["--install"], true, true, true, false);

            LogHelper.println("Rerun the script with the command line tools installed.");
        }
        else
        {
            LogHelper.println("Installed!");
        }
    }

}