Tutor::Application.routes.draw do
  scope "/cards" do
    match "/:card_name" => "cards#show"
    match "/:expansion_shortname/:card_name" => "cards#detail_show"
  end
  # root :to => 'welcome#index'
end
