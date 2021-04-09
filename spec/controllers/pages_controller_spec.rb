require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let!(:movies) { FactoryBot.create_list(:movie, 10) }
  let!(:existed_user) { FactoryBot.create(:user, email: 'aaa@gmail.com', password: 'aaa123456') }

  describe 'get #home' do
    def do_request(params)
      get :home, params: params
    end

    context 'access to root page' do
      before { do_request(format: :html) }

      it { expect(assigns(:movies)).to match_array movies[5..9] }
      it { expect(response).to render_template :home }
    end

    context 'request to root page with json format' do
      before { do_request(page: 2, format: :json) }

      it 'should be respond data' do
        body = JSON.parse(response.body)
        expect(body['success']).to eq true
        expect(body['last_page']).to eq true
        expect(body['next_page']).to eq nil
        expect(body['movie_ids']).to match_array movies[0..4].pluck(:id)
      end
    end
  end

  describe 'post #login_register' do
    def do_request(params)
      post :login_register, params: params
    end

    describe 'fillform and click register button' do
      context 'fill form with blank email' do
        before { do_request(user: { email: '' }, commit: 'Register') }

        it { expect(response).to render_template :home }
        it { expect(assigns(:user).errors.full_messages).to include "Email can't be blank" }
      end

      context 'fill form with invalid password' do
        before { do_request(user: { email: 'userbbb' }, commit: 'Register') }

        it { expect(response).to render_template :home }
        it { expect(assigns(:user).errors.full_messages).to include 'Email is invalid' }
      end

      context 'fill form with blank password' do
        before { do_request(user: { email: 'bbb@gmail.com', password: '' }, commit: 'Register') }

        it { expect(response).to render_template :home }
        it { expect(assigns(:user).errors.full_messages).to include "Password can't be blank" }
      end

      context 'fill form with invalid password' do
        before { do_request(user: { email: 'bbb@gmail.com', password: '11' }, commit: 'Register') }

        it { expect(response).to render_template :home }
        it { expect(assigns(:user).errors.full_messages).to include 'Password is too short (minimum is 6 characters)' }
      end

      context 'fill form with valid params' do
        before { do_request(user: { email: 'bbb@gmail.com', password: 'bbb123456' }, commit: 'Register') }

        it { expect(response).to redirect_to root_path }
        it { expect(flash[:notice]).to eq 'Account registered successfully' }
      end
    end

    describe 'fillform and click login button' do
      context 'fill form with blank email' do
        before { do_request(user: { email: '' }, commit: 'Login') }

        it { expect(response).to redirect_to root_path }
        it { expect(flash[:alert]).to eq 'User not found!' }
      end
    end

    describe 'fillform and click login button' do
      context 'fill form with blank password' do
        before { do_request(user: { email: existed_user.email, password: '' }, commit: 'Login') }

        it { expect(response).to redirect_to root_path }
        it { expect(flash[:alert]).to eq 'Wrong password!' }
      end
    end

    describe 'fillform and click login button' do
      context 'fill form with valid params' do
        before { do_request(user: { email: existed_user.email, password: 'aaa123456' }, commit: 'Login') }

        it { expect(response).to redirect_to root_path }
        it { expect(flash[:notice]).to eq 'Logged succesfully' }
      end
    end
  end
end
