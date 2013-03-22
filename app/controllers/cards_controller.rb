class CardsController < ActionController::Base
  def show
    @card = Card.where(name: card_params[:card_name]).first
  end

  def detail_show
  end

  private

  def card_params
    params.permit(:card_name, :expansion_shortname)
  end
end
