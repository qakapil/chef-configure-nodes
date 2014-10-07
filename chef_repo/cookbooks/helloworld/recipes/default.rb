#
# Cookbook Name:: helloworld
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
for $p in node['h']['c']
bash "ssh-copy-id" do
    user "kapil"
    code <<-EOF
    /usr/bin/expect -c 'spawn ssh-copy-id jenkins@#$p
    expect "Password: "
    send "calvin\r"
    expect eof'
    EOF
end
end
