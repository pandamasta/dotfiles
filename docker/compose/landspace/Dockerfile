FROM nginx:alpine

RUN mkdir -p /var/www/app

COPY index.html /var/www/app/index.html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
