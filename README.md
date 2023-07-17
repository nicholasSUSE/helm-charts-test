# Nick Helm Charts Test

## Objective: 

The objective of this GitHub repository is to provide a Helm chart repository with three different charts, each with different versions, available in separate branches.

The repository is designed to be easily installable using Rancher, providing installable charts that are `ready-to-go`` immediately after installation. The charts are pre-configured to ensure smooth deployment and are equipped with automatic testing capabilities to verify their successful installation.

---

### Architecture

A Helm chart Hello World example with an automatic job for testing internal connection for Kubernetes with versioning.

Features:

- Automatic job for testing internal connection
- Ingress configuration for accessing the application
- Nginx container with custom configuration
- Service definition for exposing the application
- Deployment of the Nginx container
- ConfigMap for Nginx configuration

---
  
#### Automatic Job for Testing

This Helm chart includes an automatic job for testing the internal connection of the application. The job is performed using the `busybox` image, a lightweight container that provides a minimal shell environment.

The job performs a GET request to the application's API endpoint and logs the response. This helps to verify the connectivity and functionality of the deployed application.

##### Usage

To initiate the automatic job for testing, follow these steps:

1. Add the github repository to the rancher repositories and Install the Helm chart using the provided configuration.
2. After the deployment is complete, a Job named `{{ .Release.Name }}-connection-test` will be automatically created.
3. The job container will perform a GET request to the API endpoint of the application.
4. The response from the API will be logged and can be viewed in the job logs.
Note: Ensure that the necessary networking configurations are in place, such as service and ingress settings, to enable access to the application API from the job container. (i.e just run rancher at the default mode)

---

#### Nginx and Ingress

- **External Access**: Ingress allows external clients to access the application using a defined host and URL path, such as `http://localhost/hello-1`.
- **Load Balancing**: Nginx acts as a load balancer, distributing incoming requests across multiple replicas of the application's deployment.
- **Routing and Path-Based Access**: Ingress allows routing of requests based on defined rules, directing traffic to specific services based on the requested URL path. In this chart, requests to the `/hello-1` path are routed to the application's service.

Together, Nginx and Ingress enable external access, load balancing, and routing capabilities for the application, making it accessible and scalable within the Kubernetes cluster.

---

#### Service and Deployment

- The **Service** object defines a stable network endpoint (Cluster IP) for the application. It allows other components within the cluster to access the application using the service's name and port. In this chart, the Service object is named `{{ .Release.Name }}--service` and exposes port `{{ .Values.service.port }}` for the application.
- The **Deployment** object defines the desired state of the application's pod replicas. It ensures that the specified number of replicas (in this chart, 1 replica) is running at all times. The Deployment also manages rolling updates and rollbacks when changes are made to the application's configuration. In this chart, the Deployment object is named `{{ .Release.Name }}--deployment`.

By combining the Service and Deployment objects, we achieve the following benefits:

- **Network Accessibility**: The Service object provides a stable network endpoint that allows other components within the cluster to communicate with the application using its service name.
- **Scalability**: The Deployment object allows scaling of the application by managing multiple pod replicas. This ensures high availability and load balancing across the replicas.
- **Lifecycle Management**: The Deployment object handles the creation, scaling, updating, and deletion of the application's pod replicas. It provides features like rolling updates and rollbacks, ensuring seamless changes to the application's configuration.

Together, the Service and Deployment objects enable network access, scalability, and lifecycle management for the application within the Kubernetes cluster.

---

#### values yaml file

- `Service port (service.port)`: This is the port that other services within your Kubernetes cluster will use to communicate with your service. It's typically fine to set this to a non-standard value like 81.

- `Container port (container.port)`: This is the port that your application inside the container is listening on. In your case, it's the port that nginx is listening on. Nginx typically listens on port 80 (for HTTP) or 443 (for HTTPS), and most configurations and tutorials will assume it's listening on one of these ports. If you change this to a non-standard value, you might run into confusion or issues later if you or someone else assumes it's on port 80. But technically it's fine to change it, as long as you're aware of the potential for confusion.

- `Nginx listen port (nginx.listenPort)`: This is effectively the same as the container port, it's just specific to nginx. Nginx is configured to listen on this port for incoming HTTP connections. Again, it's fine to change this to a non-standard value, but you might run into confusion later if you or someone else assumes it's on port 80.

```(yaml)
replicaCount: 1
image:
  repository: nginx
  tag: "1.14.2"
service:
  type: ClusterIP
  port: 81 #service port
container:
  port: 81 #container port 
nginx:
  listenPort: 81 #Port which Nginx listens for traffic
```

---

## Configuration

### How to re-create from scratch

https://www.opcito.com/blogs/creating-helm-repository-using-github-pages

0. Start new local and remote repository
1. At newRepo/root `helm create charts`
2. Make any changes and add `robots.txt` as show in this repo
3. Create .tgx file: `helm package charts`
4. Create index.yaml file: `helm repo index --url <github_clone_url> .`
5. Update remote:
    - `git add .`
    - `git commit -m "some message"`
    - `git push origin main`
6. GitHub repository -> Settings -> Pages:
    - Source section: [branch]
    - Save
7. Refresh page and wait until you get the Helm Repo Page Url
8. Add helm repo locally: `helm repo add myrepo <helm-repo-page-url>`
9. Installing Helm chart at cluster:

    ```(bash)
    kubectl create namespace <my_namespace>
    helm install [REALEASE-NAME] [CHART_FOLDER] --namespace [NAMESPACE]
    ```

10. Deleting from Cluster:

    ```(bash)
    helm list -n <namespace>
    helm delete <release> -n <namespace> 
    Helm history RELEASE –n <namespace>
    helm rollback <release> [REVISION] -n <namespace> 
    ```

---
### Updating Releases

0. Modifications Made
1. Increment `charts/Chart.yaml`

    ```(yaml)
    # This is the chart version. This version number should be incremented each time you make changes
    # to the chart and its templates, including the app version.
    # Versions are expected to follow Semantic Versioning (https://semver.org/)
    version: 0.1.1

    # This is the version number of the application being deployed. This version number should be
    # incremented each time you make changes to the application. Versions are not expected to
    # follow Semantic Versioning. They should reflect the version the application is using.
    # It is recommended to use it with quotes.
    appVersion: "1.16.1"
    ```

2. Create a new .tgz file: `helm package charts --version 0.1.1 --app-version 1.16.1`.
3. `Helm repo index --url <github_repository_path> .`

---
### Updating with new charts

1. Copy paste some chart folder and update the .yaml files
2. Package everything:

  ```(bash)
  helm package charts/hello-1 -d packages
  helm package charts/hello-2 -d packages
  helm package charts/hello-3 -d packages
  ```

3. Regenerate index: `helm repo index --url https://github.com/nicholasSUSE/helm-charts-test .`
4. Update remote:
    - `git add .`
    - `git commit -m "some message"`
    - `git push origin main`

#### Testing Locally

```(bash)
helm install hello-1-test ./charts/hello-1
kubectl get all
helm uninstall hello-1-test

```