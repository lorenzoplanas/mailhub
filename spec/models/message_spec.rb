# encoding: utf-8
require 'spec_helper'

describe Message do
  before(:each) do 
    @template = Template.create(
      :name     => 'wimo_ping_dude', 
      :content  => "<h1>{{title}}</h1><p>{{words}}</p>"
    )
  end

  after(:each) do
    @template.destroy
  end

  describe "when empty" do 
    it "shouldn't be saved" do 
      Message.new.save.should be_false 
    end 
  end

  context "#new" do
    describe "#to" do
      it "should store the recipients passed as an +Array+" do
        msg = Message.new
        msg.to << "Lorenzo Planas <lplanas@qindio.com>"
        msg.to.should == ["Lorenzo Planas <lplanas@qindio.com>"]
        msg.to << "Karla Jaramillo <kjaramillo@qindio.com>"
        msg.to.should == ["Lorenzo Planas <lplanas@qindio.com>", "Karla Jaramillo <kjaramillo@qindio.com>"]
      end
    end

    describe "#from" do
      it "should store the sender of the message" do
        msg = Message.new
        msg.from = "Lorenzo Planas <lplanas@qindio.com>"
        msg.from.should == "Lorenzo Planas <lplanas@qindio.com>"
        msg.from = "Karla Jaramillo <kjaramillo@qindio.com>"
        msg.from.should == "Karla Jaramillo <kjaramillo@qindio.com>"
      end
    end

    describe "#subject" do
      it "should store the subject of the message" do
        msg = Message.new
        msg.subject = "Hello"
        msg.subject.should == "Hello"
        msg.subject = "Que más"
        msg.subject.should == "Que más"
      end
    end
  end

  describe "#render" do
    it "should render the message body substituting arguments passed as a +Hash+" do
      msg = Message.create(
              :from         => 'lplanas@qindio.com', 
              :to           => ['lplanas@qindio.com'], 
              :subject      => 'Hi there',
              :template_id  => @template.id
            )
      msg.render(:title => 'Hey dude', :words => 'Just pinging you')
      msg.rendered.should == '<h1>Hey dude</h1><p>Just pinging you</p>'
    end
  end

  describe "#prepare" do
    it "should create a new message, find the template and render it" do
      Message.prepare(
        :template => 'wimo_ping_dude',
        :from     => 'lplanas@qindio.com', 
        :to       => ['lplanas@qindio.com'], 
        :subject  => 'Hi there',
        :fillers  => {
           :title   => 'Hey dude',
           :words   => 'Just pinging you'
        }
      )
    end
  end
end
