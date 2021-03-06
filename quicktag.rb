#!/bin/env ruby

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
    st = @cosmic_font.render("#{@game.remaining.count} #{@game.remaining[0]}",true,[255,255,255])
    st.blit @screen, [6,600 - 6 - st.h]
  end

end



class Game

  attr_accessor :categories
  attr_accessor :remaining

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
    @surfaces = []
    @game_over = false
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
    else
      puts "need a imagelist.txt"
      exit
    end
    @results = File.new('clasification.txt','a')

    max = 5
    if @remaining.count < 5
      max = @remaining.count
    end
    for index in 0..(max -1)
      @surfaces[index] = Rubygame::Surface.load(@remaining[index])
    end
  end

  def advance_image
    @surfaces.shift
    @remaining.shift
    if @remaining.count == 0
      puts "Game over"
      @game_over = true
    end
    if @remaining[4]
      @surfaces[4] = Rubygame::Surface.load(@remaining[4])
    else
      @surfaces[4] = nil
    end
  end

  def draw_tiles
    if @surfaces[0]
      @surfaces[0].zoom_to(560,480,true).blit(@screen,[0,0])
    else
      Rubygame::Surface.new([560,480]).blit(@screen, [0,0])
    end
    if @surfaces[1]
      @surfaces[1].zoom_to(240,150,true).blit(@screen,[560,0])
    else
      Rubygame::Surface.new([240,150]).blit(@screen, [560,0])
    end
    if @surfaces[2]
      @surfaces[2].zoom_to(240,150,true).blit(@screen,[560,150])
    else
      Rubygame::Surface.new([560,480]).blit(@screen, [560,150])
    end
    if @surfaces[3]
      @surfaces[3].zoom_to(240,150,true).blit(@screen,[560,300])
    else
      Rubygame::Surface.new([240,150]).blit(@screen, [560,300])
    end
    if @surfaces[4]
      @surfaces[4].zoom_to(240,150,true).blit(@screen,[560,450])
    else
      Rubygame::Surface.new([240,150]).blit(@screen, [560,450])
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

  def save_game
    @results.close
    remains = File.open("imagelist.txt","w")
    @remaining.each do |file|
      remains.puts file
    end
    remains.close
    Rubygame.quit
    exit
  end

  def sel_key(key)
    case key
      when 48,49,50,51,52,53,54,55,56,57
        set_category(key - 48)
      when 256,257,258,259,260,261,262,263,264,265
        set_category(key - 256)
      when 113
        save_game
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
      @results.puts "#{@remaining[0]} = #{categories[cat]}"
      @results.flush
      advance_image
    end
  end

  def update
    @queue.each do |ev|
      case ev
        when Rubygame::QuitEvent
          save_game
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
    draw_tiles
    @hud.draw
    @screen.update
    if @game_over
      @results.close
      remains = File.open("imagelist.txt","w")
      remains.puts("")
      remains.close
      Rubygame.quit
      exit
    end
  end
end

game = Game.new
game.run
