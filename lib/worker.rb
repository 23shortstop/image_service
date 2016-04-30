require 'sidekiq'
#require 'mongoid'

require './lib/handler'
#require './models/task'

class Worker
  include Sidekiq::Worker

  @@task_handler = Handler.new

  def perform(task_id)
    task = Task.find task_id
    task.status = :in_progress
    task.save!
    @@task_handler.handle(task)
  end

end
