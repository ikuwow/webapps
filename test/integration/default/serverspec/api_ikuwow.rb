require 'serverspec'
set :backend, :exec

describe file("/var/www/html/api") do
    it { should be_directory }
end

describe command("apachectl configtest") do
    its(:exit_status) { should eq 0 }
end
