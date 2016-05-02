require 'mini_magick'

class Resizer

  def edit(image, params)
    image.resize("#{params[height]}x#{params[width]}")
  end

end