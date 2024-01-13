# Use a Node.js image for building and serving the Svelte app
FROM node:14 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json (if applicable)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Svelte app
RUN npm run build

# Use a lightweight Nginx image to serve the app
FROM nginx:alpine

# Set the working directory to the Nginx web server directory
WORKDIR /usr/share/nginx/html

# Copy the compiled static files from the builder stage
COPY --from=builder /app/public .

# Expose port 80 for HTTP
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
