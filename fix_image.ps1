Add-Type -AssemblyName System.Drawing
$images = @("f:\project\ShapeWar\SPRITE\health_powerup.png", "f:\project\ShapeWar\SPRITE\speed_powerup.png")
foreach ($img in $images) {
    if (Test-Path $img) {
        $bmp = New-Object System.Drawing.Bitmap $img
        $tempPath = $img + ".tmp.png"
        $bmp.Save($tempPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        Remove-Item $img
        Rename-Item $tempPath $img
        
        $importFile = $img + ".import"
        if (Test-Path $importFile) {
            Remove-Item $importFile
        }
    }
}
