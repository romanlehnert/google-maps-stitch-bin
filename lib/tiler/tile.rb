require "tempfile"
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
    open(remote_url) do |image|
      file = Tempfile.new("x_#{x}_y_#{y}_z_#{z}")
      file.write(image.read)
      puts "downloaded #{remote_url} to #{file.path}"
      @file = file
      @local_file_name = file.path
    end
  end

  def local_file_name
    @local_file_name
  end

  def downloaded?
    !@local_file_name.nil?
  end

end
