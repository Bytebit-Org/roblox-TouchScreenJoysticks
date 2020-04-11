New-Item -Path .\\screenshots -Type Directory

while($true)
{
    $i++
    Write-Debug $i
    $outputFile = ".\\screenshots\$i.png"

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $Width = $Screen.Width
    $Height = $Screen.Height
    $Left = $Screen.Left
    $Top = $Screen.Top

    $screenshotImage = New-Object System.Drawing.Bitmap $Width, $Height

    $graphicObject = [System.Drawing.Graphics]::FromImage($screenshotImage)
    $graphicObject.CopyFromScreen($Left, $Top, 0, 0, $screenshotImage.Size)

    $screenshotImage.Save($outputFile)

    Start-Sleep -s 5
}