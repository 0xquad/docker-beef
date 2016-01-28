FROM ubuntu
MAINTAINER Alexandre Hamelin <alexandre.hamelin gmail.com>
LABEL copyright="Copyright (c) 2016, Alexandre Hamelin <alexandre.hamelin gmail.com>"

RUN locale-gen en_US.UTF_8
ENV LANG en_US.UTF_8
ENV LANGUAGE en_US.UTF_8
ENV LC_ALL en_US.UTF_8
RUN apt-get update && apt-get install -y git curl libgmp-dev && \
    curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -k -sSL https://raw.githubusercontent.com/wayneeseguin/rvm/master/binscripts/rvm-installer | bash -s stable && \
    /usr/local/rvm/bin/rvm install 2.2.4 && \
    rm -fr /var/lib/apt /var/cache/apt
RUN sed -i -e '1i export PS1=not-empty' /root/.bashrc
RUN echo "set +o posix" >> /root/.bashrc
RUN echo ". /etc/profile.d/rvm.sh" >> /root/.bashrc
RUN ln -sf /bin/bash /bin/sh
RUN sed -i -e 's/test.*sh$/true/' /etc/profile.d/rvm.sh && \
    sed -i -e '/silently stop/d' /usr/local/rvm/scripts/rvm
# not needed?
RUN . ~/.bashrc && rvm use 2.2.4 --default
RUN . ~/.bashrc && gem install bundler
RUN git clone https://github.com/beefproject/beef.git
RUN rm beef/.ruby-{gemset,version}
RUN . ~/.bashrc && cd beef && bundle install

EXPOSE 3000
CMD . ~/.bashrc && cd beef && exec ruby beef
