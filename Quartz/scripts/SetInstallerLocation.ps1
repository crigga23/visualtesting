$configLocation=$args[0]
$installerPath=$args[1]

$xml = [xml] (Get-Content $configLocation)
$xml.configuration.appSettings.add | foreach { if ($_.key -eq 'TyphoonMsiInstallerLocation') { $_.value = $installerPath} }
$xml.Save($configLocation) 