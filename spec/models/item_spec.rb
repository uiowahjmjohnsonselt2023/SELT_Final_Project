require 'spec_helper'
require 'rails_helper'

if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect(Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception')}.to raise_error(Movie::InvalidKeyError)
      end
    end
    context 'when valid items are found' do
      it 'returns an array of items with details' do
        fake_movie = double('Movie', id: 1, title: 'Inception', release_date: '2010-07-16')
        fake_rating = 'PG-13'
        allow(Tmdb::Movie).to receive(:find).with('Inception').and_return([fake_movie])
        allow(Movie).to receive(:get_movie_rating).with(1).and_return(fake_rating)

        movies = Movie.find_in_tmdb('Inception')
        expect(movies).to eq([{ tmdb_id: 1, title: 'Inception', rating: 'PG-13', release_date: '2010-07-16' }])
      end
    end
    context 'when no items are found' do
      it 'returns an empty array' do
        allow(Tmdb::Movie).to receive(:find).with('Nonexistent Movie').and_return([])
        expect(Movie.find_in_tmdb('Nonexistent Movie')).to eq([])
      end
    end
  end
  describe 'getting Tmdb rating' do
    let(:movie_id) { 1 }
    let(:us_release) { { 'iso_3166_1' => 'US', 'certification' => 'PG-13' } }
    let(:releases) { { 'countries' => [us_release] } }

    context 'when a US rating is present' do
      it 'returns the US rating for the movie' do
        allow(Tmdb::Movie).to receive(:releases).with(movie_id).and_return(releases)
        rating = Movie.get_movie_rating(movie_id)
        expect(rating).to eq('PG-13')
      end
    end
    context 'when a US rating is not present' do
      it 'returns "No rating found"' do
        allow(Tmdb::Movie).to receive(:releases).with(movie_id).and_return({ 'countries' => [] })
        rating = Movie.get_movie_rating(movie_id)
        expect(rating).to eq('No rating found')
      end
    end
  end
  describe 'creating Movie from Tmdb' do
    let(:tmdb_id) { 550 }
    let(:movie_details) {
      {
        "title" => "Fight Club",
        "overview" => "A movie about an underground fight club.",
        "release_date" => "1999-10-15 00:00:00 UTC"
      }
    }
    let(:rating) { "R" }

    context 'when movie details are present' do
      it 'creates a new movie with the correct attributes' do
        allow(Tmdb::Movie).to receive(:detail).with(tmdb_id).and_return(movie_details)
        allow(Movie).to receive(:get_movie_rating).with(tmdb_id).and_return(rating)
        expect { Movie.create_from_tmdb(tmdb_id) }.to change(Movie, :count).by(1)
        created_movie = Movie.last
        expect(created_movie.title).to eq(movie_details["title"])
        expect(created_movie.rating).to eq(rating)
        expect(created_movie.description).to eq(movie_details["overview"])
        expect(created_movie.release_date.to_s).to eq(movie_details["release_date"])
      end
    end

    context 'when movie details are blank' do
      it 'does not create a new movie' do
        allow(Tmdb::Movie).to receive(:detail).with(tmdb_id).and_return({})
        expect { Movie.create_from_tmdb(tmdb_id) }.not_to change(Movie, :count)
      end
    end
  end
end
