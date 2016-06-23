require 'spec_helper'

describe 'pulp::apache::fragment' do
  let(:title) { 'fragment_title' }

  context 'on redhat' do
    let :facts do
      {
        :concat_basedir            => '/tmp',
        :operatingsystem           => 'RedHat',
        :operatingsystemrelease    => '6.4',
        :operatingsystemmajrelease => '6.4',
        :osreleasemajor            => '6',
        :osfamily                  => 'RedHat',
        :processorcount            => 3,
      }
    end

    context 'with ssl_content parameter' do
      let :params do
        { :ssl_content => "some_string" }
      end

      it do
        should contain_concat__fragment("fragment_title").with_content('some_string')
      end
    end

  end
end
