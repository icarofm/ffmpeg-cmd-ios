# ffmpeg-cmd-ios


## Usage

`NSString * cmd = [[NSString alloc] initWithFormat:@"-i %@ -y -acodec copy -t 03 -s 640x352 %@", file_input, file_output];

[FFmpegCMD cmd:cmd oncomplete:^(int result) {
    NSLog(@"FINISH");
}];`


## Scripts
[Submodules/ffmpeg/build-ffmpeg.sh](https://github.com/kewlbear/FFmpeg-iOS-build-script)

[Submodules/ffmpeg/build-x264.sh](https://github.com/kewlbear/x264-ios)
