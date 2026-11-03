FROM nginx:alpine

LABEL org.opencontainers.image.title="GN-Codyssey-Web"

COPY app/ /usr/share/nginx/html/

EXPOSE 80