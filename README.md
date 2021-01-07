# C-Sharp-programming-setup-for-the-Pi
A walkthrough for setting up a serious C# programming environment for the Raspberry Pi

<p align="left">    
    <img src="https://raw.githubusercontent.com/A-J-Bauer/C-Sharp-programming-setup-for-the-Pi/main/img/overview.png">
</p>


Hardware you need:

<ul>
    <li>Windows 10 Pc</li>
    <li>Raspberry Pi, micro SD card</li>
</ul>




Software you need for Windows 10 (free):
<ul>
    <li>Visual Studio Community Edition</li>
    <li>Raspberry Pi Imager</li>
    <li>WSL (Windows Subsystem for Linux)</li>
</ul>

<br>

## Ready, Set, Go:

<ol>
    <li>[Win10 Pc] Get Visual Studio: Search the internet for "Visual Studio Community", download it from microsoft.com and install it.</li>
    <li>[Win10 Pc] Get Raspberry Pi Imager: Search the internet for "Raspberry Pi Imager", download it from raspberrypi.org and install it.</li>
    <li>[Win10 Pc] Get WSL(Windows Subsystem for Linux): First enable Windows Subsystem for Linux in Control Panel / Programs and Features / Turn Windows Features on or off. Restart and launch the Microsoft Store. Search for "WSL", pick the Debian distro and install it.  You will be asked to set a user name and a password (simply use the same user name and password you intend to use on the pi).</li>
    <li>[Win10 Pc] Write Raspberry PI OS with Desktop to the micro SD card. Use the Raspberry Pi Imager, choose Raspberry PI OS with Desktop, choose the SD card and write.</li>
    <li>[Raspi] Connect a monitor, keyboard and mouse to the Pi and boot it with the freshly installed OS from the micro SD. Do the setup including Wifi if not using a cable and installing updates. This takes some time.</li>
    <li>[Win10 Pc] Start Debian (WSL) and type <code>sudo apt-get update</code> and <code>sudo apt-get upgrade</code></li>
    <li>[Raspi] After installing updates on the Pi is done and the Pi has restarted, open Preferences/Raspberry Pi Configuration, on the localisation tab - set your keyboard.</li>
    <li>[Raspi] Install XRDP so you can connect to the Pi using Remote Desktop Connection on the Windows 10 pc. To do this open a terminal (black icon on the taskbar) and type <code>sudo apt-get install xrdp</code>
    <li>[Raspi] Open Preferences/Raspberry Pi Configuration again, click 'Change Password' and set the password again.</li>
    <li>[Win10 Pc] Open Remote Desktop Connection, type the Raspberry Pi hostname (default: raspberrypi), expand the dialog, fill the the 'User name' field, tick 'Allow me to save credentials' and click 'Connect'. You should now see the desktop of the Raspberry Pi. Notice the 'thinclient_drives' on the desktop, this can be very helpful if you want to transfer files between the Pi and your Windows 10 pc. You can set the folders you want to share in the Remote Desktop Connection dialog on the 'Local Resources' tab under 'More..'.</li>
    <li>[Raspi] Open Preferences/Raspberry Pi Configuration again. On the 'Interfaces' tab select 'SSH'.</li>    
    <li>[Win10 Pc] In WSL, type <code>sudo apt-get install rsync openssh-client</code></li>
    <li>[Win10 Pc] In WSL, create private and public keys in WSL with: <code>ssh-keygen</code>(simply hit enter 3 times)
    <li>[Win10 Pc] In WSL, copy the generated keys to the remote host (the raspberry Pi) with: <code>ssh-copy-id -i ~/.ssh/id_rsa.pub raspberrypi</code>
    <li>[Win10 Pc] In WSL, connect with:<code>ssh raspberrypi</code>
    <li>[Win10 Pc] In WSL/SSH on the Pi, create a folder for the C# program: <code>mkdir /home/pi/helloworld</code>
    <li>[Win10 Pc] In WSL/SSH on the Pi, Change access permissions for this folder <code>sudo chmod 777 /home/pi/helloworld</code>
    <li>[Win10 Pc] Start Visual Studio and create a Console App (.NET Core) called "helloworld"
    <li>
        In the Solution Explorer, right click on the project 'helloworld' select 'Add/New Item', set "publish_rsync.bat" as name, click 'Add'
        <br><br><img src="https://raw.githubusercontent.com/A-J-Bauer/C-Sharp-programming-setup-for-the-Pi/main/img/additem.png"><br><br>
    </li>
    <li>        
        Edit the new file add the batch script below. Most likely you need to set the variable 'localpublishfolder' differently:
        <br><br>
        <pre>
@echo off
GOTO EndComments

:: This script uses the Windows Subsystem for Linux WSL and rsync 
:: Visual Studio is 32 bit and WSL is 64 so it will not be found in c:\windows\system32 but c:\windows\sysnative instead (File System Redirector: "32-bit applications can access the native system directory by substituting %windir%\Sysnative for %windir%\System32. WOW64 recognizes Sysnative as a special alias used to indicate that the file system should not redirect the access.")
:: the --update option prevents rsync from overwriting newer files (like an sqlite db file) on the remote system
:: in order for rsync to work over ssh without a password you need to generate public and private keys (use default location no passphrase):
:: > ssh-keygen
:: the generated files need to be copied to the remote host:
:: > ssh-copy-id -i ~/.ssh/id_rsa.pub HOSTNAME

:EndComments

::set localpublishfolder="/mnt/DRIVELETTER/PROJECTPATH/bin/Debug/netcoreapp3.1/linux-arm/publish/"
set localpublishfolder="/mnt/d/Visual Studio 2019/helloworld/bin/Debug/netcoreapp3.1/linux-arm/publish/"
::set remotepublishfolder="USER@HOSTNAME:FOLDER/"
set remotepublishfolder="pi@raspberrypi:helloworld/"

:: echo -- delete files in publish directory and subdirectories --
:: c:\windows\sysnative\wsl.exe find %localpublishfolder%* -type f -exec rm {} +

echo -- publish --
dotnet publish -r linux-arm

echo.
echo -- rsync project files to Remote Raspberry --
c:\windows\sysnative\wsl.exe rsync -avzh --update %localpublishfolder% %remotepublishfolder%

echo.
echo done
        </pre>         
    </li>
    <li>
        On the top menu bar of Visual Studio go to 'Tools', select 'External Tools..' click 'Add', set "publish_rsync" as title, set "$(ProjectDir)\publish_rsync.bat" as command and "$(ProjectDir)" as initial directory, tick 'Use Output window".
        <br><br>
        <img src="https://raw.githubusercontent.com/A-J-Bauer/C-Sharp-programming-setup-for-the-Pi/main/img/externaltools.png">
    </li>
    <li>
        Go to 'Tools', select 'Customize..', select 'Commands' tab, select 'Toolbar', select  'Standard'
        <br><br>
        <img src="https://raw.githubusercontent.com/A-J-Bauer/C-Sharp-programming-setup-for-the-Pi/main/img/customize.png">
        <br>
        <br>'Add Command..' category 'Tools' command 'External Command 1'
        <br>'Add Command..' category 'Debug' command 'Reattach to Process'
        <br>
        <br>
        <img src="https://raw.githubusercontent.com/A-J-Bauer/C-Sharp-programming-setup-for-the-Pi/main/img/standardmenu.png">
    </li>
    <li>
        Edit 'Program.cs' and set a breakpoint::
        <pre>
using System.Diagnostics;
using System.Threading;
..
..
while (!Debugger.IsAttached)
{
  Thread.Sleep(100);
}
        </pre>
    <br>
        <img src="https://raw.githubusercontent.com/A-J-Bauer/C-Sharp-programming-setup-for-the-Pi/main/img/helloworld01.png">
    </li>
    <li>Click the 'Build' icon</li>
    <li>Click 'publish_rsnc'</li>
    <li>Start the program on your Pi by navigating to /home/pi/helloworld. <code>cd /home/pi/helloworld</code>, then start the program with: <code>./helloworld</code>
    <li>
        In Visual Studio you can now attach to the program. The first time you do this you need to go to 'Debug' select 'Attach to process..', select SSH, specify the remote target, select the 'helloworld' executable and also the type of code.
        <br><br>
        <img src="https://raw.githubusercontent.com/A-J-Bauer/C-Sharp-programming-setup-for-the-Pi/main/img/attachtoprocess.png">
        <br><br>
        <img src="https://raw.githubusercontent.com/A-J-Bauer/C-Sharp-programming-setup-for-the-Pi/main/img/selectcodetype.png">
    </li>
    <li>
        <br>
        <img src="https://raw.githubusercontent.com/A-J-Bauer/C-Sharp-programming-setup-for-the-Pi/main/img/helloworldbreakpoint.png">
        <br><br>
        The next time you simply need to click the 'Reattach icon' you added previously to the standard menu and connection will also be much quicker.
    </li>
</ol>

 ## Congratulations:
<p>
    You now have the most powerful tool at hand to develop programs for the PI!
</p>

## Workflow:
<p>
    <ol>
        <li>Stop the program if running on the Pi</li>
        <li>Build the project (Build Solution icon)</li>
        <li>Publish the project (publish_rsyns button)</li>
        <li>Start the program on the Pi (arrow up key, enter)</li>
        <li>Reattach to the program (Reattach icon)</li>
        <li>Debug</li>     
    </ol>        
</p>
<p>
    Notes:
    <ul>
        <li>If you use the 'Wait for Debugger attached part' you added in step 24 you should attach to the process once before trying to stop the program on the Pi.</li>
        <li>For long running processes e.g. programs that implement a BackgroundService you can stop/detach the Debugger and let the program run on it's own, you can reattach at a later point in time.</li>        
    </ul>    
</p>








