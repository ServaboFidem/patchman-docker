FROM ubuntu:lunar
LABEL maintainer="Gordon Mott <gordon.mott@gmail.com>"
RUN apt update -y
RUN apt upgrade -y
RUN apt install -y software-properties-common
#RUN add-apt-repository ppa:cheongkt/libxml2
RUN apt update -y
RUN apt install -y python3 python3-pip
RUN apt install -y git
RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections
RUN echo 'tzdata tzdata/Zones/America select New_York' | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata

# add server-side dependencies
RUN apt install -y python3-django
RUN apt install -y python3-django-tagging
RUN apt install -y python3-django-extensions
RUN apt install -y python3-djangorestframework
RUN apt install -y python3-defusedxml python3-lxml python3-requests
RUN apt install -y python3-debian
RUN apt install -y python3-rpm
RUN apt install -y python3-progressbar
RUN apt install -y python3-lxml
RUN apt install -y python3-defusedxml
RUN apt install -y python3-requests
RUN apt install -y python3-colorama
RUN apt install -y python3-magic
RUN apt install -y python3-humanize

# update pip
RUN pip install --upgrade pip --break-system-packages

# install python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt --break-system-packages

# clone patchman repo
RUN git clone https://github.com/furlongm/patchman.git /patchman

# do God's work...
ADD etc/patchman/local_settings.py /etc/patchman/local_settings.py
COPY ./gunicorn_conf.py /gunicorn_conf.py


#FROM uqlibrary/alpine as builder
#RUN apk --no-cache add git gcc python2-dev libxslt-dev libxml2-dev libc-dev libffi-dev libressl-dev mariadb-connector-c-dev py-mysqldb py-setuptools py2-urllib3 py2-gunicorn libffi py2-pip &&\
#mkdir /patchman &&\
#pip install whitenoise==3.3.1 &&\
#git clone https://github.com/furlongm/patchman.git /patchman
#ADD ./patchman_override/host_detail.html /patchman/patchman/hosts/templates/hosts/host_detail.html
#RUN cd /patchman && ./setup.py install
#ADD etc/patchman/local_settings.py /etc/patchman/local_settings.py
#ADD entry.sh /entry.sh
#RUN chmod 755 /entry.sh
#ENTRYPOINT ["/entry.sh"]