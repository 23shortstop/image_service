class TaskSerializer < BaseSerializer
  attributes :status, :image, :result

  def status
    object.status.to_s
  end

  def image
    object.image.url
  end

  def result
    object.result.url
  end
  
end
