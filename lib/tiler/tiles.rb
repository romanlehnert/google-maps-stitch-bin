class TilesCollection

  attr_accessor :zoom, :source, :output_file
  attr_reader :start, :end

  def initialize(args)
    @zoom    = args[:zoom]
    @source  = args[:source] || "sattelite"
    @start_x = args[:start_x]
    @start_y = args[:start_y]
    @end_x   = args[:end_x]
    @end_y   = args[:end_y]
    @output  = args[:output]
    save_tiles
  end

  def tile(x,y)
    @tiles[y][x]
  end

  def rows
    @start_y.upto(@end_y)
  end

  def columns
    @start_x.upto(@end_x)
  end

  def all
    @tiles
  end

  def flatten
    rows.map do |y|
      columns.map do |x|
        tile(x,y)
      end
    end.flatten
  end

  def save_tile(x,y,tile)
    @tiles[y] = {} unless @tiles[y]
    @tiles[y][x] = tile
  end

  def save_tiles
    @tiles = {}
    rows.map do |y|
      columns.map do |x|
        save_tile(x,y,Tile.new(x: x, y: y, z: @zoom))
      end
    end
  end

  def download
    flatten.each{ |tile| tile.download }
  end

  def cleanup
    flatten.each do |tile| 
      tile.file.close
      tile.file.unlink
    end
  end

  def stitch
    output_data = Magick::ImageList.new
    columns.each do |column|
      col = Magick::ImageList.new
      rows.each do |row|
        col.push(Magick::Image.read(tile(column,row).local_file_name).first)
      end
      output_data.push(col.append(true))
    end
    output_data.append(false).write(@output)
  end
end
