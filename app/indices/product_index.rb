ThinkingSphinx::Index.define :product, :with => :real_time do
  # fields
  indexes title, :sortable => true
  indexes description
end
