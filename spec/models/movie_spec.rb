require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'factory' do
    context 'create movie' do
      let(:movie) { FactoryBot.build(:movie) }
      it { expect(movie).to be_valid }
    end
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:movie_url) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
