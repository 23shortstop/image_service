class BaseSerializer <  ActiveModel::Serializer
  attributes :id
  
  def root
    false
  end

  def id
    object.id.to_s
  end
end
