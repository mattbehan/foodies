describe "making a quick take" do

  it "does not allow a user to make a quick take if they're not logged in" do
    visit "/restaurants/1"
    expect(!page.has_content?("Been to #{Restaurant.name}"))
  end

  it "has a link to make a quick take if a user is logged in" do
    login
    visit "/restaurants/1"
    expect(page.has_content?("Rate it."))
  end

end
