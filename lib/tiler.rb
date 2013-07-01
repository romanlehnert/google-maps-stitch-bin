require 'google-map-stitch'
require 'simple_mercator_location'

class Tiler


  attr_accessor :zoom
  attr_reader :start, :end

  def initialize(args)
    @zoom = args[:zoom]
    @start = SimpleMercatorLocation.new(lat: args[:start_lat], lon: args[:start_lon], zoom: args[:zoom])
    @end = SimpleMercatorLocation.new(lat: args[:end_lat], lon: args[:end_lon], zoom: args[:zoom])
  end

  def run
    engine = GMS::Engine.new({
      :startX => @start.to_tile.first,
      :startY => @start.to_tile.last,
      :endX => @end.to_tile.first,
      :endY => @end.to_tile.last,
      :zoomLevel => @zoom
    })

    downloader = GMS::Downloader.new(engine.tiles, 'tiles_folder')
    downloader.process

    stitcher = GMS::Stitcher.new('tiles_folder', 'map.png')
    stitcher.process

  end
end

require "tiler/location"
