# Use the official Nginx image as base
FROM nginx:latest

# Copy your custom nginx.conf into the container
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]


#acrnginx