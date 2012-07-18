require "bundler/setup"

## -- Rsync Deploy config -- ##

ssh_user        = "peter@c7.se"
ssh_port        = "22"
document_root   = "/var/www/c7.se/"
deploy_default  = "rsync"

## -- Misc Configs -- ##

public_dir      = ".public"

#####################
# Development       #
#####################

task :default do
  `bundle exec guard`
end

#####################
# Deployment        #
#####################

desc "Deploy website to http://c7.se"
task :deploy do
  puts "## Building Jekyll site"
  system("bundle exec jekyll")

  puts "## Deploying website via Rsync"
  ok_failed system("rsync -avze 'ssh -p #{ssh_port}' --delete #{public_dir}/ #{ssh_user}:#{document_root}")
end

def ok_failed(condition)
  if (condition)
    puts "OK"
  else
    puts "FAILED"
  end
end

def get_stdin(message)
  print message
  STDIN.gets.chomp
end
