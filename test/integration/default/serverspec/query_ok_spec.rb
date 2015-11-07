require 'serverspec'
set :backend, :exec

describe file('/var/www/html/query_ok') do
    it { should be_directory }
end

