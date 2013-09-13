require 'spec_helper'


describe 'passenger::install::redhat' do
  context 'on redhat 5' do
    let :facts do
      {
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '5.4',
      }
    end

    it { should include_class('passenger::repo') }

    it 'should install passenger' do
      should contain_package('passenger').with({
        :ensure  => 'installed',
        :name    => 'mod_passenger',
        :require => 'Class[apache::install]',
        :before  => 'Class[apache::service]',
      })
    end
  end

  context 'on redhat 6' do
    let :facts do
      {
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '6.4',
      }
    end

    it { should_not include_class('passenger::repo') }
  end

  context 'on fedora 16' do
    let :facts do
      {
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '16',
      }
    end

    it { should include_class('passenger::repo') }
  end

  context 'on fedora 17' do
    let :facts do
      {
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '17',
      }
    end

    it { should_not include_class('passenger::repo') }
  end

  context 'on amazon without redhat-lsb' do
    let :facts do
      {
        :operatingsystem           => 'Amazon',
        :operatingsystemmajrelease => '3',
        :operatingsystemrelease    => '3.4.48-45.46.amzn1.x86_64',
        :osfamily                  => 'RedHat',
      }
    end

    it { should_not include_class('passenger::repo') }
  end

  context 'on amazon with redhat-lsb' do
    let :facts do
      {
        :operatingsystem           => 'Amazon',
        :operatingsystemmajrelease => '2013',
        :operatingsystemrelease    => '2013.03',
        :osfamily                  => 'RedHat',
      }
    end

    it { should_not include_class('passenger::repo') }
  end
end
