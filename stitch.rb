require "rubygems"
require_relative "location.rb"


zoom = 15

start = Location.new({lat: 48.402312, lon: 10.539215}).zoom_at(zoom)
finish  = Location.new({lat: 47.944867, lon: 10.970428}).zoom_at(zoom)

puts start.to_tile.inspect
puts finish.to_tile.inspect


require 'google-map-stitch'

# entire map

# subsection (South America)
engine = GMS::Engine.new({
  :startX => start.to_tile.first,
  :endX => finish.to_tile.first,
  :startY => start.to_tile.last,
  :endY => finish.to_tile.last,
  :zoomLevel => zoom
})

downloader = GMS::Downloader.new(engine.tiles, 'tiles_folder')
downloader.process

stitcher = GMS::Stitcher.new('tiles_folder', 'map.png')
stitcher.process

