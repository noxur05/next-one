# Use a Node.js base image
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the rest of the application code
COPY . .

# Build the Next.js app
RUN yarn build

# --- Nginx Stage ---
FROM nginx:alpine

# Copy the built Next.js app to Nginx's HTML directory
COPY --from=builder /app/.next/standalone /app

# Copy the Nginx configuration (see below)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 (standard HTTP port)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]