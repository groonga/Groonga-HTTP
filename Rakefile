# -*- ruby -*-

/^our \$VERSION = "(.+?)"/ =~ File.read("lib/Groonga/HTTP.pm")
version = $1

desc "Tag for #{version}"
task :tag do
  sh("git", "tag", "-a", version, "-m", "#{version} has been released!!!")
  sh("git", "push", "--tags")
end
