Context: AI research use: full fine-tuning of Qwen3.6-30B-A3B (MoE) on hosted GPU compute (B200), including training runs and checkpoint evaluation. Single-GPU, bounded runs, within plan credits.

Goal of this task: verify the training environment only. Do NOT run a full fine-tuning run and do NOT download full model weights.

Check and record, in a file named env_report.json in the working directory:
1. GPU: run `nvidia-smi` and record the GPU name. Confirm it is a B200-class GPU.
2. CUDA/PyTorch stack: record the PyTorch version, whether CUDA is available (`torch.cuda.is_available()`), the CUDA version PyTorch reports, and the number of GPUs visible.
3. Model config loading: using the installed transformers library, try to load only the model configuration (not weights) for Qwen3.6-30B-A3B and record whether config loading succeeded, plus the model type and hidden size if available. If config loading is unavailable offline, record that result honestly instead of claiming success.

Write env_report.json with fields: gpu_name, torch_version, cuda_available, cuda_version, gpu_count, config_load_success, model_type, hidden_size. This report is the deliverable of this environment check.
