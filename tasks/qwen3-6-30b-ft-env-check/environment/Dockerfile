FROM ubuntu:24.04
RUN apt-get update && apt-get install -y python3 python3-pip pciutils && rm -rf /var/lib/apt/lists/*
RUN pip3 install --break-system-packages torch transformers accelerate
WORKDIR /app
