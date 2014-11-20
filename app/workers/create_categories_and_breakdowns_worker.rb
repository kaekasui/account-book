# create the default categories and breakdowns
class CreateCategoriesAndBreakdownsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :sidekiq, retry: 3

  def perform(id)
    puts "*** user_id: #{id}"
    User.where(id: id).first.create_data
  end
end
