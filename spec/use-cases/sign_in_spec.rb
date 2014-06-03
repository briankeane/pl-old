require 'spec_helper'

describe 'SignIn' do

  before(:all) do
    PL.db.clear_everything
  end


  it "calls bullshit if the twitter doesn't exist" do
    result = PL::SignIn.run({ twitter: "123", password: "123" })
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:twitter_not_found)
  end

  it "calls bullshit if the password is incorrect" do
    user = PL.db.create_user({ twitter: "Bob", password: "password" })
    result = PL::SignIn.run({ twitter: "Bob", password: "NOTPASSWORD" })
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:incorrect_password)
  end

  it "signs a user in if all is correct" do
    user = PL.db.create_user({ twitter: "Sue", password: "password" })
    result = PL::SignIn.run({ twitter: "Sue", password: "password" })
    expect(result.success?).to eq(true)
    expect(result.session_id).to_not be_nil
    expect(result.user.id).to eq(user.id)
  end
end
