require 'serverspec'
set :backend, :exec

php_version = '5.6.7'

puts os[:family]

if ["centos", "redhat", "debian"].include?(os[:family])
    describe command("/usr/local/bin/php -v | grep #{php_version}") do
        its(:exit_status) { should eq 0 }
    end
end
