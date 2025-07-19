# hackthon-usecase

# Deploy the containerized microservices using AWS ECS Fargate, container orchestration, serverless computing, and AWS services.

### Target Technology Stack 

```

Component                           Technology 

Infrastructure               Terraform 

Load Balancer                AWS Application Load Balancer (ALB) 

Container deployments        ECS with Fargate

Container registry           ECR

VPC Networking               AWS VPC/Subnets/RTs 

Monitoring                   Cloudwatch

CI/CD                        GitHub Actions 

State Management              S3 

```

## Prerequisites

Before deploying the Healthcare Application, ensure you have the following:

### AWS Account Setup
1. **AWS Account**: Active AWS account with appropriate permissions
2. **IAM User**: Create IAM user with programmatic access
3. **Required Permissions**:
   - EC2 (VPC, Security Groups, Load Balancers)
   - ECS (Clusters, Services, Task Definitions)
   - ECR (Repositories)
   - IAM (Roles, Policies)
   - CloudWatch (Logs)
   - S3 (Terraform state bucket)

### GitHub Repository Setup
1. **Configure Secrets** in GitHub repository settings:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret key

### Local Development Tools
- AWS CLI v2
- Terraform >= 1.12.0
- Docker
- Node.js >= 18.0.0


## Components

### Network Infrastructure
- **VPC**: Custom VPC with CIDR block 10.0.0.0/16 (dev) or 10.1.0.0/16 (prod)
- **Subnets**: 
  - Public subnets in 2 AZs for ALB and NAT Gateways
  - Private subnets in 2 AZs for ECS services
- **Internet Gateway**: Provides internet access
- **NAT Gateways**: Enable outbound internet access for private subnets
- **Route Tables**: Configured for proper traffic routing

### Compute Services
- **ECS Fargate Cluster**: Serverless container platform
- **ECS Services**: 
  - Patient Service (manages patient data)
  - Appointment Service (manages appointments)
- **Task Definitions**: Define container specifications and resource requirements

### Load Balancing
- **Application Load Balancer**: Routes traffic based on path patterns
  - `/api/patients*` → Patient Service
  - `/api/appointments*` → Appointment Service
- **Target Groups**: Health checks and service registration

### Container Registry
- **ECR Repositories**: Store Docker images
  - healthcare-app-{env}-patient-service
  - healthcare-app-{env}-appointment-service
- **Lifecycle Policies**: Retain last 5 tagged images

### Security
- **IAM Roles**:
  - ECS Task Execution Role: Pull images and write logs
  - ECS Task Role: Application-specific permissions
- **Security Groups**:
  - ALB Security Group: Allow HTTP/HTTPS from internet
  - ECS Security Group: Allow traffic from ALB only


### Monitoring and Logging
- **CloudWatch Log Groups**: Application and container logs
- **Container Insights**: ECS cluster monitoring



## Deployment Pipeline

### Infrastructure Pipeline (Terraform)
1. **Validate**: Format check and validation
2. **Plan**: Generate execution plan on PRs
3. **Apply**: Deploy to dev on main branch merge

### Application Pipeline (Docker + ECS)
1. **Build**: Create Docker images and push to ECR
2. **Deploy**: Update ECS services with new images
3. **Monitor**: Wait for deployment stabilization

## Environments

### Development (dev)
- **Resources**: Minimal for cost optimization
- **CPU/Memory**: 256 CPU units, 512 MB memory
- **Auto-deploy**: On main branch push


## Security Considerations

1. **Network Isolation**: Services in private subnets
2. **Least Privilege**: Minimal IAM permissions
3. **Encryption**: Data encrypted at rest and in transit
4. **Container Security**: Non-root user, minimal image size
5. **Secrets Management**: Environment variables for configuration
6. **Network Security**: Security groups restrict access

## Scalability

- **Horizontal Scaling**: ECS service auto-scaling based on metrics
- **Load Distribution**: Multi-AZ deployment
- **Container Orchestration**: Fargate manages compute resources
- **Stateless Design**: Services can scale independently

## Cost Optimization

- **Fargate**: Pay-per-use compute resources
- **ECR Lifecycle**: Automatic image cleanup
- **CloudWatch Logs**: Log retention policies
- **Resource Rightsizing**: Environment-specific resource allocation