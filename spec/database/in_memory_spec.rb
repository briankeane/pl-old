require 'spec_helper'

module TM

  describe 'a badass database' do

    db = PL::Database::InMemory.new

    before { db.clear_everything }

    ##############
    #   Users    #
    ##############
    describe 'User' do
      it 'creates a User' do
        user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
        expect(user.twitter).to eq("bob")
        expect(user.compare_password("password")).to eq(true)
        expect(user.id).to_not be_nil
      end

      it 'gets a User' do
        user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
        expect(db.get_user(user.id).twitter).to eq("bob")
      end

      it 'deletes a User' do
        user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
        result = db.delete_user(user.id)
        expect(db.delete_user(999999)).to eq(false)
        expect(result).to eq(true)
        expect(db.get_user(user.id)).to be_nil
      end

      it 'gets a user by twitter' do
        user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
        expect(db.get_user_by_twitter("bob").id).to eq(user.id)
        expect(db.get_user_by_twitter("billy")).to be_nil
      end
    end

    ##############
    #   Songs    #
    ##############

    describe 'Song' do


    end



  end
end
