require 'spec_helper'

describe 'cache_data' do
  include Mocha::ParameterMatchers

  let(:initial_data) { 'my_password' }
  let(:data_name) { 'mysql_password' }
  let(:cache_dir) { 'data_cache' }
  let(:filename) { "#{cache_dir}/#{data_name}" }

  it { expect(subject).not_to eq(nil) }
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params(data_name).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('', initial_data).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('', 'mysql_password', initial_data).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(cache_dir, data_name, initial_data).and_return(initial_data) }

  context 'when data already exists' do
    before do
      File.stubs(:read).with(regexp_matches(/metadata.json/)).returns('{}')
      File.stubs(:exists?).with(regexp_matches(/#{filename}/)).returns(true)
      File.expects(:read).with(regexp_matches(/#{filename}/)).returns(initial_data).once
    end

    it { is_expected.to run.with_params(cache_dir, data_name, initial_data).and_return(initial_data) }
  end
end
