#!/bin/bash
# see: https://www.reddit.com/r/whatsapp/comments/1aoeqm4/unable_to_send_videos_directly_on_whatsapp_web/
if [[ $# -lt 1 ]]; then
  echo "Usage: `basename $0` large-video"
  echo "(reduces the size of the given video to send it via WhatsApp)"
  exit 1
fi
filename=$1
name="${filename%.*}"
extension="${filename##*.}"
wafile=${name}-wa.${extension}
ffmpeg -i $filename -c:v libx264 -profile:v baseline -level 3.0 -pix_fmt yuv420p -crf 28 ${wafile}
ls -l ${wafile}
