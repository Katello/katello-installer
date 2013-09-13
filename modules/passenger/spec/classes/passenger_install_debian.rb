require 'spec_helper'


describe 'passenger::install::debian' do
  it 'should install passenger' do
    should contain_package('passenger').with({
      :ensure  => 'installed',
      :name    => 'libapache2-mod-passenger',
      :require => 'Class[apache::install]',
      :before  => 'Class[apache::service]',
    })
  end

  it 'should enable RequestHeaders' do
    should contain_exec('enable-headers').with({
      :command => '/usr/sbin/a2enmod headers',
      :creates => '/etc/apache2/mods-enabled/headers.load',
      :require => 'Class[apache::install]',
      :notify  => 'Class[apache::service]',
    })
  end
end
