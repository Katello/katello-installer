require 'puppetlabs_spec_helper/module_spec_helper'


RSpec.configure do |c|

  # Use color in STDOUT
  c.color = true

  # Use color not only in STDOUT but also in pagers and files
  c.tty = true

  # Use the specified formatter
  c.formatter = :documentation # :progress, :html, :textmate
end