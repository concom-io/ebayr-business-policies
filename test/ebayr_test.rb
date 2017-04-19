# -*- encoding : utf-8 -*-
require 'test_helper'
require 'ebayr_business_policies'
require 'fakeweb'

describe EbayrBusinessPolicies do
  before { EbayrBusinessPolicies.sandbox = true }

  def check_common_methods(mod = EbayrBusinessPolicies)
    assert_respond_to mod, :"dev_id"
    assert_respond_to mod, :"dev_id="
    assert_respond_to mod, :"cert_id"
    assert_respond_to mod, :"cert_id="
    assert_respond_to mod, :"ru_name"
    assert_respond_to mod, :"ru_name="
    assert_respond_to mod, :"auth_token"
    assert_respond_to mod, :"auth_token="
    assert_respond_to mod, :"compatability_level"
    assert_respond_to mod, :"compatability_level="
    assert_respond_to mod, :"site_id"
    assert_respond_to mod, :"site_id="
    assert_respond_to mod, :"sandbox"
    assert_respond_to mod, :"sandbox="
    assert_respond_to mod, :"sandbox?"
    assert_respond_to mod, :"authorization_callback_url"
    assert_respond_to mod, :"authorization_callback_url="
    assert_respond_to mod, :"authorization_failure_url"
    assert_respond_to mod, :"authorization_failure_url="
    assert_respond_to mod, :"callbacks"
    assert_respond_to mod, :"callbacks="
    assert_respond_to mod, :"logger"
    assert_respond_to mod, :"logger="
    assert_respond_to mod, :"uri"
  end

  # If this passes without an exception, then we're ok.
  describe "basic usage" do
    before { FakeWeb.register_uri(:post, EbayrBusinessPolicies.uri, :body => xml) }
    let(:xml) { "<GeteBayOfficialTimeResponse><Ack>Succes</Ack><Timestamp>blah</Timestamp></GeteBayOfficialTimeResponse>" }

    it "runs without exceptions" do
      EbayrBusinessPolicies.call(:GeteBayOfficialTime).timestamp.must_equal 'blah'
    end
  end

  it "correctly reports its sandbox status" do
    EbayrBusinessPolicies.sandbox = false
    EbayrBusinessPolicies.wont_be :sandbox?
    EbayrBusinessPolicies.sandbox = true
    EbayrBusinessPolicies.must_be :sandbox?
  end

  it "has the right sandbox URIs" do
    EbayrBusinessPolicies.must_be :sandbox?
    EbayrBusinessPolicies.uri_prefix.must_equal "https://api.sandbox.ebay.com/ws"
    EbayrBusinessPolicies.uri_prefix("blah").must_equal "https://blah.sandbox.ebay.com/ws"
    EbayrBusinessPolicies.uri.to_s.must_equal "https://api.sandbox.ebay.com/ws/api.dll"
  end

  it "has the right real-world URIs" do
    EbayrBusinessPolicies.sandbox = false
    EbayrBusinessPolicies.uri_prefix.must_equal "https://api.ebay.com/ws"
    EbayrBusinessPolicies.uri_prefix("blah").must_equal "https://blah.ebay.com/ws"
    EbayrBusinessPolicies.uri.to_s.must_equal "https://api.ebay.com/ws/api.dll"
    EbayrBusinessPolicies.sandbox = true
  end

  it "works when as an extension" do
    mod = Module.new { extend EbayrBusinessPolicies }
    check_common_methods(mod)
  end

  it "works as an inclusion" do
    mod = Module.new { extend EbayrBusinessPolicies }
    check_common_methods(mod)
  end

  it "has the right methods" do
    check_common_methods
  end

  it "has decent defaults" do
    EbayrBusinessPolicies.must_be :sandbox?
    EbayrBusinessPolicies.uri.to_s.must_equal "https://api.sandbox.ebay.com/ws/api.dll"
    EbayrBusinessPolicies.logger.must_be_kind_of Logger
  end
end
