# s2i-nginx
FROM openshift/base-centos7

MAINTAINER Tobias Florek <tob@butter.sh>

ENV NGINX_VERSION 1.8

LABEL io.k8s.description="Platform for building and serving nginx-based applications (static files)" \
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

# TODO: Copy the S2I scripts to /usr/local/s2i, since openshift/base-centos7 image sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./.s2i/bin/ /usr/local/s2i

#RUN chown -R 1001:1001 /opt/app-root
RUN chmod a+rwX /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

EXPOSE 8080

CMD ["usage"]
