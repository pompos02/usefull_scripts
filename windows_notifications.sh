# this is a function that shows a title and a message (2 args) with sound
wNotification2() {
    local title="$1"
    local files_moved="$2"
    powershell.exe -Command "
        \$title = '$title'
        \$files_moved = '$files_moved'
        \$xml = @'
<toast>
  <visual>
    <binding template='ToastGeneric'>
      <text>$title</text>
      <text>files moved: '$files_moved'</text>
    </binding>
  </visual>
</toast>
'@
        \$null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
        \$null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
        \$XmlDocument = New-Object Windows.Data.Xml.Dom.XmlDocument
        \$XmlDocument.loadXml(\$xml)
        \$AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::CreateToastNotifier(\$AppId).Show(\$XmlDocument)
    "
}
