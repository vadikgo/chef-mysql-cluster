cookbook_file "/tmp/mysql_pubkey.asc" do
  source "mysql_pubkey.asc"
end
execute 'install_mysql_key' do
    command "apt-key add /tmp/mysql_pubkey.asc"
end
cookbook_file "/tmp/mysql_pubkey.asc" do
  action :delete
end
apt_repository 'mysql' do
  uri        'http://repo.mysql.com/apt/debian'
  components ['wheezy', 'mysql-5.6', 'mysql-apt-config']
end
