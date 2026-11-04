#!/bin/bash
set -x
echo "--- oracle marker check ---"
cat /tmp/oracle_probe.txt || echo "no /tmp marker"
cat ./oracle_probe.txt || echo "no cwd marker"
cat /tmp/oracle_gpu.txt || echo "no gpu marker"
nvidia-smi -L || true
FOUND=0
for f in /tmp/oracle_probe.txt ./oracle_probe.txt; do
  if [ -f "$f" ]; then
    S=$(sed -n 's/.*start=\([0-9]*\).*/\1/p' "$f")
    E=$(sed -n 's/.*end=\([0-9]*\).*/\1/p' "$f")
    if [ -n "$S" ] && [ -n "$E" ] && [ $((E-S)) -ge 100 ]; then FOUND=1; fi
  fi
done
echo "marker_ok=$FOUND"
if [ "$FOUND" = "1" ]; then R=1; else R=0; fi
echo $R > /logs/verifier/reward.txt
printf '{"reward": %s}' "$R" > /logs/verifier/reward.json
exit 0
