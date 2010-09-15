class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subject
  field :from, :default => 'Lorenzo Planas <lplanas@qindio.com>'
  field :to, :type => Array, :default => []
  field :rendered
  field :sent, :type => Boolean, :default => false
  referenced_in :template, :inverse_of => :templates
  validates_presence_of :to, :from, :subject

  def self.prepare(options = {})
    self.new(
      :subject      => options[:subject],
      :from         => options[:from],
      :to           => options[:to],
      :template_id  => Template.where(:name => options[:template]).first.id
    ).render(options[:fillers])
  end

  def render(fillers = {})
    self.rendered = self.template.content.clone
    fillers.each_pair { |k, v| self.rendered.gsub! /\{\{#{k}\}\}/, v }
    self.save!
  end
end
