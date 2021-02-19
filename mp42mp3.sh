echo "Converting MP4 to MP3"
for file in input/*.mp4
do
    ffmpeg -i $file $(echo "$file" | cut -f 1 -d '.').mp3
done
