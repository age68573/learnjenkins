FROM nginx:latest
LABEL Author xpy
COPY dist /usr/share/nginx/html
