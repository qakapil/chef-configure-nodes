#
# Cookbook Name:: nodes_init
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute 'generate ssh key for root' do
  user 'root'
  creates '/root/.ssh/id_rsa'
  command 'if [ ! -f /root/.ssh/id_rsa.pub ] ; then
        ssh-keygen -t rsa -q -f /root/.ssh/id_rsa -P "" ; fi'
end


for $p in node['nodes']['fqdn']
execute "remove fqdn from knownhost" do
          user 'root'
          command "ssh-keygen -R #$p || true"
end
execute "add fqdn to knownhost" do
          user 'root'
          command "ssh-keyscan -H #$p >> ~/.ssh/known_hosts"
end
end



for $p in node['nodes']['sname']
execute "remove sname from knownhost" do
          user 'root'
          command "ssh-keygen -R #$p || true"
end

execute "add sname to knownhost" do
          user 'root'
          command "ssh-keyscan -H #$p >> ~/.ssh/known_hosts"
end

bash "ssh-copy-id" do
    user "root"
    code <<-EOF
    /usr/bin/expect -c 'spawn ssh-copy-id jenkins@#$p
    expect "Password: "
    send "calvin\r"
    expect eof'
    EOF
end

end
