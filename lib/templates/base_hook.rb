#!/usr/bin/env ruby

# running codeqa checks on changes files

def staged_files
  @staged_files ||= begin
    files = `git diff --cached --name-only --diff-filter=ACM`.split
    files.reject do |f|
      if File.ftype(f) != 'file'
        true
      else
        size = File.size(f)
        size > 1_000_000 || (size > 20 && binary?(f))
      end
    end
  end
end

# from https://github.com/djberg96/ptools/blob/master/lib/ptools.rb#L90
def binary?(file)
  return true if File.ftype(file) != 'file'
  s = (File.read(file, File.stat(file).blksize) || '').split(//)
  ((s.size - s.grep(' '..'~').size) / s.size.to_f) > 0.30
end

begin
  require 'bundler/setup'
  require 'codeqa'
rescue LoadError
  puts "can't find codeqa in current bundle"
  exit 1
end

files_to_check = staged_files.
                 map{ |e| Pathname.new(e).realpath.to_s }.
                 reject{ |e| File.directory?(e) || Codeqa.configuration.excluded?(e) }.
                 uniq

print "Codeqa checking #{files_to_check.count} files"
# fail fast
success = files_to_check.all? do |file|
  print '.'
  Codeqa.check(file, :silent_success => true)
end

if success
  exit 0
else
  exit 1
end
