################################################################################
##  File:  Install-Unity.ps1
##  Desc:  Install Unity 6000.0.28f1
##  By:    Philip Lamb
##  Mod:   2025-01-13
################################################################################

$UNITY_VERSION = "6000.0.34f1"
$UNITY_DOWNLOAD_HASH = "5ab2d9ed9190"

$argumentList = ("/S", "/D=C:\Program Files\Unity ${UNITY_VERSION}")
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/Windows64EditorInstaller/UnitySetup64.exe" -InstallArgs $argumentList
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/TargetSupportInstaller/UnitySetup-Windows-IL2CPP-Support-for-Editor-${UNITY_VERSION}.exe" -InstallArgs $argumentList
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/TargetSupportInstaller/UnitySetup-Android-Support-for-Editor-${UNITY_VERSION}.exe" -InstallArgs $argumentList

$sdkInstallRoot = "C:\Program Files\Unity ${UNITY_VERSION}\Editor\Data\PlaybackEngines\AndroidPlayer"

# OpenJDK must be fetched separately. Version for Unity 6000.x.
$jdkUrl = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9.1/OpenJDK17U-jdk_x64_windows_hotspot_17.0.9_9.zip"
$jdkArchPath = Invoke-DownloadWithRetry -Url $jdkUrl
Expand-7ZipArchive -Path $jdkArchPath -DestinationPath "${sdkInstallRoot}"
Start-Sleep -Seconds 5.0
Rename-Item -Path "${sdkInstallRoot}\jdk-17.0.9+9" -NewName "OpenJDK"

# Android SDK and NDK must be fetched separately. Version for Unity 6000.x.
$sdkToolsUrl = "https://dl.google.com/android/repository/sdk-tools-windows-4333796.zip"
$sdkToolsArchPath = Invoke-DownloadWithRetry -Url $sdkToolsUrl
Expand-7ZipArchive -Path $sdkToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK"

$buildToolsUrl = "https://dl.google.com/android/repository/build-tools_r34-windows.zip"
$buildToolsArchPath = Invoke-DownloadWithRetry -Url $buildToolsUrl
Expand-7ZipArchive -Path $buildToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK\build-tools"
Start-Sleep -Seconds 5.0
Rename-Item -Path  "${sdkInstallRoot}\SDK\build-tools\android-14" -NewName "34.0.0"

$platformToolsUrl = "https://dl.google.com/android/repository/platform-tools_r34.0.5-windows.zip"
$platformToolsArchPath = Invoke-DownloadWithRetry -Url $platformToolsUrl
Expand-7ZipArchive -Path $platformToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK"

$ndkUrl = "https://dl.google.com/android/repository/android-ndk-r23b-windows.zip"
$ndkArchPath = Invoke-DownloadWithRetry -Url $ndkUrl
Expand-7ZipArchive -Path $ndkArchPath -DestinationPath "${sdkInstallRoot}"
Start-Sleep -Seconds 5.0
Rename-Item -Path  "${sdkInstallRoot}\android-ndk-r23b" -NewName "NDK"

$commandLineToolsUrl = "https://dl.google.com/android/repository/commandlinetools-win-8092744_latest.zip"
$commandLineToolsArchPath = Invoke-DownloadWithRetry -Url $commandLineToolsUrl
New-Item -Path "${sdkInstallRoot}\SDK\cmdline-tools" -ItemType Directory
Expand-7ZipArchive -Path $commandLineToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK\cmdline-tools"
Start-Sleep -Seconds 5.0
Rename-Item -Path  "${sdkInstallRoot}\SDK\cmdline-tools\cmdline-tools" -NewName "6.0"

$cmakeUrl = "https://dl.google.com/android/repository/cmake-3.22.1-windows.zip"
$cmakeArchPath = Invoke-DownloadWithRetry -Url $cmakeUrl
New-Item -Path "${sdkInstallRoot}\SDK\cmake" -ItemType Directory
Expand-7ZipArchive -Path $cmakeArchPath -DestinationPath "${sdkInstallRoot}\SDK\cmake\3.22.1"

$platformUrl = "https://dl.google.com/android/repository/platform-33-ext3_r03.zip"
$platformArchPath = Invoke-DownloadWithRetry -Url $platformUrl
Expand-7ZipArchive -Path $platformArchPath -DestinationPath "${sdkInstallRoot}\SDK\platforms"
Start-Sleep -Seconds 5.0
Rename-Item -Path  "${sdkInstallRoot}\SDK\platforms\android-13" -NewName "android-33"

$platformUrl = "https://dl.google.com/android/repository/platform-34-ext7_r02.zip"
$platformArchPath = Invoke-DownloadWithRetry -Url $platformUrl
Expand-7ZipArchive -Path $platformArchPath -DestinationPath "${sdkInstallRoot}\SDK\platforms"

$platformUrl = "https://dl.google.com/android/repository/platform-35_r01.zip"
$platformArchPath = Invoke-DownloadWithRetry -Url $platformUrl
Expand-7ZipArchive -Path $platformArchPath -DestinationPath "${sdkInstallRoot}\SDK\platforms"

# Uncomment to add Android API XX platform tools, where XX is desired version number.
#[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "${sdkInstallRoot}\Tools\OpenJDK\Windows", [System.EnvironmentVariableTarget]::Machine)
#Echo 'y' | & "${sdkInstallRoot}\SDK\tools\bin\sdkmanager.bat" "platform-tools" "platforms;android-XX"
