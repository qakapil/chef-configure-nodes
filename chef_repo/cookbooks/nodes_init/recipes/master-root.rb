#
# Cookbook Name:: nodes_init
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "lighttpd"

service 'lighttpd' do
  action [:start, :enable]
end


directory "/suse" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory "/mounts" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory "/mounts/dist" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


mount "/suse" do
  device "loki:/real-home/"
  fstype "nfs"
  options "rw"
  action [:mount, :enable]
end

mount "/mounts/dist" do
  device "dist.suse.de:/dist"
  fstype "nfs"
  options "rw"
  action [:mount, :enable]
end

