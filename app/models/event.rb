class Event < ActiveRecord::Base
  validates_presence_of :name
  has_many :participants do
    def find_or_create(author)
      first(:conditions => ['name = :author OR lighthouse_id = :author OR github_id = :author', {:author => author}]) || create(:name => author)
    end
  end

  def self.current
    first(:conditions => {:current => true})
  end
end
