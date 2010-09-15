class Template
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :content
  references_many :messages

  validates_presence_of :name, :content
end
