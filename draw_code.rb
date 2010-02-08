#!/usr/bin/env ruby

require 'rubygems'
require 'RMagick'

require 'upc_code'

MODULE_WIDTH = 4
MODULE_HEIGHT = 100
BORDER = MODULE_WIDTH * 4

def draw_bar(cursor, x, y, width, height)
  width.times do 
    cursor.line(x, y, x, y + height)
    x = x + 1
  end
end

def draw(width, lines)
  width = BORDER * 2 + MODULE_WIDTH * width
  height = BORDER * 2 + MODULE_HEIGHT
  barcode = Magick::Image.new(width, height)

  puts "{#{width},#{height}}"

  cursor_x = BORDER;
  cursor_y = BORDER;
  bars = Magick::Draw.new

  bars.stroke('black')

  draw_line = true

  lines.each do |line|
    px = line * MODULE_WIDTH
    draw_bar(bars, cursor_x, cursor_y, px, MODULE_HEIGHT) if draw_line
    
    puts "#{cursor_x} #{line} #{draw_line}"


    draw_line = !draw_line
    cursor_x = cursor_x + px
  end

  puts cursor_x

  bars.draw(barcode)
  barcode.display
  barcode
end

if __FILE__ == $0
  draw((7*12 + 11),(upc_code (ARGV.size ? ARGV[0].to_i : 123456789012))).write('test.png')
end
