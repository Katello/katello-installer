require 'spec_helper'

describe 'candlepin' do

  db_user = 'testuser'
  db_password = 'testpassword'

  context 'on rhel6' do
    let :facts do
      {
        :concat_basedir             => '/tmp',
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '6.4',
        :operatingsystemmajrelease  => '6',
        :osfamily                   => 'RedHat',
      }
    end

    it { should contain_class('candlepin::install') }
    it { should contain_class('candlepin::config') }
    it { should contain_class('candlepin::database') }
    it { should contain_class('candlepin::service') }

    it { should contain_file('/etc/candlepin/candlepin.conf') }

    it { should contain_service('tomcat6').with_ensure('running') }

    describe 'with default configuration' do
      it do
        should contain_concat__fragment('General Config').
          with_content(/module.config.adapter_module=org.candlepin.katello.KatelloModule/).
          with_content(/candlepin.amqp.enable=true/)
      end
      
      it do
        should contain_package('candlepin').with(
          'ensure' => 'installed'
        )
        should contain_package('candlepin-tomcat6').with(
          'ensure' => 'installed'
        )
      end
    end
    
    describe 'with modified configuration' do
      cp_version = '0.9.26'
      let :params do
        {
          :adapter_module => 'my.custom.adapter_module',
          :amq_enable => false,
          :version => cp_version,
        }
      end
      
      it do
        should contain_concat__fragment('General Config').
          with_content(/module.config.adapter_module=my.custom.adapter_module/).
          without_content(/candlepin.amqp.enable=true/)
      end
      
      it do
        should contain_package('candlepin').with(
          'ensure' => cp_version
        )
        should contain_package('candlepin-tomcat6').with(
          'ensure' => cp_version
        )
      end
    end

    describe 'with mysql' do
      describe 'default' do
        let :params do
          {
            :db_type => 'mysql',
            :db_user => db_user,
            :db_password => db_password,
          }
        end

        it {should contain_class('candlepin::database::mysql') }
        it {should_not contain_class('candlepin::database::postgresql') }

        it do
          should contain_concat__fragment('Mysql Database Configuration').
            with_content(/jpa.config.hibernate.dialect=org.hibernate.dialect.MySQLDialect/).
            with_content(/jpa.config.hibernate.connection.driver_class=com.mysql.jdbc.Driver/).
            with_content(/jpa.config.hibernate.connection.url=jdbc:mysql:\/\/localhost:3306\/candlepin/).
            with_content(/jpa.config.hibernate.connection.username=#{db_user}/).
            with_content(/jpa.config.hibernate.connection.password=#{db_password}/).
            with_content(/jpa.config.hibernate.hbm2ddl.auto=validate/)
        end
      end

      describe 'and enable_hbm2ddl_validate = false' do
        let :params do
          {
            :db_type => 'mysql',
            :enable_hbm2ddl_validate => false,
          }
        end

        it do
          should contain_concat__fragment('Mysql Database Configuration').
            without_content(/jpa.config.hibernate.hbm2ddl.auto=validate/)
        end
      end
    end

    describe 'with postgres' do
      describe 'default' do
        let :params do
          {
            #:db_type => 'postgresql', #should be the default
            :db_user => db_user,
            :db_password => db_password,
          }
        end

        it {should contain_class('candlepin::database::postgresql') }
        it {should_not contain_class('candlepin::database::mysql') }

        it do
          should contain_concat__fragment('PostgreSQL Database Configuration').
            with_content(/jpa.config.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect/).
            with_content(/jpa.config.hibernate.connection.driver_class=org.postgresql.Driver/).
            with_content(/jpa.config.hibernate.connection.url=jdbc:postgresql:\/\/localhost:5432\/candlepin/).
            with_content(/jpa.config.hibernate.connection.username=#{db_user}/).
            with_content(/jpa.config.hibernate.connection.password=#{db_password}/).
            with_content(/jpa.config.hibernate.hbm2ddl.auto=validate/)
        end

        describe 'and enable_hbm2ddl_validate = false' do
          let :params do
            {
              :db_type => 'postgresql',
              :enable_hbm2ddl_validate => false,
            }
          end

          it do
            should contain_concat__fragment('PostgreSQL Database Configuration').
              without_content(/jpa.config.hibernate.hbm2ddl.auto=validate/)
          end
        end
      end
    end

    describe 'with fake database' do
      let(:params) { {:db_type => 'fakedatabase'} }

      it do
        expect {
          to raise_error("Invalid db_type selected: fakedatabase. Valid options are ['mysql','postgresql'].")
        }
      end
    end

  end

  context 'on rhel7' do
    let :facts do
      {
        :concat_basedir             => '/tmp',
        :operatingsystem            => 'RedHat',
        :operatingsystemrelease     => '7.0',
        :operatingsystemmajrelease  => '7',
        :osfamily                   => 'RedHat',
      }
    end

    it { should contain_class('candlepin::install') }
    it { should contain_class('candlepin::config') }
    it { should contain_class('candlepin::database') }
    it { should contain_class('candlepin::service') }

    it { should contain_file('/etc/candlepin/candlepin.conf') }

    it { should contain_service('tomcat').with_ensure('running') }

    it do
      should contain_package('candlepin').with(
        'ensure' => 'installed'
      )
      should contain_package('candlepin-tomcat').with(
        'ensure' => 'installed'
      )
    end
  end

end
