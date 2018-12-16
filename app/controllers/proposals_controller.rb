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
		@proposal = Proposal.find(params[:id])
		@f_user = @proposal.f_user

		# #favorite_heartsに登録した人一覧
		@favorited_users = []
		@favorited = FavoriteHeart.where(proposal_id: @proposal).reverse_order
		@favorited.each do |f|
			@favorited_user = CUser.find_by(id: f.c_user_id)
			@favorited_users.push(@favorited_user)
		end
	end

	def index

		@proposals = Proposal.all.reverse_order
	
		#favorite_heartsに登録したやつ
		@favorites = FavoriteHeart.where("c_user_id = ?", current_c_user).reverse_order
		@proposals_fav = []
		@favorites.each do |f|
			@proposal = Proposal.find_by(id: f.proposal_id)
			@proposals_fav.push(@proposal)
		end


		# カテゴリー別
		@proposals_shipment = Proposal.where(category: "0").reverse_order
		@proposals_event = Proposal.where(category: "1").reverse_order
		@proposals_other = Proposal.where(category: "2").reverse_order

		# 月別
		@proposals_spring = []
		@proposals_summer = []
		@proposals_autumn = []
		@proposals_winter = []

		@proposals.each do |p|
			if p.start_season.month == 3 || p.start_season.month == 4 || p.start_season.month == 5
				@proposals_spring.push(p)
			elsif p.start_season.month == 6 || p.start_season.month == 7 || p.start_season.month == 8
	 			@proposals_summer.push(p)
	 		elsif p.start_season.month == 9 || p.start_season.month == 10 || p.start_season.month == 11
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

	def search
		@proposals = Proposal.all.reverse_order.search(params[:search])
	end

	private
	def proposal_params
		params.require(:proposal).permit(:title, :body, :p_image, :location, :category, :status, :start_season, :finish_season, )
	end

end
