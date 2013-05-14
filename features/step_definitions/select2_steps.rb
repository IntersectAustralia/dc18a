# Adding a tag in a searchable Select2 field
And /^I search for "(.*)" in "(.*)" and select "(.*)"$/ do |term, label, selection|
  find(:xpath, ".//label[text() = '#{label}']/../div/div/ul//input").click
  find(:xpath, ".//label[text() = '#{label}']/../div/div/ul//input").set(term)
  find(:xpath, ".//div[@class='select2-result-label'][text() = '#{selection}']").click
end

# To check if a predefined value has been added in Select2 field
And /^I search for "(.*)" in "(.*)" and should see nothing$/ do |term, label|
  find(:xpath, ".//label[text() = '#{label}']/../div/div/ul//input").click
  find(:xpath, ".//label[text() = '#{label}']/../div/div/ul//input").set(term)
  find(:xpath, ".//ul[@class='select2-results']/li[contains(@class,'select2-selected')]/div[text()='#{term}']", {:visible => false})
end
