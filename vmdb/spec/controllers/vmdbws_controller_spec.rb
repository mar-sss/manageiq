require "spec_helper"

describe VmdbwsController do
  # NOTE: VmdbwsInvetorySpec relies upon @username and authenticate returning true
  #       change those tests too

  it "handles security turned off" do
    controller.should_receive(:get_vmdb_config).and_return(mock(:fetch_path => "none"))
    controller.should_not_receive(:authenticate_or_request_with_http_basic)
    expect(controller.send(:authenticate)).to eq(true)
    expect(assigns(:username)).to eq(VmdbwsSupport::SYSTEM_USER)
  end

  it "handles ssl certs" do
    controller.should_receive(:get_vmdb_config).and_return(mock(:fetch_path => "basic"))
    request.env["SERVER_PORT"] = "8443"
    controller.should_not_receive(:authenticate_or_request_with_http_basic)

    expect(controller.send(:authenticate)).to eq(true)
    expect(assigns(:username)).to eq(VmdbwsSupport::SYSTEM_USER)
  end

  it "handles username password" do
    user = FactoryGirl.create(:user, :password => "dummy")
    http_login user.userid, user.password

    controller.should_receive(:get_vmdb_config).and_return(mock(:fetch_path => "basic"))

    expect(controller.send(:authenticate)).to eq(true)
    expect(assigns(:username)).to eq(user.userid)
  end
end
