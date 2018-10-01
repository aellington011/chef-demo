# See http://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
ssl_verify_mode          :verify_none
node_name                "admin"
client_key               "#{current_dir}/admin.pem"
chef_server_url          "https://52.40.115.57:4443/organizations/fuji"
cookbook_path            ["#{current_dir}/../cookbooks"]
