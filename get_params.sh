#!/bin/bash

# Authenticate and retrieve the token
TOKEN=$(curl -s -X GET "https://151dd0e4-bd8b-453b-a01c-924e75053a8b.mock.pstmn.io/auth")

# Retrieve parameters
PARAMETERS=$(curl -H "Authorization: $TOKEN" -s -X GET "https://151dd0e4-bd8b-453b-a01c-924e75053a8b.mock.pstmn.io/parameters")
PARAMETER1=$(jq -r '.PARAMETER1' <<<"$PARAMETERS")
PARAMETER2=$(jq -r '.PARAMETER2' <<<"$PARAMETERS")


# Generate a Kubernetes deployment YAML
cat <<EOF > output/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-world
        image: pseemayer/hello-world:latest
        env:
        - name: PARAMETER1
          value: "$PARAMETER1"
        - name: PARAMETER2
          value: "$PARAMETER2"
EOF