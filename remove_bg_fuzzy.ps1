Add-Type -AssemblyName System.Drawing

$inPath = "C:\Users\siam\.gemini\antigravity-ide\brain\3a17b911-8b76-426e-b263-cd61a44fe0c2\space_joystick_orb_1781106617655.png"
$outPath = "f:\project\ShapeWar\SPRITE\joystick_orb.png"

$img = [System.Drawing.Image]::FromFile($inPath)
$bmp = New-Object System.Drawing.Bitmap($img)

# We will iterate through every pixel. If it's close to white, make it transparent.
$width = $bmp.Width
$height = $bmp.Height

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        if ($pixel.R -gt 230 -and $pixel.G -gt 230 -and $pixel.B -gt 230) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::Transparent)
        }
    }
}

$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$img.Dispose()
$bmp.Dispose()

Write-Host "Image saved to $outPath"
