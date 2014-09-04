FROM centos

MAINTAINER yajo@openaliasbox.org

# Add EPEL
RUN yum --assumeyes install \
    http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-1.noarch.rpm

# Install Odoo
RUN yum --assumeyes install \
    http://nightly.openerp.com/8.0/nightly/rpm/odoo_8.0rc1-latest.noarch.rpm

# Dependencies available from CentOS 7 + EPEL 7
RUN yum --assumeyes install python-gevent wkhtmltopdf

# Dependencies available from Fedora 20
RUN yum --assumeyes install \
    http://dl.fedoraproject.org/pub/fedora/linux/releases/20/Everything/x86_64/os/Packages/p/pychart-1.39-16.fc20.noarch.rpm \
    http://dl.fedoraproject.org/pub/fedora/linux/releases/20/Everything/x86_64/os/Packages/p/pyPdf-1.13-6.fc20.noarch.rpm

# Dependencies available from pip
RUN yum --assumeyes install python-pip
RUN pip install psycogreen

# PYTHONPATH needs to be patched
ENV PYTHONPATH PYTHONPATH=$(python -c "import sys; print ':'.join(x for x in sys.path if x)"):/usr/local/lib/python2.7/dist-packages/

# Create path for extra addons
RUN mkdir --parents /opt/odoo/extra-addons

# Used volumes
VOLUME ["/etc/openerp/", "/var/log/openerp", "/opt/odoo/extra-addons"]

# Odoo ports for web and chat
EXPOSE 8069 8072

# Configure launcher
RUN touch /firstrun
ENV ADMIN_PASSWD admin
ADD launcher.sh /opt/odoo/

# Launcher will patch configuration on first run and launch Odoo
CMD /opt/odoo/launcher.sh
