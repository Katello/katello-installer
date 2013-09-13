require 'spec_helper'


describe 'passenger::repo' do
  context 'on redhat' do
    let :facts do
      {
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '5.4',
      }
    end

    it 'should passenger-release' do
      should contain_package('passenger-release').with({
        :ensure   => 'installed',
        :provider => 'rpm',
        :source   => "http://passenger.stealthymonkeys.com/rhel/5/passenger-release.noarch.rpm",
        :before   => 'Package[passenger]',
      })
    end
  end

  context 'on fedora' do
    let :facts do
      {
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '17',
      }
    end

    it 'should passenger-release' do
      should contain_package('passenger-release').with({
        :ensure   => 'installed',
        :provider => 'rpm',
        :source   => "http://passenger.stealthymonkeys.com/fedora/#{facts[:operatingsystemrelease]}/passenger-release.noarch.rpm",
        :before   => 'Package[passenger]',
      })
    end
  end
end
