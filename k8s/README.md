# Cloud DevOps Project - Kubernetes Deployment

This repo contains the Kubernetes configuration files for deploying a Flask app using:
- Deployment
- Service (NodePort)
- Custom Namespace

## How to Apply

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
