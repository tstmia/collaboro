class ProposalsController < ApplicationController

	def new
		@proposal = Proposal.new
	end

	def create
		proposal = Proposal.new(proposal_params)
		proposal.f_user_id = current_f_user.id
		if proposal.save
			redirect_to f_user_path(current_f_user),notice:'プロポーザルを追加しました！'
		else
			render :new
		end
	end

	def edit
		@proposal = Proposal.find(params[:id])
	end

	def update
		proposal = Proposal.find(params[:id])
		if proposal.update(proposal_params)
			redirect_to f_user_path(current_f_user),notice:'プロポーザル内容を変更しました！'
		else
			render :edit
		end
	end

	def show
	end

	def index
		@proposals = Proposal.all.reverse_order

		# カテゴリー別
		@proposals_shipment = Proposal.where(p_category: "0").reverse_order
		@proposals_event = Proposal.where(p_category: "1").reverse_order
		@proposals_other = Proposal.where(p_category: "2").reverse_order

		# 月別
		@proposals_spring = []
		@proposals_summer = []
		@proposals_autumn = []
		@proposals_winter = []

		@proposals.each do |p|
			if p.p_start_season.month == 3 || p.p_start_season.month == 4 || p.p_start_season.month == 5
				@proposals_spring.push(p)
			elsif p.p_start_season.month == 6 || p.p_start_season.month == 7 || p.p_start_season.month == 8
	 			@proposals_summer.push(p)
	 		elsif p.p_start_season.month == 9 || p.p_start_season.month == 10 || p.p_start_season.month == 11
	 			@proposals_autumn.push(p)
	 		else
	 			@proposals_winter.push(p)
			end
		end
	end

	def destroy
		proposal = Proposal.find(params[:id])
		if proposal.destroy
			redirect_to f_user_path(current_f_user),notice:"プロポーザルを削除しました！"
	    end
	end

	private
	def proposal_params
		params.require(:proposal).permit(:p_title, :p_body, :p_image, :p_location, :p_category, :p_status, :p_start_season, :p_finish_season, )
	end

end