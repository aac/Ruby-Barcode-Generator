#!/usr/bin/env ruby

require 'rubygems'
require 'json'

UPC_CHECK_DIGITS = 1
UPC_FREE_DIGITS = 11
UPC_DIGITS = UPC_FREE_DIGITS + UPC_CHECK_DIGITS
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

def upc_checksum digits
  val0 = digits.values_at(0,2,4,6,8,10).inject(0) {|sum,n| sum+n} * 3
  val1 = digits.values_at(1,3,5,7,9).inject(0) {|sum,n| sum+n}
  sum = val0 + val1

  next_multiple_of_ten = ((sum+9)/10)*10
  next_multiple_of_ten - sum
end

def upc_padded_array number
  digits = number.to_s
  pad = UPC_FREE_DIGITS - digits.size
  digits.insert(0, Array.new(pad, 0).join)

  padded_array = []
  digits.each_char {|digit| padded_array << digit.to_i}
  padded_array
end

def make_valid_upc number
  raise "number is too large" if number > 99999999999
  num_array = upc_padded_array number
  num_array << upc_checksum(num_array)
  puts num_array.join
  num_array
end

def upc_code number
  digits = make_valid_upc number

  front = digits[0, UPC_BREAK_INDEX]
  back = digits[UPC_BREAK_INDEX, UPC_DIGITS]

  lines = ''
  lines << UPC_HEADER
  front.each {|digit| lines << UPC_CODE[digit]}
  lines.concat UPC_BREAK
  back.each  {|digit| lines << UPC_CODE[digit]}
  lines << UPC_FOOTER

  widths = []
  lines.each_char {|line| widths << line.to_i}
  widths
end

if __FILE__ == $0
  puts (upc_code 36000291452).to_json
end
