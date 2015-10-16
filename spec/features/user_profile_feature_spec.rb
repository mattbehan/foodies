describe "a users profile page" do

  it "has a users name" do
    visit "/users/1"
    expect(page.has_content?(User.first.username))
  end

  it "has does not have a follow button if the user is not logged in" do
    visit "/users/1"
    expect(!page.has_content?("Follow"))
  end

  it "does have a follow button if the user is logged in" do
    login
    visit "/users/2"
    expect(page.has_content?("Follow"))
  end

  it "displays a users reputation" do
    visit "/users/1"
    expect(page.has_css?(".user-score"))
  end

  it "displays a list of visited restaurants" do
    visit "/users/1"
    expect(page.has_content?("Visited Restaurants:"))
  end

  it "displays a list of bookmarked restaurants" do
    visit "/users/1"
    expect(page.has_content?("Bookmarked Restaurants:"))
  end

  it "displays a list of followed users" do
    visit "/users/1"
    expect(page.has_content?("Followed Users:"))
  end

  it "displays a bio" do
    visit "/users/1"
    expect(page.has_content?("Bio:"))
  end

end
