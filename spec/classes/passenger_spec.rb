require 'spec_helper'


describe 'passenger' do
  context 'on redhat' do
    let :facts do
      {
        :osfamily => 'RedHat',
      }
    end

    it 'should include classes' do
      should include_class('passenger')
      should include_class('apache')
      should include_class('passenger::install')
    end
  end

  context 'on debian' do
    let :facts do
      {
        :osfamily => 'Debian',
      }
    end

    it 'should include classes' do
      should include_class('passenger')
      should include_class('apache')
      should include_class('passenger::install')
    end
  end
end
