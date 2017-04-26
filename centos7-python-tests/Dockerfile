FROM centos:7.2.1511
RUN yum install python-setuptools pygobject2-devel -y && \
    easy_install pip && \
    pip install mock && \
    pip install pep8 && \
    pip install pyOpenSSL && \
    pip install simplejson && \
    pip install suds && \
    pip install requests && \
    yum clean all

