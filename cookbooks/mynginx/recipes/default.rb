package 'git'
package 'tree'

package 'nginx' do
	  action :install
end


service 'nginx' do
	  action [ :enable, :start ]
end


template "/var/www/html/index.html" do
	 source "index.html.erb"
	   mode "0644"
	   notifies :reload, "service[nginx]"

end

template "/etc/nginx/nginx.conf" do   
	  source "nginx.conf.erb"
	    notifies :reload, "service[nginx]"
end
