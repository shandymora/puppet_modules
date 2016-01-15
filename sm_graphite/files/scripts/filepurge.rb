#!/usr/bin/env ruby

#
# Script to check for and/or delete files not modified within a certain timeframe
#
#

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'pp'
require 'time'
require 'json'
require 'optparse'
require 'time'

class Filechecker

  def initialize
    @options = {}
    time = Time.now 
    @start_date = Time.now.strftime "%Y/%m/%d" 
    @now = time.to_i
    @expire_time = 0
    @path_depth = 0
    @total_used = 0
    @total_deleted = 0
    @file_count = 0
    @dir_count = 0
  end

  def get_options
    begin
    opt_parser = OptionParser.new do |opt|
      opt.on("-h", "--hostname HOSTNAME", "A hostname") do |hostname|
        @options["hostname"] = hostname
      end
      opt.on("-d", "--dir DIRECTORY", "Directory to scan") do |directory|
        @options["directory"] = directory
      end
      opt.on("-s", "--share SHARE", "Share to scan") do |share|
        @options["share"] = share
      end
      opt.on("-a", "--action ACTION", "Action to perform (print|delete)") do |action|
        @options["action"] = action
      end
      @options["pathdepth"] = 12
      opt.on("-p", "--pathdepth PATHDEPTH", "Max path depth") do |pathdepth|
        @options["pathdepth"] = pathdepth.to_i
      end
      opt.on("-e", "--exclude EXCLUDES", "Exclude keywords") do |exclude|
        @options["exclude"] = exclude.split(",")
      end
      opt.on("-t", "--timeframe DAYS", "Timeframe in days") do |timeframe|
        @options["timeframe"] = timeframe.to_i
      end
    end
    opt_parser.parse!
    rescue
      error_and_exit("Unable to parse options")
    end

    # Validate options
    if ! @options.has_key?("directory")
      error_and_exit("No directory (--dir) specified")
    end
    if ! @options.has_key?("action") 
      error_and_exit("No action (--action) specified (print|delete)")
    else
      if @options["action"] != "print" and @options["action"] != "delete"
	error_and_exit("Invalid action option, must be print|delete")
      end
    end
    if ! @options.has_key?("timeframe")
      error_and_exit("No timeframe (--timeframe) specified (in days)")
    end
  end

  def error_and_exit(message)
    puts "#{message}"
    exit 1
  end

  def scan_directory(workdir)
    # Check for excludes
    if @options.has_key?("exclude") and @options["exclude"].respond_to?("each")
      @options["exclude"].each do |exclude|
	return if exclude == workdir
      end
    end

    # Get current working directory
    startdir = Dir.pwd
    if ! Dir.chdir workdir
      puts "Unable to enter dir #{workdir}"
      @path_depth -= 1
      puts "Unable to enter dir #{startdir}" unless Dir.chdir startdir 
    end

    @path_depth += 1

    fullworkdir = Dir.pwd
    names = Dir.entries(fullworkdir)

    # Check for excludes
    if @options.has_key?("exclude") and @options["exclude"].respond_to?("each")
      @options["exclude"].each do |exclude|
	return if exclude == fullworkdir
      end
    end

    if names.respond_to?("each")
      names.each do |name|
	next if name == "."
	next if name == ".."
        next if File.symlink?(fullworkdir+"/"+name)

	# Process Excludes
        if @options.has_key?("exclude") and @options["exclude"].respond_to?("each")
          @options["exclude"].each do |exclude|
	    next if exclude == name
          end
        end

	file_type = File.stat(fullworkdir+"/"+name).ftype 
        # Check mtime against expire_date to see if we should action this file
        if File.stat(fullworkdir+"/"+name).ftype == "file" and File.stat(fullworkdir+"/"+name).mtime < Time.at(@expire_time) and File.stat(fullworkdir+"/"+name).atime < Time.at(@expire_time)
	  file_size = File.stat(fullworkdir+"/"+name).size
	  if @options["action"] == "print"
	    puts "#{fullworkdir}/#{name}"
	    @total_used += File.stat(fullworkdir+"/"+name).size
	    @file_count += 1
	  end
	  if @options["action"] == "delete"
	    begin
	      File.delete(fullworkdir+"/"+name)
	    rescue
	      puts "Could not delete file: #{fullworkdir}/#{name}"
	      next
	    end
	    puts "Deleted file #{fullworkdir}/#{name}"
	    @total_deleted += file_size.to_i
	    @file_count += 1
	  end
        end

	if @path_depth == @options["pathdepth"]
	  puts "Maximum path depth reached"
	end
	if file_type == "directory"
	  scan_directory(name)
	  next
	end


      end

      if is_dir_empty(fullworkdir) == true
        Dir.delete(fullworkdir) if @options["action"] == "delete"
	@dir_count += 1
      end
      @path_depth -= 1
      puts "Unable to enter dir #{startdir}" unless Dir.chdir startdir

    end
  end

  def is_dir_empty(dir)
    names = Dir.entries(dir)
    contents = []
    if names.respond_to?("each")
      names.each do |name|
	next if name == "." or name == ".." 
 	contents.push(name)	
      end
    end
    if contents.length == 0
      return true 
    else
      return false
    end
  end

  def run
    get_options

    @expire_time = @now - ( @options["timeframe"] * 86400 )
    @expire_date = Time.at(@expire_time).strftime "%Y/%m/%d"
    puts "start_date: #{@start_date}"
    puts "now:        #{@now}"
    puts "expire_time: #{@expire_time}"
    puts "expire_date: #{@expire_date}"

    scan_directory(@options["directory"])

    puts "Used:    #{(@total_used/1024/1024).to_i}MB in #{@file_count} files and #{@dir_count} empty directories" if @options["action"] == "print"
    puts "Deleted: #{(@total_deleted/1024/1024).to_i}MB in #{@file_count} files and #{@dir_count} empty directories" if @options["action"] == "delete"
  end

end

checkfile = Filechecker.new
checkfile.run

