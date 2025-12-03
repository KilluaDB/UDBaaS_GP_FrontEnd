# Use official Nginx image to serve Flutter web build
FROM nginx:latest

# Copy Flutter web build files to Nginx html folder
COPY build/web /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
