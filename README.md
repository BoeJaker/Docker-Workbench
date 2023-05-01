# Docker GitHub Workbench
Test platform for multiple container configurations.  
When a container is built it creates a shared app folder and downloads the latest version of the git repo specified in .env to the app folder.  

It can also be used to bootstrap a virtual home network.
<br>

## Overview
Each dockerfile contains commands to bootstrap an its associated image, install a git package, currently it is installed to /app  

<br>

## Servers

servers are

<br>

## Clients

clinets are

<br>

## Services

Services are

<br>

## Warnings
Dont use the command   

    docker compose up  

without specifying which clients, servers or services you would like
<br>  
<br>  

# Environment Variables  


### <u>Docker Images & Digests</u>    
    ALPINE_IMAGE="alpine"  
    ALPINE_DIGEST=''  

    WINDOWS_IMAGE="mcr.microsoft.com/windows"  
    WINDOWS_DIGEST=''  

    ANDROID_DIGEST=''  
    OSX_DIGEST=''  
    IOS_DIGEST=''  

    UBUNTU_IMAGE="fredblgr/ubuntu-novnc"  
    UBUNTU_DIGEST=''    
<br>

### <u>Execution Mode</u>

    CLIENT_MODE=''  
    SERVER_MODE=''   
<br>

### <u>GitHub</u>

    GITHUB_TOKEN="asd_K...WE69"  
    GITHUB_USERNAME="Your_User"  
    CLIENT_REPO="github.com/Your_User/Your_Git.git"  
    SERVER_REPO='github.com/Your_User/Your_Git.git'    
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
    twingate        # Essentially a VPN into the network
    vpn             # Traditional VPN
    dns-sinkhole    # DNS filtering  - ad-blocking
    packet-capture  # Packet traffic log collection
    log-collector   # Operating system log collection


Each of these images will be set up to download and test the repositories prescribed in the environment variables.   

</br>  
</br>  
  
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

