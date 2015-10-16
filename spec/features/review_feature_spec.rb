describe "going to a review page" do

  it "has a form to input your address" do
    visit "/restaurants/1/reviews/1"
    expect(page.has_css?('#from-link'))
  end

  it "has a place to comment" do
    visit "/restaurants/1/reviews/1"
    expect(page.has_content?("Comments"))
  end

  it "offers a place to log in if not logged in" do
    visit "/restaurants/1/reviews/1"
    find_link("log in").click
    expect(page.has_content?("Log in"))
  end

  it "has a link that displays comments" do
    visit "/restaurants/1/reviews/1"
    expect(page.has_xpath?("//a[@href='/']"))
  end

  it "has a link to go back to that restaurants page" do
    visit "/restaurants/1/reviews/1"
    find_link("Back to Restaurant Page").click
    expect(page.has_content?(Restaurant.first.name))
  end
end
