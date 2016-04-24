require 'mongoid/enum'

class Task
  include Mongoid::Document
  include Mongoid::Enum

  enum	:operation, [:resize]
  enum	:status,    [:pending, :in_progress, :done]
  field	:params,    type: Hash

  mount_uploader :image, ImageUploader

  def to_response
    { task:
      {
        id: self.id.to_s,
        status: self.status,
        image: self.image.url
      }
    }
  end

end
