vProfile – AWS Cloud-Based Java Web Application

vProfile is a production-style, multi-tier Java web application deployed on AWS to demonstrate real-world cloud architecture and DevOps practices. The application is built using Java, Spring MVC, Maven, and JSP, and runs on Apache Tomcat.

The infrastructure is hosted on AWS using EC2 instances behind an Application Load Balancer (ALB), with Route 53 used for DNS management. Application artifacts are stored in Amazon S3 and deployed to Tomcat instances using IAM roles for secure access.

The backend services include MariaDB for relational data storage, Memcached for caching, and RabbitMQ for asynchronous message processing. Each service runs on a separate EC2 instance with proper security group isolation, enabling scalable and fault-tolerant communication between components.

This project demonstrates hands-on experience with AWS networking, security groups, IAM roles, artifact management, service integration, and troubleshooting real deployment issues in a cloud environment.ture.”
