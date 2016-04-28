require 'mini_magick'

class Handler
  
  def handle(task)
    image = MiniMagick::Image.open(task.image.url)
    operation = choose_operation(task.operation)
    result = operation.call(image, task.params)
    task.result = result
    task.status = :done
    task.save!
  end

  def choose_operation(operation_name)
    lambda do |image, params|
      case operation_name
        when :resize then resize(image, params)
        when :rotate then rotate(image, params)
        when :negate then negate(image)
      end
    end
  end

  def resize(image, params)
    image.resize(params.values.join('x'))
  end

  def rotate(image, params)
    image.rotate(params.values.first)
  end

  def negate(image)
    image.negate
  end

end
