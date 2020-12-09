require 'rails_helper'

describe 'Logout', type: :routing do
  let(:path) { 'api/v1/logout' }
  context 'Route' do
    it "should route 'api/v1/logout' to sessions#destroy" do
      should route(:delete, path).to('sessions#destroy', { format: :json })
    end

    it "should not route 'api/v1/logout' to another controller/action" do
      should_not route(:delete, path).to('some#destroy', { format: :json })
    end
  end
end
