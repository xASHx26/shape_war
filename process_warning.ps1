Add-Type -AssemblyName System.Drawing

$inPath = "C:\Users\siam\.gemini\antigravity-ide\brain\79cc33a6-ab12-4ae6-8d03-dd91e62fe5bb\pixel_exclamation_1781340835698.png"
$outPath = "f:\project\ShapeWar\SPRITE\PLAYER\Warning.png"

$img = [System.Drawing.Image]::FromFile($inPath)
$bmp = New-Object System.Drawing.Bitmap($img)

$width = $bmp.Width
$height = $bmp.Height

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        
        # Check if the pixel is grey (R, G, and B are roughly equal)
        # The checkerboard is made of greys.
        $diffRG = [Math]::Abs($pixel.R - $pixel.G)
        $diffGB = [Math]::Abs($pixel.G - $pixel.B)
        $diffRB = [Math]::Abs($pixel.R - $pixel.B)
        
        # If it's a grey pixel (not heavily saturated with red/white)
        # and it's not the pure white outline.
        $isGrey = ($diffRG -lt 25 -and $diffGB -lt 25 -and $diffRB -lt 25)
        $isWhite = ($pixel.R -gt 230 -and $pixel.G -gt 230 -and $pixel.B -gt 230)
        
        if ($isGrey -and -not $isWhite) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::Transparent)
        }
    }
}

if (Test-Path "$outPath.import") {
    Remove-Item "$outPath.import"
}

$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$img.Dispose()
$bmp.Dispose()

Write-Host "Image processed and background removed!"
