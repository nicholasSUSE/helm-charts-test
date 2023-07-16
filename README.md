# Nick Helm Charts Test

- Objective:
- Architecture:

---
## Steps to recreate
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
#### values yaml file

- `Service port (service.port)`: This is the port that other services within your Kubernetes cluster will use to communicate with your service. It's typically fine to set this to a non-standard value like 81.

- `Container port (container.port)`: This is the port that your application inside the container is listening on. In your case, it's the port that nginx is listening on. Nginx typically listens on port 80 (for HTTP) or 443 (for HTTPS), and most configurations and tutorials will assume it's listening on one of these ports. If you change this to a non-standard value, you might run into confusion or issues later if you or someone else assumes it's on port 80. But technically it's fine to change it, as long as you're aware of the potential for confusion.

- `Nginx listen port (nginx.listenPort)`: This is effectively the same as the container port, it's just specific to nginx. Nginx is configured to listen on this port for incoming HTTP connections. Again, it's fine to change this to a non-standard value, but you might run into confusion later if you or someone else assumes it's on port 80.

In summary, it's technically fine to change all of these ports to 81, but it might be a bit confusing for someone who's used to these services listening on their standard ports. If you're trying to avoid conflicts with other services that use port 80, you could consider using a higher port number that's less likely to be in use, like 8080 or 8000. These are often used for HTTP in situations where port 80 is not available, and might be a bit less confusing than 81.

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
##### Updating with new charts

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

#### Testing

```(bash)
helm install hello-1-test ./charts/hello-1
kubectl get all
helm uninstall hello-1-test

```