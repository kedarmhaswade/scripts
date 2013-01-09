#!/usr/bin/env ruby
require 'rubygems'
require 'mixlib/cli'

class MyCLI
  include Mixlib::CLI
  option :num_commits, 
    :short => "-n num",
    :long  => "--num_commits num",
    :default => 1000,
    :description => "Total number of commits to create"

  option :bad_commit_number, 
    :short => "-b bad_commit_number",
    :long  => "--bad bad_commit_number",
    :description => "Which commit should be bad?",
    :default => (1 + (options[:num_commits][:default])*0.2).round

  option :directory, 
    :short => "-d local_repo_directory",
    :long  => "--directory local_repo_directory",
    :description => "Where to create the test Git repository",
    :default => `pwd`.chomp

  def validate
    
  end
end

cli = MyCLI.new
cli.parse_options
#puts cli.options.inspect
