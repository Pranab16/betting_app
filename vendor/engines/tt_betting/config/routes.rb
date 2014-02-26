TtBetting::Engine.routes.draw do


  root :to => "home#index"

  get "leader_board" => "home#leader_board"

  post "question/new" => "question#create"

  get "question/active" => "question#active"
  get "question/inactive" => "question#inactive"
  get "question/expired" => "question#expired"

  get "question/answered" => "question#answered"
  get "question/unanswered" => "question#unanswered"

  post "question/answer" => "question#answer"

  resources :question
end
