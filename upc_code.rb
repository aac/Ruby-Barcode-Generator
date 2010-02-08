#!/usr/bin/env ruby

require 'rubygems'
require 'json'

UPC_DIGITS = 12
UPC_HEADER = [111].join
UPC_BREAK  = [11111].join
UPC_BREAK_INDEX = UPC_DIGITS / 2
UPC_FOOTER = UPC_HEADER

UPC_CODE = [
            [3211], 
            [2221], 
            [2122], 
            [1411], 
            [1132], 
            [1231], 
            [1114], 
            [1312], 
            [1213], 
            [3112]
           ].map(&:join)

def upc_code number
  digits = number.to_s
  lines = ''

  pad = UPC_DIGITS - digits.size
  digits.insert(0, Array.new(pad, 0).join)

  front = digits[0, UPC_BREAK_INDEX]
  back = digits[UPC_BREAK_INDEX, UPC_DIGITS]

  lines << UPC_HEADER
  front.each_char {|digit| lines << UPC_CODE[digit.to_i]}
  lines.concat UPC_BREAK
  back.each_char  {|digit| lines << UPC_CODE[digit.to_i]}
  lines << UPC_FOOTER
  
  widths = []
  lines.each_char {|line| widths << line.to_i}
  widths
end

if __FILE__ == $0
  puts (upc_code 36000291452).to_json
end
