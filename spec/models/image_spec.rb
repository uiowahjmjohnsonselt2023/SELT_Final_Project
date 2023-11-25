require 'spec_helper'
require 'rails_helper'

describe Image, type: :model do
  describe 'associations' do
    it { should belong_to(:item) }
  end

  describe 'validations' do
    it { should validate_presence_of(:data) }
    it { should validate_presence_of(:image_type) }
    it { should validate_presence_of(:item_id) }
  end

  describe '#get_image_data' do
    let(:image_file_path) { 'spec/fixtures/files/mona_lisa.jpg' }
    let(:extname_results) { '.jpg' }
    let(:image_type) { 'jpg' }
    let(:image_data) { 'image data' }

    before do
      allow(File).to receive(:extname).with(image_file_path).and_return(extname_results)
      allow(File).to receive(:open).with(image_file_path, mode: 'rb').and_return(image_data)
    end

    it 'should return image type and data' do
      expect(Image.get_image_data(image_file_path)).to eq([image_type, image_data])
    end
  end

  describe '#data_uri' do
    it 'should return data uri' do
      image = Image.new(data: 'image data', image_type: 'jpg')
      expect(image.data_uri).to eq('data:image/jpg;base64,aW1hZ2UgZGF0YQ==')
    end
  end
end
