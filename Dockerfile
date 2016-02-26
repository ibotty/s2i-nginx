FROM openshift/base-centos7

MAINTAINER Tobias Florek <tob@butter.sh>

ENV NGINX_VERSION 1.8
ENV NGINX_BASE_DIR /opt/rh/rh-nginx18/root
ENV NGINX_VAR_DIR /var/opt/rh/rh-nginx18

LABEL io.k8s.description="Platform for serving nginx-based applications (static files)" \
      io.k8s.display-name="nginx builder ${NGINX_VERSION}" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nginx,webserver"


RUN yum install --setopt=tsflags=nodocs -y centos-release-scl-rh \
 && yum install --setopt=tsflags=nodocs -y bcrypt rh-nginx${NGINX_VERSION/\./} \
 && yum clean all -y \
 && mkdir -p /opt/app-root/etc/nginx.conf.d /opt/app-root/run \
 && chmod -R a+rx  $NGINX_VAR_DIR/lib/nginx \
 && chmod -R a+rwX $NGINX_VAR_DIR/lib/nginx/tmp \
                   $NGINX_VAR_DIR/log \
                   $NGINX_VAR_DIR/run \
                   /opt/app-root/run

COPY ./etc/ /opt/app-root/etc
COPY ./.s2i/bin/ ${STI_SCRIPTS_PATH}

RUN cp /opt/app-root/etc/nginx.server.sample.conf /opt/app-root/etc/nginx.conf.d/default.conf \
 && chown -R 1001:1001 /opt/app-root

USER 1001

EXPOSE 8080

CMD ["usage"]
