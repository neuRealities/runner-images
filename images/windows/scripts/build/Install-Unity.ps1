################################################################################
##  File:  Install-Unity.ps1
##  Desc:  Install Unity 2022.3.20f1
##  By:    Philip Lamb
##  Mod:   2024-03-19
################################################################################

$UNITY_VERSION = "2022.3.20f1"
$UNITY_DOWNLOAD_HASH = "61c2feb0970d"

$argumentList = ("/S", "/D=C:\Program Files\Unity ${UNITY_VERSION}")
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/Windows64EditorInstaller/UnitySetup64.exe" -InstallArgs $argumentList
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/TargetSupportInstaller/UnitySetup-Windows-IL2CPP-Support-for-Editor-${UNITY_VERSION}.exe" -InstallArgs $argumentList
Install-Binary -Url "https://download.unity3d.com/download_unity/${UNITY_DOWNLOAD_HASH}/TargetSupportInstaller/UnitySetup-Android-Support-for-Editor-${UNITY_VERSION}.exe" -InstallArgs $argumentList

$sdkInstallRoot = "C:\Program Files\Unity ${UNITY_VERSION}\Editor\Data\PlaybackEngines\AndroidPlayer"

# OpenJDK must be fetched separately. Version for Unity 2022.x.
$jdkUrl = "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.14.1%2B1/OpenJDK11U-jdk_x64_windows_hotspot_11.0.14.1_1.zip"
$jdkArchPath = Invoke-DownloadWithRetry -Url $jdkUrl
Expand-7ZipArchive -Path $jdkArchPath -DestinationPath "${sdkInstallRoot}"
Rename-Item -Path "${sdkInstallRoot}\jdk-11.0.14.1+1" -NewName "OpenJDK"

# Android SDK and NDK must be fetched separately. Version for Unity 2022.x.
$sdkToolsUrl = "https://dl.google.com/android/repository/sdk-tools-windows-4333796.zip"
$sdkToolsArchPath = Invoke-DownloadWithRetry -Url $sdkToolsUrl
Expand-7ZipArchive -Path $sdkToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK"

$buildToolsUrl = "https://dl.google.com/android/repository/210b77e4bc623bd4cdda4dae790048f227972bd2.build-tools_r32-windows.zip"
$buildToolsArchPath = Invoke-DownloadWithRetry -Url $buildToolsUrl
Expand-7ZipArchive -Path $buildToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK\build-tools"
Rename-Item -Path  "${sdkInstallRoot}\SDK\build-tools\android-12" -NewName "32.0.0"

$platformToolsUrl = "https://dl.google.com/android/repository/platform-tools_r32.0.0-windows.zip"
$platformToolsArchPath = Invoke-DownloadWithRetry -Url $platformToolsUrl
Expand-7ZipArchive -Path $platformToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK"

$ndkUrl = "https://dl.google.com/android/repository/android-ndk-r23b-windows.zip"
$ndkArchPath = Invoke-DownloadWithRetry -Url $ndkUrl
Expand-7ZipArchive -Path $ndkArchPath -DestinationPath "${sdkInstallRoot}"
Rename-Item -Path  "${sdkInstallRoot}\android-ndk-r23b" -NewName "NDK"

$commandLineToolsUrl = "https://dl.google.com/android/repository/commandlinetools-win-8092744_latest.zip"
$commandLineToolsArchPath = Invoke-DownloadWithRetry -Url $commandLineToolsUrl
New-Item -Path "${sdkInstallRoot}\SDK\cmdline-tools" -ItemType Directory
Expand-7ZipArchive -Path $commandLineToolsArchPath -DestinationPath "${sdkInstallRoot}\SDK\cmdline-tools"
Rename-Item -Path  "${sdkInstallRoot}\SDK\cmdline-tools\cmdline-tools" -NewName "6.0"

$platformUrl = "https://dl.google.com/android/repository/platform-31_r01.zip"
$platformArchPath = Invoke-DownloadWithRetry -Url $platformUrl
Expand-7ZipArchive -Path $platformArchPath -DestinationPath "${sdkInstallRoot}\SDK\platforms"
Rename-Item -Path  "${sdkInstallRoot}\SDK\platforms\android-12" -NewName "android-31"

$platformUrl = "https://dl.google.com/android/repository/platform-32_r01.zip"
$platformArchPath = Invoke-DownloadWithRetry -Url $platformUrl
Expand-7ZipArchive -Path $platformArchPath -DestinationPath "${sdkInstallRoot}\SDK\platforms"
Rename-Item -Path  "${sdkInstallRoot}\SDK\platforms\android-12" -NewName "android-32"

# Uncomment to add Android API XX platform tools, where XX is desired version number.
#[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "${sdkInstallRoot}\Tools\OpenJDK\Windows", [System.EnvironmentVariableTarget]::Machine)
#Echo 'y' | & "${sdkInstallRoot}\SDK\tools\bin\sdkmanager.bat" "platform-tools" "platforms;android-XX"
