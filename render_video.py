import sys
import json
import asyncio
import subprocess
import edge_tts

async def generate_media(script_text, hook_text, video_url):
    voice = "bn-BD-NabanitaNeural"
    audio_path = "/tmp/voiceover.mp3"
    sub_path = "/tmp/subtitles.vtt"
    video_input_path = "/tmp/bg_video.mp4"
    output_path = "/tmp/final_output.mp4"

    # Step 1: Download Background Video
    subprocess.run(["curl", "-s", "-L", "-o", video_input_path, video_url], check=True)

    # Step 2: Generate Audio & VTT Subtitles via Edge-TTS
    communicate = edge_tts.Communicate(script_text, voice)
    submaker = edge_tts.SubMaker()
    
    with open(audio_path, "wb") as file:
        async for chunk in communicate.stream():
            if chunk["type"] == "audio":
                file.write(chunk["data"])
            elif chunk["type"] == "WordBoundary":
                submaker.feed(chunk)

    with open(sub_path, "w", encoding="utf-8") as file:
        file.write(submaker.get_srt())

    # Step 3: Run FFmpeg
    ffmpeg_cmd = [
        "ffmpeg", "-y",
        "-i", video_input_path,
        "-i", audio_path,
        "-vf", (
            "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,"
            f"subtitles={sub_path}:force_style='FontSize=24,PrimaryColour=&H00FFFFFF,OutlineColour=&H00000000,BorderStyle=3',"
            f"drawtext=text='{hook_text}':fontcolor=white:fontsize=40:box=1:boxcolor=black@0.6:x=(w-text_w)/2:y=200"
        ),
        "-c:v", "libx264",
        "-preset", "ultrafast",
        "-c:a", "aac",
        "-shortest",
        output_path
    ]
    
    subprocess.run(ffmpeg_cmd, check=True)
    print(output_path)

if __name__ == "__main__":
    script = sys.argv[1]
    hook = sys.argv[2]
    url = sys.argv[3]
    
    asyncio.run(generate_media(script, hook, url))
