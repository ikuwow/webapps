require 'serverspec'
set :backend, :exec

describe user('apache') do
    it { should exist }
    it { should belong_to_group 'apache' }
    it { should have_home_directory '/home/apache' }
end

describe file('/var/www/html') do
    it { should be_directory }
    it { should be_owned_by 'apache' }
    it { should be_mode 755 }
end

describe package('git') do
    it { should be_installed }
end

