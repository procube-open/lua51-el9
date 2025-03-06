FROM almalinux/9-base
MAINTAINER "Shigeki Kitamura" <kitamura@procube.jp>
RUN groupadd -g 111 builder
RUN useradd -g builder -u 111 builder
ENV HOME /home/builder
WORKDIR ${HOME}
ENV LUA_VERSION "5.1.4-15.el7"
ENV LUAROCKS_VERSION "2.3.0-1.el7"
RUN dnf -y update \
    && dnf -y install unzip wget sudo tar tcpdump vim initscripts gcc make rpm-build \
        ncurses-devel readline-devel autoconf automake
#RUN dnf -y install epel-release
#RUN dnf -y luarocks
RUN mkdir -p /tmp/buffer
COPY build.sh /tmp/buffer/
COPY builder.sudoers /etc/sudoers.d/builder
USER builder
RUN mkdir -p ${HOME}/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
RUN echo "%_topdir %(echo ${HOME})/rpmbuild" > ${HOME}/.rpmmacros
RUN cp /tmp/buffer/* ${HOME}/rpmbuild/SOURCES/
RUN mkdir ${HOME}/srpms \
    && wget -O ${HOME}/srpms/lua.src.rpm --no-verbose http://vault.centos.org/7.9.2009/os/Source/SPackages/lua-${LUA_VERSION}.src.rpm
RUN wget -O ${HOME}/srpms/luarocks.src.rpm --no-verbose https://archives.fedoraproject.org/pub/archive/epel/7.9/SRPMS/Packages/l/luarocks-${LUAROCKS_VERSION}.src.rpm
CMD ["/usr/bin/bash","rpmbuild/SOURCES/build.sh"]
