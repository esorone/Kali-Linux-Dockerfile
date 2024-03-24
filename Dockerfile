FROM kalilinux/kali-rolling:latest
#FROM kalilinux/kali-linux-large

LABEL website="https://github.com/esorone"
LABEL description="Kali Linux with XFCE Desktop via VNC and noVNC in browser."

# Install kali packages

ARG KALI_METAPACKAGE=core
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color
RUN apt-get update -y && apt-get clean all
RUN apt-get install -y software-properties-common && apt-get update -y && apt-get clean all
RUN apt-get install -y git colordiff colortail unzip nano tmux xterm zsh curl && apt-get clean all
RUN apt-get install -y kali-linux-everything && apt-get clean all

# Install kali desktop

#ARG KALI_DESKTOP=xfce
#RUN apt-get -y install kali-desktop-${KALI_DESKTOP}
RUN apt-get install -y kali-linux-all && apt-get clean all
RUN apt-get -y install tightvncserver dbus dbus-x11 novnc net-tools

ENV USER root

ENV VNCEXPOSE 0
ENV VNCPORT 5900
ENV VNCPWD root
ENV VNCDISPLAY 1920x1080
ENV VNCDEPTH 16

ENV NOVNCPORT 8080

# Configure SSH for password login
RUN mkdir -p /var/run/sshd
RUN sed -i '/PasswordAuthentication no/c\PasswordAuthentication yes' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22

# Setup default user
RUN useradd --create-home -s /bin/bash -m esorone && echo "esorone:esorone" | chpasswd && adduser esorone sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install custom packages
RUN apt-get install autocutsel -y

# TODO: You can add your own packages here
RUN mkdir -p /var/run/sshd /var/log/supervisor
RUN apt-get install openssh-server sudo -y
RUN apt-get install supervisor -y
RUN apt-get install nano -y

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Additional updates
COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY install.sh /install.sh
#RUN chmod +x /install.sh
RUN chsh -s $(which zsh)
RUN rm -f ${HOME}/.profile
RUN su -s /bin/zsh -c '. ~/.zshrc' root

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
#CMD ["/usr/bin/supervisord"]
