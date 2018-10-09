FROM nginx:1.14.0

ENV APP_ROOT /var/www/app
WORKDIR ${APP_ROOT}

# Copy Nginx config
RUN rm -f /etc/nginx/conf.d/*
COPY docker/nginx/my_app.conf /tmp/app.conf
RUN envsubst '${APP_ROOT}' < /tmp/app.conf > /etc/nginx/conf.d/app.conf

EXPOSE 80

CMD nginx -g 'daemon off;' -c /etc/nginx/nginx.conf