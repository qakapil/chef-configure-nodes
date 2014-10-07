#
# Cookbook Name:: helloworld
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
for $p in node['h']['c']
execute "remove from knownhost" do
	  user 'kapil'
          command "ssh-keygen -R #$p"
end
execute "add to knownhost" do
	  user 'kapil'
          command "ssh-keyscan -H #$p >> ~/.ssh/known_hosts"
end
end
