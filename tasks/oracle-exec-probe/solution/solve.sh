#!/bin/bash
START=$(date +%s)
echo "oracle solve start epoch=$START"
nvidia-smi -L || true
sleep 120
END=$(date +%s)
echo "oracle solve end epoch=$END elapsed=$((END-START))"
printf 'start=%s end=%s\n' "$START" "$END" > /tmp/oracle_probe.txt
printf 'start=%s end=%s\n' "$START" "$END" > ./oracle_probe.txt
nvidia-smi -L > /tmp/oracle_gpu.txt 2>&1 || true
exit 0
