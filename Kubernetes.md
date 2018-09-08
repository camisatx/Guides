# Kubernetes Notes

This document is a collection of notes I've assembled from my time learning how to use Kubernetes. Don't take them as gospel, as they are likely to be wrong... :3

## Contents

- [Terminology](#terminology)
- [Single Container Setup](#single-container-setup)

## Terminology

**Pods** - units that represent a container (or group of tightly-coupled containers)

**Deployment** - manages multiple copies of your application (replicas) and schedules them to run on the individual nodes in your cluster

**Service** - provides networking and IP support to the application's pods; Kubernetes Engine creates an external IP and a load balancer for the application

## Single Container Setup

This process spins up a single Docker container within a GKE cluster. It follows the [hello-app tutorial](https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app) from the Google Cloud docs.

Steps:
1. Specify the project environment within the terminal for easy retrieval: `export PROJECT_ID="$(gcloud config get-value project -q)"`

    1.1. Change the default `gcloud` environment with: `gcloud config set project PROJECT_ID` where `PROJECT_ID` is the exact name of the environment you specified within the Google Cloud console

2. Build the Docker container and assign a tag to it: `docker build -t gcr.io/${PROJECT_ID}/helloapp:v1 .`

    2.1. Optional - Test the container locally: `docker run --rm -p 8080:8080 gcr.io/${PROJECT_ID}/hello-app:v1`

3. Push the Docker container to the Google Container Registry: `docker push grc.io/${PROJECT_ID}/hello-app:v1`

    3.1. You may need to authenticate the Docker command line tool to access the Container Registry with: `gcloud auth configure-docker`

4. Create the container cluster (a pool of Compute Engine VM instances running Kubernetes) where the containers will be run: `gcloud container clusters create hello-cluster --num-nodes=3`

    4.1. If you are using an existing cluster, retrieve the cluster's credentials with: `gcloud container clusters get-credentials hello-cluster`

5. Deploy the application, making it listen on port 8080: `kubectl run hello-web --image=gcr.io/${PROJECT_ID}}/hello-app:v1 --port 8080`

6. Create a service (via `kubectl expose`) that will expose the application to the internet (only required on Kubernetes Engine): `kubectl expose deployment hello-web --type=LoadBalancer --port 80 --target-port 8080`

    6.1. View the external IP with: `kubectl get service`

7. Scale the application by adding more replicas to the deployment: `kubectl scale deployment hello-web --replicas=3`

8. Deploy a new version of the application by:

    8.1. Building the new container: `docker build -t gcr.io/${PROJECT_ID}/hello-app:v2 .`

    8.2. Push the container to Google Container Registry: `gcloud docker -- push gcr.io/${PROJECT_ID}/hello-app:v2`

    8.3. Apply a rolling update to the existing deployment: `kubectl set image deployment/hello-web hello-web=gcr.io/${PROJECT_ID}/hello-app:v2`

9. If testing, delete the environment (**WARNING** - will remove the deployment!):

    9.1. Delete the service: `kubectl delete service hello-web`

    9.2. Delete the container cluster: `gcloud container clusters delete hello-cluster`

    9.3. Delete the containers stored in the Google Container Repository

    9.4. Delete the containers stored locally: `docker image rm gcr.io/${PROJECT_ID}/hello-app`
