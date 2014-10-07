import yaml
from launch import launch
import logging
import time

log = logging.getLogger(__name__)


document = open('nodes.yaml').read()
ctx = yaml.load(document)

nodes_pxe = {'teuthida-1':['01-c4-54-44-76-17-15','teuthida/pxe-ssd'],\
             'teuthida-2':['01-c4-54-44-76-17-66','teuthida/pxe-ssd'],\
             'teuthida-3':['01-c4-54-44-76-15-26','teuthida/pxe-ssd'],\
             'teuthida-4':['01-c4-54-44-76-16-be','teuthida/pxe-ssd'],\
             'teuthida-5':['01-c4-54-44-76-16-c1','teuthida/pxe-ssd'],\
             'teuthida-6':['01-c4-54-44-76-13-a9','teuthida/pxe-ssd'],\
             'teuthida-7':['01-c4-54-44-76-12-05','teuthida/pxe-ssd'],\
             'teuthida-8':['01-c4-54-44-63-d5-a2','teuthida/pxe-hdd'],\
             'teuthida-9':['01-c4-54-44-63-d6-44','teuthida/pxe-hdd'],\
             'teuthida-10':['01-c4-54-44-63-cf-87','teuthida/pxe-hdd'],\
             }

for node in ctx['reboot_nodes']:
    pxe_file = '/srv/tftpboot/pxelinux.cfg/'+nodes_pxe[node][0]
    boot_file = '/srv/tftpboot/pxelinux.cfg/'+node
    
    cmd = "ssh root@autoinst-devel rm %s || true" % (pxe_file)
    rc,stdout,stderr = launch(cmd=cmd)
    if rc != 0:
        raise Exception, "Error while executing the command '%s'. \
                          Error message: '%s'" % (cmd, stderr)
    
    cmd = "ssh root@autoinst-devel ln -s %s %s" % (boot_file, pxe_file)
    rc,stdout,stderr = launch(cmd=cmd)
    if rc != 0:
        raise Exception, "Error while executing the command '%s'. \
                          Error message: '%s'" % (cmd, stderr)
    
    cmd = "ssh root@%s sudo reboot" % (node)
    rc,stdout,stderr = launch(cmd=cmd)
    if rc != 255:
        raise Exception, "Error while executing the command '%s'. \
                          Error message: '%s'" % (cmd, stderr)
                          
                          
time.sleep(300)


for node in ctx['reboot_nodes']:
    pxe_file = '/srv/tftpboot/pxelinux.cfg/'+nodes_pxe[node][0]
    boot_file = '/srv/tftpboot/pxelinux.cfg/default'
    
    cmd = "ssh root@autoinst-devel rm %s || true" % (pxe_file)
    rc,stdout,stderr = launch(cmd=cmd)
    if rc != 0:
        raise Exception, "Error while executing the command '%s'. \
                          Error message: '%s'" % (cmd, stderr)
    
    cmd = "ssh root@autoinst-devel ln -s %s %s" % (boot_file, pxe_file)
    rc,stdout,stderr = launch(cmd=cmd)
    if rc != 0:
        raise Exception, "Error while executing the command '%s'. \
                          Error message: '%s'" % (cmd, stderr)                    



