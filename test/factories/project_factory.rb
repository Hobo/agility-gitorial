FactoryGirl.define do
  factory :story do
    title   "Sample Story"
    body    "lorem ipsum blah blah blah"
    project
  end

  factory :project do
    name "Sample Project"
  end

end
