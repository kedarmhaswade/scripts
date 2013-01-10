#!/usr/bin/env ruby
require 'lorem-ipsum'
require 'rubygems'
require 'mixlib/cli'
require 'erb'

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
puts cli.config.inspect
class Configuration
  REPO_NAME = "animator"
  class << self
    attr_reader :users, :files
    def get_git_config
      id = Random.rand(users.length)
      name_email = users.to_a[id]
      template = ERB.new <<-EOF
        [user]
           name = <%= name_email[0] %>
           email = <%= name_email[1] %>
        [core]
           editor = vi
      EOF
      template.result binding
    end
  end
  @users = {}
  @users[:amy] = "amy@example.com"
  @users[:bill] = "bill@example.com"
  @users[:carol] = "carol@example.com"
  @users[:dave] = "dave@example.com"
  @users[:elena] = "elena@example.com"
  @users[:frank] = "frank@example.com"
  @users[:gopal] = "gopal@example.com"
  @users[:hari] = "hari@example.com"
  @users[:john] = "john@example.com"
  @users[:kathy] = "kathy@example.com"
  @users[:luke] = "luke@example.com"
  @files = []
  ('a'..'z').to_a.each do |f|
    @files << (f + ".garb")
  end
  SPECIAL_FILE =  "animator.cfg"
  GOOD_VALUE = 100
  BAD_VALUE = 50
end
# create the git repo, be distructive
Dir.chdir cli.config[:directory] do 
  system("/bin/rm -rf #{Configuration::REPO_NAME}");
  system("git init #{Configuration::REPO_NAME}");
end
REPO_DIR = cli.config[:directory] + "/" + Configuration::REPO_NAME 
GIT_DIR = REPO_DIR + "/.git"
puts Configuration.get_git_config
puts cli.config[:num_commits].class
puts cli.config[:num_commits]
# Now create that many commits
1.upto cli.config[:num_commits].to_i do |i|
  # each commit chooses to change two files, along with "config" file
  # and when it is the bad commit, the special file contains the "bad" value
  li = LoremIpsum::Generator.new
  Dir.chdir REPO_DIR do
    s = Configuration.files.size
    puts "s = #{s}"
    id = Random.rand(s)
    puts "id = #{id}"
    File.open Configuration.files[id], "a" do |f|
      f.puts(li.next_paragraph Random.rand(100))
    end
    id = Random.rand(s)
    File.open Configuration.files[id], "a" do |f|
      f.puts(li.next_paragraph Random.rand(40))
    end
    File.open Configuration::SPECIAL_FILE, "w" do |f|
      f.puts Time.now
      if i == cli.config["bad_commit_number"].to_i
        f.puts Configuration::BAD_VALUE
      else
        f.puts Configuration::GOOD_VALUE
      end
    end
    Dir.chdir GIT_DIR do 
      File.open "config", "w" do |f|
        f.puts Configuration.get_git_config
      end
    end
    # call git
    system("git add .")
    system("git commit -m '#{li.next_paragraph 20}'")
  end
end
