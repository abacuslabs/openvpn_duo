# encoding: utf-8
# frozen_string_literal: true

require 'chef'
require 'chefspec'
require 'tempfile'
require 'simplecov'
require 'simplecov-console'
require 'coveralls'
require 'tmpdir'
require 'fileutils'

RSpec.configure do |c|
  c.color = true

  c.before(:suite) do
    COOKBOOK_PATH = Dir.mktmpdir('chefspec')
    metadata = Chef::Cookbook::Metadata.new
    metadata.from_file(File.expand_path('../../metadata.rb', __FILE__))
    link_path = File.join(COOKBOOK_PATH, metadata.name)
    FileUtils.ln_s(File.expand_path('../..', __FILE__), link_path)
    c.cookbook_path = [COOKBOOK_PATH,
                       File.expand_path('../support/cookbooks', __FILE__)]
  end

  c.after(:suite) { FileUtils.rm_r(COOKBOOK_PATH) }
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ]
)
SimpleCov.minimum_coverage(100)
SimpleCov.start

at_exit { ChefSpec::Coverage.report! }
