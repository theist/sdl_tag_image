#!/bin/env ruby

require 'rubygems'
require 'rubygame'

class Hud

  # construct the HUD
  def initialize options
    @screen = options[:screen]  # need that to blit on it
    @game = options[:game]

    # TTF.setup must be called before any font object is created
    Rubygame::TTF.setup

    # point to the TTF file
    filename = File.join(File.dirname(__FILE__), 'verdana.ttf')

    # creates the font object, which is used for drawing text
    @cosmic_font = Rubygame::TTF.new filename, 24

    # initialize options that are displayed, here time
    @time = "-"

  end

  # called from the game class in each loop. updates options that are displayed
  def update options
    @time = options[:time]
  end

  # called from the game class in the draw method. render any options 
  # and blit the surface on the screen
  def draw
    ypos = 6
    @game.categories.each_with_index do |category,index|
      string = @cosmic_font.render("#{category} #{index}" ,true,[255,255,255],[0,0,0])
      string.blit @screen, [@screen.w-string.w-6, ypos]
      ypos = ypos + string.h + 6
    end
  end

end



class Game

  attr_accessor :categories

  def initialize
    @screen = Rubygame::Screen.new [800,600], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "Generic Game!"
    @hud = Hud.new :screen => @screen, :game => self

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30
    @lastkey = ""
    @categories = ["Uncategorized"]
    @remaining = []
    if File.exists?('categories.txt')
      puts "file categories found"
      File.new('categories.txt').readlines.each do |line|
        line.chomp!
        @categories.push(line)
      end
    end

    if File.exists?('imagelist.txt')
      puts "imagelist found"
      File.new('imagelist.txt').readlines.each do |line|
        line.chomp!
        @remaining.push(line)
      end
    end
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
      when 256,257,258,259,260,261,262,263,264,265
        set_category(key - 256)
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
    @screen.fill :black
    @hud.draw
    @screen.update
  end
end

game = Game.new
game.run
