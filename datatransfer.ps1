<#
.Synopsis 
	Powershell script that will detect the OS and run a set of scripts based of which OS is detected for data transfer
.Notes 
	Author - Kylar Ainsworth - https://kylarainsworth.com
	Notable Help - Rob Ainsworth - https://ainsey11.com
#> 



# Sets the variables for the scripts
$excusrdir = ("Administrator","Default","Public","All Users","QB*")
$userdir = (Get-ChildItem -Path 'C:\users\' -name -exclude $excusrdir)
$userdirxp = (Get-ChildItem -Path 'C:\documents and settings' -name -exclude $excusrdir)
$getos = (Get-WmiObject Win32_OperatingSystem).Name
$getofficever = (gwmi win32_product -filter "name like '%office%'")
$testpath = foreach ($user in $userdir) {Test-Path C:\users\$user\appdata\local\microsoft\outlook\}
$testpath2 = foreach ($user in $userdir) {Test-Path C:\users\$user\appdata\roaming\microsoft\outlook\*.nk2}
$testpath3 = foreach ($user in $userdir) {Test-Path "C:\users\$user\appdata\local\microsoft\Windows Live Mail\"}
$testpath4 = foreach ($user in $userdir) {Test-Path "C:\users\$user\appdata\roaming\thunderbird\profiles\"}
$chromepath = foreach ($user in $userdir) {Test-Path "C:\users\$user\appdata\local\google\chrome\userdata\"}
$firefoxpath = foreach ($user in $userdir) {Test-Path "C:\users\$user\appdata\roaming\mozilla\firefox\profiles\"}
# Sets customer folder via compudeploy in powershell, does not work on anything less than 4.0 so net use is used.  
# $pass = "P@ssw0rd!"|ConvertTo-SecureString -AsPlainText -Force
# $cred = New-Object System.Management.Automation.PsCredential('custdata',$pass)
# New-PSDrive –Name “Z” –PSProvider FileSystem –Root "\\compudeploy.\customers" -Credential $cred -Persist
net use Z: /delete
net use Z: \\compudeploy.\customers /user:custdata P@ssw0rd!
# Sets variable for customer folder
$setclientname = Read-host -Prompt 'Input Customer First and Last name'

# Change to the \\compudeploy.\customers folder"
Z:

# makes the client name directory
mkdir Z:\$setclientname

# changes to the new client folder
cd $setclientname

# Pipe the contents of $userdir and make a directory
foreach ($user in $userdir) {mkdir $user} 

# Moves data based on OS
if ( $getos -like "Microsoft Windows 10")
{
 
#Do commands here

}
 
 
if ( $getos -like "Microsoft Windows 8*")
 
{
# Pipe the contents of $userdir and make a directory
foreach ($user in $userdir) {mkdir $user} 

 foreach ($user in $userdir) {robocopy C:\users\$user\documents\ Z:\$setclientname\$user\documents\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\contacts\ Z:\$setclientname\$user\contacts\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\downloads\ Z:\$setclientname\$user\downloads\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\videos\ Z:\$setclientname\$user\videos\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\pictures\ Z:\$setclientname\$user\pictures\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\desktop\ Z:\$setclientname\$user\desktop\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\favorites\ Z:\$setclientname\$user\favorites\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta}
 foreach ($user in $userdir) {robocopy C:\users\$user\music\ Z:\$setclientname\$user\music\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }

 # Checks for outlook, if true then pulls data
 if ( $testpath -Like "True") 
 {
    
    # copys outlook data from %localappdata%
    robocopy C:\users\$user\appdata\local\microsoft\outlook\ Z:\$setclientname\$user\outlook\local\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
  }
  if ( $testpath2 -Like "True") 
  {
    
    # copys outlook nk2 contacts file from %appdata%
    robocopy C:\users\$user\appdata\roaming\microsoft\outlook\ Z:\$setclientname\$user\outlook\roaming\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
  }
    # Exports outlook profile based on outlook version
    if ( $getofficever -Like "Microsoft Office * 2016") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Outlook\Profiles" Z:\$setclientname\$user\outlook\outlookprofile2k16.reg}
        }
    if ( $getofficever -Like "Microsoft Office * 2013") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Outlook\Profiles" Z:\$setclientname\$user\outlook\outlookprofile2k13.reg}
        }

    if ( $getofficever -Like "Microsoft Office * 2010") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook" Z:\$setclientname\$user\outlook\outlookprofile2k10.reg}
        }
    if ( $getofficever -Like "Microsoft Office * 2007") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook" Z:\$setclientname\$user\outlook\outlookprofile2k7.reg}
        }
    if ( $getofficever -Like "Microsoft Office * 2003") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook" Z:\$setclientname\$user\outlook\outlookprofile2k3.reg}
        }

   Else {
        Write-Host "Outlook Not Installed"
        } 

# checks for live mail and if true pulls data
 if ( $testpath3 -Like "True" ) 
{
        
 robocopy "C:\users\$user\appdata\local\microsoft\Windows Live Mail\" "Z:\$setclientname\$user\Windows Live Mail" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
 robocopy "C:\users\$user\appdata\local\microsoft\Windows Live Contacts\" "Z:\$setclientname\$user\Windows Live Contacts" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 

}
Else {
    Write-Host "Live Mail not installed"
    }
 # Check for thunderbird and if true pulls data
 if ( $testpath4 -Like "True" ) 
    {
    robocopy "C:\users\$user\appdata\roaming\thunderbird\profiles\" "Z:\$setclientname\$user\Thunderbird\Profiles\" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
    }
Else {
    Write-Host "Thunderbird not installed"
    }
# Browser profiles

if ( $chromepath -Like "True" )
    {
    robocopy "C:\users\$user\appdata\local\google\chrome\user data\" "Z:\$setclientname\$user\google\user data\" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
    }
 Else 
    {
    Write-Host "Chrome not Installed"
    }

if ( $firefoxpath -Like "True" )
    {
    robocopy "C:\users\$user\appdata\roaming\mozilla\firefox\profiles\" "Z:\$setclientname\$user\firefox\profiles\" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
    }
Else 
    {
    Write-Host "Firefox Not Installed" 
    }

 
# Pulls Win8.1/Win10 Product Keys In Bios
if ( $getos -Like "Windows 8*" )
    {
    wmic path softwarelicensingservice get OA3xOriginalProductKey >> Z:\$setclientname\$user\windowsbioskey.txt
    }
if ( $getos -Like "Windows 10*" )
    {
    wmic path softwarelicensingservice get OA3xOriginalProductKey >> Z:\$setclientname\$user\windowsbioskey.txt
    }
# Pulls Windows 7 legacy and below keys
if ( $getos -Like "Windows 7*" )
    {
    Import-Module GetProductKey.ps1
    cscript Get-WindowsKey >> Z:\$setclientname\$user\windows7key.txt
    }

}



if ( $getos -like "Microsoft Windows 7*")
 
{
# Pipe the contents of $userdir and make a directory
foreach ($user in $userdir) {mkdir $user} 

 foreach ($user in $userdir) {robocopy C:\users\$user\documents\ Z:\$setclientname\$user\documents\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\contacts\ Z:\$setclientname\$user\contacts\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\downloads\ Z:\$setclientname\$user\downloads\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\videos\ Z:\$setclientname\$user\videos\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\pictures\ Z:\$setclientname\$user\pictures\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\desktop\ Z:\$setclientname\$user\desktop\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\favorites\ Z:\$setclientname\$user\favorites\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta}
 foreach ($user in $userdir) {robocopy C:\users\$user\music\ Z:\$setclientname\$user\music\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }

 # Checks for outlook, if true then pulls data
 if ( $testpath -Like "True") 
 {
    
    # copys outlook data from %localappdata%
    robocopy C:\users\$user\appdata\local\microsoft\outlook\ Z:\$setclientname\$user\outlook\local\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
  }
  if ( $testpath2 -Like "True") 
  {
    
    # copys outlook nk2 contacts file from %appdata%
    robocopy C:\users\$user\appdata\roaming\microsoft\outlook\ Z:\$setclientname\$user\outlook\roaming\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
  }
    # Exports outlook profile based on outlook version
    if ( $getofficever -Like "Microsoft Office * 2016") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Outlook\Profiles" Z:\$setclientname\$user\outlook\outlookprofile2k16.reg}
        }
    if ( $getofficever -Like "Microsoft Office * 2013") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Outlook\Profiles" Z:\$setclientname\$user\outlook\outlookprofile2k13.reg}
        }

    if ( $getofficever -Like "Microsoft Office * 2010") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook" Z:\$setclientname\$user\outlook\outlookprofile2k10.reg}
        }
    if ( $getofficever -Like "Microsoft Office * 2007") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook" Z:\$setclientname\$user\outlook\outlookprofile2k7.reg}
        }
    if ( $getofficever -Like "Microsoft Office * 2003") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook" Z:\$setclientname\$user\outlook\outlookprofile2k3.reg}
        }

   Else {
        Write-Host "Outlook Not Installed"
        } 

# checks for live mail and if true pulls data
 if ( $testpath3 -Like "True" ) 
{
        
 robocopy "C:\users\$user\appdata\local\microsoft\Windows Live Mail\" "Z:\$setclientname\$user\Windows Live Mail" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
 robocopy "C:\users\$user\appdata\local\microsoft\Windows Live Contacts\" "Z:\$setclientname\$user\Windows Live Contacts" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 

}
Else {
    Write-Host "Live Mail not installed"
    }
 # Check for thunderbird and if true pulls data
 if ( $testpath4 -Like "True" ) 
    {
    robocopy "C:\users\$user\appdata\roaming\thunderbird\profiles\" "Z:\$setclientname\$user\Thunderbird\Profiles\" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
    }
Else {
    Write-Host "Thunderbird not installed"
    }
# Browser profiles

if ( $chromepath -Like "True" )
    {
    robocopy "C:\users\$user\appdata\local\google\chrome\user data\" "Z:\$setclientname\$user\google\user data\" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
    }
 Else 
    {
    Write-Host "Chrome not Installed"
    }

if ( $firefoxpath -Like "True" )
    {
    robocopy "C:\users\$user\appdata\roaming\mozilla\firefox\profiles\" "Z:\$setclientname\$user\firefox\profiles\" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
    }
Else 
    {
    Write-Host "Firefox Not Installed" 
    }

 
# Pulls Win8.1/Win10 Product Keys In Bios
if ( $getos -Like "Windows 8*" )
    {
    wmic path softwarelicensingservice get OA3xOriginalProductKey >> Z:\$setclientname\$user\windowsbioskey.txt
    }
if ( $getos -Like "Windows 10*" )
    {
    wmic path softwarelicensingservice get OA3xOriginalProductKey >> Z:\$setclientname\$user\windowsbioskey.txt
    }
# Pulls Windows 7 legacy and below keys
if ( $getos -Like "Windows 7*" )
    {
    Import-Module GetProductKey.ps1
    cscript Get-WindowsKey >> Z:\$setclientname\$user\windows7key.txt
    }
}

if ( $getos -like "Microsoft Windows Vista")
 
{
 
#Do commands here
# Pipe the contents of $userdir and make a directory
foreach ($user in $userdir) {mkdir $user} 

 foreach ($user in $userdir) {robocopy C:\users\$user\documents\ Z:\$setclientname\$user\documents\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\contacts\ Z:\$setclientname\$user\contacts\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\downloads\ Z:\$setclientname\$user\downloads\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\videos\ Z:\$setclientname\$user\videos\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\pictures\ Z:\$setclientname\$user\pictures\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\desktop\ Z:\$setclientname\$user\desktop\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }
 foreach ($user in $userdir) {robocopy C:\users\$user\favorites\ Z:\$setclientname\$user\favorites\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta}
 foreach ($user in $userdir) {robocopy C:\users\$user\music\ Z:\$setclientname\$user\music\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta }

 # Checks for outlook, if true then pulls data
 if ( $testpath -Like "True") 
 {
    
    # copys outlook data from %localappdata%
    robocopy C:\users\$user\appdata\local\microsoft\outlook\ Z:\$setclientname\$user\outlook\local\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
  }
  if ( $testpath2 -Like "True") 
  {
    
    # copys outlook nk2 contacts file from %appdata%
    robocopy C:\users\$user\appdata\roaming\microsoft\outlook\ Z:\$setclientname\$user\outlook\roaming\ /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
  }
    # Exports outlook profile based on outlook version
    if ( $getofficever -Like "Microsoft Office * 2016") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Outlook\Profiles" Z:\$setclientname\$user\outlook\outlookprofile2k16.reg}
        }
    if ( $getofficever -Like "Microsoft Office * 2013") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Outlook\Profiles" Z:\$setclientname\$user\outlook\outlookprofile2k13.reg}
        }

    if ( $getofficever -Like "Microsoft Office * 2010") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook" Z:\$setclientname\$user\outlook\outlookprofile2k10.reg}
        }
    if ( $getofficever -Like "Microsoft Office * 2007") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook" Z:\$setclientname\$user\outlook\outlookprofile2k7.reg}
        }
    if ( $getofficever -Like "Microsoft Office * 2003") 
        {
        # exports reg key 
        foreach ($user in $userdir) {reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\Outlook" Z:\$setclientname\$user\outlook\outlookprofile2k3.reg}
        }

   Else {
        Write-Host "Outlook Not Installed"
        } 

# checks for live mail and if true pulls data
 if ( $testpath3 -Like "True" ) 
{
        
 robocopy "C:\users\$user\appdata\local\microsoft\Windows Live Mail\" "Z:\$setclientname\$user\Windows Live Mail" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
 robocopy "C:\users\$user\appdata\local\microsoft\Windows Live Contacts\" "Z:\$setclientname\$user\Windows Live Contacts" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 

}
Else {
    Write-Host "Live Mail not installed"
    }
 # Check for thunderbird and if true pulls data
 if ( $testpath4 -Like "True" ) 
    {
    robocopy "C:\users\$user\appdata\roaming\thunderbird\profiles\" "Z:\$setclientname\$user\Thunderbird\Profiles\" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
    }
Else {
    Write-Host "Thunderbird not installed"
    }
# Browser profiles

if ( $chromepath -Like "True" )
    {
    robocopy "C:\users\$user\appdata\local\google\chrome\user data\" "Z:\$setclientname\$user\google\user data\" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
    }
 Else 
    {
    Write-Host "Chrome not Installed"
    }

if ( $firefoxpath -Like "True" )
    {
    robocopy "C:\users\$user\appdata\roaming\mozilla\firefox\profiles\" "Z:\$setclientname\$user\firefox\profiles\" /e /zb /dcopy:T /MT:25 /r:3 /w:3 /v /eta 
    }
Else 
    {
    Write-Host "Firefox Not Installed" 
    }

# Pulls Vista Key
if ( $getos -Like "Windows Vista*" )
    {
    cscript .\getxpkey.vbs >> Z:\$setclientname\$user\WindowsVistakey.txt
    }

 
}

if ( $getos -like "Microsoft Windows XP")
 
{
 
#Do commands here
 foreach ($user in $userdirxp) {xcopy "C:\documents and settings\$user\desktop\*" Z:\$setclientname\$user\desktop\ /e }
 foreach ($user in $userdirxp) {xcopy "C:\documents and settings\$user\My Documents\*" "Z:\$setclientname\$user\My Documents\" /e }
 foreach ($user in $userdirxp) {xcopy "C:\documents and settings\$user\facorites\*" Z:\$setclientname\$user\favorites /e }
 # Pulls windows XP Key
if ( $getos -Like "Windows XP*" )
    {
    cscript .\getxpkey.vbs >> Z:\$setclientname\$user\WindowsXPkey.txt
    }
}
 
Else {
Write-Host "OS Not Supported"
}
 
 