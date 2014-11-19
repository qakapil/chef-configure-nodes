#
# Cookbook Name:: nodes_setup
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
for p in [ "ruby2.1-rubygem-ruby-shadow", "gcc", "git", "python-pip", "libevent-devel", "python-devel"] do
  package p do
    action [:install]
  end
end

execute "install nosetest" do
          command "pip install nose"
end

user "jenkins" do
  supports :manage_home => true
  comment "jenkins user"
  uid 1234
  gid "users"
  home "/home/jenkins"
  shell "/bin/bash"
  password "$1$GL3c3aa.$mKDp/VvtV8/vQ8R.Pr7Y8."
end

execute "passwordless sudo " do
          command "echo 'jenkins ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers"
end

