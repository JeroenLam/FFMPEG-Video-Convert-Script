# Factor with which to reduce the length and new extension
$Factor    = 20
$Extension = ".mp4"

# Finding relative paths to input, output and ffmpeg folders
$Current = Get-Location
$InPath  = Join-Path $Current "Input"
$OutPath = Join-Path $Current "Output/"
$Ffmpeg  = Join-Path $Current "/bin/ffmpeg.exe"
$Coefficient = 1/$Factor

foreach ($f in Get-ChildItem $InPath){
	# Nameing output file
	$OutputFile  = $OutPath + "X" + $Factor + "-" + $f.Basename + $Extension

	# Converting file
	.$Ffmpeg -itsscale $Coefficient -i $f.FullName -c copy $OutputFile

	# move file to Output folder
#	Move-Item $f.FullName $OutPath -Force
	
	# Keep list of converted files
	"file '" + $OutputFile + "'" >> convertedFiles.txt
}
# Combining all converted videos to 1 video file
$OutputFileTotal = $OutPath + "Total-Output" + $Extension
.$Ffmpeg -f concat -safe 0 -i convertedFiles.txt -c copy $OutputFileTotal
