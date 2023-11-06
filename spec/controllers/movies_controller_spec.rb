require 'spec_helper'
require 'rails_helper'

if RUBY_VERSION >= '2.6.0'
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

describe MoviesController do
  describe 'GET #show' do
    let(:movie) { Movie.create!(title: 'The Shawshank Redemption', rating: 'PG-13', description: 'Two imprisoned men bond over a number of years...', release_date: '1994-10-14 00:00:00 UTC') }

    context 'when a valid ID is provided' do
      it 'assigns the requested movie to @movie' do
        get :show, { :id => movie.id }
        expect(assigns(:movie)).to eq(movie)
      end

      it 'renders the show template' do
        get :show, { :id => movie.id }
        expect(response).to render_template('show')
      end
    end

    context 'when an invalid ID is provided' do
      it 'redirects to the items index page' do
        get :show, { :id => 'invalid_id' }
        expect(response).to redirect_to(movies_path)
      end

      it 'sets a flash alert indicating the movie could not be found' do
        get :show, { :id => 'invalid_id' }
        expect(flash[:alert]).to eq('Movie not found.')
      end
    end
  end

  describe 'GET index' do
    let(:movies) {
      [
        Movie.create!(title: 'Movie 1', rating: 'PG', description: 'Description 1', release_date: '1994-10-14 00:00:00 UTC'),
        Movie.create!(title: 'Movie 2', rating: 'PG-13', description: 'Description 2', release_date: '1994-10-14 00:00:00 UTC')
      ]
    }

    let(:fake_relation) { Movie.where(nil) }


    it 'renders the index template and assigns all ratings to @all_ratings' do
      get :index
      expect(response).to render_template('index')
      expect(assigns(:all_ratings)).to eq(%w[G PG PG-13 NC-17 R])
    end

    context 'when sorted by title' do
      before do
        allow(Movie).to receive(:all_ratings).and_return(%w[G PG PG-13 R])
        fake_relation = double('ActiveRecord_Relation')
        allow(Movie).to receive(:where).and_return(fake_relation)
        allow(fake_relation).to receive(:order).and_return(movies.sort_by(&:title))
      end

      before do
        session[:sort] = 'title'
        session[:ratings] = {'PG' => '1', 'R' => '1'}
      end
      it 'highlights the title header' do
        get :index, :sort => 'title'
        expect(assigns(:title_header)).to eq('hilite')
      end

      it 'orders items by title' do
        get :index, :sort => 'title', :ratings => { 'PG' => '1', 'R' => '1' }
        expect(assigns(:movies)).to eq(movies.sort_by(&:title))
      end
    end

    context 'when sorted by release date' do
      before do
        allow(Movie).to receive(:all_ratings).and_return(%w[G PG PG-13 R])
        fake_relation = double('ActiveRecord_Relation')
        allow(Movie).to receive(:where).and_return(fake_relation)
        allow(fake_relation).to receive(:order).and_return(movies.sort_by(&:release_date))
      end

      before do
        session[:sort] = 'release_date'
        session[:ratings] = {'PG' => '1', 'R' => '1'}
      end
      it 'highlights the release date header' do
        get :index, :sort => 'release_date'
        expect(assigns(:date_header)).to eq('hilite')
      end

      it 'orders items by release date' do
        get :index, :sort => 'release_date', :ratings => { 'PG' => '1', 'R' => '1' }
        expect(assigns(:movies)).to eq(movies.sort_by(&:release_date))
      end
    end

    context 'when filtered by rating' do
      before do
        allow(Movie).to receive(:all_ratings).and_return(%w[G PG PG-13 R])
        fake_relation = double('ActiveRecord_Relation')
        allow(Movie).to receive(:where).and_return(fake_relation)
        allow(fake_relation).to receive(:order).and_return(movies[0])
        session[:sort] = 'title'
        session[:ratings] = {'PG' => '1', 'R' => '1'}
      end
      it 'includes only items with the selected ratings' do
        get :index, :sort => 'title', :ratings => { 'PG' => '1', 'R' => '1' }
        expect(assigns(:selected_ratings)).to eq({'PG' => '1', 'R' => '1'})
        expect(assigns(:movies)).to eq(movies[0])
      end
    end

    context 'when session differs from params' do
      it 'redirects to the index with the new parameters' do
        session[:sort] = 'release_date'
        session[:ratings] = {'G' => '1'}
        get :index, :sort => 'title', :ratings => { 'PG' => '1' }
        expect(response).to redirect_to(movies_path(:sort => 'title', :ratings => { 'PG' => '1' }))
      end
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe "POST #create" do
    let(:valid_attributes) {
      { title: 'The Shawshank Redemption', rating: 'PG-13', description: 'Two imprisoned men bond over a number of years...', release_date: '1994-10-14 00:00:00 UTC' }
    }

    let(:invalid_attributes) {
      { rating: 'PG-13', description: 'Two imprisoned men bond over a number of years...', release_date: '1994-10-14 00:00:00 UTC' }
    }
    context "with valid movie_params" do
      it "creates a new Movie with the permitted parameters" do
        expect {
          post :create, { :movie => valid_attributes }
        }.to change(Movie, :count).by(1)

        expect(Movie.last.title).to eq('The Shawshank Redemption')
      end

      it "redirects to the created movie" do
        post :create, { :movie => valid_attributes }
        expect(response).to redirect_to(movies_path)
      end
    end

    context "with invalid movie_params" do
      it "does not create a new Movie" do
        expect {
          post :create, { :movie => invalid_attributes }
        }.to change(Movie, :count).by(0)
      end

      it "re-renders the 'new' template" do
        post :create, { :movie => invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe 'searching TMDb' do
    it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, { :search_terms => 'Ted' }
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, { :search_terms => 'Ted' }
      expect(response).to render_template('search_tmdb')
    end
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return(fake_results)
      post :search_tmdb, { :search_terms => 'Ted' }
      expect(assigns(:search_movies)).to eq(fake_results)
    end

    context 'when no search terms are provided' do
      it 'should redirect to the home page with a flash notice' do
        post :search_tmdb, { :search_terms => '' }
        expect(flash[:notice]).to eq('Invalid search term')
        expect(response).to redirect_to(movies_path)
      end
    end

    context 'when no results are found' do
      it 'redirects to the home page with a flash notice' do
        allow(Movie).to receive(:find_in_tmdb).and_return([])
        post :search_tmdb, { :search_terms => 'Nonexistent Movie' }
        expect(flash[:notice]).to eq('No matching items were found on TMDb')
        expect(response).to redirect_to(movies_path)
      end
    end
  end

  describe "adding items from Tmdb" do
    it 'calls the model method to create items from TMDb' do
      tmdb_movies = { '123' => '1', '456' => '1' }
      tmdb_movies.keys.each do |id|
        expect(Movie).to receive(:create_from_tmdb).with(id)
      end
      post :add_tmdb, { :tmdb_movies => { '123' => '1', '456' => '1' } }
    end

    it 'redirects to the items index page after adding' do
      allow(Movie).to receive(:create_from_tmdb)
      post :add_tmdb, { :tmdb_movies => { '123' => '1', '456' => '1' } }
      expect(response).to redirect_to(movies_path)
    end

    it 'shows a flash message indicating the items were added' do
      allow(Movie).to receive(:create_from_tmdb)
      post :add_tmdb, { :tmdb_movies => { '123' => '1', '456' => '1' } }
      expect(flash[:notice]).to eq("Movies were successfully added.")
    end
  end
end
