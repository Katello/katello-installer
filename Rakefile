require 'rake/clean'
require 'tempfile'

BUILDDIR = File.expand_path(ENV['BUILDDIR'] || '_build')
PKGDIR = ENV['PKGDIR'] || File.expand_path('pkg')
FOREMAN_MODULES_DIR = File.expand_path(ENV['FOREMAN_MODULES_DIR'] || '/usr/share/foreman-installer/modules')
FOREMAN_BRANCH = ENV['FOREMAN_BRANCH'] || 'develop'

file BUILDDIR do
  mkdir BUILDDIR
end

file PKGDIR do
  mkdir PKGDIR
end

file "#{BUILDDIR}/modules" do |t|
  if Dir["modules/*"].empty?
    sh "librarian-puppet install --verbose --path #{BUILDDIR}/modules"
    Rake::Task["prune_foreman_modules"].execute
  else
    mkdir BUILDDIR
    cp_r "modules", "#{BUILDDIR}/modules"
  end
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
      FileUtils.rm_rf(File.join("#{BUILDDIR}",'modules', File.basename(mod)))
    end
  ensure
    FileUtils.remove_entry_secure temp_dir if temp_dir
  end
end

namespace :pkg do
  desc 'Generate package source tar.bz2'
  task :generate_source => [:clean, PKGDIR, "#{BUILDDIR}/modules"] do

    version = File.read('VERSION').chomp
    raise "can't read VERSION" if version.length == 0

    Dir.chdir(BUILDDIR) do
      puts "tar -cf #{BUILDDIR}/modules.tar --transform=s,^,katello-installer-#{version}/, modules/"
      `tar -cf #{BUILDDIR}/modules.tar --transform=s,^,katello-installer-#{version}/, modules/`
    end

    `git archive --prefix=katello-installer-#{version}/ HEAD > #{PKGDIR}/katello-installer-#{version}.tar`
    `tar --concatenate --file=#{PKGDIR}/katello-installer-#{version}.tar #{BUILDDIR}/modules.tar`
    `gzip -9 #{PKGDIR}/katello-installer-#{version}.tar`
  end
end

CLEAN.include(BUILDDIR, PKGDIR)

task :default => ['pkg:generate_source']
