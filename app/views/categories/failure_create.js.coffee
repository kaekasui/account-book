name = "<%= @category.errors[:name].any? %>"

if name == "true"
  $('#category_name').popover(placement: "bottom", content: "<%= @category.errors.full_message(:name, @category.errors[:name].first) %>")
  $('#category_name').click()
