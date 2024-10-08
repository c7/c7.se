require "bundler/setup"

## -- Rsync Deploy config -- ##

ssh_user        = "peter@c7.se"
ssh_port        = "22"
document_root   = "/var/www/c7.se/"

## -- Misc Configs -- ##

public_dir      = ".public"
development_dir = ".development"

#####################
# Development       #
#####################

task :default do
  exec("hugo server --bind=0.0.0.0 --disableFastRender --watch -d #{development_dir}")
end

task :css do
  exec("sassc -t compressed sass/main.scss static/css/main.css")
end

#####################
# Deployment        #
#####################

desc "Deploy website to https://c7.se"
task :deploy do
  puts "## Building Hugo site"
  system("rm -rf #{public_dir}")
  system("hugo -b 'https://c7.se/' -d #{public_dir}")

  puts "## Deploying website via Rsync"
  ok_failed system("rsync -avze 'ssh -p #{ssh_port}' --delete #{public_dir}/ #{ssh_user}:#{document_root}")

  system("rm -rf #{public_dir}")
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
