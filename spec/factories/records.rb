FactoryGirl.define do
  factory :record, class: 'Record' do
    published_at '2014-06-14'
    charge 1000
    memo 'MyText'
  end
end
