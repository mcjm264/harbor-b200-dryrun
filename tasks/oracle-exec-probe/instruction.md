# Oracle execution probe

This task checks that the oracle agent runs solution/solve.sh as the agent phase on hosted Harbor. The solution performs a short timed run (about 2 minutes), records the GPU name and start/end timestamps into marker files, and the verifier confirms the markers. No real workload.
