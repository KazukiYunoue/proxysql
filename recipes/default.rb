#
# Cookbook:: proxysql
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

remote_file "/tmp/percona-release-latest.noarch.rpm" do
  source "https://repo.percona.com/yum/percona-release-latest.noarch.rpm"
  not_if "rpm -qa | grep -1 '^percona-release-latest'"
  action :create
end

yum_package "percona-release-latest" do
  source "/tmp/percona-release-latest.noarch.rpm"
  action :install
end

package "proxysql" do
  action :install
end

service "proxysql" do
  action [:enable, :start]
  supports :status => true, :reload => true, :restart => true
end

template "/etc/proxysql-admin.cnf" do
  source "proxysql-admin.cnf.erb"
  user "root"
  group "proxysql"
  mode 0640
end

execute "proxysql-admin" do
  command "proxysql-admin --config-file=/etc/proxysql-admin.cnf --enable"
end
