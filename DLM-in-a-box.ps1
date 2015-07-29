#Started by reading this http://www.systemcentercentral.com/automating-application-installation-using-powershell-without-dsc-oneget-2/

#Defining and cleaning a workspace for installing executables etc
$source = 'C:\source' 
If (!(Test-Path -Path $source -PathType Container)) {
    New-Item -Path $source -ItemType Directory | Out-Null
} 

#Listing the software we want
$packages = @( 
    @{title='DLM Automation Suite';url='http://download.red-gate.com/DLMAutomationSuite.exe';Destination=$source}, 
    @{title='Jenkins';url='http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.zip';Destination=$source} 
) 

#Downloading software
foreach ($package in $packages) { 
    $packageName = $package.title 
    $fileName = Split-Path $package.url -Leaf 
    $destinationPath = $package.Destination + "\" + $fileName 

    If (!(Test-Path -Path $destinationPath -PathType Leaf)) { 
        Write-Host "Downloading $packageName" 
        $webClient = New-Object System.Net.WebClient 
        $webClient.DownloadFile($package.url,$destinationPath) 
        } 
}
 
#Installing software 
foreach ($package in $packages) { 
    $packageName = $package.title 
    $fileName = Split-Path $package.url -Leaf 
    $destinationPath = $package.Destination + "\" + $fileName 
    $Arguments = $package.Arguments 
    Write-Output "Installing $packageName" 
    Invoke-Expression -Command "$destinationPath $Arguments" 
}