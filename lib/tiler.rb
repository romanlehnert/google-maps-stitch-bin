require 'simple_mercator_location'
require 'forwardable'
require 'open-uri'
require 'tiler/tile'
require 'tiler/tiles'
require 'RMagick'


class Tiler

  extend Forwardable

  attr_accessor :zoom, 
                :source, 
                :output, 
                :start_x, 
                :start_y, 
                :end_x, 
                :end_y, 
                :start_lat, 
                :start_lon, 
                :end_lat, 
                :end_lon


  def_delegator :tiles, :download
  def_delegator :tiles, :stitch
  def_delegator :tiles, :cleanup


  def initialize(args = {})
    set_rectangle(args)
    args = defaults.merge(args)

    self.zoom   = args[:zoom]
    self.source = args[:source]
    self.output = args[:output]
  end

  def defaults
    { zoom: 1, source: "sattelite", start_x: 0, start_y: 0, end_x: 0, end_y: 0}
  end

  def tiles
    @tiles ||= TilesCollection.new(zoom: zoom, source: source, start_x: start_x, start_y: start_y, end_x: end_x, end_y: end_y, output: output)
  end

  def run
    download
    stitch
    cleanup
  end

private

  def set_rectangle(args)
    if given_lat_lon?(args)
      set_lat_lon(args)
      set_x_y_from_lat_lon(args)
    elsif given_x_y?(args)
      set_x_y(args)
    end
  end

  def set_x_y_from_lat_lon(args)
    start        = SimpleMercatorLocation.new(lat: args[:start_lat], lon: args[:start_lon], zoom: args[:zoom])
    finish       = SimpleMercatorLocation.new(lat: args[:end_lat],   lon: args[:end_lon],   zoom: args[:zoom])
    self.start_x = start.to_tile.first
    self.start_y = start.to_tile.last
    self.end_x   = finish.to_tile.first
    self.end_y   = finish.to_tile.last
  end

  def set_x_y(args)
    self.start_x      = args[:start_x]
    self.start_y      = args[:start_y]
    self.end_x        = args[:end_x]
    self.end_y        = args[:end_y]
  end

  def set_lat_lon(args)
    self.start_lat    = args[:start_lat]
    self.start_lon    = args[:start_lon]
    self.end_lat      = args[:end_lat]
    self.end_lon      = args[:end_lon]
  end

  def given_x_y?(args)
    args.has_key?(:start_x) && args[:start_x].is_a?(Integer) &&
    args.has_key?(:start_y) && args[:start_y].is_a?(Integer) &&
    args.has_key?(:end_x)   && args[:end_x].is_a?(Integer)   &&
    args.has_key?(:end_y)   && args[:end_y].is_a?(Integer)   
  end

  def given_lat_lon?(args)
    args.has_key?(:start_lat) && args[:start_lat].is_a?(Float) &&
    args.has_key?(:start_lon) && args[:start_lon].is_a?(Float) &&
    args.has_key?(:end_lat)   && args[:end_lat].is_a?(Float)   &&
    args.has_key?(:end_lon)   && args[:end_lon].is_a?(Float)
  end

end
