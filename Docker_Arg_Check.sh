#!/bin/bash

# Set the path to the directory containing the Dockerfiles and docker-compose.yml file
DOCKER_DIR="path/to/docker/files"

# Get a list of Dockerfiles in the directory
DOCKERFILES=$(ls ${DOCKER_DIR}/*.dockerfile)

# Read the environment variables and arguments defined in docker-compose.yml
COMPOSE_VARS=$(docker-compose -f ${DOCKER_DIR}/docker-compose.yml config | grep -E '(environment:|args:)')

# Loop through each Dockerfile and compare its environment variables and arguments with those in docker-compose.yml
for DOCKERFILE in ${DOCKERFILES}; do
    # Read the environment variables and arguments defined in the Dockerfile
    FILE_VARS=$(cat ${DOCKERFILE} | grep -E '(ENV|ARG)')

    # Compare the environment variables and arguments defined in the Dockerfile with those in docker-compose.yml
    DIFF=$(diff <(echo "${COMPOSE_VARS}") <(echo "${FILE_VARS}"))

    # Print the name of the Dockerfile and any differences found
    if [[ ${DIFF} != "" ]]; then
        echo "Differences found in ${DOCKERFILE}:"
        echo "${DIFF}"
    fi
done
