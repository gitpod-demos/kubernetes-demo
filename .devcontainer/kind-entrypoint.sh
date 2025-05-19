#!/usr/bin/env sh
set -e

# Start Docker daemon
dockerd > /var/log/dockerd.log 2>&1 &

# Install KinD inside the DinD side-car
apk add --no-cache curl
curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
chmod +x /usr/local/bin/kind

# Wait until the inner Docker daemon is ready
until docker info >/dev/null 2>&1; do sleep 1; done

# Create cluster once (idempotent on restarts)
if ! kind get clusters | grep -q '^dev$'; then
  kind create cluster --name dev --image kindest/node:v1.30.0 --wait 5m
fi

# Keep the container alive
tail -f /dev/null