#! /usr/bin/env ruby -S rspec

#  Copyright 2015 Puppet Community
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

require 'spec_helper'

describe 'resources_deep_merge' do
  let(:resources) do
    {
      'one' => {
        'attributes' => {
          'user' => '1',
          'pass' => '1',
        }
      },
      'two' => {
        'attributes' => {
          'user' => '2',
          'pass' => '2',
        }
      }
    }
  end

  let(:defaults) do
    {
      'ensure' => 'present',
      'attributes' => {
        'type' => 'psql',
      }
    }
  end

  let(:result) do
    {
      'one' => {
        'ensure' => 'present',
        'attributes' => {
          'type' => 'psql',
          'user' => '1',
          'pass' => '1',
        }
      },
      'two' => {
        'ensure' => 'present',
        'attributes' => {
          'type' => 'psql',
          'user' => '2',
          'pass' => '2',
        }
      },
    }
  end

  describe 'signature validation' do
    it 'should exist' do
      is_expected.not_to be_nil
    end

    it 'should raise an ArgumentError if there is less than 1 arguments' do
      is_expected.to run.with_params.and_raise_error ArgumentError
    end

    it 'should not compile when 1 argument is passed' do
      my_hash = { 'one' => 1 }
      is_expected.to run.with_params(my_hash).and_raise_error ArgumentError
    end

    it 'should require all parameters are hashes' do
      is_expected.to run.with_params({}, '2').and_raise_error ArgumentError
    end
  end

  describe 'when calling resources_deep_merge on a resource and a defaults hash' do
    it 'should be able to deep_merge a resource hash and a defaults hash' do
      is_expected.to run.with_params(resources, defaults).and_return(result)
    end
  end
end
