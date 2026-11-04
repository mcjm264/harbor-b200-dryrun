#!/bin/bash
# Harbor verifier for tasks/qwen3-6-30b-ft-env-check.
# Checks that the sandbox provides an NVIDIA B200 GPU and that
# PyTorch can see it, then writes 1 (B200 found) or 0 (otherwise)
# to /logs/verifier/reward.txt (and the same value to reward.json).
# Deliberately no `set -e`: a failing check must still reach the
# reward write below instead of aborting the verifier early.
set -x

REWARD_FILE="/logs/verifier/reward.txt"
REWARD_JSON="/logs/verifier/reward.json"
mkdir -p /logs/verifier || true

echo "=== nvidia-smi ==="
nvidia-smi || true

echo "=== GPU names (nvidia-smi) ==="
GPU_NAMES="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>&1 || true)"
echo "$GPU_NAMES"

echo "=== PyTorch CUDA check (JSON) ==="
TORCH_JSON="$(python3 <<'PY'
import json
import traceback

try:
    import torch

    device_count = int(torch.cuda.device_count()) if torch.cuda.is_available() else 0
    # device_count() alone can be nonzero without CUDA; keep the two consistent.
    if torch.cuda.is_available():
        device_count = int(torch.cuda.device_count())
    device_name = None
    if device_count > 0:
        device_name = torch.cuda.get_device_name(0)
    info = {
        "cuda_available": bool(torch.cuda.is_available()),
        "device_count": device_count,
        "device_name": device_name,
    }
except Exception as exc:  # Print the failure and keep going.
    traceback.print_exc()
    info = {
        "cuda_available": False,
        "device_count": 0,
        "device_name": None,
        "error": f"{type(exc).__name__}: {exc}",
    }

print(json.dumps(info))
PY
)"
echo "$TORCH_JSON"

echo "=== Reward decision ==="
if printf '%s\n%s\n' "$GPU_NAMES" "$TORCH_JSON" | grep -q "B200"; then
    REWARD=1
else
    REWARD=0
fi

echo "$REWARD" > "$REWARD_FILE"
printf '{"reward": %s}\n' "$REWARD" > "$REWARD_JSON"
echo "reward=$REWARD"
echo "Wrote $REWARD_FILE and $REWARD_JSON"
cat "$REWARD_FILE"

exit 0
