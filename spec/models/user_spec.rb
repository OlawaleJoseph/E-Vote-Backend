require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Model' do
    subject { build :user }
    context '#validations' do
      scenario { should validate_presence_of(:first_name) }
      scenario { should validate_length_of(:first_name).is_at_least(3) }
      scenario { should validate_length_of(:first_name).is_at_most(50) }

      scenario { should validate_presence_of(:last_name) }
      scenario { should validate_length_of(:last_name).is_at_least(3) }
      scenario { should validate_length_of(:last_name).is_at_most(50) }

      scenario { should validate_presence_of(:email) }

      scenario { should validate_presence_of(:username) }
      scenario { should validate_uniqueness_of(:username).case_insensitive }
      scenario { should validate_length_of(:username).is_at_least(3) }
      scenario { should validate_length_of(:username).is_at_most(50) }

      scenario { should validate_presence_of(:password) }
      scenario { should allow_value('Password1$').for(:password) }
      scenario { should validate_length_of(:password).is_at_least(8) }
      scenario { should validate_length_of(:password).is_at_most(50) }

      scenario { should validate_presence_of(:email_notification) }

      scenario { should define_enum_for(:plan) }
      scenario { should validate_presence_of(:plan) }

      scenario { should be_valid }
    end
  end
end
