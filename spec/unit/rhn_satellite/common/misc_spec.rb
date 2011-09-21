#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../../spec_helper'

describe RhnSatellite::Common::Misc do
  describe ".gen_date_time" do
    it "uses now by default" do
      now = Time.now
      Time.expects(:now).once.returns(now)
      (res=subject.gen_date_time).should be_kind_of(XMLRPC::DateTime)
      res.min.should eql(now.min)
    end

    it "has the default as 'now'" do
      now = Time.now
      Time.expects(:now).once.returns(now)
      (res=subject.gen_date_time('now')).should be_kind_of(XMLRPC::DateTime)
      res.min.should eql(now.min)
    end

    [DateTime,Time].each do |type|
      it "converts #{type.name} to a XMLRPC::DateTime" do
        now = type.now
        (res=subject.gen_date_time).should be_kind_of(XMLRPC::DateTime)
        res.min.should eql(now.min)
      end
    end

    it "pass everything else" do
      a = 'blub'
      subject.gen_date_time(a).should eql(a)
    end
  end
end
