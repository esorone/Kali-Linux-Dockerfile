FROM kalilinux/kali-rolling:latest

LABEL website="https://github.com/esorone"
LABEL description="Kali Linux with XFCE Desktop via VNC and noVNC in browser."


# Install Kali Full
RUN rm -fR /var/lib/apt/ && \
    apt-get clean && \
    apt-get update -y && \
    apt-get install -y software-properties-common kali-linux-headless --fix-missing && \
    echo 'VERSION_CODENAME=kali-rolling' >> /etc/os-release

ARG KALI_METAPACKAGE=core
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get clean

# Some system tools
RUN apt-get install -y git colordiff colortail unzip tmux xterm zsh curl telnet strace ltrace tmate less build-essential wget python3-setuptools python3-pip zstd net-tools bash-completion iputils-tracepath  

# Oh-my-git!
RUN git clone https://github.com/arialdomartini/oh-my-git.git ~/.oh-my-git && \ 
  echo source ~/.oh-my-git/prompt.sh >> /etc/profile

# secLists!
RUN git clone https://github.com/danielmiessler/SecLists /usr/share/seclists

# Install kali desktop

ARG KALI_DESKTOP=xfce
RUN apt-get -y install kali-desktop-${KALI_DESKTOP}
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
# TODO: You can add your own packages here
RUN mkdir -p /var/run/sshd /var/log/supervisor
RUN apt-get install openssh-server sudo -y
RUN apt-get install supervisor -y
RUN apt-get -y install nano

# Update DB and clean'up!
RUN updatedb && \
    apt-get autoremove -y && \
    apt-get clean 

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
#CMD ["/usr/bin/supervisord"]
