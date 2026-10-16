FROM nginx:1.27-alpine

COPY index.html /usr/share/nginx/html/
COPY app.js /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/

COPY default.conf.template /etc/nginx/templates/default.conf.template

EXPOSE 80