class Entry
  include DataMapper::Resource
  property :id, Serial
  property :link, String, :nullable => false
  property :title, String, :length => 250
  property :description, Text, :lazy => false
  property :published, DateTime

  has n, :feed_entries
  has n, :feeds, :through => :feed_entries
end # Entry

