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
