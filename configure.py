import yaml
from launch import launch
import logging
import time
import socket

log = logging.getLogger(__name__)


document = open('nodes.yaml').read()
ctx = yaml.load(document)
ctx['fqdn_nodes'] = []
ctx['ip_nodes'] = []

for node in ctx['config_nodes']:
    fqdn = socket.getfqdn(node)
    ip = socket.gethostbyname(node)
    ctx['fqdn_nodes'].append(fqdn)
    ctx['ip_nodes'].append(ip)

print str(ctx['config_nodes'])

tr1 = "default['nodes']['fqdn'] = " + str(ctx['fqdn_nodes'])
tr2 = "default['nodes']['sname'] = " + str(ctx['config_nodes'])
tr3 = "default['nodes']['master'] = " + str(ctx['master_nodes'])
tr4 = "default['nodes']['ip'] = " + str(ctx['ip_nodes'])

f = open("chef_repo/cookbooks/nodes_init/attributes/default.rb", "w")
f.write(tr1+"\n")
f.write(tr2+"\n")
f.write(tr3+"\n")
f.write(tr4+"\n")
f.close()

cmd = "chef-solo -j chef_repo/nodes/nodes_init.json -c chef_repo/solo-init.rb"
rc,stdout,stderr = launch(cmd=cmd)
if rc != 0:
    raise Exception, "Error while executing the command '%s'\
                      Error message: '%s'" % (cmd, stderr)
