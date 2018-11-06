# frozen_string_literal: true

class EnhanceInstructionController < ApplicationController
  include HeapNotifyable

  def index
    heap_notify 'Visit enhance instruction'
    @props = EnhanceInstructionInteractor.call(self).props
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end
end
