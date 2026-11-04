# Checkpoint egress probe (infrastructure check)

This task only checks whether the sandbox can move checkpoint-sized data in and out during a run: outbound internet reachability (Hugging Face), download and upload throughput, and whether a single phase can run multi-hour (cancelled after a few minutes once startup is confirmed). There is no agent work and no model training in this task. All checks run in tests/test.sh during verification.
