#!/usr/bin/env bash

kubectl apply -f rbac.yaml
helm init --service-account tiller --tiller-namespace helm

