#cookbook Name:: nodes_init
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

for $p in node['nodes']['ip']
execute "remove ip from knownhost" do
          user 'jenkins'
          command "ssh-keygen -R #$p"
end
end


for $p in node['nodes']['fqdn']
execute "remove fqdn from knownhost" do
          user 'jenkins'
          command "ssh-keygen -R #$p"
end
execute "add fqdn to knownhost" do
          user 'jenkins'
          command "ssh-keyscan -H #$p >> ~/.ssh/known_hosts"
end
end




for $p in node['nodes']['sname']


execute "remove sname from knownhost" do
          user 'jenkins'
          command "ssh-keygen -R #$p"
end

execute "add sname to knownhost" do
          user 'jenkins'
          command "ssh-keyscan -H #$p >> ~/.ssh/known_hosts"
end


bash "ssh-copy-id" do
    user "jenkins"
    code <<-EOF
    /usr/bin/expect -c 'spawn ssh-copy-id root@#$p
    expect "Password: "
    send "calvin\r"
    expect eof'
    EOF
end


execute "remove old chef repo" do
          command "ssh root@#$p zypper rr chef"
end

execute "remove old ibs sle12 repo" do
          command "ssh root@#$p zypper rr ibs-sle12"
end

execute "refresh repos" do
          command "ssh root@#$p zypper --gpg-auto-import-keys --non-interactive refresh"
end

execute "add chef repo" do
          command "ssh root@#$p zypper ar http://download.suse.de/ibs/Devel:/Cloud:/Shared:/12/standard chef"
end

execute "add ibs sle12 repo" do
          command "ssh root@#$p zypper ar http://dist.suse.de/ibs/SUSE:/SLE-12:/GA/standard/ ibs-sle12"
end



execute "add benchmark repo" do
          command "ssh root@#$p zypper ar http://download.opensuse.org/repositories/benchmark/SLE_12/ benchmark"
end



execute "refresh repos" do
          command "ssh root@#$p zypper --gpg-auto-import-keys --non-interactive refresh"
end


execute "install ruby-gem" do
          command "ssh root@#$p zypper --non-interactive --no-gpg-checks --quiet install rubygem-chef"
end



execute "remove old dir" do
          command "ssh root@#$p rm -rf workspace"
end

execute "create dir" do
          command "ssh root@#$p mkdir workspace"
end

execute "copy chef_repo" do
          command "scp -r ~/workspace/storage-bootstrap_nodes/chef_repo/ root@#$p:~/workspace"
end

execute "run chef solo" do
          command "ssh root@#$p chef-solo -j /root/workspace/chef_repo/nodes/nodes_setup.json -c /root/workspace/chef_repo/solo-root.rb"
end


bash "ssh-copy-id" do
    user "jenkins"
    code <<-EOF
    /usr/bin/expect -c 'spawn ssh-copy-id jenkins@#$p
    expect "Password: "
    send "calvin\r"
    expect eof'
    EOF
end


end




for $p in node['nodes']['master']

execute "remove old dir" do
          command "ssh root@#$p rm -rf workspace"
end

execute "create dir" do
          command "ssh root@#$p mkdir workspace"
end

execute "copy chef_repo" do
          command "scp -r ~/workspace/storage-bootstrap_nodes/chef_repo/ root@#$p:~/workspace"
end

execute "run chef solo" do
          command "ssh root@#$p chef-solo -j /root/workspace/chef_repo/nodes/nodes_master_root.json -c /root/workspace/chef_repo/solo-master-root.rb"
end

end






for $p in node['nodes']['master']

execute "remove old dir" do
          command "ssh jenkins@#$p rm -rf workspace"
end

execute "create dir" do
          command "ssh jenkins@#$p mkdir workspace"
end

execute "copy chef_repo" do
          command "scp -r ~/workspace/storage-bootstrap_nodes/chef_repo/ jenkins@#$p:/home/jenkins/workspace"
end

execute "run chef solo" do
          command "ssh jenkins@#$p chef-solo -j /home/jenkins/workspace/chef_repo/nodes/nodes_master.json -c /home/jenkins/workspace/chef_repo/solo-master.rb"
end


end
