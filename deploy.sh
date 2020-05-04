#!/usr/bin/env bash

docker build -t skiddykong/multi-client:latest -t skiddykong/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t skiddykong/multi-server:latest -t skiddykong/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t skiddykong/multi-worker:latest -t skiddykong/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push skiddykong/multi-client:latest
docker push skiddykong/multi-server:latest
docker push skiddykong/multi-worker:latest

docker push skiddykong/multi-client:$SHA
docker push skiddykong/multi-server:$SHA
docker push skiddykong/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=skiddykong/multi-server:$SHA
kubectl set image deployments/client-deployment client=skiddykong/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=skiddykong/multi-worker:$SHA
