#!/usr/bin/env ruby

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'optparse'
require 'tiler'

###require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "tiler"))

options = {}
 
optparse = OptionParser.new do |opts|

  opts.banner = "Usage: tiler.rb [options] ..."

  opts.on('--start_lat LAT', Float, 'Latitude of startpoint (top left)' ) do |start_lat|
    options[:start_lat] = start_lat
  end

  opts.on('--start_lon LON', Float, 'Longitude of startpoint (top left)' ) do |start_lon|
    options[:start_lon] = start_lon
  end

  opts.on('--end_lat LAT', Float,  'Latitude of endpoint (bottom right)' ) do |end_lat|
    options[:end_lat] = end_lat
  end

  opts.on('--end_lon LON', Float, 'Longitude of endoint (bottom right)' ) do |end_lon|
    options[:end_lon] = end_lon
  end

  opts.on('--zoom ZOOM_LEVEL', Integer, 'Zoom Level in Google maps') do |zoom|
    if (1..18).include?(zoom)
      options[:zoom] = zoom
    else
      raise OptionParser::InvalidArgument
    end
  end

  opts.on('--source SOURCE', String, '"map" or "sattelite". Default is "sattelite"') do |source|
    if ["map", "sattelite"].include?(source)
      options[:source] = source 
    else
      raise OptionParser::InvalidArgument
    end
  end

  opts.on('--output FILEPATH', String, 'select output file') do |output|
    options[:output] = output
  end


  opts.on( '-h', '--help', 'Display this help' ) do
    puts opts
    exit
  end
end


begin
  optparse.parse!
  mandatory_opts = [:output, :start_lat, :start_lon, :end_lat, :end_lon, :zoom ]
  missing_opts = mandatory_opts.select { |param| options[param].nil? }

  if !missing_opts.empty?
    puts
    puts "Missing options: #{missing_opts.join(', ')}"
    puts 
    puts optparse
    exit
  end

rescue OptionParser::InvalidArgument, OptionParser::InvalidOption, OptionParser::MissingArgument => e
  puts
  puts e.inspect
  puts
  puts optparse
  exit
end

tiler = Tiler.new(options)
tiler.run
