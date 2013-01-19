#!/usr/bin/env ruby
require 'random_ipsum'
require 'rubygems'
require 'mixlib/cli'
require 'erb'
# creates the repo
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

# Creates the script that determines the "health" of the repository
def create_health_script file
  contents = <<EOF
#!/bin/bash
f1=static.cfg
f2=runtime.cfg
f3=prefs.cfg
if [[ ! (-e $f1 && -e $f2 && -e $f3) ]]; then
  echo "files missing, no, it's not good :-("
  exit 1
fi
STATIC=$(grep ".*" $f1)
RUNTIME=$(grep ".*" $f2)
PREFS=$(grep ".*" $f3)
if [[ ("$STATIC" == "ncores=4") && ("$RUNTIME" == "memory=1024") && ("$PREFS" == "folder=home") ]]; then
  echo "yes, it's good :-)"
else
  echo "no, it's not good :-("
  exit 2
fi
EOF
  File.open file, "w" do |f|
    f.puts contents
  end
  File.chmod(0744, file)
end

cli = MyCLI.new
cli.parse_options
puts cli.config.inspect
class Configuration
  REPO_NAME = "animator-pro"
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
    @files << (f + ".txt")
  end
  SPECIAL_FILES =  ["static.cfg", "runtime.cfg", "prefs.cfg"]
  SPECIAL_FILE_GOOD_CONTENTS = ["ncores=4", "memory=1024", "folder=home"]
  SPECIAL_FILE_BAD_CONTENTS = ["ncores=6", "memory=2048", "folder=/tmp"]
end
# create the git repo, be distructive
REPO_DIR = cli.config[:directory] + "/" + Configuration::REPO_NAME 
GIT_DIR = REPO_DIR + "/.git"
# puts Configuration.get_git_config
# puts cli.config[:num_commits].class
# puts cli.config[:num_commits]
Dir.chdir cli.config[:directory] do 
  system("/bin/rm -rf #{Configuration::REPO_NAME}"); 
  system("git init #{Configuration::REPO_NAME}");
  Dir.chdir Configuration::REPO_NAME do
    create_health_script "is_it_good"
    Dir.chdir GIT_DIR do 
      File.open "config", "w" do |f|
        f.puts Configuration.get_git_config
      end
    end
  end
end
# create a good commit, tag it, this commit must put the repo in "good" state
Dir.chdir REPO_DIR do
  0.upto 2 do |fi|
    File.open Configuration::SPECIAL_FILES[fi], "w" do |f|
      f.puts Configuration::SPECIAL_FILE_GOOD_CONTENTS[fi]
    end
  end
  system("git add .")
  system("git commit -m 'a good version ...'")
  system("git tag release_1.0.0 HEAD");
end
# Now create that many commits
2.upto cli.config[:num_commits].to_i do |i|
  # each commit chooses to change two files, along with "a config file"
  Dir.chdir REPO_DIR do
    if i == cli.config[:bad_commit_number].to_i
      index = Random.rand(Configuration::SPECIAL_FILES.size)
      File.open Configuration::SPECIAL_FILES[index], "w" do |f|
        f.puts Configuration::SPECIAL_FILE_BAD_CONTENTS[index]
      end
      s = Configuration.files.size
      id = Random.rand(s)
      File.open Configuration.files[id], "a" do |f|
        f.puts RandomIpsum.paragraphs(2, 5, 11)
      end
    else
      s = Configuration.files.size
      id = Random.rand(s)
      File.open Configuration.files[id], "a" do |f|
        f.puts RandomIpsum.paragraphs(2, 5, 11)
      end
      id = Random.rand(s)
      File.open Configuration.files[id], "a" do |f|
        f.puts RandomIpsum.paragraphs(2, 4, 12)
      end
    end
    Dir.chdir GIT_DIR do 
      File.open "config", "w" do |f|
        f.puts Configuration.get_git_config
      end
    end
    # call git
    system("git add .")
    system("git commit -m '#{RandomIpsum.paragraphs(1, 2, 10)}'")
  end
end
