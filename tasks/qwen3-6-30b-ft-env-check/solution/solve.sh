#!/bin/bash
set -e
nvidia-smi || true
python3 - << 'PY'
import json, subprocess
report = {}
try:
    out = subprocess.run(["nvidia-smi", "--query-gpu=name", "--format=csv,noheader"], capture_output=True, text=True, timeout=30)
    report["gpu_name"] = out.stdout.strip()
except Exception as e:
    report["gpu_name"] = f"unavailable: {e}"
try:
    import torch
    report["torch_version"] = torch.__version__
    report["cuda_available"] = torch.cuda.is_available()
    report["cuda_version"] = torch.version.cuda
    report["gpu_count"] = torch.cuda.device_count()
except Exception as e:
    report["torch_version"] = "unavailable"
    report["cuda_available"] = False
    report["cuda_version"] = None
    report["gpu_count"] = 0
    report["torch_error"] = str(e)
try:
    from transformers import AutoConfig
    config = AutoConfig.from_pretrained("Qwen/Qwen3.6-30B-A3B", trust_remote_code=False)
    report["config_load_success"] = True
    report["model_type"] = getattr(config, "model_type", None)
    report["hidden_size"] = getattr(config, "hidden_size", None)
except Exception as e:
    report["config_load_success"] = False
    report["model_type"] = None
    report["hidden_size"] = None
    report["config_error"] = str(e)
with open("env_report.json", "w") as f:
    json.dump(report, f, indent=2)
print(json.dumps(report, indent=2))
PY
