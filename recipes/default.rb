#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'java-1.8.0-openjdk-devel'

group 'tomcat'

user 'tomcat' do
	manage_home false
	shell '/bin/nologin'
	group 'tomcat'
	home '/opt/tomcat'
end

remote_file '/opt/apache-tomcat-8.5.9.tar.gz' do
	source 'http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz'
end

execute 'extract_tar' do
  command 'tar xvf apache-tomcat-8.5.9.tar.gz && mv apache-tomcat-8.5.32 tomcat'
  cwd '/opt'
  not_if { File.exists?("/opt/tomcat") }
end

execute 'chgrp -R tomcat /opt/tomcat'

execute 'chmod -R g+r /opt/tomcat/conf'

execute 'chmod g+x /opt/tomcat/conf'

execute 'chown -R tomcat webapps/ work/ temp/ logs/' do
  cwd '/opt/tomcat/'
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

execute 'systemctl daemon-reload'

service 'tomcat' do
  action [:start, :enable]
end
