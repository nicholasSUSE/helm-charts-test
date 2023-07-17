  # How-to
  
  - Just give a name and install on a rancher default installation. 
  - After installed, you will se a command for checking the test result: `kubectl logs job/<release_name>-connection-test`
  - Open a shell at rancher and run, or run from your terminal if the Kubeconfig is configured for the same cluster. 
  - Or just go see the logs from the corresponding job pod. 

  ## Architecture

  A Helm chart Hello World example with an automatic job for testing internal connection for Kubernetes with versioning.

  Features:

  - Automatic job for testing internal connection
  - Ingress configuration for accessing the application
  - Nginx container with custom configuration
  - Service definition for exposing the application
  - Deployment of the Nginx container
  - ConfigMap for Nginx configuration
