#!/bin/bash
set -e

# Stop kalau ada error 
VERSION=$(git rev-parse --short HEAD)

# Pakai Git commit hash sebagai version
IMAGE="my-app:${VERSION}"
echo "Building $IMAGE..."
docker build -t $IMAGE .
echo "Testing $IMAGE..."
CONTAINER=$(docker run -d -e APP_VERSION=$VERSION -p 3001:3000 $IMAGE)
sleep 2 
RESPONSE=$(curl -sf http://localhost:3001 || echo "Error")
docker stop $CONTAINER && docker rm $CONTAINER
if
echo "$RESPONSE" | grep -q "Error"; then
    echo "Test failed! Tidak Deploy."
    exit 1
fi

echo "Test passed!: $RESPONSE"
echo "Deploying $IMAGE..."
docker stop my-app-prod 2>/dev/null || true
docker rm my-app-prod 2>/dev/null || true
docker run -d --name my-app-prod -e APP_VERSION=$VERSION -p 3000:3000 $IMAGE
echo ""
echo "Deployed $IMAGE as my-app-prod"
echo "Test: curl http://localhost:3000"
