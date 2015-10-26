require 'spec_helper'

describe 'candlepin::database' do

  let(:db_user) { 'testuser' }
  let(:db_password) { 'testpassword' }

  let :facts do
    {
      :concat_basedir         => '/tmp',
      :operatingsystem        => 'RedHat',
      :operatingsystemrelease => '6.4',
      :osfamily               => 'RedHat',
    }
  end

  describe 'with mysql' do
    describe 'default' do
      let :pre_condition do
        "class {'candlepin':
          db_type => 'mysql',
          db_user => #{db_user},
          db_password => #{db_password},
        }"
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
      let :pre_condition do
        "class {'candlepin':
          db_type => 'mysql',
          enable_hbm2ddl_validate => false,
        }"
      end

      it do
        should contain_concat__fragment('Mysql Database Configuration').
          without_content(/jpa.config.hibernate.hbm2ddl.auto=validate/)
      end
    end
  end

  describe 'with postgres' do
    describe 'default' do
      let :pre_condition do
        "class {'candlepin':
          db_user => #{db_user},
          db_password => #{db_password},
        }"
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
        let :pre_condition do
          "class {'candlepin':
            enable_hbm2ddl_validate => false,
          }"
        end

        it do
          should contain_concat__fragment('PostgreSQL Database Configuration').
            without_content(/jpa.config.hibernate.hbm2ddl.auto=validate/)
        end
      end
    end
  end

  describe 'with fake database' do
    let :pre_condition do
      "class {'candlepin':
        db_type => 'fakedatabase'
      }"
    end

    it do
      expect {
        to raise_error("Invalid db_type selected: fakedatabase. Valid options are ['mysql','postgresql'].")
      }
    end
  end

end
