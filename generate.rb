#!/usr/bin/env ruby

# ====================================
# Steps to generate logo assets:
# 1. edit .ai or .svg using Adobe AI
# 2. export as .png under *dist/*
# 3. run this script
# ====================================

require 'chunky_png'

shapes = {
  1 => ChunkyPNG::Image.from_file('dist/1-layer.png'),
  3 => ChunkyPNG::Image.from_file('dist/3-layer.png'),
  5 => ChunkyPNG::Image.from_file('dist/5-layer.png')
}

colors = {
  trans: ChunkyPNG::Color::TRANSPARENT,
  white: ChunkyPNG::Color::WHITE,
  light: ChunkyPNG::Color.rgb(208, 228, 242),
  blue:  ChunkyPNG::Color.rgb(42, 113, 203),
  bold:  ChunkyPNG::Color.rgb(82, 122, 165),
  dark:  ChunkyPNG::Color.rgb(45, 71, 89),
  black: ChunkyPNG::Color::BLACK
}

combos = (colors.keys - %i[trans]).product(%i[trans]) + %i[white].product(%i[blue bold dark black])

shapes.each_key do |s|
  logo = { black: shapes[s].resample(1024, 1024) }

  (colors.keys - %i[trans black]).each do |key|
    logo[key] = logo[:black]
      .extract_mask(ChunkyPNG::Color::BLACK, ChunkyPNG::Color::WHITE).last
      .change_mask_color!(colors[key])
  end

  combos.each do |fg, bg|
    ChunkyPNG::Image.new(1024, 1024, colors[bg]).compose(logo[fg]).save("dist/logo-#{s}-#{fg}-#{bg}.png")
  end
end
