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
  end

  def run
    loop do
      update
      draw
      @clock.tick
    end
  end

  def sel_key(key)
    case key
    when 113
      exit
    end
    puts "matched key #{key}"
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
