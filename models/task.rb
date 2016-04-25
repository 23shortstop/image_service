require 'mongoid/enum'

class Task
  include Mongoid::Document
  include Mongoid::Enum

  enum	:operation, [:resize]
  enum	:status,    [:pending, :in_progress, :done]
  field	:params,    type: Hash

  mount_uploader :image,  ImageUploader
  mount_uploader :result, ImageUploader

end
