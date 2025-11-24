FROM nginx:alpine

# Copy the HTML, CSS and photo files to the Nginx default directory
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY photo.png /usr/share/nginx/html/

# Expose port 80 to allow external access
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]