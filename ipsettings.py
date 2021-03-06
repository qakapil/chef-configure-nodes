import yaml
from launch import launch
import logging
import time
import socket
import sys

sys.stdout.flush()
log = logging.getLogger(__name__)

grp1 = ['teuthida-1','teuthida-2','teuthida-3','teuthida-4','teuthida-5','teuthida-6','teuthida-7']
grp2 = ['teuthida-8','teuthida-9','teuthida-10']
document = open('nodes.yaml').read()
ctx = yaml.load(document)
fr = open("template", "r")
ifcfg_template = fr.read()
fr.close()

for node in ctx['config_nodes']:
    orig_ip = socket.gethostbyname(node)
    ip = socket.gethostbyname(node)+'/16'
    ifcfg_p1 = ifcfg_template % ('dhcp', ip)
    private_ip = '10.0.0.'+orig_ip.split(".")[3]+'/8'
    ifcfg_p2 = ifcfg_template % ('static', private_ip)
    if node in grp1:
       nic_prefix = "p2"
    else:
       nic_prefix = "p1"
    filename1 = 'ifcfg-'+nic_prefix+'p1'
    filename2 = 'ifcfg-'+nic_prefix+'p2'
    fw = open(filename1, "w")
    fw.write(ifcfg_p1)
    fw.close()
    fw = open(filename2, "w")
    fw.write(ifcfg_p2)
    fw.close()

    cmd = "scp %s %s root@%s:/etc/sysconfig/network/" % (filename1, filename2, node)
    print("executing the command - "+cmd)
    rc,stdout,stderr = launch(cmd=cmd)
    if rc != 0:
        raise Exception, "Error while executing the command '%s'. \
                          Error message: '%s'" % (cmd, stderr)

    interface1 = nic_prefix+'p1'
    interface2 = nic_prefix+'p2'
    
    cmd = "ssh root@%s 'ifdown em1 && sleep 5 && ifup %s && sleep 10 && route add default gw 10.160.255.254 %s'"\
          % (node, interface1, interface1)
    print("executing the command - "+cmd)
    rc,stdout,stderr = launch(cmd=cmd)
    if rc != 0:
        raise Exception, "Error while executing the command '%s'. \
                          Error message: '%s'" % (cmd, stderr)


    cmd = "ssh root@%s 'ifdown %s && sleep 5 && ifup %s'"\
          % (node, interface2, interface2)
    print("executing the command - "+cmd)
    rc,stdout,stderr = launch(cmd=cmd)
    if rc != 0:
        raise Exception, "Error while executing the command '%s'. \
                          Error message: '%s'" % (cmd, stderr)
