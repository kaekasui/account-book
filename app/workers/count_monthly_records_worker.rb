class CountMonthlyRecordsWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(id)
    puts '************* set records count *************'
    @record = Record.find(id)
    @record.set_records_count
  end
end
