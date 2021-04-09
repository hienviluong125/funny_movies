require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:movie_attributes) { FactoryBot.attributes_for(:movie, user_id: user.id) }

  describe 'get #new' do
    def do_request
      get :new
    end

    context 'access to new movie page without authentication' do
      before { do_request }

      it { expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.' }
      it { expect(response).to redirect_to root_path }
    end

    context 'access to new movie page within authentication' do
      before { sign_in(user); do_request }

      it { expect(response).to render_template :new }
    end
  end

  describe 'post #create' do
    def do_request(params)
      post :create, params: params
    end

    context 'create a new movie record without authentication' do
      before { do_request(movie: movie_attributes) }

      it { expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.' }
      it { expect(response).to redirect_to root_path }
    end

    context 'create a new movie record within authentication' do
      before do
        sign_in(user)
        do_request({movie: movie_attributes})
      end

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:notice]).to eq 'Movie shared succesfully' }
    end

    context 'create a new movie record within blank parameters' do
      before do
        sign_in(user)
        do_request(movie: movie_attributes.merge(movie_url: ''))
      end

      it { expect(response).to render_template :new }
      it { expect(assigns(:movie).errors.full_messages).to include "Movie url can't be blank" }
      it { expect(assigns(:movie).errors.full_messages).to include 'Movie url is invalid' }
    end

    context 'create a new movie record within invalid parameters' do
      before do
        sign_in(user)
        do_request(movie: movie_attributes.merge(movie_url: 'hello_world'))
      end

      it { expect(response).to render_template :new }
      it { expect(assigns(:movie).errors.full_messages).to include 'Movie url is invalid' }
    end
  end
end
