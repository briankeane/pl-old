require 'spec_helper'


describe "DeleteUser" do
  it "calls bullshit if user does not exist" do
    result = PL::DeleteUser.run({ twitter: "Bob", password: "another" })
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:user_not_found)
  end

  it "creates a user" do
    user = PL.db.create_user({ twitter: "Alice", password: "password2" })
    result = PL::DeleteUser.run({ user_id: user.id })
    expect(result.success?).to eq(true)
    expect(PL.db.get_user(user.id)).to be_nil
  end
end

