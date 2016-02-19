class PinsController < ApplicationController
	before_action :find_pin, only: [:show, :edit, :update, :destroy]
	before_filter :authenticate_user!

	def destroy
		@pin.destroy
		redirect_to root_path
	end

	def update
		if @pin.update(pin_params)
			redirect_to @pin, notice: "Pin was Successfully updated!"
		else
			render 'edit'
		end
	end

	def create
		@pin = Pin.new(pin_params)

    respond_to do |format|
      if @pin.save
        format.json { render json: @pin, status: :created, location: @pin }
      else
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
	end

	private

		def pin_params
			@pin_params = params.require(:pin).permit(:title, :description, :image, :text_marks, :tag_list, :album_id, :person_ids => [])
			@pin_params[:text_marks] = @pin_params[:text_marks].to_s.split(",").map(&:squish)
			@pin_params
		end

		def find_pin
			@pin = Pin.all.find(params[:id])
		end

end
