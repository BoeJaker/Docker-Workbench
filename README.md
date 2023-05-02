# Docker GitHub Workbench
A docker-compose for bootstrapping virtual networks, such as test platforms for code, virtualized file servers, virtualized computer science labs.

When a container is built it creates a shared app folder and downloads the latest version of the git repo specified in .env to the app folder.  
<br>

## Overview
Each dockerfile contains commands to bootstrap an its associated image, install a git package, currently it is installed to /app  

<br>

## Servers

Servers are containers configured to serve content to clients and the host system. A website server such as flask or database like postgres would be an example.

<br>

## Clients

Clients are containers configured to receive content and send requests to server containers. Each OS has its own client, there is a client dockerfile for windows, linux, mac and phone operating systems.
Multiple identical clients can be built to simulate real world networks and loads.

<br>

## Services

Services are containers that provide network services such as VPN, logging, penetration testing and stress testing. Twingate is an example of a service, it allows the admin to, from anywhere, connect to services, servers & clients within the docker network.

<br>

## Warnings
Dont use the command   

    docker compose up  

without specifying which clients, servers or services you would like
<br>  
<br>  

# Environment Variables  


### <u>Docker Images & Digests</u>    
    ALPINE_IMAGE=alpine
    ALPINE_DIGEST=''  

    WINDOWS_IMAGE=mcr.microsoft.com/windows  
    WINDOWS_DIGEST=''  

    ANDROID_DIGEST=''  
    OSX_DIGEST=''  
    IOS_DIGEST=''  

    UBUNTU_IMAGE=fredblgr/ubuntu-novnc 
    UBUNTU_DIGEST=''    

These variables set the image that each container is built with, defaults are set for each in the respective dockerfile, but you can customize which flavour of container you are building with by settign it in .env or at build time on the command line.
<br>

### <u>Execution Mode</u>

    CLIENT_MODE=''  
    SERVER_MODE=''   
<br>
Execution modes are examples of environment variables intended to augment the execution of the code being tested. They do not impact the build of the container. There function should be defined in the tested code.

### <u>GitHub</u>

    GITHUB_TOKEN=asd_K...WE69 
    GITHUB_USERNAME=Your_User  
    CLIENT_REPO=github.com/Your_User/Your_Git.git  
    SERVER_REPO=github.com/Your_User/Your_Git.git    
<br>

### <u>Twingate</u>

    TENANT_URL="https://your_network.twingate.com"   
    ACCESS_TOKEN="sixXa1L...5MaMdgJte8a281xg"  
    REFRESH_TOKEN="824_Q....NBQO"  
    TWINGATE_LABEL_HOSTNAME="\`hostname\`"  

  
These variables must be set in a variable called .env in the project root,  or with 'docker compose run' using the -e flag. See env.dummy in the root directory for an example of a .env file.  
<br>  
<br>  
# Server, Client and Service Containers

This compose provides flexibility to use testing workflows for each of the following servers and clients, as well as a selection of services to run along-side.   
The containers are named as follows:

## Servers  
    alpine-server 
    # The below have not been implemented 
    windows-server
    debian-server
    fedora-server
    centos-server
    nginx-server
   
## Clients  
    windows-client   
    android-client   
    osx-client   
    ios-client   
    ubuntu-client
    # The below have not been implemented 
    kali-client

There are also built in network services that can be enabled to perform task such as filter traffic or log packets.

## Services
    instantlinux/samba-dc   # Domain Controller
    twingate                # Split tunnel
    vpn                     # Traditional VPN
    dns-sinkhole            # DNS filtering  - ad-blocking
    packet-capture          # Packet traffic log collection
    log-collector           # Operating system log collection


Each of these images will be set up to download and test the repositories prescribed in the environment variables.   

<br>   
<br>  
  
# Build Command Syntax  

## Simple Build
To build a standalone server execute the following, substituting [server] for the name of the server container you would like to run.

    docker compose build [server]

    docker compose up [server]

With the values filled it it would look like the following

    docker compose build alpine-server

     docker compose up alpine-server  
     
You can also run just a client with the following, substituting [client] for the name of the client container you would like to run.

    docker compose build [client]

    docker compose up [client]   

You can also run an interactive session with

    docker-compose run -it [client/server] 
<br>

## Network Build
It is possible to build a virtual network of servers and clients

    docker compose build [server] [client 1] [client 2]  

    docker compose up [server] [client 1] [client 2]  

With the values filled it it would look like 

    docker compose build alpine-server windows-client ubuntu-client  
<br>

## Service Build

Services are pre-built images that perform a network function such as VPN, packet capture, logging and more.

Services can be defined in the .env file, in which case the will be built as dependencies of any other container built.

Another way to build a service is to define add it, ad-hoc, to the build instruction.

## Ad-Hoc Service Build

    docker compose build [server] [client] [service]  

    docker compose up [server] [client] [service]  

With the values filled it it would look like 

    docker compose build alpine-server windows-client VPN

This would build both an alpine server, windows client alongside a VPN service.

<br>

## Ad-hoc Environment Variables
Alternatively you can use to specify adhoc environment variables

    docker compose run -e [ENVIRONMENT_VARIABLE_1] -e [ENVIRONMENT_VARIABLE_2] [server] [client 1] [service 1]  

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