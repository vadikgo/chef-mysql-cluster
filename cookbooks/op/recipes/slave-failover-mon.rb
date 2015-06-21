cookbook_file "/usr/local/sbin/takeover-mysql.sh" do
    source "takeover-mysql.sh"
    mode 0755
end
package 'telnet' do
    action :install
end
execute 'start-takeover-mon' do
    command "/usr/local/sbin/takeover-mysql.sh #{node['op']['mysql_cl_ip']} #{node['op']['mysql_master_ip']} #{node['op']['mysql_slave_ip']} &"
end
