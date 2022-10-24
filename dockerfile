FROM nginx:latest
LABEL Author jeremy
COPY dist /usr/share/nginx/html
