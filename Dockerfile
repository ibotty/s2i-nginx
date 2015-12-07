FROM openshift/base-centos7

MAINTAINER Tobias Florek <tob@butter.sh>

ENV NGINX_VERSION 1.8

LABEL io.k8s.description="Platform for serving nginx-based applications (static files)" \
      io.k8s.display-name="nginx builder ${NGINX_VERSION}" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nginx,webserver"


RUN yum install --setopt=tsflags=nodocs -y centos-release-scl-rh \
 && yum install --setopt=tsflags=nodocs -y rh-nginx${NGINX_VERSION/\./} \
 && yum clean all -y \
 && chmod a+rx /var/opt/rh/rh-nginx18/lib/nginx \
 && chown -R default /var/opt/rh/rh-nginx18/lib/nginx/tmp \
                     /var/opt/rh/rh-nginx18/run \
 && mkdir -p /opt/app-root/etc/nginx.conf.d

ADD nginx.conf nginx.server.sample.conf /opt/app-root/etc/

COPY ./.s2i/bin/ ${STI_SCRIPTS_PATH}

#RUN chown -R 1001:1001 /opt/app-root
RUN chmod a+rwX /opt/app-root

USER 1001

EXPOSE 8080

CMD ["usage"]
