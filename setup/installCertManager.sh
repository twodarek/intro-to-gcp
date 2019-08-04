#!/usr/bin/env bash
# From https://hub.helm.sh/charts/jetstack/cert-manager

kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.9/deploy/manifests/00-crds.yaml
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation="true"
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install --name my-release --namespace cert-manager jetstack/cert-manager
kubectl apply -f clusterissuer.yaml

