#!/bin/bash

APP_DIR=/home/ubuntu/Grile-PCLP

cd $APP_DIR

# Check for new Git commits
if git rev-parse HEAD &> /dev/null; then
    git fetch origin
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse origin/main)

    if [ $LOCAL != $REMOTE ]; then
	# Pull the new commit
        echo "New Git commit found. Updating..."
	git pull        
        
	# Check if Docker container exists
        if docker ps -a --format '{{.Names}}' | grep -q grile-pclp; then
            echo "Stopping and removing existing Docker container..."
            docker stop grile-pclp
            docker rm grile-pclp
        else
            echo "No existing Docker container found."
        fi

        # Prune unused Docker images
        echo "Pruning Docker images..."
        docker image prune -f

        # Build and run the Docker container
        echo "Building and running Docker container..."
        docker build -t grile-pclp .
        docker run --detach --name grile-pclp -p 10443:4173 grile-pclp

        echo "Update complete."
    else
        echo "No new Git commit. Nothing to update."
    fi
else
    echo "Unable to determine Git status. Please make sure you are in a Git repository."
fi
