# Swisscom SminGate Coding Challenge CI/CD

## Background
The "Hello World" application is running in Kubernetes and requires additional parameters from an external data source, which can be retrieved via an API. The API requires an authentication request, providing a token, authorizing subsequent query requests. 

The objective of this task is to create an automation, which authenticates against the API of the external data source, retrieves the parameters, and deploys the "Hello World" application including the retrieved data to Kubernetes.

## Tasks
Part 1 involves creating the automation given specific presets. Part 2 involves critacally questioning the presets.

### 1.
* Create a Bash script which retrieves the token for the external data source API, then retrieves PARAMETER1 and PARAMETER2, passing the token via http GET parameter named 'TOKEN'. 
* Create a docker image, ready to run this bash script.
* Extend the Bash script to generate a plain kubernetes deployment yaml, deploying the "Hello World" app. The provided deployment must result in the container outputting "HELLO WORD , {parmater1} - {parmater1}" on startup, with the retrieved values of PARAMETER1 and PARAMETER2.

### 2.
* Please come up with an alternative way to deploy the "Hello World" application with the same end result as with part 1, then briefly debate the pros and cons of both solutions.
* Please note: it is not required to create a demonstration of the alternative solution.

> **Important:** To ensure your privacy, please **download** the Github repository and submit your work in your own Github repository. Once finished, kindly send us the link to the repository for review.

## Resources
* Hello World app: https://hub.docker.com/_/hello-world
* external data source auth: https://151dd0e4-bd8b-453b-a01c-924e75053a8b.mock.pstmn.io/auth
* external data source parameters: https://151dd0e4-bd8b-453b-a01c-924e75053a8b.mock.pstmn.io/parameters

## Task 1 specifics/how to run:
Follow these steps to build the Docker image and deploy the application:
### 1. Build and Run the Docker Image 

Build and run the Docker image using the Dockerfile and the `get_params.sh` bash script. This script fetches the parameters from the external API and generates the `deployment.yaml` file. 

You will need to mount a volume to the container to access the `deployment.yaml` file. This can be done using the `-v` option with the `docker run` command. Replace `${PWD}` with the appropriate command for your operating system, if necessary.

```bash
docker build -t get-params .
docker run -v ${PWD}/output:/output get-params:latest
```

**Note:** `${PWD}` returns the current working directory on Unix-based systems. If you're using a different operating system, you might need to replace `${PWD}` with the appropriate command.
**Note:** The generated yaml file will use pseemayer/hello-world, which is just a pre-built version of the included files under the "helloWorldApp" folder.

Or you can use my own built version of this image
```bash
docker run -v ${PWD}/output:/output pseemayer/get-params:latest
```

### 2. Deploy the Application

After running the Docker container, the `deployment.yaml` file should be located in your `output` directory. You can use this file to deploy the application to your Kubernetes cluster with `kubectl`:
```bash
kubectl apply -f output/deployment.yaml
```

**Note:** For testing purposes, Docker Desktop's internal Kubernetes was used.

### 3. Check the Deployment

After deploying the application, you should be able to see the output of the "Hello World" application in the logs of the deployed pod. You can retrieve the logs with `kubectl logs <pod-name>`.

```bash
kubectl logs <pod-name>
```

## Answers for Task 2:
### Alternative: 
Using ConfigMaps/Secrets for environment variables and Helm for deployment
In this alternative, we can use Kubernetes native resources, ConfigMaps and Secrets, to store PARAMETER1 and PARAMETER2, which are retrieved from the external data source API, and Helm to handle the deployment of the application.
We would first authenticate with the external data source API and retrieve the parameters as before.
The retrieved parameters would then be stored in a ConfigMap/Secret in the Kubernetes cluster.
We would have a Helm chart for our "Hello World" application which refers to the values in the ConfigMap/Secret as environment variables.
To deploy the application, we run helm install or helm upgrade with the Helm chart.

### Pros and Cons:
Solution 1 (Bash Script & Docker):
Pros:

* Easy to set up without a lot of Kubernetes specific knowledge. 
* Docker and Bash are widely used, and many developers are familiar with them.

Cons:

* The approach tightly couples the data retrieval and deployment process. This might not be ideal in a real-world scenario where these would often be handled separately.
* The Docker container is ephemeral and the deployment YAML file generated is lost when the container is terminated. This requires workarounds to access generated files.

Solution 2 (ConfigMaps/Secrets & Helm):

Pros:

* Decouples the process of data retrieval and application deployment. This allows more flexibility.
* Helm simplifies the management and deployment of Kubernetes applications.
* ConfigMaps and Secrets are Kubernetes-native solutions for managing configuration data, improving compatibility and integration with other parts of the Kubernetes ecosystem.
Cons:

* Managing Helm charts can become complex with large applications.
* Takes longer to initially set up