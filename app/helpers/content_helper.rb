module ContentHelper
  def get_preview
    self.content.split(" ")[0..60].join(" ")
  end
end
