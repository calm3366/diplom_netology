FROM nginx:latest
ADD /html /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]