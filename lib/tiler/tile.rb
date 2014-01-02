require "tempfile"
require 'net/http'
require 'uri'

class Tile

  attr_reader :x, :y, :z

  attr_accessor :file

  def initialize(args)
    @x        = args[:x]
    @y        = args[:y]
    @z        = args[:z]
    @source   = args[:source] || "sattelite"
  end

  def remote_url
    "https://khms0.google.com/kh/v=143&src=app&x=#{x}&y=#{y}&z=#{z.to_s}"
  end

  def download

    uri = URI.parse(remote_url)
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      resp = http.get(uri.path)
      file = Tempfile.new("x_#{x}_y_#{y}_z_#{z}", Dir.tmpdir, 'wb+')
      file.write(resp.body)
      file.flush
      puts "downloaded #{remote_url} to #{file.path}"
      @file = file
      @local_file_name = file.path
      file
    end
  end

  def local_file_name
    @local_file_name
  end

  def downloaded?
    !@local_file_name.nil?
  end

end
