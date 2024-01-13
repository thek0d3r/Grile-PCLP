# Use a Debian image as the base
FROM debian:stable-slim

# Set the working directory in the container
WORKDIR /app

# Install required dependencies
RUN apt-get update && apt-get install -y \
    nodejs \
    npm

# Copy package.json and package-lock.json (if applicable)
COPY package*.json ./

# Install dependencies
RUN npm install --force

# Copy the rest of the application code
COPY . .

RUN npm run build

# Build the Svelte app and run npm run preview
CMD ["npx", "vite", "preview", "--host"]

# Expose port 4173
EXPOSE 4173