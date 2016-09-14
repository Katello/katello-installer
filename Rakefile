require 'rake/clean'
require 'tempfile'
require 'kafo'
require 'yaml'

BUILDDIR = File.expand_path(ENV['BUILDDIR'] || '_build')
PKGDIR = ENV['PKGDIR'] || File.expand_path('pkg')
FOREMAN_MODULES_DIR = File.expand_path(ENV['FOREMAN_MODULES_DIR'] || '/usr/share/foreman-installer/modules')
FOREMAN_BRANCH = ENV['FOREMAN_BRANCH'] || 'develop'
PARSER_CACHE_DIR = ENV['PARSER_CACHE_DIR'] || "#{BUILDDIR}/parser_cache"

file BUILDDIR do
  mkdir BUILDDIR
end

file PKGDIR do
  mkdir PKGDIR
end

file PARSER_CACHE_DIR => [BUILDDIR] do
  mkdir PARSER_CACHE_DIR
end

file "#{BUILDDIR}/modules" do |t|
  sh "librarian-puppet install --verbose --path #{BUILDDIR}/modules"
end

task :generate_parser_caches => [PARSER_CACHE_DIR] do
  caches = [
    "#{PARSER_CACHE_DIR}/katello.yaml",
    "#{PARSER_CACHE_DIR}/katello-devel.yaml",
    "#{PARSER_CACHE_DIR}/capsule-certs-generate.yaml"
  ]

  configs = [
    'config/katello.yaml',
    'config/katello-devel.yaml'
  ]

  # capsule-certs-generate is a special (read: "problem") child
  load File.expand_path(File.join(File.dirname(__FILE__), 'bin', 'capsule-certs-generate'))
  gen = CapsuleCertsGenerate.new
  configs << gen.config_file.path

  caches.each_with_index do |filename, i|
    sh "kafo-export-params -c #{configs[i]} -f parsercache --no-parser-cache -o #{filename}"

    cache = YAML.load_file(filename.to_s)
    cache[:files] = cache[:files].delete_if { |k, _| k =~ /\Aforeman/ }
    File.open(filename.to_s, "w") do |file|
      file.write(cache.to_yaml)
    end
  end
  gen.cleanup
end

desc 'Remove foreman modules from $BUILDDIR/modules'
task :prune_foreman_modules => [] do
  begin
    # raise "No foreman modules found in #{FOREMAN_MODULES_DIR}"
    if Dir["#{FOREMAN_MODULES_DIR}/*"].empty?
      temp_dir = Dir.mktmpdir
      Dir.chdir(temp_dir) do
        puts 'Downloading foreman modules...'
        `git clone -b #{FOREMAN_BRANCH} https://github.com/theforeman/foreman-installer.git`
        Dir.chdir('foreman-installer') do
          `rake pkg:generate_source --trace`
        end
      end
      temp_foreman_modules_dir = File.join(temp_dir, 'foreman-installer', '_build', 'modules')
    end
    Dir.glob(File.join((temp_foreman_modules_dir || FOREMAN_MODULES_DIR), '*')).each do |mod|
      FileUtils.rm_rf(File.join("#{BUILDDIR}", 'modules', File.basename(mod)))
    end
  ensure
    FileUtils.remove_entry_secure temp_dir if temp_dir
  end
end

namespace :pkg do
  desc 'Generate package source tar.bz2'
  task :generate_source => [:clean, PKGDIR, "#{BUILDDIR}/modules", :generate_parser_caches, :prune_foreman_modules] do

    version = File.read('VERSION').chomp
    raise "can't read VERSION" if version.length == 0

    Dir.chdir(BUILDDIR) do
      sh "tar --create --file=#{BUILDDIR}/modules.tar --transform=s,^,katello-installer-#{version}/, modules/"
      sh "tar --create --file=#{BUILDDIR}/parser_cache.tar --transform=s,^,katello-installer-#{version}/, parser_cache/"
    end

    sh "git archive --prefix=katello-installer-#{version}/ HEAD > #{PKGDIR}/katello-installer-#{version}.tar"
    sh "tar --concatenate --file=#{PKGDIR}/katello-installer-#{version}.tar #{BUILDDIR}/modules.tar"
    sh "tar --concatenate --file=#{PKGDIR}/katello-installer-#{version}.tar #{BUILDDIR}/parser_cache.tar"
    sh "gzip -9 #{PKGDIR}/katello-installer-#{version}.tar"
  end
end

task :setup_local => [:clean, "#{BUILDDIR}/modules"] do
  rm_rf "modules"
  cp_r "#{BUILDDIR}/modules", "modules"
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue
  puts 'Rubocop not loaded'
end

CLEAN.include(BUILDDIR, PKGDIR)

task :default => [:rubocop, 'pkg:generate_source']
