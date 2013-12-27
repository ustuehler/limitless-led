module Colors

  def color_code_from_color(color)
    ((-(color.to_hsl.hue - 240) % 360) / 360.0 * 255.0).to_i
  end

  def color_from_hex(hex)
    Color::RGB.from_html(hex)
  end

end