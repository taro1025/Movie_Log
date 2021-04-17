Rails.application.routes.draw do
  get '' => "home#top"
  get '/user_page/:user_id' => "home#user_page"
  get '/user_page/likes/:user_id' => "home#likes_page"

  get '/signup' => "home#signup"
  post '/user_create' => "home#user_create"
  post '/user/edit/:user_id' => "home#edit"
  get '/login' => "home#login_form"
  post '/login' => "home#login"
  get '/logout' => "home#logout"
  #get '/tes' => "home#tes"

  get '/notifications' => "home#notifications"

  post '/movie/search' => "movie#search"
  get '/movie/create_form' => "movie#create_form"
  post '/movie/add' => "movie#add"
  get '/add/watch_list/:movie_id' => "movie#add_watch_list"

  get '/posts/:id' => "post#index" #idはmovie_id
  post '/posts/post/:id' => "post#post" #post(投稿)
  get '/posts/show/:id' => "post#show"

  post '/create_comment_to_post/:id' => "post#comment" #jump to show
  post '/create_comment_to_comment/:id' => "post#new_response" #jump to comments
  get '/comments/:id' => "post#comments"

  post '/like/create/:post_id' => "like#create"
  post '/like/destroy/:post_id' => "like#destroy"
  post '/like/create/:post_id/show' => "like#create_show"
  post '/like/destroy/:post_id/show' => "like#destroy_show"

  get '/follow/:user_id' => "relationship#follow"
  get '/unfollow/:user_id' => "relationship#unfollow"

  get '/mobile_search' => "movie#mobile_search"
  get '/mobile_manager/:user_id' => "movie#mobile_manager"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
