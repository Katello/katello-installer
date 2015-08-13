BUILDDIR = File.expand_path(ENV['BUILDDIR'] || '_build')
PKGDIR = ENV['PKGDIR'] || File.expand_path('pkg')

file BUILDDIR do
  mkdir BUILDDIR
end

file PKGDIR do
  mkdir PKGDIR
end

file "#{BUILDDIR}/modules" do |t|
  if Dir["modules/*"].empty?
    sh "librarian-puppet install --verbose --path #{BUILDDIR}/modules"
  else
    cp_r "modules/", BUILDDIR
  end
end

namespace :pkg do
  desc 'Generate package source tar.bz2'
  task :generate_source => [PKGDIR, "#{BUILDDIR}/modules"] do

    version = File.read('VERSION').chomp
    raise "can't read VERSION" if version.length == 0

    Dir.chdir(BUILDDIR) do
      `tar -cf #{BUILDDIR}/modules.tar --transform=s,^,katello-installer-#{version}/, modules/`
    end

    `git archive --prefix=katello-installer-#{version}/ HEAD > #{PKGDIR}/katello-installer-#{version}.tar`
    `tar --concatenate --file=#{PKGDIR}/katello-installer-#{version}.tar #{BUILDDIR}/modules.tar`
    `gzip -9 #{PKGDIR}/katello-installer-#{version}.tar`
  end
end

task :default => ['pkg:generate_source']
