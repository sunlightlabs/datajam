namespace :plugins do
  desc "Create a plugins file with the default plugins"
  task :defaults do
    tmpl = <<-EOT.strip_heredoc
    gem 'datajam-chat',     git: 'https://github.com/sunlightlabs/datajam-chat.git', require: 'datajam/chat'
    gem 'datajam-datacard', git: 'https://github.com/sunlightlabs/datajam-datacard.git', require: 'datajam/datacard'
    EOT
    pfile = File.open(File.expand_path('../../../Pluginfile', __FILE__), 'w+') { |f| f.write(tmpl)}
  end

  desc "Create an empty plugins file with examples"
  task :sample do
    tmpl = <<-EOT.strip_heredoc
    #gem 'datajam-chat',     git: 'https://github.com/sunlightlabs/datajam-chat.git', require: 'datajam/chat'
    #gem 'datajam-datacard', git: 'https://github.com/sunlightlabs/datajam-datacard.git', require: 'datajam/datacard'
    EOT
    pfile = File.open(File.expand_path('../../../Pluginfile', __FILE__), 'w+') { |f| f.write(tmpl)}
  end
end

desc "Create an empty plugins file with examples"
task :plugins do
  Rake::Task['plugins:sample'].invoke
end
