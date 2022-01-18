# -*- ruby -*-

/^our \$VERSION = "(.+?)"/ =~ File.read("lib/Groonga/HTTP.pm")
version = $1

desc "Tag for #{version}"
task :tag do
  sh("git", "tag", "-a", version, "-m", "#{version} has been released!!!")
  sh("git", "push", "--tags")
end

namespace :version do
  desc "Update version"
  task :update do
    new_version = ENV["NEW_VERSION"]
    if new_version.nil?
      raise "Specify new version as VERSION environment variable value"
    end

    http_pm_content = File.read("lib/Groonga/HTTP.pm").gsub(/^our \$VERSION = ".+?"/) do
      "our $VERSION = \"#{new_version}\""
    end
    File.open("lib/Groonga/HTTP.pm", "w") do |http_pm|
      http_pm.print(http_pm_content)
    end

    doc_config_content = File.read("docs/_config.yml").gsub(/^version: [0-9]{1}\.[0-9]{2}/) do
      "version: #{new_version}"
    end
    File.open("docs/_config.yml", "w") do |doc_config|
      doc_config.print(doc_config_content)
    end

    doc_install_content =
      File.read("docs/install/index.md").gsub(/^% cpanm .*@[0-9]{1}\.[0-9]{2}$/) do
      "% cpanm --notest git://github.com/groonga/Groonga-HTTP.git@#{new_version}"
    end
    File.open("docs/install/index.md", "w") do |doc_install|
      doc_install.print(doc_install_content)
    end

    install_test_content =
      File.read("t/install-test.sh").gsub(/^cpanm .*@[0-9]{1}\.[0-9]{2}$/) do
      "cpanm --notest git://github.com/groonga/Groonga-HTTP.git@#{new_version}"
    end
    File.open("t/install-test.sh", "w") do |install_test|
      install_test.print(install_test_content)
    end
  end
end
