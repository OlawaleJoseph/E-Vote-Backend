require 'rails_helper'

RSpec.describe JwtDenylist, type: :model do
  context 'Verify Table Name' do
    scenario 'Table name should be jwt_denylist' do
      expect(JwtDenylist.table_name).to eq('jwt_denylist')
    end
  end
end
