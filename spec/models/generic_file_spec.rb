require 'rails_helper'

describe GenericFile do

  let(:generic_file) { GenericFile.new }

  describe '#media_duration' do
    it 'returns the duration value' do
      expect{ generic_file.media_duration }.to_not raise_error
    end
  end

  describe '#media_duration=' do
    it 'sets the media duration' do
      expect{ generic_file.media_duration = ["foo"] }.to_not raise_error
      expect(generic_file.media_duration).to eq ["foo"]
    end
  end
end