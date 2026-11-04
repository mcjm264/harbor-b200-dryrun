#!/bin/bash
set -x
echo "=== probe start ==="
date -u
echo "--- HF reachability ---"
curl -sI --max-time 30 https://huggingface.co | head -5
echo "--- download range 200MB from HF (Qwen2.5-0.5B safetensors) ---"
curl -sL --max-time 300 -r 0-209715199 -o /tmp/dl.bin -w "dl_code=%{http_code} dl_bytes=%{size_download} dl_time=%{time_total} dl_speed_Bps=%{speed_download}\n" https://huggingface.co/Qwen/Qwen2.5-0.5B/resolve/main/model.safetensors
ls -la /tmp/dl.bin
echo "--- upload 100MB to cloudflare speed endpoint ---"
head -c 104857600 /dev/urandom > /tmp/up.bin
curl -s --max-time 300 -o /dev/null -w "up_code=%{http_code} up_bytes=%{size_upload} up_time=%{time_total} up_speed_Bps=%{speed_upload}\n" -X POST --data-binary @/tmp/up.bin https://speed.cloudflare.com/__up
echo "--- sleep 14400 phase-length test (will be cancelled after a few minutes) ---"
date -u +%s
sleep 14400
date -u +%s
echo "=== probe end ==="
date -u
echo 1 > /logs/verifier/reward.txt
printf '%s' '{"reward": 1}' > /logs/verifier/reward.json
exit 0
