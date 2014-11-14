require 'gtk2'

class GTKScreen < Screen

  def initialize(app_name, width, height)
    @app_name = app_name
    @width = width
    @height = height

    # Size of each "pixel"
    @tile_size = 10
  end

  def run(title)
    # TODO:
    # Draw the initial screen and capture keyboard events
    window = Gtk::Window.new

    area = Gtk::DrawingArea.new
    area.set_size_request(100,100)
    area.signal_connect("expose_event") do
      alloc = area.allocation
      area.window.draw_arc(area.style.fg_gc(area.state), true, 0, 0, alloc.width, alloc.height, 0, 64 * 360)
    end

    window.show
    window.set_default_size(@width*@tile_size, @height*@tile_size).show_all

    Gtk.main
  end

  def draw
    # TODO
  end

  # Gets the next character entered
  def getch

  end
end
