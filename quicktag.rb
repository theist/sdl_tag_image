#!/bin/env ruby

require 'rubygems'
require 'rubygame'

class Game
  def initialize
    @screen = Rubygame::Screen.new [640,480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "Generic Game!"

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30
    @lastkey = ""
    @categories = ["Uncategorized"]
  end

  def run
    loop do
      update
      draw
      @clock.tick
    end
  end

  def add_cat
    puts "add a category"
  end

  def sel_key(key)
    case key
      when 48,49,50,51,52,53,54,55,56,57
        set_category(key - 48)
      when 113
        exit
      when 186
        add_cat
    end
    puts "matched key #{key}"
  end

  def set_category(cat)
    if cat >= @categories.count
      puts "Theres no such cat"
    else
      puts "Categorized as #{@categories[cat]}"
    end
  end

  def update
    @queue.each do |ev|
      case ev
        when Rubygame::QuitEvent
          Rubygame.quit
          exit
        when Rubygame::KeyUpEvent
          if ev.key == @lastkey
            sel_key(ev.key)
          else
            @lastkey = ""
          end
        when Rubygame::KeyDownEvent
          @lastkey = ev.key
      end
    end
  end

  def draw
    @screen.update
  end
end

game = Game.new
game.run
