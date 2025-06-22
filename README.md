## Introduction
This is a Flask application that returns a simple greeting and health check message. The goal of this project is to demonstrate containerization, IaC, K8s deployment, and CI/CD automation using Jenkins.

## Local Development
1. Run docker compose:
```
docker-compose up
```
2. The application will be available at: http://localhost:5000

Note: The app runs internally on port 5001 and is forwarded to port 5000 on the host machine via Docker Compose.

## Step by step implementation

### Step 1:
1. Write a Dockerfile by using the Python base image.
2. Since this is a small application, a multistage build is not necessary.
3. Document the internal container port using the EXPOSE 5001 directive.

### Step 2:
1. Write a Docker Compose file to build the image and forward port 5000 (host) to 5001 (container) so that the app is accessible at http://localhost:5000.
2. Mount the source code as a volume to allow live reloading or local development.
3. Run the application with `docker-compose up`


### Step 3:
1. Write Terraform code using modular structure: separate files for providers, variables, outputs, and resources for better readability and maintainability.
2. Pass variables dynamically depending on the environment using env.tfvars, where env can be dev, stg, or prod.
3. Preview the execution plan using:
```
terraform plan -var-file=dev.tfvars
```
4. Provision the resources using:
```
terraform apply -var-file=dev.tfvars
```
5. This will create a state file representing the current infrastructure state. In real-world setups, this state file should be stored in a remote backend like Azure Blob Storage, AWS S3, or DigitalOcean Spaces for team collaboration, high availability, state locking, security, and to enforce that all infrastructure changes go through Terraform.

### Step 4:
1. Write `deployment.yml` referencing the Docker image. There is no need to use a ConfigMap since the application does not require external configuration.
2. If there were configuration values, they would be defined in a ConfigMap and injected into the deployment either via environment variables (envFrom.configMapRef) or as mounted volumes.
3. For secrets, never hardcode them. Use secret management tools like HashiCorp Vault, or use Kubernetes Secret resources. Define a `secret.yml` and mount it using volume or environment variable as needed.
4. Write `service.yml` to define a stable internal service exposing port 5000 and forwarding it to container targetPort 5001.
5. Write ingress.yml to define HTTP rules for routing external requests to the internal service.

### Step 5:
1. Write a `Jenkinsfile` to configure a secure and automated CI/CD pipeline.
2. Pass sensitive values like the `DigitalOcean token` and `kubeconfig` securely using Jenkins credentials.