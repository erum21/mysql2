# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'mysql2/em'

describe Mysql2::EM::Client do
  it "should support async queries" do
    results = []
    EM.run do
      client1 = Mysql2::EM::Client.new
      defer1 = client1.query "SELECT sleep(0.05) as first_query"
      defer1.callback do |result|
        results << result.first
        EM.stop_event_loop
      end

      client2 = Mysql2::EM::Client.new
      defer2 = client2.query "SELECT sleep(0.025) second_query"
      defer2.callback do |result|
        results << result.first
      end
    end
    
    results[0].keys.should include("second_query")
    results[1].keys.should include("first_query")
  end
end