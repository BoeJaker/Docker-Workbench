# Docker-GitHub Workbench 
<!-- [![Sparkline](https://stars.medv.io/BoeJaker/Workbench.svg)](https://stars.medv.io/Boejaker/Workbench) -->

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/Boejaker/Workbench/graphs/commit-activity)
[![Ask Me Anything !](https://img.shields.io/badge/Ask%20me-anything-1abc9c.svg)](https://GitHub.com/Boejaker/ama)
[![saythanks](https://img.shields.io/badge/say-thanks-ff69b4.svg)](https://saythanks.io/to/boejaker)
[![GitHub license](https://img.shields.io/github/license/Boejaker/Workbench.svg)](https://github.com/Boejaker/Workbench/blob/master/LICENSE)  

[![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://https://docker.com/)
[![GitHub branches](https://badgen.net/github/branches/Boejaker/Workbench)](https://github.com/Boejaker/Workbench/)
[![GitHub release](https://img.shields.io/github/release/Boejaker/Workbench.svg)](https://github.com/Boejaker/Workbench/releases/) 
[![Latest release](https://badgen.net/github/release/Boejaker/Workbench)](https://github.com/Boejaker/Workbench/releases)
[![GitHub latest commit](https://badgen.net/github/last-commit/Boejaker/Workbench)](https://github.com/Boejaker/Workbench/commit/)
[![GitHub issues](https://img.shields.io/github/issues/Boejaker/Workbench.svg)](https://github.com/Boejaker/Workbench/issues/)  

# What is Docker-Github Workbench?
A docker-compose for bootstrapping virtual networks, such as test platforms for code, virtualized file servers, virtualized computer science labs.

### Problem:  
Working with git across multiple machines and locations poses a challenge in maintaining a consistent and reliable production environment for my projects and tools. It becomes increasingly difficult to ensure that the development environment on each machine matches the desired configuration. Additionally, I require access to the powerful computing resources available on my desktop machine.

### Goal:  
To address these challenges, I am seeking a solution that allows me to create a private network environment capable of providing seamless access to the computing capabilities of my desktop machine. By establishing this network, I aim to achieve a consistent and flexible development environment that can be accessed from any location. Docker emerges as a promising technology that can enable the creation of isolated, containerized environments, ensuring consistent configurations across multiple machines.

The primary goal of this project is to leverage Docker and related technologies to establish a robust and portable development environment. This environment will enable me to seamlessly transition between different machines and locations while maintaining consistency in the setup, dependencies, and configurations of my projects and tools. By utilizing Docker, I anticipate achieving a flexible and scalable solution that optimizes productivity and resource utilization.

### Solution:  
By leveraging Twingate, I will establish a secure network connection that allows me to access my powerful desktop's computing resources from any location. This will address the challenge of maintaining a consistent production environment across multiple machines and locations.

To enhance the flexibility and consistency of my development environment, I will containerize operating systems. This approach will enable me to quickly deploy isolated environments for testing code, ensuring that each instance is self-contained and can be easily spun up, imaged, and shut down as needed.

Furthermore, I plan to create a variety of containerized tools specifically designed to monitor and log the Docker stack. These tools will serve as valuable resources for postmortem analysis of failures, enabling me to diagnose issues more effectively and identify bugs more efficiently. The metrics collected from these monitoring tools will also play a crucial role in measuring the overall health and performance of the system.

### Conclusion:
Overall, this solution aims to establish a secure and flexible development environment that leverages containerization, remote network connectivity, and robust monitoring capabilities. By implementing these strategies, I will be able to streamline my development workflow, enhance debugging processes, and ensure the optimal performance of my projects.

<br>

# Overview

The stack consists of servers, clients and services which can be further broken down into sub-categories, below is a description of each, their function and properties.

<br>

## Servers

Servers are containers configured to serve content to clients and the host system. A website server such as flask or database like postgres would be an example.

Each dockerfile contains commands to bootstrap its associated image and install a specified package from a CDN or from version control such as git, currently it is installed to /app.  
<br>

### Alpine
Name: alpine-server  
Environment:  
Description:  
A 'vanilla' Alpine server, lightweight and fast. Test linux sever code in a deterministic environment.  
<br>

### FTP
Name: ftp  
Ports:    
    21:21   
    21000-21010:21000-21010   
Environment:  
Description:  
An ftp server using Alpine. Launch basic FTP servers and test ftp services in a deterministic environment.   
<br>

### Postgres
Name: postgres  
Ports:
    5432
<br>

### Ubuntu
Name: ubuntu-server  
Ports: 80:80  
Environment:  
Description:  
Launch a ubuntu server or test ubuntu server code in a deterministic environment.
<br>

## Clients

Clients are containers configured to receive content, send requests to servers and use service containers. Each OS has a respective client container, these include windows, linux, mac, IOS and android operating systems.
Multiple identical clients can be built to simulate real world networks and loads.  
Note:  
When a client is built it creates a shared app folder and downloads the latest version of the git repo specified in .env to the app folder.  


Each dockerfile contains commands to bootstrap its associated image and install a specified package from a CDN or from version control such as git, currently it is installed to /app. However some clients are pre configured for use as virtual machines using VNC.

Clients are headless but you can run gui's by forwarding to the hosts X11 server (xming on windows)

### Windows
Name: windows-client  
Environment:  
Description:  
Test windows client code in a deterministic environment.
<br>

### Ubuntu
Name: ubuntu-client  
Environment:  
Description:  
Test ubnutu client code in a deterministic environment.
<br>

### OSX
Name: osx-client  
Environment:  
Description:  
Test OSX client code in a deterministic environment.
<br>

### IOS
Name: ios-client  
Environment:  
Description:  
Test IOS client code in a deterministic environment.
<br>

### Andoid
Name: android-client  
Environment:  
Description:  
Test android client code in a deterministic environment.
<br>

## VNC Clients
### Ubuntu
Name: vnc (ubuntu-vnc)  
Environment:  
Description: 

### Kali
Name: kali (kali-vnc)  
Environment:  
Description: 


## Services

Services are containers that provide network services such as VPN, logging, penetration testing and stress testing. Twingate is an example of a service, it allows the admin to, from anywhere, connect to services, servers & clients within the docker network.

### NoVNC
Name: novnc   
Ports: 6080:80  
Environment:  
Description:  
Virtual Network Computing, a technology that allows remote access and control of a computer or server over a network. Capable of forwarding any container using an x11 interface.
### VPN  
Name: VPN  
Environment:  
Description:  
Provides a virtual private network that can be accessed, internally site-to-site or remotely
<br>

### Twingate  
Name: twingate  
Environment:  
These environment variables must be set to use twingate      
    TENANT_URL="https://your_network.twingate.com"   
    ACCESS_TOKEN="sixXa1L...5MaMdgJte8a281xg"  
    REFRESH_TOKEN="824_Q....NBQO"  
    TWINGATE_LABEL_HOSTNAME="\`hostname\`" 

Description:
Provides a zero trust network access solution. It provides a simple and secure way to connect users to internal applications and resources, while also allowing IT teams to maintain control and visibility over access policies and permissions. It works by authenticating users and devices, and then granting access to specific resources based on their access policies.
<br>

### Prometheus
Name: prometheus
Ports: 9090:9090  
Environment: 
Description:
An open-source monitoring system and time series database that is designed to collect and store metrics from various sources, including containers, operating systems, and applications. It provides powerful querying and alerting capabilities.
<br>

### Large Language Model Interface
Name: llm
Ports: 8888:7860
Environment: 
Description:
A python framework for loading large language models into a gradio interface.

<!-- ## Warnings
Dont use the command:   

    docker compose up  

without specifying which clients, servers or services you would like. Not doing so will result  -->
<!-- <br>  
<br>   -->

# Environment Variables  

These variables must be set in a variable called .env in the project root,  or with 'docker compose run' using the -e flag. See env.dummy in the root directory for an example of a .env file.  
### <u>Docker Images & Digests</u>    
These environment variables do not need to be set. Defaults are set in the .Dockerfile

    ALPINE_IMAGE=alpine
    ALPINE_DIGEST=''  

    WINDOWS_IMAGE=mcr.microsoft.com/windows  
    WINDOWS_DIGEST=''  

    ANDROID_DIGEST=''  
    OSX_DIGEST=''  
    IOS_DIGEST=''  

    UBUNTU_IMAGE=fredblgr/ubuntu-novnc 
    UBUNTU_DIGEST=''    

These variables set the image that each container is built with. Defaults are set for each in the respective dockerfile,you can set the digest and image of the container you are building with by setting it in .env or at build time on the command line.  
<br>

### <u>GitHub</u>
These environment variables must be set to use git

    GITHUB_TOKEN=asd_K...WE69 
    GITHUB_USERNAME=Your_User  
    CLIENT_REPO=github.com/Your_User/Your_Git.git  
    SERVER_REPO=github.com/Your_User/Your_Git.git    
<br>

### <u>Pass-through Environment Variables</u>
These environment variables pass though to the running containers.

    CLIENT_MODE=''  
    SERVER_MODE=''   

 Execution modes are examples of pass-through environment variables intended to augment the execution of the code being tested. They do not impact the build of the container. There function should be defined in the tested code.

<br>
<br>  
  
# Build Command Syntax  
Containers can be built one at a time using consecutive simple build statements.
Alternatively users can opt to build all the clients, servers and services they would like with a single command using a complex build statement.  
<br>  

## Simple Build
To build a standalone client, server or service execute the following, substituting [client|server|service] for the name of the client, server or service you would like to run.

    docker-compose build [client|server|service]

    docker-compose up [client|server|service]

With the values filled it it would look like the following

    docker-compose build alpine-server

    docker-compose up alpine-server   

You can also run an interactive session with

    docker-compose run -it [client|server|service] 

<br>

## Complex Build
It is possible to build a virtual network of servers and clients

    docker-compose build [server] [client 1] [client 2] [service]  

    docker-compose up [server] [client 1] [client 2] [service]  

With the values filled it it would look like 

    docker-compose build alpine-server windows-client ubuntu-client  
<br>

## Ad-hoc Environment Variables
Alternatively you can use to specify adhoc environment variables

    docker-compose run -e [ENVIRONMENT_VARIABLE_1] -e [ENVIRONMENT_VARIABLE_2] [server] [client 1] [service 1]  

You can specify any combination of servers, hosts and services, that have been defined in the compose file  

<br>  
<br>  

# Saving and Restoration of State

<b>NOTE: Saved configuration should be scrubbed of their keys before sharing</b>
 

## Scrubbing keys

Run the command


to scrub the image of environment variables defined here.

## Saving State

Use the following command to save the current configuration 
     
    docker-compose save -o [my-project.tar] [my-project]

## Loading State

Replace my-project with the name of your Docker Compose project, and my-project.tar with the name you want to give the tar archive.
to restore the project 

    docker-compose load -i my-project.tar

<br>  

# Windows Containers
To run windows contianers you must first switch docker to windows mode, this can be done by executing the following   

    & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon

This can also be achieved by right clicking the docker tray icon and selecting 'Switch to windows containers'

<br>   

# Useful flags

To help calculate system requirements you can use the verbose flag 
    
    docker-compose build --verbose

To build with no cache - useful for debugging environment variables and build commands

    docker-compose build --no-cache

To view the output of echo statements in the build process, this can help you debug misconfigurations

    docker-compose build --progress-plain  

<br> 

# Twingate Setup

### What is twingate?
Twingate is a cloud-based network security platform that provides secure access to private networks, cloud applications, and other resources for remote workers and contractors. Twingate uses a zero-trust model to authenticate users and devices and enforce granular access policies for each resource, ensuring that only authorized users can access specific resources based on their role, device, location, and other factors. Twingate uses lightweight software components called "Connectors" to provide secure access to private networks and cloud resources without requiring a VPN or opening ports on firewalls. Twingate also provides centralized visibility and control over user activity and resource access across multiple environments, including on-premises, cloud, and hybrid environments.

Twingate has been included to serve as a simple, secure RAS.  

<br> 

### Create a Twingate network:   
A network is a logical container that represents the resources you want to secure. You can create a network by logging in to your Twingate account and navigating to the Networks page. Click on the "Create Network" button and follow the steps to create a new network.  

<br> 

### Set up a Connector:   
A Connector is a lightweight software component that allows your Docker Compose application to securely connect to your Twingate network. You can set up a Connector by navigating to the Connectors page and clicking on the "Add Connector" button. Follow the steps to set up a Connector and make sure to note the Connector's ID and Secret.  

<br> 

### Setting up a Resource in Twingate:   
this involves creating an access policy that defines the conditions under which users can access the resource. Navigate to the Resources page on the Twingate web console and click "Add Resource". Provide the necessary details for the resource, including the IP address, hostname, or URL. Next, create an access policy for the resource by clicking "Add Access Policy". Specify the users or groups that should have access to the resource, and configure any additional conditions, such as time of day or location. Once you have configured the access policy, save it and activate it.   

<br>   

### Build and Run With docker:   
You will need to add environment variables that provide the Twingate Connector configuration details. These variables include the Connector ID, Connector Secret, and the name of your Twingate network. The resource is now set up and ready for users to access securely through the Twingate network.  

<br> 

### Connect your Docker Compose Application to Twingate:   
Finally you can download the Twingate client and log in and select the network you created in step 1. Once signed in you can use the alias set when setting up the resource such as my_network.int to access the resource, try entering the alias into the browser.