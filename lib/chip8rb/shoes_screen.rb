require 'shoes'

class ShoesScreen < Screen

  def initialize
    # TODO
  end

  def run
    # TODO:
    # Draw the initial screen and capture keyboard events
    Shoes.app do
      s = stack width: 200, height: 200 do
        background red
        hover do
          s.clear { background blue }
        end
        leave do
          s.clear { background red }
        end
      end
    end
  end

  def draw
    # TODO
  end

  # Gets the next character entered
  def getch

  end
end
