#!/usr/bin/env ruby -0777 -n

require 'nokogiri'

$_.gsub! /^"/, ''
$_.gsub! /"\s\Z/, ''

parts = $_.split(/"\s*"/)

builder =  Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
  xml.cards do
    parts.each do |part|
      lines = part.split(/\n+/)

      card = {
        duration: lines.shift.split(/\s/).first.capitalize.gsub(/:/, ''),
        title: lines.shift,
        description: lines
      }

      if card[:description].empty?
        card[:description] = [card.delete(:title)]
      end

      xml.card(duration: card[:duration]) do
        xml.title(card[:title]) if card[:title]
        if card[:description].size > 1
          xml.description do
            card[:description].each do |l|
              xml.line l
            end
          end
        else
          xml.description card[:description].first
        end
      end
    end
  end
end

puts builder.to_xml
