FROM centos:7.2.1511
RUN yum install python-setuptools pygobject2-devel -y && \
    easy_install pip && \
    pip install mock && \
    pip install pep8 && \
    yum clean all
