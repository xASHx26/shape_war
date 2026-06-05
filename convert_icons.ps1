Add-Type -AssemblyName System.Drawing
$images = @(
    "C:\Users\siam\.gemini\antigravity-ide\brain\2cff7c67-9a63-47d8-bd87-43baef13a74d\icon_rapid_fire_1780679799073.png",
    "C:\Users\siam\.gemini\antigravity-ide\brain\2cff7c67-9a63-47d8-bd87-43baef13a74d\icon_shield_1780679811222.png",
    "C:\Users\siam\.gemini\antigravity-ide\brain\2cff7c67-9a63-47d8-bd87-43baef13a74d\icon_death_beam_1780679822893.png"
)
$dests = @(
    "f:\project\ShapeWar\SPRITE\AI\icon_rapid_fire.png",
    "f:\project\ShapeWar\SPRITE\AI\icon_shield.png",
    "f:\project\ShapeWar\SPRITE\AI\icon_death_beam.png"
)

for ($i = 0; $i -lt $images.Length; $i++) {
    $src = $images[$i]
    $dst = $dests[$i]
    $bmp = New-Object System.Drawing.Bitmap $src
    $bmp.MakeTransparent([System.Drawing.Color]::Black)
    $bmp.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}
