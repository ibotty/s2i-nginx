FROM centos/s2i-base-centos7

MAINTAINER Tobias Florek <tob@butter.sh>

ENV NGINX_VAR_DIR /usr/local/openresty

LABEL io.k8s.description="Platform for serving nginx-based applications (static files)" \
      io.k8s.display-name="nginx openresty builder" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nginx,webserver"


RUN yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo \
 && yum install -y --setopt=tsflags=nodocs openresty openresty-opm openresty-resty openresty-pcre bcrypt \
 && yum clean all -y \
 && mkdir -p /opt/app-root/etc/nginx.conf.d /opt/app-root/run/logs \
 && chmod -R a+rwX $NGINX_VAR_DIR/nginx \
                   $NGINX_VAR_DIR/site \
                   /opt/app-root/run

COPY ./etc/ /opt/app-root/etc
COPY ./.s2i/bin/ ${STI_SCRIPTS_PATH}

RUN cp /opt/app-root/etc/nginx.server.sample.conf /opt/app-root/etc/nginx.conf.d/default.conf \
 && chown -R 1001:1001 /opt/app-root

USER 1001

EXPOSE 8080

CMD ["usage"]
