\# Video Crop \& Upscale with FFmpeg



Crop black borders and enlarge the actual picture area using FFmpeg.



\## Quick Start

1\) Detect crop:

"C:\\ffmpeg\\bin\\ffmpeg.exe" -i "input.mp4" -vf cropdetect -t 3 -f null - 2>crop.txt



2\) Use the suggested crop (format: crop=W:H:X:Y), then:

"C:\\ffmpeg\\bin\\ffmpeg.exe" -y -i "input.mp4" -vf "crop=W:H:X:Y,scale=1280:1080" -c:v libx264 -crf 18 -preset medium -c:a copy "output.mp4"



Screenshots: see `examples/before.png` and `examples/after.png`.



