class Request < ApplicationRecord

	belongs_to :c_user
	has_many :favorite_stars, dependent: :destroy
	has_many :f_users, through: :favorite_stars

	def favorited_by?(f_user)
        favorite_stars.where(f_user_id: f_user.id).exists?
    end

    def self.search(search) #ここでのself.はRequest.を意味する
	    if search
	      where(['body LIKE ? OR location LIKE ?', "%#{search}%", "%#{search}%"]) #検索との部分一致を表示。#Request.は省略
	    else
	      all #全て表示。#Request.は省略
	    end
	  end

end
