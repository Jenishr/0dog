if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
{ # Powershell script
	$global:presentpath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}
else
{ # PS2EXE compiled script
	$global:presentpath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
}

function notifyme($ntdata){

$app = (Get-StartApps | Where-Object {$_.name -match "powershell"}).appid
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
$Template = [Windows.UI.Notifications.ToastTemplateType]::ToastImageAndText04
#Gets the Template XML so we can manipulate the values
[xml]$ToastTemplate = ([Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($Template).GetXml())
[xml]$ToastTemplate = @"
<toast launch="developer-defined-string">
  <visual>
    <binding template='ToastGeneric'>
    <group>
        <subgroup>
            <text hint-style="base">Process Name</text>
            <text hint-style="captionSubtle">$($ntdata.Image)</text>
        </subgroup>
        <subgroup>
            <text hint-style="base">User</text>
            <text hint-style="captionSubtle">$($ntdata.User)</text>
        </subgroup>
    </group>
      <group>
        <subgroup>
            <text hint-style="base">SourceAddress</text>
            <text hint-style="captionSubtle">$($ntdata.SourceAddress)</text>
        </subgroup>
		<subgroup>
            <text hint-style="base">SourcePort</text>
            <text hint-style="captionSubtle">$($ntdata.SourcePort)</text>
        </subgroup>
		
    </group>
     <group>
        <subgroup>
            <text hint-style="base">DestinationIp</text>
            <text hint-style="captionSubtle">$($ntdata.DestinationIp)</text>
        </subgroup>
		<subgroup>
            <text hint-style="base">DestinationPort</text>
            <text hint-style="captionSubtle">$($ntdata.DestinationPort)</text>
        </subgroup>
    </group>
    <image placement="appLogoOverride" hint-crop="circle" src='file:///$global:presentpath/edr.png' addimagequery='true'/><text>0dog!</text>
      <text id='2'>0dog detected new network connection activity</text>
      <image placement="appLogoOverride" src="file:////$global:presentpath/edr.png"/>
    </binding>
  </visual>
</toast>
"@
$ToastXml = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
$ToastXml.LoadXml($ToastTemplate.OuterXml)
$notify = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app[0])
$notify.Show($ToastXml)

}

Export-ModuleMember -Function notifyme