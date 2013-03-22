class CardsController < ActionController::Base
  def show
    if (@card = Card.where(name: card_params[:card_name]).first)
      render action: :show, status: 201
    else
      render text: '{"error" : "Card does not exist.}', status: 404
    end
  end

  def detail_show
    if (@card = Card.where(name: card_params[:card_name]).first)
      if (@printing = @card.printings.where(expansion_id: Expansion.where(short_name: card_params[:expansion_shortname]).first.id).first)
        render action: :show, status: 201
      else
        render text: '{"error": "Card Exists but does not belong to expansion with given short name."}', status: 404
      end
    else
      render text: '{"error" : "Card does not exist.}', status: 404
    end
  end

  private

  def card_params
    params.permit(:card_name, :expansion_shortname)
  end
end
