# DevOps Learning Project – CI/CD with GitHub Actions

## Overview
This repository is my **first hands-on DevOps project**, created to learn and practice **CI/CD concepts** using real tools and real infrastructure.

The main focus of this project is:
- Understanding **how CI/CD works end-to-end**
- Using **GitHub Actions** for Continuous Integration and Continuous Deployment
- Building and shipping applications with **Docker**
- Deploying automatically to an **AWS EC2** server

The application itself is intentionally simple (a Flask web app). The goal is **not the app**, but the **DevOps pipeline around it**.

---

## What This Project Demonstrates

- Automated testing with `pytest`
- Docker image build and push to Docker Hub
- Secure secret handling with GitHub Secrets
- SSH-based deployment to a remote Linux server
- Container lifecycle management (stop / replace / restart)
- Production-like practices such as restart policies and health endpoints

---

## Architecture & Flow

High-level flow:

```
Developer (git push)
        |
        v
GitHub Repository
        |
        v
GitHub Actions (CI/CD)
  - Install dependencies
  - Run tests (pytest)
  - Build Docker image
  - Push image to Docker Hub
  - SSH into EC2
        |
        v
Docker Hub (Image Registry)
        |
        v
AWS EC2 Server
  - Pull latest image
  - Stop old container
  - Run new container
        |
        v
Web Application (Port 80)
```

This creates a **fully automated pipeline** from code commit to a live running service.

---

## Repository Structure

```
.
├── .github/workflows/
│   └── deploy.yml        # CI/CD pipeline definition
├── tests/
│   └── test_app.py       # Application tests
├── app.py                # Flask application
├── Dockerfile            # Docker image definition
├── requirements.txt      # Python runtime dependencies
├── .dockerignore
└── README.md
```

---

## CI/CD Pipeline (GitHub Actions)

The pipeline is triggered on every `push` to the main branch in the repository.

### Pipeline Steps

1. **Checkout Code**
2. **Set up Python 3.9**
3. **Install dependencies**
4. **Run tests (pytest)**
5. **Login to Docker Hub** (via GitHub Secrets)
6. **Build Docker image**
7. **Push image to Docker Hub**
8. **Deploy to EC2 via SSH**

Only if tests pass does the pipeline continue to build and deploy.

---

## Deployment Strategy

Deployment is done using a **recreate strategy**:

1. Pull the latest Docker image from Docker Hub
2. Stop the currently running container (if exists)
3. Remove the old container
4. Start a new container with the updated image

The container is run with:

```
--restart unless-stopped
```

This ensures the application automatically restarts after:
- EC2 reboot
- Docker daemon restart
- Application crash

---

## Application Endpoints

| Endpoint   | Description |
|-----------|------------|
| `/`        | Main application response |
| `/health` | Health check endpoint |
| `/version`| Application version |
| `/info`   | Runtime/server metadata |

These endpoints are useful for:
- Monitoring
- Health checks
- Debugging deployments

---

## Important Commands

### Run container manually on EC2

```
docker pull <username>/devops-project:latest
docker stop webapp || true
docker rm webapp || true
docker run -d --restart unless-stopped --name webapp -p 80:5000 <username>/devops-project:latest
```

### Check running containers

```
docker ps
```

### View container logs

```
docker logs webapp
```

### Test application locally on EC2

```
curl http://localhost
```

---

## Security Notes

- Secrets (Docker Hub credentials, SSH key, server IP) are stored securely using **GitHub Secrets**
- SSH access uses **key-based authentication only**
- No credentials are hardcoded in the repository

---

## Why This Project Exists

This project exists to:
- Build a **strong DevOps foundation**
- Understand how CI/CD works under the hood
- Practice Linux, Docker, networking, and automation
- Serve as a **portfolio project** demonstrating real-world DevOps skills

The setup intentionally avoids over-engineering (Kubernetes, Terraform, etc.) and focuses on **core concepts done correctly**.


