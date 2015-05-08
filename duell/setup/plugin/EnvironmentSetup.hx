/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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