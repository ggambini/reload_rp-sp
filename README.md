# Reload_rp-sp

A minimalist tool to reload an Apache reverse proxy and a Shibboleth service provider in HA environement.
Design for RHEL6, doesn't not work on RHEL7 cause of systemd.

### Mechanism

This script test the config on local httpd with configtest command. If its ok, he reload local and rsync the config on remote node and reload . Same method with shibd, test on local node, reload and sync/reload remonte node.

### Usage

Call script without parameters. The remote node and conf_path are specified at the top of script.
