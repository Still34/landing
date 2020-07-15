function Begin-ImageOptimization {
    [CmdletBinding()]
    param (
        $File
        $TargetWidth = 1080
    )
    
    begin {
        $ErrorActionPreference = "Stop"
    }
    
    process {
        $_ = $File
        $res = (ffprobe -v error -show_entries stream="width,height" -of csv=p=0 $_).split(',');
        $width = [int]$res[0]
        $height = [int]$res[1]
        $args = @($_, '-lossless', '-mt', '-q 95', '-z 9', "-o $($_.BaseName).webp")
        if ($width -gt $TargetWidth){
            $targetMultiplier = [Math]::Round($TargetWidth / $width, 1)
            $resizeWidth = $width * $targetMultiplier
            $resizeHeight = $height * $targetMultiplier
            $args += "-resize $resizeWidth $resizeHeight"
        }
        $args
        Start-Process cwebp -ArgumentList $args -Wait -PassThru -NoNewWindow
    }
    
    end {
        
    }
}